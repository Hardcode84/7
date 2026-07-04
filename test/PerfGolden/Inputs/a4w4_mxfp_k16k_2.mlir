module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 4 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @_a4w4_kernel(%arg0: !wave.ptr<#wave.global, i8>, %arg1: !wave.ptr<#wave.global, i8>, %arg2: !wave.ptr<#wave.global, bf16>, %arg3: !wave.ptr<#wave.global, i8>, %arg4: !wave.ptr<#wave.global, i8>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 256, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 4 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 4 : i64, wave.workgroup_size = array<i32: 256, 1, 1>, waveamdmachine.schedule_max_region_ops = -1 : i64, waveamdmachine.target_waves = 1 : i64} {
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
      %38 = wave.alloc() {align = 16 : i64, bytesize = 67520 : i64} : !wave.ptr<#wave.shared, i8>
      %39 = wave.alloc() {align = 16 : i64, bytesize = 33728 : i64} : !wave.ptr<#wave.shared, i8>
      %40 = wave.alloc() {align = 16 : i64, bytesize = 33728 : i64} : !wave.ptr<#wave.shared, i8>
      %41 = wave.alloc() {align = 16 : i64, bytesize = 2048 : i64} : !wave.ptr<#wave.shared, i8>
      %42 = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64} : !wave.ptr<#wave.shared, i8>
      %43 = wave.binary muli %35, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %44 = wave.binary muli %43, %arg7 : i32, i32 -> i32
      %45 = wave.binary muli %arg8, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %46 = wave.binary muli %37, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %47 = wave.binary muli %46, %arg8 : i32, i32 -> i32
      %48 = wave.binary muli %arg11, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %49 = wave.ptr_add %arg0, %44 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %50 = waveamd.make_buffer %49, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %51 = wave.ptr_cast %38 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %52 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %53 = wave.read_first %52 : !wave.simd<i32, 64> -> i32
      %54 = wave.assume %53 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
      %55 = wave.binary divui %54, %c64_i32 : i32, i32 -> i32
      %56 = wave.binary muli %55, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %57 = wave.token : !wave.mem.token
      %58 = wave.index_expr <"128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %59 = wave.assume %58 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %60 = wave.ptr_add %50, %59 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %61 = wave.ptr_add %51, %56 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %62 = waveamd.dma_load_lds %60 -> %61 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %63 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %64 = wave.assume %63 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %65 = wave.ptr_add %50, %64 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %66 = wave.binary addi %56, %c1056_i32 overflow<nsw> : i32, i32 -> i32
      %67 = wave.ptr_add %51, %66 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %68 = waveamd.dma_load_lds %65 -> %67 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %69 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %70 = wave.assume %69 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %71 = wave.ptr_add %50, %70 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %72 = wave.binary addi %56, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %73 = wave.ptr_add %51, %72 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %74 = waveamd.dma_load_lds %71 -> %73 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %75 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %76 = wave.assume %75 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %77 = wave.ptr_add %50, %76 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %78 = wave.binary addi %56, %c3168_i32 overflow<nsw> : i32, i32 -> i32
      %79 = wave.ptr_add %51, %78 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %80 = waveamd.dma_load_lds %77 -> %79 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %81 = wave.index_expr <"128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %82 = wave.assume %81 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %83 = wave.ptr_add %50, %82 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %84 = wave.binary addi %56, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %85 = wave.ptr_add %51, %84 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %86 = waveamd.dma_load_lds %83 -> %85 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %87 = wave.index_expr <"128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %88 = wave.assume %87 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %89 = wave.ptr_add %50, %88 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %90 = wave.binary addi %56, %c5280_i32 overflow<nsw> : i32, i32 -> i32
      %91 = wave.ptr_add %51, %90 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %92 = waveamd.dma_load_lds %89 -> %91 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %93 = wave.index_expr <"128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %94 = wave.assume %93 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %95 = wave.ptr_add %50, %94 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %96 = wave.binary addi %56, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %97 = wave.ptr_add %51, %96 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %98 = waveamd.dma_load_lds %95 -> %97 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %99 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %100 = wave.assume %99 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %101 = wave.ptr_add %50, %100 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %102 = wave.binary addi %56, %c7392_i32 overflow<nsw> : i32, i32 -> i32
      %103 = wave.ptr_add %51, %102 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %104 = waveamd.dma_load_lds %101 -> %103 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %105 = wave.join %62, %68, %74, %80, %86, %92, %98, %104 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %106 = wave.ptr_add %arg1, %47 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %107 = waveamd.make_buffer %106, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %108 = wave.ptr_cast %39 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %109 = wave.index_expr <"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %110 = wave.assume %109 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %111 = wave.ptr_add %107, %110 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %112 = wave.ptr_add %108, %56 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %113 = waveamd.dma_load_lds %111 -> %112 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %114 = wave.index_expr <"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %115 = wave.assume %114 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %116 = wave.ptr_add %107, %115 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %117 = wave.ptr_add %108, %66 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %118 = waveamd.dma_load_lds %116 -> %117 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %119 = wave.index_expr <"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %120 = wave.assume %119 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %121 = wave.ptr_add %107, %120 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %122 = wave.ptr_add %108, %72 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %123 = waveamd.dma_load_lds %121 -> %122 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %124 = wave.index_expr <"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %125 = wave.assume %124 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %126 = wave.ptr_add %107, %125 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %127 = wave.ptr_add %108, %78 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %128 = waveamd.dma_load_lds %126 -> %127 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %129 = wave.join %113, %118, %123, %128 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %130 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %131 = wave.index_expr <"s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %132 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %133 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %134 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %135 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(128 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(128, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %136 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(160 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(160, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %137 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(192 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(192, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %138 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(224 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(224, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %139 = wave.assume %131 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %140 = wave.ptr_add %130, %139 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value, %token = wave.load %140 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %141 = wave.assume %132 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %142 = wave.ptr_add %130, %141 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_0, %token_1 = wave.load %142 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %143 = wave.assume %133 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %144 = wave.ptr_add %130, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_2, %token_3 = wave.load %144 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %145 = wave.assume %134 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %146 = wave.ptr_add %130, %145 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_4, %token_5 = wave.load %146 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %147 = wave.assume %135 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %148 = wave.ptr_add %130, %147 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_6, %token_7 = wave.load %148 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %149 = wave.assume %136 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %150 = wave.ptr_add %130, %149 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_8, %token_9 = wave.load %150 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %151 = wave.assume %137 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %152 = wave.ptr_add %130, %151 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_10, %token_11 = wave.load %152 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %153 = wave.assume %138 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %154 = wave.ptr_add %130, %153 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_12, %token_13 = wave.load %154 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %155 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %156 = wave.index_expr <"s0*s1 + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), Mod(floor(1/8*wi), 2))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %157 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(32 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(32, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %158 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(64 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(64, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %159 = wave.index_expr <"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(96 + Mod(floor(1/8*wi), 2), 2*Mod(floor(1/16*wi), 2))))) + Mod(wi, 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) >= 0">, #wave.pred<"-2147483647 + s0*s1 + s0*xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(2*Mod(floor(1/16*wi), 2), xor(96, Mod(floor(1/8*wi), 2)))))) + xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %160 = wave.assume %156 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %161 = wave.ptr_add %155, %160 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_14, %token_15 = wave.load %161 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %162 = wave.assume %157 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %163 = wave.ptr_add %155, %162 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_16, %token_17 = wave.load %163 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %164 = wave.assume %158 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %165 = wave.ptr_add %155, %164 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_18, %token_19 = wave.load %165 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %166 = wave.assume %159 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %167 = wave.ptr_add %155, %166 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_20, %token_21 = wave.load %167 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %168 = wave.join %105, %129 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %169 = wave.ptr_cast %40 : !wave.ptr<#wave.shared, i8> -> !wave.ptr<#wave.shared, i32>
      %170 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %171 = wave.assume %170 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %172 = wave.ptr_add %107, %171 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %173 = wave.ptr_add %169, %56 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %174 = waveamd.dma_load_lds %172 -> %173 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %175 = wave.index_expr <"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %176 = wave.assume %175 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %177 = wave.ptr_add %107, %176 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %178 = wave.ptr_add %169, %66 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %179 = waveamd.dma_load_lds %177 -> %178 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %180 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %181 = wave.assume %180 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %182 = wave.ptr_add %107, %181 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %183 = wave.ptr_add %169, %72 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %184 = waveamd.dma_load_lds %182 -> %183 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %185 = wave.index_expr <"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483632 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %186 = wave.assume %185 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %187 = wave.ptr_add %107, %186 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %188 = wave.ptr_add %169, %78 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %189 = waveamd.dma_load_lds %187 -> %188 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %190 = wave.join %174, %179, %184, %189 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %191 = wave.index_expr <"s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %192 = wave.index_expr <"s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %193 = wave.index_expr <"2*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %194 = wave.index_expr <"3*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483647 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %195 = wave.assume %191 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %196 = wave.ptr_add %155, %195 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_22, %token_23 = wave.load %196 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %197 = wave.assume %192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %198 = wave.ptr_add %155, %197 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_24, %token_25 = wave.load %198 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %199 = wave.assume %193 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %200 = wave.ptr_add %155, %199 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_26, %token_27 = wave.load %200 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %201 = wave.assume %194 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %202 = wave.ptr_add %155, %201 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_28, %token_29 = wave.load %202 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %203 = wave.ptr_add %38, %c33760_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
      %204 = wave.index_expr <"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %205 = wave.assume %204 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %206 = wave.ptr_add %50, %205 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %207 = wave.binary addi %c8440_i32, %56 overflow<nsw> : i32, i32 -> i32
      %208 = wave.ptr_add %51, %207 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %209 = waveamd.dma_load_lds %206 -> %208 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %210 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(1/4 + 1/1024*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %211 = wave.assume %210 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %212 = wave.ptr_add %50, %211 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %213 = wave.binary addi %c8440_i32, %66 overflow<nsw> : i32, i32 -> i32
      %214 = wave.ptr_add %51, %213 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %215 = waveamd.dma_load_lds %212 -> %214 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %216 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %217 = wave.assume %216 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %218 = wave.ptr_add %50, %217 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %219 = wave.binary addi %c8440_i32, %72 overflow<nsw> : i32, i32 -> i32
      %220 = wave.ptr_add %51, %219 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %221 = waveamd.dma_load_lds %218 -> %220 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %222 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 128*s0*Mod(floor(3/4 + 1/1024*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %223 = wave.assume %222 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %224 = wave.ptr_add %50, %223 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %225 = wave.binary addi %c8440_i32, %78 overflow<nsw> : i32, i32 -> i32
      %226 = wave.ptr_add %51, %225 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %227 = waveamd.dma_load_lds %224 -> %226 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %228 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %229 = wave.assume %228 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %230 = wave.ptr_add %50, %229 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %231 = wave.binary addi %c8440_i32, %84 overflow<nsw> : i32, i32 -> i32
      %232 = wave.ptr_add %51, %231 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %233 = waveamd.dma_load_lds %230 -> %232 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %234 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %235 = wave.assume %234 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %236 = wave.ptr_add %50, %235 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %237 = wave.binary addi %c8440_i32, %90 overflow<nsw> : i32, i32 -> i32
      %238 = wave.ptr_add %51, %237 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %239 = waveamd.dma_load_lds %236 -> %238 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %240 = wave.index_expr <"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %241 = wave.assume %240 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %242 = wave.ptr_add %50, %241 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %243 = wave.binary addi %c8440_i32, %96 overflow<nsw> : i32, i32 -> i32
      %244 = wave.ptr_add %51, %243 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %245 = waveamd.dma_load_lds %242 -> %244 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %246 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 128*s0*Mod(1 + floor(3/4 + 1/1024*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg7) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %247 = wave.assume %246 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %248 = wave.ptr_add %50, %247 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %249 = wave.binary addi %c8440_i32, %102 overflow<nsw> : i32, i32 -> i32
      %250 = wave.ptr_add %51, %249 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %251 = waveamd.dma_load_lds %248 -> %250 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %252 = wave.join %209, %215, %221, %227, %233, %239, %245, %251 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %253 = wave.ptr_add %39, %c16864_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
      %254 = wave.index_expr <"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %255 = wave.assume %254 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %256 = wave.ptr_add %107, %255 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %257 = wave.binary addi %c4216_i32, %56 overflow<nsw> : i32, i32 -> i32
      %258 = wave.ptr_add %108, %257 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %259 = waveamd.dma_load_lds %256 -> %258 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %260 = wave.index_expr <"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %261 = wave.assume %260 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %262 = wave.ptr_add %107, %261 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %263 = wave.binary addi %c4216_i32, %66 overflow<nsw> : i32, i32 -> i32
      %264 = wave.ptr_add %108, %263 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %265 = waveamd.dma_load_lds %262 -> %264 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %266 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %267 = wave.assume %266 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %268 = wave.ptr_add %107, %267 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %269 = wave.binary addi %c4216_i32, %72 overflow<nsw> : i32, i32 -> i32
      %270 = wave.ptr_add %108, %269 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %271 = waveamd.dma_load_lds %268 -> %270 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %272 = wave.index_expr <"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%52, %arg8) : (!wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %273 = wave.assume %272 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %274 = wave.ptr_add %107, %273 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %275 = wave.binary addi %c4216_i32, %78 overflow<nsw> : i32, i32 -> i32
      %276 = wave.ptr_add %108, %275 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %277 = waveamd.dma_load_lds %274 -> %276 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %278 = wave.join %259, %265, %271, %277 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %279 = wave.index_expr <"8 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %280 = wave.index_expr <"8 + s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %281 = wave.index_expr <"8 + 2*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %282 = wave.index_expr <"8 + 3*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %283 = wave.index_expr <"8 + 4*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %284 = wave.index_expr <"8 + 5*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %285 = wave.index_expr <"8 + 6*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %286 = wave.index_expr <"8 + 7*s0 + s0*s1 + 8*s0*Mod(wi, 2) + 128*s0*Mod(floor(1/16*wi), 2) + 64*s0*Mod(floor(1/8*wi), 2) + 32*s0*Mod(floor(1/4*wi), 2) + 16*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg10, %43) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %287 = wave.assume %279 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %288 = wave.ptr_add %130, %287 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_30, %token_31 = wave.load %288 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %289 = wave.assume %280 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %290 = wave.ptr_add %130, %289 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_32, %token_33 = wave.load %290 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %291 = wave.assume %281 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %292 = wave.ptr_add %130, %291 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_34, %token_35 = wave.load %292 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %293 = wave.assume %282 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %294 = wave.ptr_add %130, %293 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_36, %token_37 = wave.load %294 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %295 = wave.assume %283 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %296 = wave.ptr_add %130, %295 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_38, %token_39 = wave.load %296 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %297 = wave.assume %284 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %298 = wave.ptr_add %130, %297 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_40, %token_41 = wave.load %298 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %299 = wave.assume %285 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %300 = wave.ptr_add %130, %299 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_42, %token_43 = wave.load %300 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %301 = wave.assume %286 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %302 = wave.ptr_add %130, %301 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_44, %token_45 = wave.load %302 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %303 = wave.index_expr <"8 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %304 = wave.index_expr <"8 + s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %305 = wave.index_expr <"8 + 2*s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %306 = wave.index_expr <"8 + 3*s0 + s0*s1 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s0*s1 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1"](%52, %arg11, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %307 = wave.assume %303 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %308 = wave.ptr_add %155, %307 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_46, %token_47 = wave.load %308 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %309 = wave.assume %304 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %310 = wave.ptr_add %155, %309 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_48, %token_49 = wave.load %310 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %311 = wave.assume %305 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %312 = wave.ptr_add %155, %311 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_50, %token_51 = wave.load %312 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %313 = wave.assume %306 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %314 = wave.ptr_add %155, %313 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_52, %token_53 = wave.load %314 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %315 = wave.join %252, %278 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %316 = wave.ptr_add %40, %c16864_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
      %317 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %318 = wave.assume %317 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %319 = wave.ptr_add %107, %318 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %320 = wave.ptr_add %169, %257 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %321 = waveamd.dma_load_lds %319 -> %320 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %322 = wave.index_expr <"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 4*s0*Mod(1 + floor(1/256*wi), 2) + 8*s0*Mod(floor(1/2 + 1/512*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %323 = wave.assume %322 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %324 = wave.ptr_add %107, %323 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %325 = wave.ptr_add %169, %263 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %326 = waveamd.dma_load_lds %324 -> %325 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %327 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/512*wi), 2) + 4*s0*Mod(floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %328 = wave.assume %327 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %329 = wave.ptr_add %107, %328 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %330 = wave.ptr_add %169, %269 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %331 = waveamd.dma_load_lds %329 -> %330 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %332 = wave.index_expr <"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-2147483504 + s1 + 8*s0*Mod(1 + floor(1/2 + 1/512*wi), 2) + 4*s0*Mod(1 + floor(1/256*wi), 2) + 2*s0*Mod(floor(1/128*wi), 2) + s0*Mod(floor(1/64*wi), 2) + 64*s0*Mod(floor(1/32*wi), 2) + 32*s0*Mod(floor(1/16*wi), 2) + 16*s0*Mod(floor(1/8*wi), 2) + 16*Mod(wi, 2) + 64*Mod(floor(1/4*wi), 2) + 32*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%52, %arg8, %45) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %333 = wave.assume %332 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483632 + x <= 0">] : !wave.simd<index, 64>
      %334 = wave.ptr_add %107, %333 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %335 = wave.ptr_add %169, %275 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %336 = waveamd.dma_load_lds %334 -> %335 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %337 = wave.join %321, %326, %331, %336 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %338 = wave.index_expr <"8 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %339 = wave.index_expr <"8 + s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(1, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %340 = wave.index_expr <"8 + 2*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(2, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %341 = wave.index_expr <"8 + 3*s0 + s1 + s0*s2 + 4*s0*Mod(wi, 2) + 64*s0*Mod(floor(1/16*wi), 2) + 32*s0*Mod(floor(1/8*wi), 2) + 16*s0*Mod(floor(1/4*wi), 2) + 8*s0*Mod(floor(1/2*wi), 2) + 4*Mod(floor(1/128*wi), 2) + 2*Mod(floor(1/64*wi), 2) + Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"8 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) >= 0">, #wave.pred<"-2147483639 + s1 + s0*s2 + s0*xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(8*Mod(floor(1/2*wi), 2), xor(3, 4*Mod(wi, 2)))))) + xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2))) <= 0">] ["wi", "s0", "s1", "s2"](%52, %arg11, %48, %46) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %342 = wave.assume %338 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %343 = wave.ptr_add %155, %342 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_54, %token_55 = wave.load %343 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %344 = wave.assume %339 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %345 = wave.ptr_add %155, %344 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_56, %token_57 = wave.load %345 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %346 = wave.assume %340 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %347 = wave.ptr_add %155, %346 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_58, %token_59 = wave.load %347 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %348 = wave.assume %341 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : !wave.simd<index, 64>
      %349 = wave.ptr_add %155, %348 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
      %value_60, %token_61 = wave.load %349 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
      %350 = wave.binary addi %44, %c256_i32 : i32, i32 -> i32
      %351 = wave.binary addi %47, %c256_i32 : i32, i32 -> i32
      %352 = wave.barrier %168 : (!wave.mem.token) -> !wave.mem.token
      %353 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %354 = wave.ptr_add %38, %353 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_62, %token_63 = wave.load %354 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %355 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %356 = wave.ptr_add %38, %355 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_64, %token_65 = wave.load %356 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %357 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %358 = wave.ptr_add %38, %357 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_66, %token_67 = wave.load %358 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %359 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %360 = wave.ptr_add %38, %359 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_68, %token_69 = wave.load %360 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %361 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %362 = wave.ptr_add %38, %361 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_70, %token_71 = wave.load %362 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %363 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %364 = wave.ptr_add %38, %363 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_72, %token_73 = wave.load %364 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %365 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %366 = wave.ptr_add %38, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_74, %token_75 = wave.load %366 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %367 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 16896*Mod(floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %368 = wave.ptr_add %38, %367 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_76, %token_77 = wave.load %368 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %369 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %370 = wave.ptr_add %38, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_78, %token_79 = wave.load %370 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %371 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 16896*Mod(1 + floor(1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %372 = wave.ptr_add %38, %371 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_80, %token_81 = wave.load %372 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %373 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %374 = wave.ptr_add %38, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_82, %token_83 = wave.load %374 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %375 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/2*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 512*Mod(floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %376 = wave.ptr_add %38, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_84, %token_85 = wave.load %376 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %377 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %378 = wave.ptr_add %38, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_86, %token_87 = wave.load %378 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %379 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/2*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/4*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 512*Mod(1 + floor(1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 256*Mod(floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %380 = wave.ptr_add %38, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_88, %token_89 = wave.load %380 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %381 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %382 = wave.ptr_add %38, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_90, %token_91 = wave.load %382 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %383 = wave.index_expr <"64 + 32*floor(1/16 + 1/32*floor(1/32*Mod(wi, 64)) + 1/4*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 1/2*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 1/64*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/128*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/256*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/512*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 1/8*Mod(floor(1/128*wi), 2)) + 32*floor(1/32*Mod(wi, 64)) + 256*Mod(1 + floor(1/2*floor(1/128*wi) + 1/32*Mod(Mod(wi, 64), 16)), 2) + 512*Mod(1 + floor(1/2 + 1/4*floor(1/128*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 16896*Mod(1 + floor(3/4 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 16*Mod(1/16*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 8*Mod(1/8*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 4*Mod(1/4*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 2*Mod(1/2*(64 + 16*floor(1/16*Mod(wi, 64))), 2) + 128*Mod(floor(1/128*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %384 = wave.ptr_add %38, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_92, %token_93 = wave.load %384 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %385 = wave.index_expr <"16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %386 = wave.ptr_add %39, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_94, %token_95 = wave.load %386 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %387 = wave.index_expr <"64 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %388 = wave.ptr_add %39, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_96, %token_97 = wave.load %388 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %389 = wave.index_expr <"256 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %390 = wave.ptr_add %39, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_98, %token_99 = wave.load %390 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %391 = wave.index_expr <"320 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %392 = wave.ptr_add %39, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_100, %token_101 = wave.load %392 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %393 = wave.index_expr <"512 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %394 = wave.ptr_add %39, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_102, %token_103 = wave.load %394 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %395 = wave.index_expr <"576 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %396 = wave.ptr_add %39, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_104, %token_105 = wave.load %396 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %397 = wave.index_expr <"768 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %398 = wave.ptr_add %39, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_106, %token_107 = wave.load %398 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %399 = wave.index_expr <"832 + 16*floor(1/16*Mod(wi, 64)) + 128*Mod(floor(1/64*wi), 2) + 1056*Mod(Mod(wi, 64), 16)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %400 = wave.ptr_add %39, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_108, %token_109 = wave.load %400 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %401 = wave.binary divui %52, %14 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %402 = wave.binary remui %401, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %403 = wave.binary divui %52, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %404 = wave.binary remui %403, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %405 = wave.binary muli %404, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %406 = wave.binary xori %402, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %407 = wave.binary divui %52, %11 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %408 = wave.binary remui %407, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %409 = wave.binary muli %408, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %410 = wave.binary xori %406, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %411 = wave.binary divui %52, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %412 = wave.binary remui %411, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %413 = wave.binary muli %412, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %414 = wave.binary xori %410, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %415 = wave.binary divui %52, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %416 = wave.binary remui %415, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %417 = wave.binary muli %416, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %418 = wave.binary xori %414, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %419 = wave.binary remui %52, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %420 = wave.binary divui %52, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %421 = wave.binary remui %420, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %422 = wave.binary muli %421, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %423 = wave.binary xori %419, %422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %424 = wave.binary divui %52, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %425 = wave.binary remui %424, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %426 = wave.binary muli %425, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %427 = wave.binary xori %423, %426 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %428 = wave.binary muli %427, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %429 = wave.binary addi %428, %418 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %430 = wave.binary xori %11, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %431 = wave.binary xori %430, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %432 = wave.binary xori %431, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %433 = wave.binary xori %432, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %434 = wave.binary xori %433, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %435 = wave.binary addi %428, %434 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %436 = wave.binary xori %9, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %437 = wave.binary xori %436, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %438 = wave.binary xori %437, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %439 = wave.binary xori %438, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %440 = wave.binary xori %439, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %441 = wave.binary addi %428, %440 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %442 = wave.binary xori %6, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %443 = wave.binary xori %442, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %444 = wave.binary xori %443, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %445 = wave.binary xori %444, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %446 = wave.binary xori %445, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %447 = wave.binary addi %428, %446 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %448 = wave.binary xori %8, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %449 = wave.binary xori %448, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %450 = wave.binary xori %449, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %451 = wave.binary xori %450, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %452 = wave.binary xori %451, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %453 = wave.binary addi %428, %452 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %454 = wave.binary xori %5, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %455 = wave.binary xori %454, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %456 = wave.binary xori %455, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %457 = wave.binary xori %456, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %458 = wave.binary xori %457, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %459 = wave.binary addi %428, %458 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %460 = wave.binary xori %4, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %461 = wave.binary xori %460, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %462 = wave.binary xori %461, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %463 = wave.binary xori %462, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %464 = wave.binary xori %463, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %465 = wave.binary addi %428, %464 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %466 = wave.binary xori %3, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %467 = wave.binary xori %466, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %468 = wave.binary xori %467, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %469 = wave.binary xori %468, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %470 = wave.binary xori %469, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %471 = wave.binary addi %428, %470 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %472 = wave.ptr_add %41, %429 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %473 = wave.store %value -> %472 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %474 = wave.ptr_add %41, %435 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %475 = wave.store %value_0 -> %474 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %476 = wave.ptr_add %41, %441 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %477 = wave.store %value_2 -> %476 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %478 = wave.ptr_add %41, %447 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %479 = wave.store %value_4 -> %478 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %480 = wave.ptr_add %41, %453 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %481 = wave.store %value_6 -> %480 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %482 = wave.ptr_add %41, %459 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %483 = wave.store %value_8 -> %482 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %484 = wave.ptr_add %41, %465 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %485 = wave.store %value_10 -> %484 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %486 = wave.ptr_add %41, %471 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %487 = wave.store %value_12 -> %486 after %57 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %488 = wave.barrier %473, %475, %477, %479, %481, %483, %485, %487 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %489 = wave.binary muli %427, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %490 = wave.binary addi %489, %418 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %491 = wave.binary addi %489, %434 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %492 = wave.binary addi %489, %440 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %493 = wave.binary addi %489, %446 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %494 = wave.ptr_add %42, %490 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %495 = wave.store %value_14 -> %494 after %488 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %496 = wave.ptr_add %42, %491 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %497 = wave.store %value_16 -> %496 after %488 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %498 = wave.ptr_add %42, %492 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %499 = wave.store %value_18 -> %498 after %488 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %500 = wave.ptr_add %42, %493 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %501 = wave.store %value_20 -> %500 after %488 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %502 = wave.barrier %495, %497, %499, %501 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %503 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %504 = wave.ptr_add %41, %503 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_110, %token_111 = waveamd.transpose_load %504 after %502 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %505 = wave.extract %value_110[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %506 = wave.extract %value_110[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %507 = wave.index_expr <"128 + 8*Mod(wi, 2) + 16*Mod(floor(1/128*wi), 2) + 512*Mod(floor(1/32*wi), 2) + 256*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 1024*Mod(floor(1/2*wi), 2)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %508 = wave.ptr_add %41, %507 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_112, %token_113 = waveamd.transpose_load %508 after %502 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %509 = wave.extract %value_112[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %510 = wave.extract %value_112[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %511 = wave.join %token_111, %token_113 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %512 = wave.index_expr <"8*Mod(wi, 2) + 16*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/32*wi), 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 512*Mod(floor(1/2*wi), 2)"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %513 = wave.ptr_add %42, %512 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_114, %token_115 = waveamd.transpose_load %513 after %511 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %514 = wave.extract %value_114[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %515 = wave.extract %value_114[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %516 = wave.pack %value_22, %value_24, %value_26, %value_28 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %517 = wave.pack %value_30, %value_32, %value_34, %value_36, %value_38, %value_40, %value_42, %value_44 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %518 = wave.pack %value_46, %value_48, %value_50, %value_52 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %519 = wave.pack %value_54, %value_56, %value_58, %value_60 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %520:105 = scf.for %arg12 = %c0_i32 to %c62_i32 step %c2_i32 iter_args(%arg13 = %350, %arg14 = %351, %arg15 = %c16_i32, %arg16 = %c16_i32, %arg17 = %16, %arg18 = %16, %arg19 = %16, %arg20 = %16, %arg21 = %16, %arg22 = %16, %arg23 = %16, %arg24 = %16, %arg25 = %16, %arg26 = %16, %arg27 = %16, %arg28 = %16, %arg29 = %16, %arg30 = %16, %arg31 = %16, %arg32 = %16, %arg33 = %16, %arg34 = %16, %arg35 = %16, %arg36 = %16, %arg37 = %16, %arg38 = %16, %arg39 = %16, %arg40 = %16, %arg41 = %16, %arg42 = %16, %arg43 = %16, %arg44 = %16, %arg45 = %16, %arg46 = %16, %arg47 = %16, %arg48 = %16, %arg49 = %16, %arg50 = %16, %arg51 = %16, %arg52 = %16, %arg53 = %16, %arg54 = %16, %arg55 = %16, %arg56 = %16, %arg57 = %16, %arg58 = %16, %arg59 = %16, %arg60 = %16, %arg61 = %16, %arg62 = %16, %arg63 = %16, %arg64 = %16, %arg65 = %16, %arg66 = %16, %arg67 = %16, %arg68 = %16, %arg69 = %16, %arg70 = %16, %arg71 = %16, %arg72 = %16, %arg73 = %16, %arg74 = %16, %arg75 = %16, %arg76 = %16, %arg77 = %16, %arg78 = %16, %arg79 = %16, %arg80 = %16, %arg81 = %516, %arg82 = %517, %arg83 = %518, %arg84 = %519, %arg85 = %value_62, %arg86 = %value_64, %arg87 = %value_66, %arg88 = %value_68, %arg89 = %value_70, %arg90 = %value_72, %arg91 = %value_74, %arg92 = %value_76, %arg93 = %value_78, %arg94 = %value_80, %arg95 = %value_82, %arg96 = %value_84, %arg97 = %value_86, %arg98 = %value_88, %arg99 = %value_90, %arg100 = %value_92, %arg101 = %value_94, %arg102 = %value_96, %arg103 = %value_98, %arg104 = %value_100, %arg105 = %value_102, %arg106 = %value_104, %arg107 = %value_106, %arg108 = %value_108, %arg109 = %505, %arg110 = %506, %arg111 = %509, %arg112 = %510, %arg113 = %514, %arg114 = %515, %arg115 = %190, %arg116 = %315, %arg117 = %337) -> (i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<8xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %2030 = waveamd.fragment_pack %arg85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2031 = waveamd.fragment_pack %arg86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2032 = waveamd.fragment_pack %arg87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2033 = waveamd.fragment_pack %arg88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2034 = waveamd.fragment_pack %arg89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2035 = waveamd.fragment_pack %arg90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2036 = waveamd.fragment_pack %arg91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2037 = waveamd.fragment_pack %arg92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2038 = waveamd.fragment_pack %arg93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2039 = waveamd.fragment_pack %arg94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2040 = waveamd.fragment_pack %arg95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2041 = waveamd.fragment_pack %arg96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2042 = waveamd.fragment_pack %arg97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2043 = waveamd.fragment_pack %arg98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2044 = waveamd.fragment_pack %arg99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2045 = waveamd.fragment_pack %arg100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2046 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2047 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2048 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2049 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2050 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2051 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2052 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2053 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2054 = waveamd.fragment_pack %arg17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2055 = waveamd.fragment_pack %arg18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2056 = waveamd.fragment_pack %arg19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2057 = waveamd.fragment_pack %arg20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2058 = waveamd.fragment_pack %arg21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2059 = waveamd.fragment_pack %arg22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2060 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2061 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2062 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2063 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2064 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2065 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2066 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2067 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2068 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2069 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2070 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2071 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2072 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2073 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2074 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2075 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2076 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2077 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2078 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2079 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2080 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2081 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2082 = waveamd.fragment_pack %arg45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2083 = waveamd.fragment_pack %arg46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2084 = waveamd.fragment_pack %arg47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2085 = waveamd.fragment_pack %arg48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2086 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2030, %arg109, %2054 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2087 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2031, %arg109, %2086 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2088 = waveamd.fragment_unpack %2087 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2089 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2030, %arg109, %2055 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2090 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2031, %arg109, %2089 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2091 = waveamd.fragment_unpack %2090 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2092 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2030, %arg109, %2056 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2093 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2031, %arg109, %2092 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2094 = waveamd.fragment_unpack %2093 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2095 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2030, %arg109, %2057 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2096 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2031, %arg109, %2095 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2097 = waveamd.fragment_unpack %2096 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2098 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2032, %arg109, %2058 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2099 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2033, %arg109, %2098 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2100 = waveamd.fragment_unpack %2099 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2101 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2032, %arg109, %2059 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2102 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2033, %arg109, %2101 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2103 = waveamd.fragment_unpack %2102 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2104 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2032, %arg109, %2060 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2105 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2033, %arg109, %2104 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2106 = waveamd.fragment_unpack %2105 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2107 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2032, %arg109, %2061 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2108 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2033, %arg109, %2107 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2109 = waveamd.fragment_unpack %2108 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2110 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2034, %arg110, %2062 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2111 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2035, %arg110, %2110 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2112 = waveamd.fragment_unpack %2111 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2113 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2034, %arg110, %2063 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2114 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2035, %arg110, %2113 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2115 = waveamd.fragment_unpack %2114 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2116 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2034, %arg110, %2064 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2117 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2035, %arg110, %2116 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2118 = waveamd.fragment_unpack %2117 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2119 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2034, %arg110, %2065 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2120 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2035, %arg110, %2119 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2121 = waveamd.fragment_unpack %2120 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2122 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2036, %arg110, %2066 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2123 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2037, %arg110, %2122 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2124 = waveamd.fragment_unpack %2123 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2125 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2036, %arg110, %2067 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2126 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2037, %arg110, %2125 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2127 = waveamd.fragment_unpack %2126 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2128 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2036, %arg110, %2068 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2129 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2037, %arg110, %2128 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2130 = waveamd.fragment_unpack %2129 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2131 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2036, %arg110, %2069 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2132 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2037, %arg110, %2131 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2133 = waveamd.fragment_unpack %2132 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2134 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2038, %arg111, %2070 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2135 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2039, %arg111, %2134 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2136 = waveamd.fragment_unpack %2135 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2137 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2038, %arg111, %2071 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2138 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2039, %arg111, %2137 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2139 = waveamd.fragment_unpack %2138 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2140 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2038, %arg111, %2072 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2141 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2039, %arg111, %2140 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2142 = waveamd.fragment_unpack %2141 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2143 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2038, %arg111, %2073 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2144 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2039, %arg111, %2143 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2145 = waveamd.fragment_unpack %2144 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2146 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2040, %arg111, %2074 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2147 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2041, %arg111, %2146 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2148 = waveamd.fragment_unpack %2147 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2149 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2040, %arg111, %2075 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2150 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2041, %arg111, %2149 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2151 = waveamd.fragment_unpack %2150 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2152 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2040, %arg111, %2076 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2153 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2041, %arg111, %2152 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2154 = waveamd.fragment_unpack %2153 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2155 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2040, %arg111, %2077 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2156 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2041, %arg111, %2155 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2157 = waveamd.fragment_unpack %2156 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2158 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2042, %arg112, %2078 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2159 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2043, %arg112, %2158 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2160 = waveamd.fragment_unpack %2159 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2161 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2042, %arg112, %2079 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2162 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2043, %arg112, %2161 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2163 = waveamd.fragment_unpack %2162 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2164 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2042, %arg112, %2080 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2165 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2043, %arg112, %2164 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2166 = waveamd.fragment_unpack %2165 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2167 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2042, %arg112, %2081 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2168 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2043, %arg112, %2167 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2169 = waveamd.fragment_unpack %2168 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2170 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2046, %arg113, %2044, %arg112, %2082 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2171 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2047, %arg113, %2045, %arg112, %2170 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2172 = waveamd.fragment_unpack %2171 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2173 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2048, %arg113, %2044, %arg112, %2083 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2174 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2049, %arg113, %2045, %arg112, %2173 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2175 = waveamd.fragment_unpack %2174 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2176 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2050, %arg114, %2044, %arg112, %2084 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2177 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2051, %arg114, %2045, %arg112, %2176 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2178 = waveamd.fragment_unpack %2177 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2179 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2052, %arg114, %2044, %arg112, %2085 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2180 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2053, %arg114, %2045, %arg112, %2179 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2181 = waveamd.fragment_unpack %2180 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2182 = wave.barrier %arg115 : (!wave.mem.token) -> !wave.mem.token
        %2183 = wave.ptr_add %40, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_270, %token_271 = wave.load %2183 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2184 = wave.ptr_add %40, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_272, %token_273 = wave.load %2184 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2185 = wave.ptr_add %40, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_274, %token_275 = wave.load %2185 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2186 = wave.ptr_add %40, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_276, %token_277 = wave.load %2186 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2187 = wave.ptr_add %40, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_278, %token_279 = wave.load %2187 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2188 = wave.ptr_add %40, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_280, %token_281 = wave.load %2188 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2189 = wave.ptr_add %40, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_282, %token_283 = wave.load %2189 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2190 = wave.ptr_add %40, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_284, %token_285 = wave.load %2190 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2191 = wave.binary muli %419, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2192 = wave.binary muli %421, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2193 = wave.binary xori %2191, %2192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2194 = wave.binary muli %425, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2195 = wave.binary xori %2193, %2194 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2196 = wave.binary muli %402, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2197 = wave.binary xori %2195, %2196 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2198 = wave.binary muli %404, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2199 = wave.binary xori %2197, %2198 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2200 = wave.binary muli %412, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2201 = wave.binary xori %408, %2200 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2202 = wave.binary muli %416, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2203 = wave.binary xori %2201, %2202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2204 = wave.binary muli %2203, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2205 = wave.binary addi %2204, %2199 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2206 = wave.ptr_add %42, %2205 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2207 = wave.store %arg81 -> %2206 after %token_115 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2208 = wave.barrier %2207 : (!wave.mem.token) -> !wave.mem.token
        %value_286, %token_287 = waveamd.transpose_load %513 after %2208 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2209 = wave.extract %value_286[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2210 = wave.extract %value_286[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2211 = wave.ptr_add %arg0, %arg13 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2212 = waveamd.make_buffer %2211, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2213 = wave.ptr_add %2212, %59 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2214 = waveamd.dma_load_lds %2213 -> %61 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2215 = wave.ptr_add %2212, %64 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2216 = waveamd.dma_load_lds %2215 -> %67 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2217 = wave.ptr_add %2212, %70 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2218 = waveamd.dma_load_lds %2217 -> %73 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2219 = wave.ptr_add %2212, %76 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2220 = waveamd.dma_load_lds %2219 -> %79 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2221 = wave.ptr_add %2212, %82 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2222 = waveamd.dma_load_lds %2221 -> %85 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2223 = wave.ptr_add %2212, %88 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2224 = waveamd.dma_load_lds %2223 -> %91 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2225 = wave.ptr_add %2212, %94 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2226 = waveamd.dma_load_lds %2225 -> %97 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2227 = wave.ptr_add %2212, %100 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2228 = waveamd.dma_load_lds %2227 -> %103 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2229 = wave.join %2214, %2216, %2218, %2220, %2222, %2224, %2226, %2228 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2230 = wave.ptr_add %arg1, %arg14 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2231 = waveamd.make_buffer %2230, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2232 = wave.ptr_add %2231, %110 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2233 = waveamd.dma_load_lds %2232 -> %112 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2234 = wave.ptr_add %2231, %115 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2235 = waveamd.dma_load_lds %2234 -> %117 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2236 = wave.ptr_add %2231, %120 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2237 = waveamd.dma_load_lds %2236 -> %122 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2238 = wave.ptr_add %2231, %125 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2239 = waveamd.dma_load_lds %2238 -> %127 after %arg115 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2240 = wave.join %2233, %2235, %2237, %2239 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2241 = wave.ptr_add %arg3, %arg15 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2242 = waveamd.make_buffer %2241, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2243 = wave.ptr_add %2242, %139 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_288, %token_289 = wave.load %2243 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2244 = wave.ptr_add %2242, %141 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_290, %token_291 = wave.load %2244 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2245 = wave.ptr_add %2242, %143 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_292, %token_293 = wave.load %2245 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2246 = wave.ptr_add %2242, %145 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_294, %token_295 = wave.load %2246 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2247 = wave.ptr_add %2242, %147 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_296, %token_297 = wave.load %2247 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2248 = wave.ptr_add %2242, %149 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_298, %token_299 = wave.load %2248 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2249 = wave.ptr_add %2242, %151 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_300, %token_301 = wave.load %2249 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2250 = wave.ptr_add %2242, %153 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_302, %token_303 = wave.load %2250 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2251 = wave.ptr_add %arg4, %arg16 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %2252 = waveamd.make_buffer %2251, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %2253 = wave.ptr_add %2252, %160 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_304, %token_305 = wave.load %2253 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2254 = wave.ptr_add %2252, %162 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_306, %token_307 = wave.load %2254 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2255 = wave.ptr_add %2252, %164 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_308, %token_309 = wave.load %2255 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2256 = wave.ptr_add %2252, %166 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_310, %token_311 = wave.load %2256 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2257 = wave.join %2229, %2240 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2258 = waveamd.fragment_pack %value_270 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2259 = waveamd.fragment_pack %value_272 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2260 = waveamd.fragment_pack %value_274 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2261 = waveamd.fragment_pack %value_276 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2262 = waveamd.fragment_pack %value_278 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2263 = waveamd.fragment_pack %value_280 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2264 = waveamd.fragment_pack %value_282 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2265 = waveamd.fragment_pack %value_284 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2266 = waveamd.fragment_pack %arg49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2267 = waveamd.fragment_pack %arg50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2268 = waveamd.fragment_pack %arg51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2269 = waveamd.fragment_pack %arg52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2270 = waveamd.fragment_pack %arg53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2271 = waveamd.fragment_pack %arg54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2272 = waveamd.fragment_pack %arg55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2273 = waveamd.fragment_pack %arg56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2274 = waveamd.fragment_pack %arg57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2275 = waveamd.fragment_pack %arg58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2276 = waveamd.fragment_pack %arg59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2277 = waveamd.fragment_pack %arg60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2278 = waveamd.fragment_pack %arg61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2279 = waveamd.fragment_pack %arg62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2280 = waveamd.fragment_pack %arg63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2281 = waveamd.fragment_pack %arg64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2282 = waveamd.fragment_pack %arg65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2283 = waveamd.fragment_pack %arg66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2284 = waveamd.fragment_pack %arg67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2285 = waveamd.fragment_pack %arg68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2286 = waveamd.fragment_pack %arg69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2287 = waveamd.fragment_pack %arg70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2288 = waveamd.fragment_pack %arg71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2289 = waveamd.fragment_pack %arg72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2290 = waveamd.fragment_pack %arg73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2291 = waveamd.fragment_pack %arg74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2292 = waveamd.fragment_pack %arg75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2293 = waveamd.fragment_pack %arg76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2294 = waveamd.fragment_pack %arg77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2295 = waveamd.fragment_pack %arg78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2296 = waveamd.fragment_pack %arg79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2297 = waveamd.fragment_pack %arg80 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2298 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2030, %arg109, %2266 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2299 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2031, %arg109, %2298 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2300 = waveamd.fragment_unpack %2299 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2301 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2030, %arg109, %2267 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2302 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2031, %arg109, %2301 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2303 = waveamd.fragment_unpack %2302 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2304 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2030, %arg109, %2268 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2305 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2031, %arg109, %2304 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2306 = waveamd.fragment_unpack %2305 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2307 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2030, %arg109, %2269 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2308 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2031, %arg109, %2307 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2309 = waveamd.fragment_unpack %2308 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2310 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2032, %arg109, %2270 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2311 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2033, %arg109, %2310 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2312 = waveamd.fragment_unpack %2311 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2313 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2032, %arg109, %2271 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2314 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2033, %arg109, %2313 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2315 = waveamd.fragment_unpack %2314 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2316 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2032, %arg109, %2272 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2317 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2033, %arg109, %2316 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2318 = waveamd.fragment_unpack %2317 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2319 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2032, %arg109, %2273 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2320 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2033, %arg109, %2319 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2321 = waveamd.fragment_unpack %2320 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2322 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2034, %arg110, %2274 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2323 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2035, %arg110, %2322 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2324 = waveamd.fragment_unpack %2323 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2325 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2034, %arg110, %2275 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2326 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2035, %arg110, %2325 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2327 = waveamd.fragment_unpack %2326 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2328 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2034, %arg110, %2276 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2329 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2035, %arg110, %2328 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2330 = waveamd.fragment_unpack %2329 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2331 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2034, %arg110, %2277 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2332 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2035, %arg110, %2331 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2333 = waveamd.fragment_unpack %2332 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2334 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2036, %arg110, %2278 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2335 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2037, %arg110, %2334 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2336 = waveamd.fragment_unpack %2335 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2337 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2036, %arg110, %2279 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2338 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2037, %arg110, %2337 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2339 = waveamd.fragment_unpack %2338 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2340 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2036, %arg110, %2280 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2341 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2037, %arg110, %2340 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2342 = waveamd.fragment_unpack %2341 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2343 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2036, %arg110, %2281 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2344 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2037, %arg110, %2343 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2345 = waveamd.fragment_unpack %2344 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2346 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2038, %arg111, %2282 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2347 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2039, %arg111, %2346 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2348 = waveamd.fragment_unpack %2347 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2349 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2038, %arg111, %2283 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2350 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2039, %arg111, %2349 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2351 = waveamd.fragment_unpack %2350 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2352 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2038, %arg111, %2284 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2353 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2039, %arg111, %2352 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2354 = waveamd.fragment_unpack %2353 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2355 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2038, %arg111, %2285 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2356 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2039, %arg111, %2355 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2357 = waveamd.fragment_unpack %2356 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2358 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2040, %arg111, %2286 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2359 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2041, %arg111, %2358 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2360 = waveamd.fragment_unpack %2359 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2361 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2040, %arg111, %2287 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2362 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2041, %arg111, %2361 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2363 = waveamd.fragment_unpack %2362 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2364 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2040, %arg111, %2288 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2365 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2041, %arg111, %2364 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2366 = waveamd.fragment_unpack %2365 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2367 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2040, %arg111, %2289 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2368 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2041, %arg111, %2367 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2369 = waveamd.fragment_unpack %2368 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2370 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2042, %arg112, %2290 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2371 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2043, %arg112, %2370 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2372 = waveamd.fragment_unpack %2371 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2373 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2042, %arg112, %2291 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2374 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2043, %arg112, %2373 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2375 = waveamd.fragment_unpack %2374 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2376 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2042, %arg112, %2292 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2377 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2043, %arg112, %2376 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2378 = waveamd.fragment_unpack %2377 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2379 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2042, %arg112, %2293 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2380 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2043, %arg112, %2379 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2381 = waveamd.fragment_unpack %2380 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2382 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2258, %2209, %2044, %arg112, %2294 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2383 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2259, %2209, %2045, %arg112, %2382 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2384 = waveamd.fragment_unpack %2383 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2385 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2260, %2209, %2044, %arg112, %2295 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2386 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2261, %2209, %2045, %arg112, %2385 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2387 = waveamd.fragment_unpack %2386 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2388 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2262, %2210, %2044, %arg112, %2296 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2389 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2263, %2210, %2045, %arg112, %2388 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2390 = waveamd.fragment_unpack %2389 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2391 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2264, %2210, %2044, %arg112, %2297 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2392 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2265, %2210, %2045, %arg112, %2391 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2393 = waveamd.fragment_unpack %2392 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2394 = wave.barrier %arg116 : (!wave.mem.token) -> !wave.mem.token
        %2395 = wave.ptr_add %203, %353 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_312, %token_313 = wave.load %2395 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2396 = wave.ptr_add %203, %355 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_314, %token_315 = wave.load %2396 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2397 = wave.ptr_add %203, %357 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_316, %token_317 = wave.load %2397 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2398 = wave.ptr_add %203, %359 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_318, %token_319 = wave.load %2398 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2399 = wave.ptr_add %203, %361 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_320, %token_321 = wave.load %2399 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2400 = wave.ptr_add %203, %363 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_322, %token_323 = wave.load %2400 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2401 = wave.ptr_add %203, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_324, %token_325 = wave.load %2401 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2402 = wave.ptr_add %203, %367 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_326, %token_327 = wave.load %2402 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2403 = wave.ptr_add %203, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_328, %token_329 = wave.load %2403 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2404 = wave.ptr_add %203, %371 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_330, %token_331 = wave.load %2404 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2405 = wave.ptr_add %203, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_332, %token_333 = wave.load %2405 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2406 = wave.ptr_add %203, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_334, %token_335 = wave.load %2406 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2407 = wave.ptr_add %203, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_336, %token_337 = wave.load %2407 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2408 = wave.ptr_add %203, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_338, %token_339 = wave.load %2408 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2409 = wave.ptr_add %203, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_340, %token_341 = wave.load %2409 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2410 = wave.ptr_add %203, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_342, %token_343 = wave.load %2410 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2411 = wave.ptr_add %253, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_344, %token_345 = wave.load %2411 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2412 = wave.ptr_add %253, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_346, %token_347 = wave.load %2412 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2413 = wave.ptr_add %253, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_348, %token_349 = wave.load %2413 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2414 = wave.ptr_add %253, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_350, %token_351 = wave.load %2414 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2415 = wave.ptr_add %253, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_352, %token_353 = wave.load %2415 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2416 = wave.ptr_add %253, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_354, %token_355 = wave.load %2416 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2417 = wave.ptr_add %253, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_356, %token_357 = wave.load %2417 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2418 = wave.ptr_add %253, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_358, %token_359 = wave.load %2418 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2419 = wave.binary muli %419, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2420 = wave.binary muli %421, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2421 = wave.binary xori %2419, %2420 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2422 = wave.binary muli %425, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2423 = wave.binary xori %2421, %2422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2424 = wave.binary muli %402, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2425 = wave.binary xori %2423, %2424 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2426 = wave.binary muli %404, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2427 = wave.binary xori %2425, %2426 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2428 = wave.binary muli %2203, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2429 = wave.binary addi %2428, %2427 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2430 = wave.ptr_add %41, %2429 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %2431 = wave.store %arg82 -> %2430 after %token_287 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2432 = wave.barrier %2431 : (!wave.mem.token) -> !wave.mem.token
        %2433 = wave.store %arg83 -> %2206 after %2432 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2434 = wave.barrier %2433 : (!wave.mem.token) -> !wave.mem.token
        %value_360, %token_361 = waveamd.transpose_load %504 after %2434 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2435 = wave.extract %value_360[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2436 = wave.extract %value_360[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_362, %token_363 = waveamd.transpose_load %508 after %2434 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2437 = wave.extract %value_362[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2438 = wave.extract %value_362[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2439 = wave.join %token_361, %token_363 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_364, %token_365 = waveamd.transpose_load %513 after %2439 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2440 = wave.extract %value_364[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2441 = wave.extract %value_364[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2442 = wave.ptr_add %2231, %171 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2443 = waveamd.dma_load_lds %2442 -> %173 after %arg116 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2444 = wave.ptr_add %2231, %176 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2445 = waveamd.dma_load_lds %2444 -> %178 after %arg116 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2446 = wave.ptr_add %2231, %181 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2447 = waveamd.dma_load_lds %2446 -> %183 after %arg116 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2448 = wave.ptr_add %2231, %186 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2449 = waveamd.dma_load_lds %2448 -> %188 after %arg116 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2450 = wave.join %2443, %2445, %2447, %2449 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2451 = wave.ptr_add %2252, %195 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_366, %token_367 = wave.load %2451 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2452 = wave.ptr_add %2252, %197 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_368, %token_369 = wave.load %2452 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2453 = wave.ptr_add %2252, %199 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_370, %token_371 = wave.load %2453 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2454 = wave.ptr_add %2252, %201 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_372, %token_373 = wave.load %2454 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2455 = waveamd.fragment_pack %value_312 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2456 = waveamd.fragment_pack %value_314 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2457 = waveamd.fragment_pack %value_316 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2458 = waveamd.fragment_pack %value_318 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2459 = waveamd.fragment_pack %value_320 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2460 = waveamd.fragment_pack %value_322 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2461 = waveamd.fragment_pack %value_324 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2462 = waveamd.fragment_pack %value_326 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2463 = waveamd.fragment_pack %value_328 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2464 = waveamd.fragment_pack %value_330 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2465 = waveamd.fragment_pack %value_332 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2466 = waveamd.fragment_pack %value_334 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2467 = waveamd.fragment_pack %value_336 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2468 = waveamd.fragment_pack %value_338 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2469 = waveamd.fragment_pack %value_340 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2470 = waveamd.fragment_pack %value_342 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %2471 = waveamd.fragment_pack %value_344 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2472 = waveamd.fragment_pack %value_346 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2473 = waveamd.fragment_pack %value_348 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2474 = waveamd.fragment_pack %value_350 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2475 = waveamd.fragment_pack %value_352 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2476 = waveamd.fragment_pack %value_354 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2477 = waveamd.fragment_pack %value_356 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2478 = waveamd.fragment_pack %value_358 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2479 = waveamd.fragment_pack %2088 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2480 = waveamd.fragment_pack %2091 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2481 = waveamd.fragment_pack %2094 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2482 = waveamd.fragment_pack %2097 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2483 = waveamd.fragment_pack %2100 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2484 = waveamd.fragment_pack %2103 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2485 = waveamd.fragment_pack %2106 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2486 = waveamd.fragment_pack %2109 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2487 = waveamd.fragment_pack %2112 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2488 = waveamd.fragment_pack %2115 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2489 = waveamd.fragment_pack %2118 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2490 = waveamd.fragment_pack %2121 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2491 = waveamd.fragment_pack %2124 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2492 = waveamd.fragment_pack %2127 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2493 = waveamd.fragment_pack %2130 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2494 = waveamd.fragment_pack %2133 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2495 = waveamd.fragment_pack %2136 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2496 = waveamd.fragment_pack %2139 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2497 = waveamd.fragment_pack %2142 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2498 = waveamd.fragment_pack %2145 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2499 = waveamd.fragment_pack %2148 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2500 = waveamd.fragment_pack %2151 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2501 = waveamd.fragment_pack %2154 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2502 = waveamd.fragment_pack %2157 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2503 = waveamd.fragment_pack %2160 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2504 = waveamd.fragment_pack %2163 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2505 = waveamd.fragment_pack %2166 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2506 = waveamd.fragment_pack %2169 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2507 = waveamd.fragment_pack %2172 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2508 = waveamd.fragment_pack %2175 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2509 = waveamd.fragment_pack %2178 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2510 = waveamd.fragment_pack %2181 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2511 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2455, %2435, %2479 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2512 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2456, %2435, %2511 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2513 = waveamd.fragment_unpack %2512 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2514 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2455, %2435, %2480 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2515 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2456, %2435, %2514 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2516 = waveamd.fragment_unpack %2515 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2517 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2455, %2435, %2481 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2518 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2456, %2435, %2517 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2519 = waveamd.fragment_unpack %2518 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2520 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2455, %2435, %2482 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2521 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2456, %2435, %2520 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2522 = waveamd.fragment_unpack %2521 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2523 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2457, %2435, %2483 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2524 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2458, %2435, %2523 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2525 = waveamd.fragment_unpack %2524 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2526 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2457, %2435, %2484 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2527 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2458, %2435, %2526 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2528 = waveamd.fragment_unpack %2527 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2529 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2457, %2435, %2485 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2530 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2458, %2435, %2529 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2531 = waveamd.fragment_unpack %2530 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2532 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2457, %2435, %2486 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2533 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2458, %2435, %2532 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2534 = waveamd.fragment_unpack %2533 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2535 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2459, %2436, %2487 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2536 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2460, %2436, %2535 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2537 = waveamd.fragment_unpack %2536 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2538 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2459, %2436, %2488 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2539 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2460, %2436, %2538 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2540 = waveamd.fragment_unpack %2539 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2541 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2459, %2436, %2489 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2542 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2460, %2436, %2541 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2543 = waveamd.fragment_unpack %2542 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2544 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2459, %2436, %2490 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2545 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2460, %2436, %2544 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2546 = waveamd.fragment_unpack %2545 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2547 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2461, %2436, %2491 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2548 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2462, %2436, %2547 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2549 = waveamd.fragment_unpack %2548 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2550 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2461, %2436, %2492 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2551 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2462, %2436, %2550 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2552 = waveamd.fragment_unpack %2551 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2553 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2461, %2436, %2493 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2554 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2462, %2436, %2553 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2555 = waveamd.fragment_unpack %2554 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2556 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2461, %2436, %2494 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2557 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2462, %2436, %2556 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2558 = waveamd.fragment_unpack %2557 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2559 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2463, %2437, %2495 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2560 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2464, %2437, %2559 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2561 = waveamd.fragment_unpack %2560 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2562 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2463, %2437, %2496 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2563 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2464, %2437, %2562 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2564 = waveamd.fragment_unpack %2563 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2565 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2463, %2437, %2497 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2566 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2464, %2437, %2565 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2567 = waveamd.fragment_unpack %2566 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2568 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2463, %2437, %2498 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2569 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2464, %2437, %2568 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2570 = waveamd.fragment_unpack %2569 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2571 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2465, %2437, %2499 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2572 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2466, %2437, %2571 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2573 = waveamd.fragment_unpack %2572 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2574 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2465, %2437, %2500 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2575 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2466, %2437, %2574 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2576 = waveamd.fragment_unpack %2575 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2577 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2465, %2437, %2501 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2466, %2437, %2577 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2579 = waveamd.fragment_unpack %2578 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2465, %2437, %2502 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2466, %2437, %2580 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2582 = waveamd.fragment_unpack %2581 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2467, %2438, %2503 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2468, %2438, %2583 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2585 = waveamd.fragment_unpack %2584 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2586 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2467, %2438, %2504 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2468, %2438, %2586 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2588 = waveamd.fragment_unpack %2587 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2467, %2438, %2505 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2468, %2438, %2589 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2591 = waveamd.fragment_unpack %2590 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2467, %2438, %2506 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2468, %2438, %2592 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2594 = waveamd.fragment_unpack %2593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2471, %2440, %2469, %2438, %2507 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2472, %2440, %2470, %2438, %2595 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2597 = waveamd.fragment_unpack %2596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2473, %2440, %2469, %2438, %2508 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2474, %2440, %2470, %2438, %2598 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2600 = waveamd.fragment_unpack %2599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2475, %2441, %2469, %2438, %2509 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2476, %2441, %2470, %2438, %2601 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2603 = waveamd.fragment_unpack %2602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2477, %2441, %2469, %2438, %2510 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2478, %2441, %2470, %2438, %2604 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2606 = waveamd.fragment_unpack %2605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2607 = wave.barrier %arg117 : (!wave.mem.token) -> !wave.mem.token
        %2608 = wave.ptr_add %316, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_374, %token_375 = wave.load %2608 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2609 = wave.ptr_add %316, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_376, %token_377 = wave.load %2609 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2610 = wave.ptr_add %316, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_378, %token_379 = wave.load %2610 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2611 = wave.ptr_add %316, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_380, %token_381 = wave.load %2611 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2612 = wave.ptr_add %316, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_382, %token_383 = wave.load %2612 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2613 = wave.ptr_add %316, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_384, %token_385 = wave.load %2613 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2614 = wave.ptr_add %316, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_386, %token_387 = wave.load %2614 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2615 = wave.ptr_add %316, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
        %value_388, %token_389 = wave.load %2615 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2616 = wave.store %arg84 -> %2206 after %token_365 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2617 = wave.barrier %2616 : (!wave.mem.token) -> !wave.mem.token
        %value_390, %token_391 = waveamd.transpose_load %513 after %2617 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2618 = wave.extract %value_390[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2619 = wave.extract %value_390[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2620 = wave.ptr_add %2212, %205 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2621 = waveamd.dma_load_lds %2620 -> %208 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2622 = wave.ptr_add %2212, %211 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2623 = waveamd.dma_load_lds %2622 -> %214 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2624 = wave.ptr_add %2212, %217 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2625 = waveamd.dma_load_lds %2624 -> %220 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2626 = wave.ptr_add %2212, %223 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2627 = waveamd.dma_load_lds %2626 -> %226 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2628 = wave.ptr_add %2212, %229 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2629 = waveamd.dma_load_lds %2628 -> %232 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2630 = wave.ptr_add %2212, %235 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2631 = waveamd.dma_load_lds %2630 -> %238 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2632 = wave.ptr_add %2212, %241 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2633 = waveamd.dma_load_lds %2632 -> %244 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2634 = wave.ptr_add %2212, %247 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2635 = waveamd.dma_load_lds %2634 -> %250 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2636 = wave.join %2621, %2623, %2625, %2627, %2629, %2631, %2633, %2635 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2637 = wave.ptr_add %2231, %255 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2638 = waveamd.dma_load_lds %2637 -> %258 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2639 = wave.ptr_add %2231, %261 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2640 = waveamd.dma_load_lds %2639 -> %264 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2641 = wave.ptr_add %2231, %267 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2642 = waveamd.dma_load_lds %2641 -> %270 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2643 = wave.ptr_add %2231, %273 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2644 = waveamd.dma_load_lds %2643 -> %276 after %arg117 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2645 = wave.join %2638, %2640, %2642, %2644 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2646 = wave.ptr_add %2242, %287 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_392, %token_393 = wave.load %2646 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2647 = wave.ptr_add %2242, %289 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_394, %token_395 = wave.load %2647 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2648 = wave.ptr_add %2242, %291 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_396, %token_397 = wave.load %2648 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2649 = wave.ptr_add %2242, %293 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_398, %token_399 = wave.load %2649 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2650 = wave.ptr_add %2242, %295 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_400, %token_401 = wave.load %2650 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2651 = wave.ptr_add %2242, %297 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_402, %token_403 = wave.load %2651 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2652 = wave.ptr_add %2242, %299 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_404, %token_405 = wave.load %2652 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2653 = wave.ptr_add %2242, %301 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_406, %token_407 = wave.load %2653 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2654 = wave.ptr_add %2252, %307 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_408, %token_409 = wave.load %2654 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2655 = wave.ptr_add %2252, %309 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_410, %token_411 = wave.load %2655 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2656 = wave.ptr_add %2252, %311 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_412, %token_413 = wave.load %2656 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2657 = wave.ptr_add %2252, %313 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_414, %token_415 = wave.load %2657 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2658 = wave.join %2636, %2645 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2659 = waveamd.fragment_pack %value_374 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2660 = waveamd.fragment_pack %value_376 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2661 = waveamd.fragment_pack %value_378 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2662 = waveamd.fragment_pack %value_380 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2663 = waveamd.fragment_pack %value_382 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2664 = waveamd.fragment_pack %value_384 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2665 = waveamd.fragment_pack %value_386 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2666 = waveamd.fragment_pack %value_388 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %2667 = waveamd.fragment_pack %2300 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2668 = waveamd.fragment_pack %2303 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2669 = waveamd.fragment_pack %2306 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2670 = waveamd.fragment_pack %2309 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2671 = waveamd.fragment_pack %2312 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2672 = waveamd.fragment_pack %2315 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2673 = waveamd.fragment_pack %2318 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2674 = waveamd.fragment_pack %2321 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2675 = waveamd.fragment_pack %2324 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2676 = waveamd.fragment_pack %2327 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2677 = waveamd.fragment_pack %2330 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2678 = waveamd.fragment_pack %2333 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2679 = waveamd.fragment_pack %2336 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2680 = waveamd.fragment_pack %2339 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2681 = waveamd.fragment_pack %2342 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2682 = waveamd.fragment_pack %2345 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2683 = waveamd.fragment_pack %2348 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2684 = waveamd.fragment_pack %2351 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2685 = waveamd.fragment_pack %2354 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2686 = waveamd.fragment_pack %2357 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2687 = waveamd.fragment_pack %2360 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2688 = waveamd.fragment_pack %2363 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2689 = waveamd.fragment_pack %2366 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2690 = waveamd.fragment_pack %2369 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2691 = waveamd.fragment_pack %2372 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2692 = waveamd.fragment_pack %2375 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2693 = waveamd.fragment_pack %2378 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2694 = waveamd.fragment_pack %2381 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2695 = waveamd.fragment_pack %2384 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2696 = waveamd.fragment_pack %2387 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2697 = waveamd.fragment_pack %2390 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2698 = waveamd.fragment_pack %2393 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2699 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2455, %2435, %2667 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2700 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2456, %2435, %2699 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2701 = waveamd.fragment_unpack %2700 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2702 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2455, %2435, %2668 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2703 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2456, %2435, %2702 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2704 = waveamd.fragment_unpack %2703 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2705 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2455, %2435, %2669 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2706 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2456, %2435, %2705 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2707 = waveamd.fragment_unpack %2706 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2708 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2455, %2435, %2670 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2709 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2456, %2435, %2708 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2710 = waveamd.fragment_unpack %2709 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2711 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2457, %2435, %2671 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2712 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2458, %2435, %2711 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2713 = waveamd.fragment_unpack %2712 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2714 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2457, %2435, %2672 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2715 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2458, %2435, %2714 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2716 = waveamd.fragment_unpack %2715 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2717 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2457, %2435, %2673 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2718 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2458, %2435, %2717 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2719 = waveamd.fragment_unpack %2718 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2720 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2457, %2435, %2674 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2721 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2458, %2435, %2720 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2722 = waveamd.fragment_unpack %2721 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2723 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2459, %2436, %2675 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2724 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2460, %2436, %2723 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2725 = waveamd.fragment_unpack %2724 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2726 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2459, %2436, %2676 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2727 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2460, %2436, %2726 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2728 = waveamd.fragment_unpack %2727 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2729 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2459, %2436, %2677 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2730 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2460, %2436, %2729 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2731 = waveamd.fragment_unpack %2730 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2732 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2459, %2436, %2678 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2733 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2460, %2436, %2732 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2734 = waveamd.fragment_unpack %2733 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2735 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2461, %2436, %2679 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2736 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2462, %2436, %2735 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2737 = waveamd.fragment_unpack %2736 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2738 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2461, %2436, %2680 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2739 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2462, %2436, %2738 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2740 = waveamd.fragment_unpack %2739 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2741 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2461, %2436, %2681 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2742 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2462, %2436, %2741 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2743 = waveamd.fragment_unpack %2742 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2744 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2461, %2436, %2682 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2745 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2462, %2436, %2744 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2746 = waveamd.fragment_unpack %2745 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2747 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2463, %2437, %2683 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2748 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2464, %2437, %2747 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2749 = waveamd.fragment_unpack %2748 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2750 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2463, %2437, %2684 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2751 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2464, %2437, %2750 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2752 = waveamd.fragment_unpack %2751 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2753 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2463, %2437, %2685 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2754 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2464, %2437, %2753 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2755 = waveamd.fragment_unpack %2754 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2756 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2463, %2437, %2686 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2757 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2464, %2437, %2756 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2758 = waveamd.fragment_unpack %2757 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2759 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2465, %2437, %2687 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2760 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2466, %2437, %2759 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2761 = waveamd.fragment_unpack %2760 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2762 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2465, %2437, %2688 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2763 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2466, %2437, %2762 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2764 = waveamd.fragment_unpack %2763 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2765 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2465, %2437, %2689 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2766 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2466, %2437, %2765 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2767 = waveamd.fragment_unpack %2766 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2768 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2465, %2437, %2690 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2466, %2437, %2768 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2770 = waveamd.fragment_unpack %2769 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2771 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2467, %2438, %2691 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2772 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2468, %2438, %2771 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2773 = waveamd.fragment_unpack %2772 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2774 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2467, %2438, %2692 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2468, %2438, %2774 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2776 = waveamd.fragment_unpack %2775 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2777 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2467, %2438, %2693 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2468, %2438, %2777 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2779 = waveamd.fragment_unpack %2778 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2780 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2467, %2438, %2694 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2468, %2438, %2780 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2782 = waveamd.fragment_unpack %2781 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2783 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2659, %2618, %2469, %2438, %2695 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2784 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2660, %2618, %2470, %2438, %2783 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2785 = waveamd.fragment_unpack %2784 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2786 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2661, %2618, %2469, %2438, %2696 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2787 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2662, %2618, %2470, %2438, %2786 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2788 = waveamd.fragment_unpack %2787 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2789 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2663, %2619, %2469, %2438, %2697 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2664, %2619, %2470, %2438, %2789 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2791 = waveamd.fragment_unpack %2790 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2792 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2665, %2619, %2469, %2438, %2698 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2666, %2619, %2470, %2438, %2792 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %2794 = waveamd.fragment_unpack %2793 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %2795 = wave.barrier %2257 : (!wave.mem.token) -> !wave.mem.token
        %value_416, %token_417 = wave.load %354 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_418, %token_419 = wave.load %356 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_420, %token_421 = wave.load %358 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_422, %token_423 = wave.load %360 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_424, %token_425 = wave.load %362 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_426, %token_427 = wave.load %364 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_428, %token_429 = wave.load %366 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_430, %token_431 = wave.load %368 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_432, %token_433 = wave.load %370 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_434, %token_435 = wave.load %372 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_436, %token_437 = wave.load %374 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_438, %token_439 = wave.load %376 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_440, %token_441 = wave.load %378 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_442, %token_443 = wave.load %380 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_444, %token_445 = wave.load %382 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_446, %token_447 = wave.load %384 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_448, %token_449 = wave.load %386 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_450, %token_451 = wave.load %388 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_452, %token_453 = wave.load %390 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_454, %token_455 = wave.load %392 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_456, %token_457 = wave.load %394 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_458, %token_459 = wave.load %396 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_460, %token_461 = wave.load %398 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_462, %token_463 = wave.load %400 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %2796 = wave.store %value_288 -> %472 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2797 = wave.store %value_290 -> %474 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2798 = wave.store %value_292 -> %476 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2799 = wave.store %value_294 -> %478 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2800 = wave.store %value_296 -> %480 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2801 = wave.store %value_298 -> %482 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2802 = wave.store %value_300 -> %484 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2803 = wave.store %value_302 -> %486 after %token_391 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2804 = wave.barrier %2796, %2797, %2798, %2799, %2800, %2801, %2802, %2803 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %2805 = wave.store %value_304 -> %494 after %2804 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2806 = wave.store %value_306 -> %496 after %2804 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2807 = wave.store %value_308 -> %498 after %2804 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2808 = wave.store %value_310 -> %500 after %2804 : (!wave.simd<i8, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
        %2809 = wave.barrier %2805, %2806, %2807, %2808 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %value_464, %token_465 = waveamd.transpose_load %504 after %2809 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2810 = wave.extract %value_464[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2811 = wave.extract %value_464[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %value_466, %token_467 = waveamd.transpose_load %508 after %2809 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2812 = wave.extract %value_466[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2813 = wave.extract %value_466[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2814 = wave.join %token_465, %token_467 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_468, %token_469 = waveamd.transpose_load %513 after %2814 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %2815 = wave.extract %value_468[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2816 = wave.extract %value_468[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
        %2817 = wave.ptr_add %2231, %318 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2818 = waveamd.dma_load_lds %2817 -> %320 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2819 = wave.ptr_add %2231, %323 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2820 = waveamd.dma_load_lds %2819 -> %325 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2821 = wave.ptr_add %2231, %328 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2822 = waveamd.dma_load_lds %2821 -> %330 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2823 = wave.ptr_add %2231, %333 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %2824 = waveamd.dma_load_lds %2823 -> %335 after %57 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2825 = wave.join %2818, %2820, %2822, %2824 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2826 = wave.ptr_add %2252, %342 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_470, %token_471 = wave.load %2826 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2827 = wave.ptr_add %2252, %344 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_472, %token_473 = wave.load %2827 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2828 = wave.ptr_add %2252, %346 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_474, %token_475 = wave.load %2828 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2829 = wave.ptr_add %2252, %348 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
        %value_476, %token_477 = wave.load %2829 : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>) -> (!wave.simd<i8, 64>, !wave.mem.token)
        %2830 = wave.binary addi %arg13, %c256_i32 : i32, i32 -> i32
        %2831 = wave.binary addi %arg14, %c256_i32 : i32, i32 -> i32
        %2832 = wave.binary addi %arg15, %c16_i32 : i32, i32 -> i32
        %2833 = wave.binary addi %arg16, %c16_i32 : i32, i32 -> i32
        %2834 = wave.pack %value_366, %value_368, %value_370, %value_372 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2835 = wave.pack %value_392, %value_394, %value_396, %value_398, %value_400, %value_402, %value_404, %value_406 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %2836 = wave.pack %value_408, %value_410, %value_412, %value_414 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %2837 = wave.pack %value_470, %value_472, %value_474, %value_476 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        scf.yield %2830, %2831, %2832, %2833, %2513, %2516, %2519, %2522, %2525, %2528, %2531, %2534, %2537, %2540, %2543, %2546, %2549, %2552, %2555, %2558, %2561, %2564, %2567, %2570, %2573, %2576, %2579, %2582, %2585, %2588, %2591, %2594, %2597, %2600, %2603, %2606, %2701, %2704, %2707, %2710, %2713, %2716, %2719, %2722, %2725, %2728, %2731, %2734, %2737, %2740, %2743, %2746, %2749, %2752, %2755, %2758, %2761, %2764, %2767, %2770, %2773, %2776, %2779, %2782, %2785, %2788, %2791, %2794, %2834, %2835, %2836, %2837, %value_416, %value_418, %value_420, %value_422, %value_424, %value_426, %value_428, %value_430, %value_432, %value_434, %value_436, %value_438, %value_440, %value_442, %value_444, %value_446, %value_448, %value_450, %value_452, %value_454, %value_456, %value_458, %value_460, %value_462, %2810, %2811, %2812, %2813, %2815, %2816, %2450, %2658, %2825 : i32, i32, i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<8xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.simd<vector<4xi8>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %521 = waveamd.fragment_pack %520#72 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %522 = waveamd.fragment_pack %520#73 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %523 = waveamd.fragment_pack %520#74 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %524 = waveamd.fragment_pack %520#75 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %525 = waveamd.fragment_pack %520#76 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %526 = waveamd.fragment_pack %520#77 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %527 = waveamd.fragment_pack %520#78 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %528 = waveamd.fragment_pack %520#79 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %529 = waveamd.fragment_pack %520#80 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %530 = waveamd.fragment_pack %520#81 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %531 = waveamd.fragment_pack %520#82 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %532 = waveamd.fragment_pack %520#83 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %533 = waveamd.fragment_pack %520#84 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %534 = waveamd.fragment_pack %520#85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %535 = waveamd.fragment_pack %520#86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %536 = waveamd.fragment_pack %520#87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %537 = waveamd.fragment_pack %520#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %538 = waveamd.fragment_pack %520#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %539 = waveamd.fragment_pack %520#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %540 = waveamd.fragment_pack %520#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %541 = waveamd.fragment_pack %520#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %542 = waveamd.fragment_pack %520#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %543 = waveamd.fragment_pack %520#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %544 = waveamd.fragment_pack %520#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %545 = waveamd.fragment_pack %520#4 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %546 = waveamd.fragment_pack %520#5 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %547 = waveamd.fragment_pack %520#6 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %548 = waveamd.fragment_pack %520#7 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %549 = waveamd.fragment_pack %520#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %550 = waveamd.fragment_pack %520#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %551 = waveamd.fragment_pack %520#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %552 = waveamd.fragment_pack %520#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %553 = waveamd.fragment_pack %520#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %554 = waveamd.fragment_pack %520#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %555 = waveamd.fragment_pack %520#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %556 = waveamd.fragment_pack %520#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %557 = waveamd.fragment_pack %520#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %558 = waveamd.fragment_pack %520#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %559 = waveamd.fragment_pack %520#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %560 = waveamd.fragment_pack %520#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %561 = waveamd.fragment_pack %520#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %562 = waveamd.fragment_pack %520#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %563 = waveamd.fragment_pack %520#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %564 = waveamd.fragment_pack %520#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %565 = waveamd.fragment_pack %520#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %566 = waveamd.fragment_pack %520#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %567 = waveamd.fragment_pack %520#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %568 = waveamd.fragment_pack %520#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %569 = waveamd.fragment_pack %520#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %570 = waveamd.fragment_pack %520#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %571 = waveamd.fragment_pack %520#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %572 = waveamd.fragment_pack %520#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %573 = waveamd.fragment_pack %520#32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %574 = waveamd.fragment_pack %520#33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %575 = waveamd.fragment_pack %520#34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %576 = waveamd.fragment_pack %520#35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %577 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %521, %520#96, %545 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %522, %520#96, %577 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %579 = waveamd.fragment_unpack %578 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %521, %520#96, %546 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %522, %520#96, %580 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %582 = waveamd.fragment_unpack %581 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %521, %520#96, %547 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %522, %520#96, %583 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %585 = waveamd.fragment_unpack %584 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %586 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %521, %520#96, %548 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %522, %520#96, %586 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %588 = waveamd.fragment_unpack %587 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %523, %520#96, %549 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %524, %520#96, %589 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %591 = waveamd.fragment_unpack %590 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %523, %520#96, %550 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %524, %520#96, %592 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %594 = waveamd.fragment_unpack %593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %523, %520#96, %551 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %524, %520#96, %595 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %597 = waveamd.fragment_unpack %596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %523, %520#96, %552 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %524, %520#96, %598 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %600 = waveamd.fragment_unpack %599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %525, %520#97, %553 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %526, %520#97, %601 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %603 = waveamd.fragment_unpack %602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %525, %520#97, %554 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %526, %520#97, %604 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %606 = waveamd.fragment_unpack %605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %525, %520#97, %555 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %526, %520#97, %607 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %609 = waveamd.fragment_unpack %608 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %525, %520#97, %556 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %526, %520#97, %610 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.fragment_unpack %611 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %527, %520#97, %557 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %528, %520#97, %613 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_unpack %614 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %527, %520#97, %558 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %528, %520#97, %616 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_unpack %617 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %527, %520#97, %559 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %528, %520#97, %619 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.fragment_unpack %620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %527, %520#97, %560 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %623 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %528, %520#97, %622 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.fragment_unpack %623 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %529, %520#98, %561 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %626 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %530, %520#98, %625 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.fragment_unpack %626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %529, %520#98, %562 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %629 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %530, %520#98, %628 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %630 = waveamd.fragment_unpack %629 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %529, %520#98, %563 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %632 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %530, %520#98, %631 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %633 = waveamd.fragment_unpack %632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %529, %520#98, %564 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %635 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %530, %520#98, %634 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %636 = waveamd.fragment_unpack %635 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %531, %520#98, %565 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %532, %520#98, %637 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.fragment_unpack %638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %531, %520#98, %566 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %532, %520#98, %640 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.fragment_unpack %641 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %531, %520#98, %567 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %532, %520#98, %643 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %645 = waveamd.fragment_unpack %644 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %531, %520#98, %568 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %532, %520#98, %646 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %648 = waveamd.fragment_unpack %647 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %533, %520#99, %569 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %534, %520#99, %649 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %651 = waveamd.fragment_unpack %650 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %533, %520#99, %570 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %534, %520#99, %652 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %654 = waveamd.fragment_unpack %653 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %533, %520#99, %571 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %656 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %534, %520#99, %655 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %657 = waveamd.fragment_unpack %656 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %533, %520#99, %572 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %659 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %534, %520#99, %658 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %660 = waveamd.fragment_unpack %659 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %537, %520#100, %535, %520#99, %573 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %538, %520#100, %536, %520#99, %661 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.fragment_unpack %662 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %539, %520#100, %535, %520#99, %574 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %540, %520#100, %536, %520#99, %664 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.fragment_unpack %665 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %541, %520#101, %535, %520#99, %575 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %542, %520#101, %536, %520#99, %667 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.fragment_unpack %668 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %543, %520#101, %535, %520#99, %576 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %544, %520#101, %536, %520#99, %670 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %672 = waveamd.fragment_unpack %671 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %673 = wave.barrier %520#102, %520#103, %520#104 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %674 = wave.ptr_add %40, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_116, %token_117 = wave.load %674 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %675 = wave.ptr_add %40, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_118, %token_119 = wave.load %675 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %676 = wave.ptr_add %40, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_120, %token_121 = wave.load %676 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %677 = wave.ptr_add %40, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_122, %token_123 = wave.load %677 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %678 = wave.ptr_add %40, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_124, %token_125 = wave.load %678 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %679 = wave.ptr_add %40, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_126, %token_127 = wave.load %679 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %680 = wave.ptr_add %40, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_128, %token_129 = wave.load %680 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %681 = wave.ptr_add %40, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_130, %token_131 = wave.load %681 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %682 = wave.binary muli %419, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %683 = wave.binary muli %421, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %684 = wave.binary xori %682, %683 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %685 = wave.binary muli %425, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %686 = wave.binary xori %684, %685 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %687 = wave.binary muli %402, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %688 = wave.binary xori %686, %687 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %689 = wave.binary muli %404, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %690 = wave.binary xori %688, %689 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %691 = wave.binary muli %412, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %692 = wave.binary xori %408, %691 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %693 = wave.binary muli %416, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %694 = wave.binary xori %692, %693 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %695 = wave.binary muli %694, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %696 = wave.binary addi %695, %690 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %697 = wave.ptr_add %42, %696 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %698 = wave.store %520#68 -> %697 after %token_115 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %699 = wave.barrier %698 : (!wave.mem.token) -> !wave.mem.token
      %value_132, %token_133 = waveamd.transpose_load %513 after %699 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %700 = wave.extract %value_132[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %701 = wave.extract %value_132[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %702 = waveamd.fragment_pack %value_116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %703 = waveamd.fragment_pack %value_118 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %704 = waveamd.fragment_pack %value_120 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %705 = waveamd.fragment_pack %value_122 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %706 = waveamd.fragment_pack %value_124 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %707 = waveamd.fragment_pack %value_126 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %708 = waveamd.fragment_pack %value_128 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %709 = waveamd.fragment_pack %value_130 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %710 = waveamd.fragment_pack %520#36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %711 = waveamd.fragment_pack %520#37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %712 = waveamd.fragment_pack %520#38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %713 = waveamd.fragment_pack %520#39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %714 = waveamd.fragment_pack %520#40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %715 = waveamd.fragment_pack %520#41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %716 = waveamd.fragment_pack %520#42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %717 = waveamd.fragment_pack %520#43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %718 = waveamd.fragment_pack %520#44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %719 = waveamd.fragment_pack %520#45 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %720 = waveamd.fragment_pack %520#46 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %721 = waveamd.fragment_pack %520#47 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %722 = waveamd.fragment_pack %520#48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %723 = waveamd.fragment_pack %520#49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %724 = waveamd.fragment_pack %520#50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %725 = waveamd.fragment_pack %520#51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %726 = waveamd.fragment_pack %520#52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %727 = waveamd.fragment_pack %520#53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %728 = waveamd.fragment_pack %520#54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %729 = waveamd.fragment_pack %520#55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %730 = waveamd.fragment_pack %520#56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %731 = waveamd.fragment_pack %520#57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %732 = waveamd.fragment_pack %520#58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %733 = waveamd.fragment_pack %520#59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %734 = waveamd.fragment_pack %520#60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %735 = waveamd.fragment_pack %520#61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %736 = waveamd.fragment_pack %520#62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %737 = waveamd.fragment_pack %520#63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %738 = waveamd.fragment_pack %520#64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %739 = waveamd.fragment_pack %520#65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %740 = waveamd.fragment_pack %520#66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %741 = waveamd.fragment_pack %520#67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %742 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %521, %520#96, %710 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %743 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %522, %520#96, %742 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %744 = waveamd.fragment_unpack %743 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %745 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %521, %520#96, %711 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %746 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %522, %520#96, %745 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %747 = waveamd.fragment_unpack %746 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %748 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %521, %520#96, %712 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %749 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %522, %520#96, %748 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %750 = waveamd.fragment_unpack %749 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %751 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %521, %520#96, %713 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %752 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %522, %520#96, %751 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %753 = waveamd.fragment_unpack %752 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %754 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %523, %520#96, %714 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %755 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %524, %520#96, %754 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %756 = waveamd.fragment_unpack %755 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %757 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %523, %520#96, %715 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %758 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %524, %520#96, %757 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %759 = waveamd.fragment_unpack %758 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %760 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %523, %520#96, %716 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %761 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %524, %520#96, %760 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %762 = waveamd.fragment_unpack %761 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %763 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %523, %520#96, %717 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %764 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %524, %520#96, %763 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %765 = waveamd.fragment_unpack %764 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %766 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %525, %520#97, %718 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %767 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %526, %520#97, %766 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %768 = waveamd.fragment_unpack %767 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %525, %520#97, %719 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %770 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %526, %520#97, %769 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %771 = waveamd.fragment_unpack %770 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %772 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %525, %520#97, %720 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %773 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %526, %520#97, %772 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %774 = waveamd.fragment_unpack %773 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %525, %520#97, %721 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %776 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %526, %520#97, %775 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %777 = waveamd.fragment_unpack %776 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %527, %520#97, %722 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %779 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %528, %520#97, %778 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %780 = waveamd.fragment_unpack %779 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %527, %520#97, %723 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %782 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %528, %520#97, %781 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %783 = waveamd.fragment_unpack %782 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %784 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %527, %520#97, %724 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %785 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %528, %520#97, %784 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %786 = waveamd.fragment_unpack %785 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %787 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %527, %520#97, %725 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %788 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %528, %520#97, %787 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %789 = waveamd.fragment_unpack %788 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %790 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %529, %520#98, %726 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %791 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %530, %520#98, %790 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %792 = waveamd.fragment_unpack %791 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %793 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %529, %520#98, %727 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %794 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %530, %520#98, %793 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %795 = waveamd.fragment_unpack %794 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %796 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %529, %520#98, %728 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %797 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %530, %520#98, %796 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %798 = waveamd.fragment_unpack %797 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %799 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %529, %520#98, %729 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %800 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %530, %520#98, %799 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %801 = waveamd.fragment_unpack %800 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %802 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %531, %520#98, %730 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %803 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %532, %520#98, %802 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %804 = waveamd.fragment_unpack %803 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %805 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %531, %520#98, %731 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %806 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %532, %520#98, %805 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %807 = waveamd.fragment_unpack %806 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %808 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %531, %520#98, %732 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %532, %520#98, %808 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %810 = waveamd.fragment_unpack %809 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %811 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %531, %520#98, %733 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %532, %520#98, %811 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %813 = waveamd.fragment_unpack %812 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %814 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %533, %520#99, %734 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %534, %520#99, %814 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %816 = waveamd.fragment_unpack %815 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %817 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %533, %520#99, %735 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %534, %520#99, %817 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %819 = waveamd.fragment_unpack %818 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %820 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %533, %520#99, %736 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %534, %520#99, %820 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %822 = waveamd.fragment_unpack %821 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %823 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %533, %520#99, %737 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %534, %520#99, %823 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %825 = waveamd.fragment_unpack %824 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %826 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %702, %700, %535, %520#99, %738 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %703, %700, %536, %520#99, %826 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %828 = waveamd.fragment_unpack %827 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %829 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %704, %700, %535, %520#99, %739 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %705, %700, %536, %520#99, %829 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %831 = waveamd.fragment_unpack %830 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %832 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %706, %701, %535, %520#99, %740 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %707, %701, %536, %520#99, %832 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %834 = waveamd.fragment_unpack %833 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %835 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %708, %701, %535, %520#99, %741 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %709, %701, %536, %520#99, %835 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %837 = waveamd.fragment_unpack %836 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %838 = wave.ptr_add %203, %353 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_134, %token_135 = wave.load %838 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %839 = wave.ptr_add %203, %355 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_136, %token_137 = wave.load %839 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %840 = wave.ptr_add %203, %357 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_138, %token_139 = wave.load %840 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %841 = wave.ptr_add %203, %359 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_140, %token_141 = wave.load %841 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %842 = wave.ptr_add %203, %361 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_142, %token_143 = wave.load %842 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %843 = wave.ptr_add %203, %363 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_144, %token_145 = wave.load %843 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %844 = wave.ptr_add %203, %365 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_146, %token_147 = wave.load %844 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %845 = wave.ptr_add %203, %367 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_148, %token_149 = wave.load %845 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %846 = wave.ptr_add %203, %369 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_150, %token_151 = wave.load %846 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %847 = wave.ptr_add %203, %371 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_152, %token_153 = wave.load %847 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %848 = wave.ptr_add %203, %373 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_154, %token_155 = wave.load %848 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %849 = wave.ptr_add %203, %375 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_156, %token_157 = wave.load %849 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %850 = wave.ptr_add %203, %377 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_158, %token_159 = wave.load %850 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %851 = wave.ptr_add %203, %379 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_160, %token_161 = wave.load %851 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %852 = wave.ptr_add %203, %381 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_162, %token_163 = wave.load %852 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %853 = wave.ptr_add %203, %383 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_164, %token_165 = wave.load %853 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %854 = wave.ptr_add %253, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_166, %token_167 = wave.load %854 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %855 = wave.ptr_add %253, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_168, %token_169 = wave.load %855 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %856 = wave.ptr_add %253, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_170, %token_171 = wave.load %856 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %857 = wave.ptr_add %253, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_172, %token_173 = wave.load %857 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %858 = wave.ptr_add %253, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_174, %token_175 = wave.load %858 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %859 = wave.ptr_add %253, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_176, %token_177 = wave.load %859 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %860 = wave.ptr_add %253, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_178, %token_179 = wave.load %860 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %861 = wave.ptr_add %253, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_180, %token_181 = wave.load %861 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %862 = wave.binary muli %419, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %863 = wave.binary muli %421, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %864 = wave.binary xori %862, %863 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %865 = wave.binary muli %425, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %866 = wave.binary xori %864, %865 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %867 = wave.binary muli %402, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %868 = wave.binary xori %866, %867 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %869 = wave.binary muli %404, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %870 = wave.binary xori %868, %869 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %871 = wave.binary muli %694, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %872 = wave.binary addi %871, %870 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %873 = wave.ptr_add %41, %872 : !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %874 = wave.store %520#69 -> %873 after %token_133 : (!wave.simd<vector<8xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %875 = wave.barrier %874 : (!wave.mem.token) -> !wave.mem.token
      %876 = wave.store %520#70 -> %697 after %875 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %877 = wave.barrier %876 : (!wave.mem.token) -> !wave.mem.token
      %value_182, %token_183 = waveamd.transpose_load %504 after %877 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %878 = wave.extract %value_182[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %879 = wave.extract %value_182[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %value_184, %token_185 = waveamd.transpose_load %508 after %877 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %880 = wave.extract %value_184[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %881 = wave.extract %value_184[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %882 = wave.join %token_183, %token_185 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_186, %token_187 = waveamd.transpose_load %513 after %882 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %883 = wave.extract %value_186[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %884 = wave.extract %value_186[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %885 = waveamd.fragment_pack %value_134 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %886 = waveamd.fragment_pack %value_136 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %887 = waveamd.fragment_pack %value_138 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %888 = waveamd.fragment_pack %value_140 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %889 = waveamd.fragment_pack %value_142 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %890 = waveamd.fragment_pack %value_144 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %891 = waveamd.fragment_pack %value_146 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %892 = waveamd.fragment_pack %value_148 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %893 = waveamd.fragment_pack %value_150 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %894 = waveamd.fragment_pack %value_152 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %895 = waveamd.fragment_pack %value_154 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %896 = waveamd.fragment_pack %value_156 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %897 = waveamd.fragment_pack %value_158 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %898 = waveamd.fragment_pack %value_160 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %899 = waveamd.fragment_pack %value_162 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %900 = waveamd.fragment_pack %value_164 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %901 = waveamd.fragment_pack %value_166 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %902 = waveamd.fragment_pack %value_168 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %903 = waveamd.fragment_pack %value_170 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %904 = waveamd.fragment_pack %value_172 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %905 = waveamd.fragment_pack %value_174 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %906 = waveamd.fragment_pack %value_176 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %907 = waveamd.fragment_pack %value_178 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %908 = waveamd.fragment_pack %value_180 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %909 = waveamd.fragment_pack %579 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %910 = waveamd.fragment_pack %582 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %911 = waveamd.fragment_pack %585 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %912 = waveamd.fragment_pack %588 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %913 = waveamd.fragment_pack %591 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %914 = waveamd.fragment_pack %594 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %915 = waveamd.fragment_pack %597 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %916 = waveamd.fragment_pack %600 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %917 = waveamd.fragment_pack %603 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %918 = waveamd.fragment_pack %606 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %919 = waveamd.fragment_pack %609 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %920 = waveamd.fragment_pack %612 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %921 = waveamd.fragment_pack %615 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %922 = waveamd.fragment_pack %618 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %923 = waveamd.fragment_pack %621 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %924 = waveamd.fragment_pack %624 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %925 = waveamd.fragment_pack %627 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %926 = waveamd.fragment_pack %630 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %927 = waveamd.fragment_pack %633 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %928 = waveamd.fragment_pack %636 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %929 = waveamd.fragment_pack %639 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %930 = waveamd.fragment_pack %642 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %931 = waveamd.fragment_pack %645 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %932 = waveamd.fragment_pack %648 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %933 = waveamd.fragment_pack %651 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %934 = waveamd.fragment_pack %654 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %935 = waveamd.fragment_pack %657 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %936 = waveamd.fragment_pack %660 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %937 = waveamd.fragment_pack %663 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %938 = waveamd.fragment_pack %666 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %939 = waveamd.fragment_pack %669 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %940 = waveamd.fragment_pack %672 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %941 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %885, %878, %909 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %942 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %886, %878, %941 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %943 = waveamd.fragment_unpack %942 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %944 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %885, %878, %910 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %945 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %886, %878, %944 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %946 = waveamd.fragment_unpack %945 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %947 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %885, %878, %911 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %948 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %886, %878, %947 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %949 = waveamd.fragment_unpack %948 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %950 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %885, %878, %912 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %951 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %886, %878, %950 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %952 = waveamd.fragment_unpack %951 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %953 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %887, %878, %913 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %954 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %888, %878, %953 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %955 = waveamd.fragment_unpack %954 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %956 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %887, %878, %914 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %957 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %888, %878, %956 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %958 = waveamd.fragment_unpack %957 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %959 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %887, %878, %915 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %960 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %888, %878, %959 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %961 = waveamd.fragment_unpack %960 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %962 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %887, %878, %916 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %963 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %888, %878, %962 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %964 = waveamd.fragment_unpack %963 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %965 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %889, %879, %917 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %966 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %890, %879, %965 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %967 = waveamd.fragment_unpack %966 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %968 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %889, %879, %918 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %969 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %890, %879, %968 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %970 = waveamd.fragment_unpack %969 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %971 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %889, %879, %919 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %972 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %890, %879, %971 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %973 = waveamd.fragment_unpack %972 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %974 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %889, %879, %920 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %975 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %890, %879, %974 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %976 = waveamd.fragment_unpack %975 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %977 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %891, %879, %921 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %978 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %892, %879, %977 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %979 = waveamd.fragment_unpack %978 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %980 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %891, %879, %922 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %981 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %892, %879, %980 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %982 = waveamd.fragment_unpack %981 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %983 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %891, %879, %923 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %984 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %892, %879, %983 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %985 = waveamd.fragment_unpack %984 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %986 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %891, %879, %924 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %987 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %892, %879, %986 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %988 = waveamd.fragment_unpack %987 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %989 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %893, %880, %925 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %990 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %894, %880, %989 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %991 = waveamd.fragment_unpack %990 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %992 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %893, %880, %926 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %993 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %894, %880, %992 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %994 = waveamd.fragment_unpack %993 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %995 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %893, %880, %927 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %996 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %894, %880, %995 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %997 = waveamd.fragment_unpack %996 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %998 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %893, %880, %928 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %999 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %894, %880, %998 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1000 = waveamd.fragment_unpack %999 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1001 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %895, %880, %929 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1002 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %896, %880, %1001 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1003 = waveamd.fragment_unpack %1002 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1004 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %895, %880, %930 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1005 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %896, %880, %1004 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1006 = waveamd.fragment_unpack %1005 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1007 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %895, %880, %931 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1008 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %896, %880, %1007 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1009 = waveamd.fragment_unpack %1008 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1010 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %895, %880, %932 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1011 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %896, %880, %1010 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1012 = waveamd.fragment_unpack %1011 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1013 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %897, %881, %933 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1014 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %898, %881, %1013 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1015 = waveamd.fragment_unpack %1014 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1016 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %897, %881, %934 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1017 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %898, %881, %1016 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1018 = waveamd.fragment_unpack %1017 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1019 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %897, %881, %935 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1020 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %898, %881, %1019 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1021 = waveamd.fragment_unpack %1020 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1022 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %897, %881, %936 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1023 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %898, %881, %1022 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1024 = waveamd.fragment_unpack %1023 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1025 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %901, %883, %899, %881, %937 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1026 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %902, %883, %900, %881, %1025 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1027 = waveamd.fragment_unpack %1026 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1028 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %903, %883, %899, %881, %938 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1029 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %904, %883, %900, %881, %1028 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1030 = waveamd.fragment_unpack %1029 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1031 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %905, %884, %899, %881, %939 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1032 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %906, %884, %900, %881, %1031 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1033 = waveamd.fragment_unpack %1032 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1034 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %907, %884, %899, %881, %940 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1035 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %908, %884, %900, %881, %1034 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1036 = waveamd.fragment_unpack %1035 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1037 = wave.ptr_add %316, %385 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_188, %token_189 = wave.load %1037 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1038 = wave.ptr_add %316, %387 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_190, %token_191 = wave.load %1038 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1039 = wave.ptr_add %316, %389 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_192, %token_193 = wave.load %1039 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1040 = wave.ptr_add %316, %391 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_194, %token_195 = wave.load %1040 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1041 = wave.ptr_add %316, %393 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_196, %token_197 = wave.load %1041 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1042 = wave.ptr_add %316, %395 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_198, %token_199 = wave.load %1042 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1043 = wave.ptr_add %316, %397 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_200, %token_201 = wave.load %1043 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1044 = wave.ptr_add %316, %399 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
      %value_202, %token_203 = wave.load %1044 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1045 = wave.store %520#71 -> %697 after %token_187 : (!wave.simd<vector<4xi8>, 64>, !wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> !wave.mem.token
      %1046 = wave.barrier %1045 : (!wave.mem.token) -> !wave.mem.token
      %value_204, %token_205 = waveamd.transpose_load %513 after %1046 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1047 = wave.extract %value_204[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %1048 = wave.extract %value_204[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<vector<4xi8>, 64>
      %1049 = wave.binary muli %43, %arg9 : i32, i32 -> i32
      %1050 = wave.cast fpconvert %943 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1051 = wave.cast fpconvert %946 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1052 = wave.cast fpconvert %949 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1053 = wave.cast fpconvert %952 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1054 = wave.cast fpconvert %955 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1055 = wave.cast fpconvert %958 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1056 = wave.cast fpconvert %961 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1057 = wave.cast fpconvert %964 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1058 = wave.cast fpconvert %967 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1059 = wave.cast fpconvert %970 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1060 = wave.cast fpconvert %973 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1061 = wave.cast fpconvert %976 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1062 = wave.cast fpconvert %979 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1063 = wave.cast fpconvert %982 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1064 = wave.cast fpconvert %985 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1065 = wave.cast fpconvert %988 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1066 = wave.cast fpconvert %991 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1067 = wave.cast fpconvert %994 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1068 = wave.cast fpconvert %997 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1069 = wave.cast fpconvert %1000 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1070 = wave.cast fpconvert %1003 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1071 = wave.cast fpconvert %1006 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1072 = wave.cast fpconvert %1009 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1073 = wave.cast fpconvert %1012 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1074 = wave.cast fpconvert %1015 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1075 = wave.cast fpconvert %1018 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1076 = wave.cast fpconvert %1021 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1077 = wave.cast fpconvert %1024 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1078 = wave.cast fpconvert %1027 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1079 = wave.cast fpconvert %1030 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1080 = wave.cast fpconvert %1033 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1081 = wave.cast fpconvert %1036 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1082 = wave.alloc() {align = 16 : i64, bytesize = 16384 : i64} : !wave.ptr<#wave.shared, bf16>
      %1083 = wave.binary muli %52, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1084 = wave.ptr_add %1082, %1083 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1085 = wave.extract %1050[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1086 = wave.extract %1050[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1087 = wave.extract %1050[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1088 = wave.extract %1050[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1089 = wave.extract %1054[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1090 = wave.extract %1054[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1091 = wave.extract %1054[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1092 = wave.extract %1054[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1093 = wave.pack %1085, %1086, %1087, %1088, %1089, %1090, %1091, %1092 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1094 = wave.store %1093 -> %1084 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1095 = wave.binary addi %1083, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1096 = wave.ptr_add %1082, %1095 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1097 = wave.extract %1051[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1098 = wave.extract %1051[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1099 = wave.extract %1051[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1100 = wave.extract %1051[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1101 = wave.extract %1055[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1102 = wave.extract %1055[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1103 = wave.extract %1055[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1104 = wave.extract %1055[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1105 = wave.pack %1097, %1098, %1099, %1100, %1101, %1102, %1103, %1104 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1106 = wave.store %1105 -> %1096 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1107 = wave.binary addi %1083, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1108 = wave.ptr_add %1082, %1107 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1109 = wave.extract %1052[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1110 = wave.extract %1052[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1111 = wave.extract %1052[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1112 = wave.extract %1052[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1113 = wave.extract %1056[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1114 = wave.extract %1056[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1115 = wave.extract %1056[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1116 = wave.extract %1056[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1117 = wave.pack %1109, %1110, %1111, %1112, %1113, %1114, %1115, %1116 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1118 = wave.store %1117 -> %1108 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1119 = wave.binary addi %1083, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1120 = wave.ptr_add %1082, %1119 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1121 = wave.extract %1053[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1122 = wave.extract %1053[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1123 = wave.extract %1053[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1124 = wave.extract %1053[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1125 = wave.extract %1057[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1126 = wave.extract %1057[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1127 = wave.extract %1057[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1128 = wave.extract %1057[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1129 = wave.pack %1121, %1122, %1123, %1124, %1125, %1126, %1127, %1128 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1130 = wave.store %1129 -> %1120 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>) -> !wave.mem.token
      %1131 = wave.barrier %1094, %1106, %1118, %1130 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1132 = wave.index_expr <"8*(32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1133 = wave.ptr_add %1082, %1132 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_206, %token_207 = wave.load %1133 after %1131 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1134 = wave.extract %value_206[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1135 = wave.extract %value_206[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1136 = wave.extract %value_206[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1137 = wave.extract %value_206[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1138 = wave.extract %value_206[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1139 = wave.extract %value_206[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1140 = wave.extract %value_206[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1141 = wave.extract %value_206[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1142 = wave.index_expr <"8*(16 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1143 = wave.ptr_add %1082, %1142 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_208, %token_209 = wave.load %1143 after %1131 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1144 = wave.extract %value_208[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1145 = wave.extract %value_208[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1146 = wave.extract %value_208[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1147 = wave.extract %value_208[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1148 = wave.extract %value_208[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1149 = wave.extract %value_208[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1150 = wave.extract %value_208[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1151 = wave.extract %value_208[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1152 = wave.index_expr <"8*(128 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1153 = wave.ptr_add %1082, %1152 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_210, %token_211 = wave.load %1153 after %1131 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1154 = wave.extract %value_210[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1155 = wave.extract %value_210[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1156 = wave.extract %value_210[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1157 = wave.extract %value_210[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1158 = wave.extract %value_210[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1159 = wave.extract %value_210[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1160 = wave.extract %value_210[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1161 = wave.extract %value_210[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1162 = wave.index_expr <"8*(144 + 32*Mod(wi, 2) + 8*Mod(floor(1/128*wi), 2) + 4*Mod(floor(1/64*wi), 2) + 2*Mod(floor(1/32*wi), 2) + Mod(floor(1/16*wi), 2) + 512*Mod(floor(1/8*wi), 2) + 256*Mod(floor(1/4*wi), 2) + 64*Mod(floor(1/2*wi), 2))"> ["wi"](%52) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1163 = wave.ptr_add %1082, %1162 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_212, %token_213 = wave.load %1163 after %1131 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1164 = wave.extract %value_212[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1165 = wave.extract %value_212[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1166 = wave.extract %value_212[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1167 = wave.extract %value_212[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1168 = wave.extract %value_212[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1169 = wave.extract %value_212[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1170 = wave.extract %value_212[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1171 = wave.extract %value_212[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1172 = wave.barrier %token_207, %token_209, %token_211, %token_213 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1173 = wave.extract %1058[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1174 = wave.extract %1058[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1175 = wave.extract %1058[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1176 = wave.extract %1058[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1177 = wave.extract %1062[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1178 = wave.extract %1062[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1179 = wave.extract %1062[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1180 = wave.extract %1062[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1181 = wave.pack %1173, %1174, %1175, %1176, %1177, %1178, %1179, %1180 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1182 = wave.store %1181 -> %1084 after %1172 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1183 = wave.extract %1059[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1184 = wave.extract %1059[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1185 = wave.extract %1059[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1186 = wave.extract %1059[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1187 = wave.extract %1063[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1188 = wave.extract %1063[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1189 = wave.extract %1063[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1190 = wave.extract %1063[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1191 = wave.pack %1183, %1184, %1185, %1186, %1187, %1188, %1189, %1190 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1192 = wave.store %1191 -> %1096 after %1172 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1193 = wave.extract %1060[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1194 = wave.extract %1060[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1195 = wave.extract %1060[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1196 = wave.extract %1060[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1197 = wave.extract %1064[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1198 = wave.extract %1064[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1199 = wave.extract %1064[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1200 = wave.extract %1064[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1201 = wave.pack %1193, %1194, %1195, %1196, %1197, %1198, %1199, %1200 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1202 = wave.store %1201 -> %1108 after %1172 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1203 = wave.extract %1061[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1204 = wave.extract %1061[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1205 = wave.extract %1061[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1206 = wave.extract %1061[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1207 = wave.extract %1065[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1208 = wave.extract %1065[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1209 = wave.extract %1065[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1210 = wave.extract %1065[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1211 = wave.pack %1203, %1204, %1205, %1206, %1207, %1208, %1209, %1210 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1212 = wave.store %1211 -> %1120 after %1172 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1213 = wave.barrier %1182, %1192, %1202, %1212 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_214, %token_215 = wave.load %1133 after %1213 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1214 = wave.extract %value_214[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1215 = wave.extract %value_214[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1216 = wave.extract %value_214[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1217 = wave.extract %value_214[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1218 = wave.extract %value_214[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1219 = wave.extract %value_214[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1220 = wave.extract %value_214[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1221 = wave.extract %value_214[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_216, %token_217 = wave.load %1143 after %1213 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1222 = wave.extract %value_216[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1223 = wave.extract %value_216[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1224 = wave.extract %value_216[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1225 = wave.extract %value_216[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1226 = wave.extract %value_216[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1227 = wave.extract %value_216[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1228 = wave.extract %value_216[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1229 = wave.extract %value_216[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_218, %token_219 = wave.load %1153 after %1213 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1230 = wave.extract %value_218[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1231 = wave.extract %value_218[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1232 = wave.extract %value_218[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1233 = wave.extract %value_218[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1234 = wave.extract %value_218[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1235 = wave.extract %value_218[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1236 = wave.extract %value_218[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1237 = wave.extract %value_218[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_220, %token_221 = wave.load %1163 after %1213 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1238 = wave.extract %value_220[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1239 = wave.extract %value_220[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1240 = wave.extract %value_220[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1241 = wave.extract %value_220[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1242 = wave.extract %value_220[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1243 = wave.extract %value_220[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1244 = wave.extract %value_220[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1245 = wave.extract %value_220[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1246 = wave.barrier %token_215, %token_217, %token_219, %token_221 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1247 = wave.extract %1066[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1248 = wave.extract %1066[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1249 = wave.extract %1066[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1250 = wave.extract %1066[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1251 = wave.extract %1070[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1252 = wave.extract %1070[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1253 = wave.extract %1070[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1254 = wave.extract %1070[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1255 = wave.pack %1247, %1248, %1249, %1250, %1251, %1252, %1253, %1254 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1256 = wave.store %1255 -> %1084 after %1246 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1257 = wave.extract %1067[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1258 = wave.extract %1067[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1259 = wave.extract %1067[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1260 = wave.extract %1067[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1261 = wave.extract %1071[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1262 = wave.extract %1071[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1263 = wave.extract %1071[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1264 = wave.extract %1071[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1265 = wave.pack %1257, %1258, %1259, %1260, %1261, %1262, %1263, %1264 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1266 = wave.store %1265 -> %1096 after %1246 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1267 = wave.extract %1068[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1268 = wave.extract %1068[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1269 = wave.extract %1068[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1270 = wave.extract %1068[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1271 = wave.extract %1072[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1272 = wave.extract %1072[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1273 = wave.extract %1072[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1274 = wave.extract %1072[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1275 = wave.pack %1267, %1268, %1269, %1270, %1271, %1272, %1273, %1274 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1276 = wave.store %1275 -> %1108 after %1246 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1277 = wave.extract %1069[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1278 = wave.extract %1069[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1279 = wave.extract %1069[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1280 = wave.extract %1069[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1281 = wave.extract %1073[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1282 = wave.extract %1073[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1283 = wave.extract %1073[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1284 = wave.extract %1073[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1285 = wave.pack %1277, %1278, %1279, %1280, %1281, %1282, %1283, %1284 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1286 = wave.store %1285 -> %1120 after %1246 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1287 = wave.barrier %1256, %1266, %1276, %1286 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_222, %token_223 = wave.load %1133 after %1287 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1288 = wave.extract %value_222[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1289 = wave.extract %value_222[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1290 = wave.extract %value_222[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1291 = wave.extract %value_222[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1292 = wave.extract %value_222[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1293 = wave.extract %value_222[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1294 = wave.extract %value_222[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1295 = wave.extract %value_222[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_224, %token_225 = wave.load %1143 after %1287 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1296 = wave.extract %value_224[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1297 = wave.extract %value_224[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1298 = wave.extract %value_224[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1299 = wave.extract %value_224[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1300 = wave.extract %value_224[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1301 = wave.extract %value_224[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1302 = wave.extract %value_224[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1303 = wave.extract %value_224[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_226, %token_227 = wave.load %1153 after %1287 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1304 = wave.extract %value_226[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1305 = wave.extract %value_226[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1306 = wave.extract %value_226[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1307 = wave.extract %value_226[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1308 = wave.extract %value_226[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1309 = wave.extract %value_226[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1310 = wave.extract %value_226[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1311 = wave.extract %value_226[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_228, %token_229 = wave.load %1163 after %1287 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1312 = wave.extract %value_228[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1313 = wave.extract %value_228[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1314 = wave.extract %value_228[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1315 = wave.extract %value_228[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1316 = wave.extract %value_228[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1317 = wave.extract %value_228[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1318 = wave.extract %value_228[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1319 = wave.extract %value_228[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1320 = wave.barrier %token_223, %token_225, %token_227, %token_229 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1321 = wave.extract %1074[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1322 = wave.extract %1074[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1323 = wave.extract %1074[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1324 = wave.extract %1074[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1325 = wave.extract %1078[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1326 = wave.extract %1078[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1327 = wave.extract %1078[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1328 = wave.extract %1078[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1329 = wave.pack %1321, %1322, %1323, %1324, %1325, %1326, %1327, %1328 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1330 = wave.store %1329 -> %1084 after %1320 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1331 = wave.extract %1075[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1332 = wave.extract %1075[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1333 = wave.extract %1075[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1334 = wave.extract %1075[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1335 = wave.extract %1079[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1336 = wave.extract %1079[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1337 = wave.extract %1079[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1338 = wave.extract %1079[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1339 = wave.pack %1331, %1332, %1333, %1334, %1335, %1336, %1337, %1338 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1340 = wave.store %1339 -> %1096 after %1320 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1341 = wave.extract %1076[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1342 = wave.extract %1076[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1343 = wave.extract %1076[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1344 = wave.extract %1076[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1345 = wave.extract %1080[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1346 = wave.extract %1080[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1347 = wave.extract %1080[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1348 = wave.extract %1080[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1349 = wave.pack %1341, %1342, %1343, %1344, %1345, %1346, %1347, %1348 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1350 = wave.store %1349 -> %1108 after %1320 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1351 = wave.extract %1077[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1352 = wave.extract %1077[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1353 = wave.extract %1077[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1354 = wave.extract %1077[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1355 = wave.extract %1081[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1356 = wave.extract %1081[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1357 = wave.extract %1081[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1358 = wave.extract %1081[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1359 = wave.pack %1351, %1352, %1353, %1354, %1355, %1356, %1357, %1358 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1360 = wave.store %1359 -> %1120 after %1320 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1361 = wave.barrier %1330, %1340, %1350, %1360 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_230, %token_231 = wave.load %1133 after %1361 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1362 = wave.extract %value_230[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1363 = wave.extract %value_230[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1364 = wave.extract %value_230[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1365 = wave.extract %value_230[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1366 = wave.extract %value_230[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1367 = wave.extract %value_230[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1368 = wave.extract %value_230[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1369 = wave.extract %value_230[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_232, %token_233 = wave.load %1143 after %1361 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1370 = wave.extract %value_232[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1371 = wave.extract %value_232[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1372 = wave.extract %value_232[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1373 = wave.extract %value_232[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1374 = wave.extract %value_232[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1375 = wave.extract %value_232[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1376 = wave.extract %value_232[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1377 = wave.extract %value_232[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_234, %token_235 = wave.load %1153 after %1361 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1378 = wave.extract %value_234[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1379 = wave.extract %value_234[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1380 = wave.extract %value_234[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1381 = wave.extract %value_234[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1382 = wave.extract %value_234[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1383 = wave.extract %value_234[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1384 = wave.extract %value_234[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1385 = wave.extract %value_234[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_236, %token_237 = wave.load %1163 after %1361 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1386 = wave.extract %value_236[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1387 = wave.extract %value_236[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1388 = wave.extract %value_236[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1389 = wave.extract %value_236[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1390 = wave.extract %value_236[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1391 = wave.extract %value_236[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1392 = wave.extract %value_236[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1393 = wave.extract %value_236[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1394 = wave.barrier %token_231, %token_233, %token_235, %token_237 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1395 = wave.ptr_add %arg2, %1049 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
      %1396 = waveamd.make_buffer %1395, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %1397 = wave.pack %1134, %1135, %1136, %1137, %1144, %1145, %1146, %1147 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1398 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1399 = wave.assume %1398 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1400 = wave.ptr_add %1396, %1399 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1401 = wave.store %1397 -> %1400 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1402 = wave.pack %1154, %1155, %1156, %1157, %1164, %1165, %1166, %1167 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1403 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1404 = wave.assume %1403 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1405 = wave.ptr_add %1396, %1404 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1406 = wave.store %1402 -> %1405 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1407 = wave.pack %1138, %1139, %1140, %1141, %1148, %1149, %1150, %1151 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1408 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1409 = wave.assume %1408 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1410 = wave.ptr_add %1396, %1409 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1411 = wave.store %1407 -> %1410 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1412 = wave.pack %1158, %1159, %1160, %1161, %1168, %1169, %1170, %1171 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1413 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1414 = wave.assume %1413 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1415 = wave.ptr_add %1396, %1414 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1416 = wave.store %1412 -> %1415 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1417 = wave.pack %1214, %1215, %1216, %1217, %1222, %1223, %1224, %1225 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1418 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1419 = wave.assume %1418 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1420 = wave.ptr_add %1396, %1419 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1421 = wave.store %1417 -> %1420 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1422 = wave.pack %1230, %1231, %1232, %1233, %1238, %1239, %1240, %1241 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1423 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1424 = wave.assume %1423 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1425 = wave.ptr_add %1396, %1424 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1426 = wave.store %1422 -> %1425 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1427 = wave.pack %1218, %1219, %1220, %1221, %1226, %1227, %1228, %1229 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1428 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1429 = wave.assume %1428 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1430 = wave.ptr_add %1396, %1429 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1431 = wave.store %1427 -> %1430 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1432 = wave.pack %1234, %1235, %1236, %1237, %1242, %1243, %1244, %1245 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1433 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1434 = wave.assume %1433 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1435 = wave.ptr_add %1396, %1434 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1436 = wave.store %1432 -> %1435 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1437 = wave.pack %1288, %1289, %1290, %1291, %1296, %1297, %1298, %1299 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1438 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1439 = wave.assume %1438 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1440 = wave.ptr_add %1396, %1439 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1441 = wave.store %1437 -> %1440 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1442 = wave.pack %1304, %1305, %1306, %1307, %1312, %1313, %1314, %1315 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1443 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1444 = wave.assume %1443 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1445 = wave.ptr_add %1396, %1444 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1446 = wave.store %1442 -> %1445 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1447 = wave.pack %1292, %1293, %1294, %1295, %1300, %1301, %1302, %1303 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1448 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1449 = wave.assume %1448 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1450 = wave.ptr_add %1396, %1449 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1451 = wave.store %1447 -> %1450 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1452 = wave.pack %1308, %1309, %1310, %1311, %1316, %1317, %1318, %1319 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1453 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1454 = wave.assume %1453 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1455 = wave.ptr_add %1396, %1454 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1456 = wave.store %1452 -> %1455 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1457 = wave.pack %1362, %1363, %1364, %1365, %1370, %1371, %1372, %1373 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1458 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1459 = wave.assume %1458 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1460 = wave.ptr_add %1396, %1459 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1461 = wave.store %1457 -> %1460 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1462 = wave.pack %1378, %1379, %1380, %1381, %1386, %1387, %1388, %1389 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1463 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1464 = wave.assume %1463 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1465 = wave.ptr_add %1396, %1464 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1466 = wave.store %1462 -> %1465 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1467 = wave.pack %1366, %1367, %1368, %1369, %1374, %1375, %1376, %1377 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1468 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1469 = wave.assume %1468 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1470 = wave.ptr_add %1396, %1469 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1471 = wave.store %1467 -> %1470 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1472 = wave.pack %1382, %1383, %1384, %1385, %1390, %1391, %1392, %1393 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1473 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1474 = wave.assume %1473 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1475 = wave.ptr_add %1396, %1474 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1476 = wave.store %1472 -> %1475 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1477 = waveamd.fragment_pack %value_188 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1478 = waveamd.fragment_pack %value_190 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1479 = waveamd.fragment_pack %value_192 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1480 = waveamd.fragment_pack %value_194 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1481 = waveamd.fragment_pack %value_196 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1482 = waveamd.fragment_pack %value_198 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1483 = waveamd.fragment_pack %value_200 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1484 = waveamd.fragment_pack %value_202 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1485 = waveamd.fragment_pack %744 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1486 = waveamd.fragment_pack %747 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1487 = waveamd.fragment_pack %750 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1488 = waveamd.fragment_pack %753 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1489 = waveamd.fragment_pack %756 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1490 = waveamd.fragment_pack %759 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1491 = waveamd.fragment_pack %762 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1492 = waveamd.fragment_pack %765 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1493 = waveamd.fragment_pack %768 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1494 = waveamd.fragment_pack %771 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1495 = waveamd.fragment_pack %774 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1496 = waveamd.fragment_pack %777 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1497 = waveamd.fragment_pack %780 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1498 = waveamd.fragment_pack %783 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1499 = waveamd.fragment_pack %786 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1500 = waveamd.fragment_pack %789 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1501 = waveamd.fragment_pack %792 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1502 = waveamd.fragment_pack %795 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1503 = waveamd.fragment_pack %798 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1504 = waveamd.fragment_pack %801 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1505 = waveamd.fragment_pack %804 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1506 = waveamd.fragment_pack %807 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1507 = waveamd.fragment_pack %810 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1508 = waveamd.fragment_pack %813 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1509 = waveamd.fragment_pack %816 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1510 = waveamd.fragment_pack %819 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1511 = waveamd.fragment_pack %822 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1512 = waveamd.fragment_pack %825 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1513 = waveamd.fragment_pack %828 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1514 = waveamd.fragment_pack %831 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1515 = waveamd.fragment_pack %834 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1516 = waveamd.fragment_pack %837 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1517 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %885, %878, %1485 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1518 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %886, %878, %1517 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1519 = waveamd.fragment_unpack %1518 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1520 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %885, %878, %1486 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1521 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %886, %878, %1520 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1522 = waveamd.fragment_unpack %1521 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1523 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %885, %878, %1487 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1524 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %886, %878, %1523 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1525 = waveamd.fragment_unpack %1524 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1526 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %885, %878, %1488 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1527 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %886, %878, %1526 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1528 = waveamd.fragment_unpack %1527 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1529 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %887, %878, %1489 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1530 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %888, %878, %1529 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1531 = waveamd.fragment_unpack %1530 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1532 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %887, %878, %1490 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1533 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %888, %878, %1532 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1534 = waveamd.fragment_unpack %1533 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1535 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %887, %878, %1491 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1536 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %888, %878, %1535 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1537 = waveamd.fragment_unpack %1536 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1538 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %887, %878, %1492 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1539 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %888, %878, %1538 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1540 = waveamd.fragment_unpack %1539 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1541 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %889, %879, %1493 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1542 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %890, %879, %1541 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1543 = waveamd.fragment_unpack %1542 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1544 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %889, %879, %1494 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1545 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %890, %879, %1544 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1546 = waveamd.fragment_unpack %1545 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1547 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %889, %879, %1495 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1548 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %890, %879, %1547 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1549 = waveamd.fragment_unpack %1548 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1550 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %889, %879, %1496 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1551 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %890, %879, %1550 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1552 = waveamd.fragment_unpack %1551 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1553 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %891, %879, %1497 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1554 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %892, %879, %1553 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1555 = waveamd.fragment_unpack %1554 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1556 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %891, %879, %1498 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1557 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %892, %879, %1556 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1558 = waveamd.fragment_unpack %1557 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1559 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %891, %879, %1499 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1560 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %892, %879, %1559 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1561 = waveamd.fragment_unpack %1560 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1562 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %891, %879, %1500 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1563 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %892, %879, %1562 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1564 = waveamd.fragment_unpack %1563 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1565 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %893, %880, %1501 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1566 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %894, %880, %1565 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1567 = waveamd.fragment_unpack %1566 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1568 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %893, %880, %1502 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1569 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %894, %880, %1568 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1570 = waveamd.fragment_unpack %1569 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1571 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %893, %880, %1503 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1572 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %894, %880, %1571 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1573 = waveamd.fragment_unpack %1572 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1574 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %893, %880, %1504 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1575 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %894, %880, %1574 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1576 = waveamd.fragment_unpack %1575 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1577 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %895, %880, %1505 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %896, %880, %1577 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1579 = waveamd.fragment_unpack %1578 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %895, %880, %1506 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %896, %880, %1580 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1582 = waveamd.fragment_unpack %1581 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %895, %880, %1507 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %896, %880, %1583 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1585 = waveamd.fragment_unpack %1584 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1586 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %895, %880, %1508 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %896, %880, %1586 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1588 = waveamd.fragment_unpack %1587 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %897, %881, %1509 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %898, %881, %1589 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1591 = waveamd.fragment_unpack %1590 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %897, %881, %1510 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %898, %881, %1592 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1594 = waveamd.fragment_unpack %1593 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %897, %881, %1511 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %898, %881, %1595 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1597 = waveamd.fragment_unpack %1596 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %897, %881, %1512 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %898, %881, %1598 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1600 = waveamd.fragment_unpack %1599 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1477, %1047, %899, %881, %1513 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1602 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1478, %1047, %900, %881, %1601 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1603 = waveamd.fragment_unpack %1602 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1479, %1047, %899, %881, %1514 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1605 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1480, %1047, %900, %881, %1604 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1606 = waveamd.fragment_unpack %1605 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1481, %1048, %899, %881, %1515 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1608 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1482, %1048, %900, %881, %1607 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1609 = waveamd.fragment_unpack %1608 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1483, %1048, %899, %881, %1516 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1611 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1484, %1048, %900, %881, %1610 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1612 = waveamd.fragment_unpack %1611 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1613 = wave.cast fpconvert %1519 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1614 = wave.cast fpconvert %1522 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1615 = wave.cast fpconvert %1525 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1616 = wave.cast fpconvert %1528 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1617 = wave.cast fpconvert %1531 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1618 = wave.cast fpconvert %1534 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1619 = wave.cast fpconvert %1537 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1620 = wave.cast fpconvert %1540 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1621 = wave.cast fpconvert %1543 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1622 = wave.cast fpconvert %1546 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1623 = wave.cast fpconvert %1549 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1624 = wave.cast fpconvert %1552 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1625 = wave.cast fpconvert %1555 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1626 = wave.cast fpconvert %1558 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1627 = wave.cast fpconvert %1561 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1628 = wave.cast fpconvert %1564 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1629 = wave.cast fpconvert %1567 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1630 = wave.cast fpconvert %1570 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1631 = wave.cast fpconvert %1573 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1632 = wave.cast fpconvert %1576 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1633 = wave.cast fpconvert %1579 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1634 = wave.cast fpconvert %1582 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1635 = wave.cast fpconvert %1585 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1636 = wave.cast fpconvert %1588 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1637 = wave.cast fpconvert %1591 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1638 = wave.cast fpconvert %1594 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1639 = wave.cast fpconvert %1597 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1640 = wave.cast fpconvert %1600 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1641 = wave.cast fpconvert %1603 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1642 = wave.cast fpconvert %1606 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1643 = wave.cast fpconvert %1609 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1644 = wave.cast fpconvert %1612 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xbf16>, 64>
      %1645 = wave.alloc() {align = 16 : i64, bytesize = 16384 : i64} : !wave.ptr<#wave.shared, bf16>
      %1646 = wave.ptr_add %1645, %1083 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1647 = wave.extract %1613[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1648 = wave.extract %1613[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1649 = wave.extract %1613[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1650 = wave.extract %1613[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1651 = wave.extract %1617[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1652 = wave.extract %1617[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1653 = wave.extract %1617[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1654 = wave.extract %1617[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1655 = wave.pack %1647, %1648, %1649, %1650, %1651, %1652, %1653, %1654 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1656 = wave.store %1655 -> %1646 after %1394 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1657 = wave.ptr_add %1645, %1095 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1658 = wave.extract %1614[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1659 = wave.extract %1614[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1660 = wave.extract %1614[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1661 = wave.extract %1614[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1662 = wave.extract %1618[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1663 = wave.extract %1618[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1664 = wave.extract %1618[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1665 = wave.extract %1618[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1666 = wave.pack %1658, %1659, %1660, %1661, %1662, %1663, %1664, %1665 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1667 = wave.store %1666 -> %1657 after %1394 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1668 = wave.ptr_add %1645, %1107 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1669 = wave.extract %1615[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1670 = wave.extract %1615[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1671 = wave.extract %1615[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1672 = wave.extract %1615[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1673 = wave.extract %1619[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1674 = wave.extract %1619[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1675 = wave.extract %1619[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1676 = wave.extract %1619[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1677 = wave.pack %1669, %1670, %1671, %1672, %1673, %1674, %1675, %1676 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1678 = wave.store %1677 -> %1668 after %1394 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1679 = wave.ptr_add %1645, %1119 : !wave.ptr<#wave.shared, bf16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %1680 = wave.extract %1616[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1681 = wave.extract %1616[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1682 = wave.extract %1616[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1683 = wave.extract %1616[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1684 = wave.extract %1620[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1685 = wave.extract %1620[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1686 = wave.extract %1620[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1687 = wave.extract %1620[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1688 = wave.pack %1680, %1681, %1682, %1683, %1684, %1685, %1686, %1687 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1689 = wave.store %1688 -> %1679 after %1394 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1690 = wave.barrier %1656, %1667, %1678, %1689 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1691 = wave.ptr_add %1645, %1132 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_238, %token_239 = wave.load %1691 after %1690 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1692 = wave.extract %value_238[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1693 = wave.extract %value_238[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1694 = wave.extract %value_238[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1695 = wave.extract %value_238[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1696 = wave.extract %value_238[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1697 = wave.extract %value_238[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1698 = wave.extract %value_238[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1699 = wave.extract %value_238[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1700 = wave.ptr_add %1645, %1142 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_240, %token_241 = wave.load %1700 after %1690 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1701 = wave.extract %value_240[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1702 = wave.extract %value_240[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1703 = wave.extract %value_240[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1704 = wave.extract %value_240[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1705 = wave.extract %value_240[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1706 = wave.extract %value_240[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1707 = wave.extract %value_240[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1708 = wave.extract %value_240[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1709 = wave.ptr_add %1645, %1152 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_242, %token_243 = wave.load %1709 after %1690 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1710 = wave.extract %value_242[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1711 = wave.extract %value_242[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1712 = wave.extract %value_242[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1713 = wave.extract %value_242[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1714 = wave.extract %value_242[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1715 = wave.extract %value_242[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1716 = wave.extract %value_242[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1717 = wave.extract %value_242[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1718 = wave.ptr_add %1645, %1162 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_244, %token_245 = wave.load %1718 after %1690 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1719 = wave.extract %value_244[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1720 = wave.extract %value_244[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1721 = wave.extract %value_244[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1722 = wave.extract %value_244[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1723 = wave.extract %value_244[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1724 = wave.extract %value_244[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1725 = wave.extract %value_244[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1726 = wave.extract %value_244[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1727 = wave.barrier %token_239, %token_241, %token_243, %token_245 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1728 = wave.extract %1621[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1729 = wave.extract %1621[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1730 = wave.extract %1621[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1731 = wave.extract %1621[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1732 = wave.extract %1625[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1733 = wave.extract %1625[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1734 = wave.extract %1625[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1735 = wave.extract %1625[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1736 = wave.pack %1728, %1729, %1730, %1731, %1732, %1733, %1734, %1735 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1737 = wave.store %1736 -> %1646 after %1727 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1738 = wave.extract %1622[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1739 = wave.extract %1622[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1740 = wave.extract %1622[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1741 = wave.extract %1622[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1742 = wave.extract %1626[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1743 = wave.extract %1626[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1744 = wave.extract %1626[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1745 = wave.extract %1626[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1746 = wave.pack %1738, %1739, %1740, %1741, %1742, %1743, %1744, %1745 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1747 = wave.store %1746 -> %1657 after %1727 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1748 = wave.extract %1623[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1749 = wave.extract %1623[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1750 = wave.extract %1623[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1751 = wave.extract %1623[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1752 = wave.extract %1627[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1753 = wave.extract %1627[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1754 = wave.extract %1627[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1755 = wave.extract %1627[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1756 = wave.pack %1748, %1749, %1750, %1751, %1752, %1753, %1754, %1755 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1757 = wave.store %1756 -> %1668 after %1727 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1758 = wave.extract %1624[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1759 = wave.extract %1624[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1760 = wave.extract %1624[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1761 = wave.extract %1624[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1762 = wave.extract %1628[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1763 = wave.extract %1628[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1764 = wave.extract %1628[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1765 = wave.extract %1628[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1766 = wave.pack %1758, %1759, %1760, %1761, %1762, %1763, %1764, %1765 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1767 = wave.store %1766 -> %1679 after %1727 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1768 = wave.barrier %1737, %1747, %1757, %1767 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_246, %token_247 = wave.load %1691 after %1768 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1769 = wave.extract %value_246[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1770 = wave.extract %value_246[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1771 = wave.extract %value_246[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1772 = wave.extract %value_246[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1773 = wave.extract %value_246[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1774 = wave.extract %value_246[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1775 = wave.extract %value_246[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1776 = wave.extract %value_246[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_248, %token_249 = wave.load %1700 after %1768 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1777 = wave.extract %value_248[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1778 = wave.extract %value_248[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1779 = wave.extract %value_248[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1780 = wave.extract %value_248[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1781 = wave.extract %value_248[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1782 = wave.extract %value_248[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1783 = wave.extract %value_248[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1784 = wave.extract %value_248[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_250, %token_251 = wave.load %1709 after %1768 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1785 = wave.extract %value_250[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1786 = wave.extract %value_250[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1787 = wave.extract %value_250[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1788 = wave.extract %value_250[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1789 = wave.extract %value_250[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1790 = wave.extract %value_250[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1791 = wave.extract %value_250[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1792 = wave.extract %value_250[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_252, %token_253 = wave.load %1718 after %1768 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1793 = wave.extract %value_252[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1794 = wave.extract %value_252[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1795 = wave.extract %value_252[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1796 = wave.extract %value_252[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1797 = wave.extract %value_252[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1798 = wave.extract %value_252[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1799 = wave.extract %value_252[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1800 = wave.extract %value_252[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1801 = wave.barrier %token_247, %token_249, %token_251, %token_253 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1802 = wave.extract %1629[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1803 = wave.extract %1629[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1804 = wave.extract %1629[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1805 = wave.extract %1629[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1806 = wave.extract %1633[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1807 = wave.extract %1633[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1808 = wave.extract %1633[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1809 = wave.extract %1633[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1810 = wave.pack %1802, %1803, %1804, %1805, %1806, %1807, %1808, %1809 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1811 = wave.store %1810 -> %1646 after %1801 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1812 = wave.extract %1630[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1813 = wave.extract %1630[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1814 = wave.extract %1630[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1815 = wave.extract %1630[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1816 = wave.extract %1634[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1817 = wave.extract %1634[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1818 = wave.extract %1634[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1819 = wave.extract %1634[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1820 = wave.pack %1812, %1813, %1814, %1815, %1816, %1817, %1818, %1819 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1821 = wave.store %1820 -> %1657 after %1801 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1822 = wave.extract %1631[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1823 = wave.extract %1631[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1824 = wave.extract %1631[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1825 = wave.extract %1631[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1826 = wave.extract %1635[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1827 = wave.extract %1635[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1828 = wave.extract %1635[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1829 = wave.extract %1635[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1830 = wave.pack %1822, %1823, %1824, %1825, %1826, %1827, %1828, %1829 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1831 = wave.store %1830 -> %1668 after %1801 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1832 = wave.extract %1632[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1833 = wave.extract %1632[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1834 = wave.extract %1632[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1835 = wave.extract %1632[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1836 = wave.extract %1636[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1837 = wave.extract %1636[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1838 = wave.extract %1636[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1839 = wave.extract %1636[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1840 = wave.pack %1832, %1833, %1834, %1835, %1836, %1837, %1838, %1839 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1841 = wave.store %1840 -> %1679 after %1801 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1842 = wave.barrier %1811, %1821, %1831, %1841 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_254, %token_255 = wave.load %1691 after %1842 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1843 = wave.extract %value_254[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1844 = wave.extract %value_254[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1845 = wave.extract %value_254[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1846 = wave.extract %value_254[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1847 = wave.extract %value_254[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1848 = wave.extract %value_254[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1849 = wave.extract %value_254[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1850 = wave.extract %value_254[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_256, %token_257 = wave.load %1700 after %1842 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1851 = wave.extract %value_256[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1852 = wave.extract %value_256[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1853 = wave.extract %value_256[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1854 = wave.extract %value_256[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1855 = wave.extract %value_256[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1856 = wave.extract %value_256[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1857 = wave.extract %value_256[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1858 = wave.extract %value_256[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_258, %token_259 = wave.load %1709 after %1842 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1859 = wave.extract %value_258[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1860 = wave.extract %value_258[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1861 = wave.extract %value_258[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1862 = wave.extract %value_258[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1863 = wave.extract %value_258[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1864 = wave.extract %value_258[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1865 = wave.extract %value_258[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1866 = wave.extract %value_258[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_260, %token_261 = wave.load %1718 after %1842 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1867 = wave.extract %value_260[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1868 = wave.extract %value_260[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1869 = wave.extract %value_260[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1870 = wave.extract %value_260[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1871 = wave.extract %value_260[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1872 = wave.extract %value_260[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1873 = wave.extract %value_260[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1874 = wave.extract %value_260[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1875 = wave.barrier %token_255, %token_257, %token_259, %token_261 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1876 = wave.extract %1637[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1877 = wave.extract %1637[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1878 = wave.extract %1637[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1879 = wave.extract %1637[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1880 = wave.extract %1641[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1881 = wave.extract %1641[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1882 = wave.extract %1641[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1883 = wave.extract %1641[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1884 = wave.pack %1876, %1877, %1878, %1879, %1880, %1881, %1882, %1883 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1885 = wave.store %1884 -> %1646 after %1875 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1886 = wave.extract %1638[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1887 = wave.extract %1638[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1888 = wave.extract %1638[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1889 = wave.extract %1638[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1890 = wave.extract %1642[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1891 = wave.extract %1642[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1892 = wave.extract %1642[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1893 = wave.extract %1642[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1894 = wave.pack %1886, %1887, %1888, %1889, %1890, %1891, %1892, %1893 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1895 = wave.store %1894 -> %1657 after %1875 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1896 = wave.extract %1639[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1897 = wave.extract %1639[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1898 = wave.extract %1639[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1899 = wave.extract %1639[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1900 = wave.extract %1643[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1901 = wave.extract %1643[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1902 = wave.extract %1643[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1903 = wave.extract %1643[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1904 = wave.pack %1896, %1897, %1898, %1899, %1900, %1901, %1902, %1903 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1905 = wave.store %1904 -> %1668 after %1875 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1906 = wave.extract %1640[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1907 = wave.extract %1640[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1908 = wave.extract %1640[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1909 = wave.extract %1640[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1910 = wave.extract %1644[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1911 = wave.extract %1644[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1912 = wave.extract %1644[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1913 = wave.extract %1644[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %1914 = wave.pack %1906, %1907, %1908, %1909, %1910, %1911, %1912, %1913 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1915 = wave.store %1914 -> %1679 after %1875 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> !wave.mem.token
      %1916 = wave.barrier %1885, %1895, %1905, %1915 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_262, %token_263 = wave.load %1691 after %1916 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1917 = wave.extract %value_262[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1918 = wave.extract %value_262[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1919 = wave.extract %value_262[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1920 = wave.extract %value_262[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1921 = wave.extract %value_262[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1922 = wave.extract %value_262[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1923 = wave.extract %value_262[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1924 = wave.extract %value_262[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_264, %token_265 = wave.load %1700 after %1916 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1925 = wave.extract %value_264[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1926 = wave.extract %value_264[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1927 = wave.extract %value_264[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1928 = wave.extract %value_264[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1929 = wave.extract %value_264[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1930 = wave.extract %value_264[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1931 = wave.extract %value_264[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1932 = wave.extract %value_264[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_266, %token_267 = wave.load %1709 after %1916 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1933 = wave.extract %value_266[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1934 = wave.extract %value_266[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1935 = wave.extract %value_266[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1936 = wave.extract %value_266[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1937 = wave.extract %value_266[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1938 = wave.extract %value_266[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1939 = wave.extract %value_266[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1940 = wave.extract %value_266[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_268, %token_269 = wave.load %1718 after %1916 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %1941 = wave.extract %value_268[0] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1942 = wave.extract %value_268[1] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1943 = wave.extract %value_268[2] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1944 = wave.extract %value_268[3] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1945 = wave.extract %value_268[4] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1946 = wave.extract %value_268[5] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1947 = wave.extract %value_268[6] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1948 = wave.extract %value_268[7] : !wave.simd<vector<8xbf16>, 64> -> !wave.simd<bf16, 64>
      %1949 = wave.barrier %token_263, %token_265, %token_267, %token_269 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1950 = wave.pack %1692, %1693, %1694, %1695, %1701, %1702, %1703, %1704 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1951 = wave.index_expr <"128 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1952 = wave.assume %1951 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1953 = wave.ptr_add %1396, %1952 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1954 = wave.store %1950 -> %1953 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1955 = wave.pack %1710, %1711, %1712, %1713, %1719, %1720, %1721, %1722 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1956 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1957 = wave.assume %1956 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1958 = wave.ptr_add %1396, %1957 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1959 = wave.store %1955 -> %1958 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1960 = wave.pack %1696, %1697, %1698, %1699, %1705, %1706, %1707, %1708 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1961 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1962 = wave.assume %1961 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1963 = wave.ptr_add %1396, %1962 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1964 = wave.store %1960 -> %1963 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1965 = wave.pack %1714, %1715, %1716, %1717, %1723, %1724, %1725, %1726 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1966 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1967 = wave.assume %1966 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1968 = wave.ptr_add %1396, %1967 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1969 = wave.store %1965 -> %1968 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1970 = wave.pack %1769, %1770, %1771, %1772, %1777, %1778, %1779, %1780 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1971 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1972 = wave.assume %1971 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1973 = wave.ptr_add %1396, %1972 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1974 = wave.store %1970 -> %1973 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1975 = wave.pack %1785, %1786, %1787, %1788, %1793, %1794, %1795, %1796 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1976 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1977 = wave.assume %1976 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1978 = wave.ptr_add %1396, %1977 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1979 = wave.store %1975 -> %1978 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1980 = wave.pack %1773, %1774, %1775, %1776, %1781, %1782, %1783, %1784 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1981 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1982 = wave.assume %1981 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1983 = wave.ptr_add %1396, %1982 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1984 = wave.store %1980 -> %1983 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1985 = wave.pack %1789, %1790, %1791, %1792, %1797, %1798, %1799, %1800 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1986 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1987 = wave.assume %1986 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1988 = wave.ptr_add %1396, %1987 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1989 = wave.store %1985 -> %1988 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1990 = wave.pack %1843, %1844, %1845, %1846, %1851, %1852, %1853, %1854 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1991 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1992 = wave.assume %1991 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1993 = wave.ptr_add %1396, %1992 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1994 = wave.store %1990 -> %1993 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %1995 = wave.pack %1859, %1860, %1861, %1862, %1867, %1868, %1869, %1870 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1996 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1997 = wave.assume %1996 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %1998 = wave.ptr_add %1396, %1997 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %1999 = wave.store %1995 -> %1998 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2000 = wave.pack %1847, %1848, %1849, %1850, %1855, %1856, %1857, %1858 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2001 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2002 = wave.assume %2001 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2003 = wave.ptr_add %1396, %2002 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2004 = wave.store %2000 -> %2003 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2005 = wave.pack %1863, %1864, %1865, %1866, %1871, %1872, %1873, %1874 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2006 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2007 = wave.assume %2006 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2008 = wave.ptr_add %1396, %2007 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2009 = wave.store %2005 -> %2008 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2010 = wave.pack %1917, %1918, %1919, %1920, %1925, %1926, %1927, %1928 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2011 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2012 = wave.assume %2011 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2013 = wave.ptr_add %1396, %2012 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2014 = wave.store %2010 -> %2013 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2015 = wave.pack %1933, %1934, %1935, %1936, %1941, %1942, %1943, %1944 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2016 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2017 = wave.assume %2016 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2018 = wave.ptr_add %1396, %2017 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2019 = wave.store %2015 -> %2018 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2020 = wave.pack %1921, %1922, %1923, %1924, %1929, %1930, %1931, %1932 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2021 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2022 = wave.assume %2021 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2023 = wave.ptr_add %1396, %2022 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2024 = wave.store %2020 -> %2023 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      %2025 = wave.pack %1937, %1938, %1939, %1940, %1945, %1946, %1947, %1948 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %2026 = wave.index_expr <"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741688 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%52, %arg9, %46) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2027 = wave.assume %2026 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %2028 = wave.ptr_add %1396, %2027 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %2029 = wave.store %2025 -> %2028 : (!wave.simd<vector<8xbf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>) -> !wave.mem.token
      return
    }
  }
}
