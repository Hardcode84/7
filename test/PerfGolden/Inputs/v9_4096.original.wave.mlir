module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @v9_beyond_hotloop(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: i32, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %1 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 192 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant false -> !wave.mask<64>
      %c8448_i32 = arith.constant 8448 : i32
      %c16896_i32 = arith.constant 16896 : i32
      %c6336_i32 = arith.constant 6336 : i32
      %c4224_i32 = arith.constant 4224 : i32
      %c2112_i32 = arith.constant 2112 : i32
      %c264_i32 = arith.constant 264 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c0_i32 = arith.constant 0 : i32
      %c255_i32 = arith.constant 255 : i32
      %c2_i32 = arith.constant 2 : i32
      %c62_i32 = arith.constant 62 : i32
      %c64_i32 = arith.constant 64 : i32
      %c128_i32 = arith.constant 128 : i32
      %c256_i32 = arith.constant 256 : i32
      %c4_i32 = arith.constant 4 : i32
      %c8_i32 = arith.constant 8 : i32
      %c32_i32 = arith.constant 32 : i32
      %12 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %13 = wave.pack %12, %12, %12, %12 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %14 = wave.workgroup_id 0
      %15 = wave.assume %arg3 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %16 = wave.binary addi %15, %c255_i32 overflow<nsw, nuw> : i32, i32 -> i32
      %17 = wave.binary divsi %16, %c256_i32 : i32, i32 -> i32
      %18 = wave.assume %arg4 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %19 = wave.binary addi %18, %c255_i32 overflow<nsw, nuw> : i32, i32 -> i32
      %20 = wave.binary divsi %19, %c256_i32 : i32, i32 -> i32
      %21 = wave.assume %arg3 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %22 = wave.assume %arg4 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %23 = wave.binary remui %14, %c8_i32 : i32, i32 -> i32
      %24 = wave.binary divui %14, %c8_i32 : i32, i32 -> i32
      %25 = wave.binary muli %23, %c32_i32 overflow<nsw, nuw> : i32, i32 -> i32
      %26 = wave.binary addi %25, %24 overflow<nsw, nuw> : i32, i32 -> i32
      %27 = wave.binary muli %20, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %28 = wave.binary divsi %26, %27 : i32, i32 -> i32
      %29 = wave.binary muli %28, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %30 = wave.binary subi %17, %29 overflow<nsw> : i32, i32 -> i32
      %31 = arith.cmpi slt, %30, %c4_i32 : i32
      %32 = wave.select %31, %30, %c4_i32 : i32
      %33 = wave.binary remsi %26, %27 : i32, i32 -> i32
      %34 = wave.assume %32 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %35 = wave.binary remui %33, %34 : i32, i32 -> i32
      %36 = wave.binary addi %29, %35 overflow<nsw> : i32, i32 -> i32
      %37 = wave.assume %32 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %38 = wave.binary divui %33, %37 : i32, i32 -> i32
      %39 = wave.assume %arg5 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %40 = wave.alloc() {align = 16 : i64, bytesize = 67552 : i64} : !wave.ptr<#wave.shared, f16>
      %41 = wave.alloc() {align = 16 : i64, bytesize = 33760 : i64} : !wave.ptr<#wave.shared, f16>
      %42 = wave.alloc() {align = 16 : i64, bytesize = 33760 : i64} : !wave.ptr<#wave.shared, f16>
      %43 = wave.assume %36 as "x" [#wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %44 = wave.binary muli %43, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %45 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %46 = wave.binary remui %45, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %47 = wave.binary divui %45, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %48 = wave.binary remui %47, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %49 = wave.binary muli %48, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %50 = wave.binary addi %46, %49 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %51 = wave.binary divui %45, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %52 = wave.binary remui %51, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %53 = wave.binary muli %52, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %54 = wave.binary addi %50, %53 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %55 = wave.binary divui %45, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %56 = wave.binary remui %55, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %57 = wave.binary muli %56, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %58 = wave.binary addi %54, %57 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary divui %45, %7 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary remui %59, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary muli %60, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary addi %58, %61 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary divui %45, %5 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary remui %63, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary muli %64, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary addi %62, %65 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary addi %66, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary addi %66, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.binary addi %66, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.splat %44 : i32 -> !wave.simd<i32, 64>
      %71 = wave.binary addi %70, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary addi %70, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary addi %70, %68 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary addi %70, %69 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.assume %38 as "x" [#wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %76 = wave.binary muli %75, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %77 = wave.binary divui %45, %6 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary remui %77, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary muli %78, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary addi %79, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary addi %79, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary addi %79, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.splat %76 : i32 -> !wave.simd<i32, 64>
      %84 = wave.binary addi %83, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.binary addi %83, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary addi %83, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary addi %83, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.assume %arg6 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %89 = wave.binary muli %88, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %90 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %91 = wave.token : !wave.mem.token
      %92 = wave.ptr_cast %40 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %93 = wave.read_first %45 : !wave.simd<i32, 64> -> i32
      %94 = wave.assume %93 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
      %95 = wave.binary divui %94, %c64_i32 : i32, i32 -> i32
      %96 = wave.binary muli %95, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %97 = wave.index_expr <"s0*s1 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0*s1 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %98 = wave.assume %97 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %99 = wave.ptr_add %90, %98 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %100 = wave.ptr_add %92, %96 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %101 = waveamd.dma_load_lds %99 -> %100 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %102 = wave.index_expr <"s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %103 = wave.assume %102 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %104 = wave.ptr_add %90, %103 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %105 = wave.binary addi %96, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %106 = wave.ptr_add %92, %105 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %107 = waveamd.dma_load_lds %104 -> %106 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %108 = wave.index_expr <"s0*s1 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0*s1 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %109 = wave.assume %108 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %110 = wave.ptr_add %90, %109 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %111 = wave.binary addi %96, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %112 = wave.ptr_add %92, %111 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %113 = waveamd.dma_load_lds %110 -> %112 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %114 = wave.index_expr <"s0*s1 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0*s1 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %115 = wave.assume %114 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %116 = wave.ptr_add %90, %115 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %117 = wave.binary addi %96, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %118 = wave.ptr_add %92, %117 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %119 = waveamd.dma_load_lds %116 -> %118 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %120 = wave.join %101, %107, %113, %119 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %121 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %122 = wave.ptr_cast %41 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %123 = wave.index_expr <"s0*s1 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0*s1 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %88, %76) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %124 = wave.assume %123 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %125 = wave.ptr_add %121, %124 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %126 = wave.ptr_add %122, %96 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %127 = waveamd.dma_load_lds %125 -> %126 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %128 = wave.index_expr <"s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %88, %76) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %129 = wave.assume %128 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %130 = wave.ptr_add %121, %129 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %131 = wave.ptr_add %122, %105 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %132 = waveamd.dma_load_lds %130 -> %131 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %133 = wave.join %127, %132 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %134 = wave.join %120, %133 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %135 = wave.ptr_cast %42 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %136 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %89, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %137 = wave.assume %136 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %138 = wave.ptr_add %121, %137 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %139 = wave.ptr_add %135, %96 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %140 = waveamd.dma_load_lds %138 -> %139 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %141 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %89, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %142 = wave.assume %141 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %143 = wave.ptr_add %121, %142 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %144 = wave.ptr_add %135, %105 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %145 = waveamd.dma_load_lds %143 -> %144 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %146 = wave.join %140, %145 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %147 = wave.ptr_add %40, %c16896_i32 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %148 = wave.index_expr <"64 + s0*s1 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0*s1 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0*s1 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %149 = wave.assume %148 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %150 = wave.ptr_add %90, %149 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %151 = wave.binary addi %c8448_i32, %96 overflow<nsw> : i32, i32 -> i32
      %152 = wave.ptr_add %92, %151 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %153 = waveamd.dma_load_lds %150 -> %152 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %154 = wave.index_expr <"64 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %155 = wave.assume %154 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %156 = wave.ptr_add %90, %155 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %157 = wave.binary addi %c8448_i32, %105 overflow<nsw> : i32, i32 -> i32
      %158 = wave.ptr_add %92, %157 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %159 = waveamd.dma_load_lds %156 -> %158 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %160 = wave.index_expr <"64 + s0*s1 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0*s1 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0*s1 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %161 = wave.assume %160 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %162 = wave.ptr_add %90, %161 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %163 = wave.binary addi %c8448_i32, %111 overflow<nsw> : i32, i32 -> i32
      %164 = wave.ptr_add %92, %163 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %165 = waveamd.dma_load_lds %162 -> %164 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %166 = wave.index_expr <"64 + s0*s1 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0*s1 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0*s1 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %39, %44) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %167 = wave.assume %166 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %168 = wave.ptr_add %90, %167 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %169 = wave.binary addi %c8448_i32, %117 overflow<nsw> : i32, i32 -> i32
      %170 = wave.ptr_add %92, %169 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %171 = waveamd.dma_load_lds %168 -> %170 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %172 = wave.join %153, %159, %165, %171 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %173 = wave.ptr_add %41, %c8448_i32 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %174 = wave.index_expr <"64 + s0*s1 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0*s1 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0*s1 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %88, %76) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %175 = wave.assume %174 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %176 = wave.ptr_add %121, %175 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %177 = wave.binary addi %c4224_i32, %96 overflow<nsw> : i32, i32 -> i32
      %178 = wave.ptr_add %122, %177 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %179 = waveamd.dma_load_lds %176 -> %178 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %180 = wave.index_expr <"64 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0*s1 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%45, %88, %76) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %181 = wave.assume %180 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %182 = wave.ptr_add %121, %181 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %183 = wave.binary addi %c4224_i32, %105 overflow<nsw> : i32, i32 -> i32
      %184 = wave.ptr_add %122, %183 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %185 = waveamd.dma_load_lds %182 -> %184 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %186 = wave.join %179, %185 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %187 = wave.join %172, %186 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %188 = wave.ptr_add %42, %c8448_i32 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %189 = wave.index_expr <"64 + s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %89, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %190 = wave.assume %189 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %191 = wave.ptr_add %121, %190 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %192 = wave.ptr_add %135, %177 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %193 = waveamd.dma_load_lds %191 -> %192 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %194 = wave.index_expr <"64 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %89, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
      %195 = wave.assume %194 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %196 = wave.ptr_add %121, %195 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %197 = wave.ptr_add %135, %183 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %198 = waveamd.dma_load_lds %196 -> %197 after %91 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %199 = wave.join %193, %198 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %200 = wave.barrier %134 : (!wave.mem.token) -> !wave.mem.token
      %201 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 8448*Mod(floor(1/1024*wi), 2) + 4224*Mod(floor(1/512*wi), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %202 = wave.ptr_add %40, %201 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %202 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %203 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 8448*Mod(floor(1/1024*wi), 2) + 4224*Mod(floor(1/512*wi), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %204 = wave.ptr_add %40, %203 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %204 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %205 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 4224*Mod(1 + floor(1/512*wi), 2) + 8448*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %206 = wave.ptr_add %40, %205 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %206 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %207 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 4224*Mod(1 + floor(1/512*wi), 2) + 8448*Mod(floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %208 = wave.ptr_add %40, %207 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %208 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %209 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 8448*Mod(1 + floor(1/1024*wi), 2) + 4224*Mod(floor(1/512*wi), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %210 = wave.ptr_add %40, %209 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %210 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %211 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 8448*Mod(1 + floor(1/1024*wi), 2) + 4224*Mod(floor(1/512*wi), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %212 = wave.ptr_add %40, %211 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %212 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %213 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 8448*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 4224*Mod(1 + floor(1/512*wi), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %214 = wave.ptr_add %40, %213 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %214 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %215 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 8448*Mod(1 + floor(1/2 + 1/8*floor(1/128*wi) + 1/128*Mod(Mod(wi, 64), 16)), 2) + 4224*Mod(1 + floor(1/512*wi), 2) + 2112*Mod(floor(1/256*wi), 2) + 1056*Mod(floor(1/128*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %216 = wave.ptr_add %40, %215 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %216 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %217 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %218 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %219 = wave.ptr_add %41, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_14, %token_15 = wave.load %219 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %220 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %221 = wave.ptr_add %41, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_16, %token_17 = wave.load %221 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %222 = wave.index_expr <"2112 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %223 = wave.ptr_add %41, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_18, %token_19 = wave.load %223 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %224 = wave.index_expr <"2144 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %225 = wave.ptr_add %41, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_20, %token_21 = wave.load %225 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %226 = wave.index_expr <"4224 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %227 = wave.ptr_add %41, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_22, %token_23 = wave.load %227 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %228 = wave.index_expr <"4256 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %229 = wave.ptr_add %41, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_24, %token_25 = wave.load %229 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %230 = wave.index_expr <"6336 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %231 = wave.ptr_add %41, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_26, %token_27 = wave.load %231 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %232 = wave.index_expr <"6368 + 8*floor(1/16*Mod(wi, 64)) + 528*floor(1/8*Mod(Mod(wi, 64), 16)) + 1056*Mod(floor(1/64*wi), 2) + 256*Mod(floor(1/4*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(floor(1/2*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%45) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %233 = wave.ptr_add %41, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_28, %token_29 = wave.load %233 after %200 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %234 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %235 = wave.join %120, %172, %217 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %236 = wave.join %133, %186, %234 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %237 = wave.join %146, %199 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %238:56 = scf.for %arg8 = %c0_i32 to %c62_i32 step %c2_i32 iter_args(%arg9 = %c128_i32, %arg10 = %c128_i32, %arg11 = %13, %arg12 = %13, %arg13 = %13, %arg14 = %13, %arg15 = %13, %arg16 = %13, %arg17 = %13, %arg18 = %13, %arg19 = %13, %arg20 = %13, %arg21 = %13, %arg22 = %13, %arg23 = %13, %arg24 = %13, %arg25 = %13, %arg26 = %13, %arg27 = %13, %arg28 = %13, %arg29 = %13, %arg30 = %13, %arg31 = %13, %arg32 = %13, %arg33 = %13, %arg34 = %13, %arg35 = %13, %arg36 = %13, %arg37 = %13, %arg38 = %13, %arg39 = %13, %arg40 = %13, %arg41 = %13, %arg42 = %13, %arg43 = %value, %arg44 = %value_0, %arg45 = %value_2, %arg46 = %value_4, %arg47 = %value_6, %arg48 = %value_8, %arg49 = %value_10, %arg50 = %value_12, %arg51 = %value_14, %arg52 = %value_16, %arg53 = %value_18, %arg54 = %value_20, %arg55 = %value_22, %arg56 = %value_24, %arg57 = %value_26, %arg58 = %value_28, %arg59 = %146, %arg60 = %187, %arg61 = %199, %arg62 = %235, %arg63 = %236, %arg64 = %237) -> (i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %849 = waveamd.fragment_pack %arg43 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %850 = waveamd.fragment_pack %arg44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %851 = waveamd.fragment_pack %arg45 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %852 = waveamd.fragment_pack %arg46 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %853 = waveamd.fragment_pack %arg47 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %854 = waveamd.fragment_pack %arg48 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %855 = waveamd.fragment_pack %arg49 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %856 = waveamd.fragment_pack %arg50 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %857 = waveamd.fragment_pack %arg51 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %858 = waveamd.fragment_pack %arg52 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %859 = waveamd.fragment_pack %arg53 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %860 = waveamd.fragment_pack %arg54 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %861 = waveamd.fragment_pack %arg55 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %862 = waveamd.fragment_pack %arg56 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %863 = waveamd.fragment_pack %arg57 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %864 = waveamd.fragment_pack %arg58 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %865 = waveamd.fragment_pack %arg11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %866 = waveamd.fragment_pack %arg12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %867 = waveamd.fragment_pack %arg13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %868 = waveamd.fragment_pack %arg14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %869 = waveamd.fragment_pack %arg15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %870 = waveamd.fragment_pack %arg16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %871 = waveamd.fragment_pack %arg17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %872 = waveamd.fragment_pack %arg18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %873 = waveamd.fragment_pack %arg19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %874 = waveamd.fragment_pack %arg20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %875 = waveamd.fragment_pack %arg21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %876 = waveamd.fragment_pack %arg22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %877 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %878 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %879 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %880 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %881 = waveamd.mma "mfma.f32.16x16x32.f16" %857, %849, %865 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %882 = waveamd.mma "mfma.f32.16x16x32.f16" %858, %850, %881 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %883 = waveamd.fragment_unpack %882 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %884 = waveamd.mma "mfma.f32.16x16x32.f16" %859, %849, %866 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %885 = waveamd.mma "mfma.f32.16x16x32.f16" %860, %850, %884 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %886 = waveamd.fragment_unpack %885 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %887 = waveamd.mma "mfma.f32.16x16x32.f16" %861, %849, %867 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %888 = waveamd.mma "mfma.f32.16x16x32.f16" %862, %850, %887 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %889 = waveamd.fragment_unpack %888 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %890 = waveamd.mma "mfma.f32.16x16x32.f16" %863, %849, %868 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %891 = waveamd.mma "mfma.f32.16x16x32.f16" %864, %850, %890 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %892 = waveamd.fragment_unpack %891 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %893 = waveamd.mma "mfma.f32.16x16x32.f16" %857, %851, %869 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %894 = waveamd.mma "mfma.f32.16x16x32.f16" %858, %852, %893 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %895 = waveamd.fragment_unpack %894 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %896 = waveamd.mma "mfma.f32.16x16x32.f16" %859, %851, %870 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %897 = waveamd.mma "mfma.f32.16x16x32.f16" %860, %852, %896 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %898 = waveamd.fragment_unpack %897 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %899 = waveamd.mma "mfma.f32.16x16x32.f16" %861, %851, %871 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %900 = waveamd.mma "mfma.f32.16x16x32.f16" %862, %852, %899 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %901 = waveamd.fragment_unpack %900 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %902 = waveamd.mma "mfma.f32.16x16x32.f16" %863, %851, %872 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %903 = waveamd.mma "mfma.f32.16x16x32.f16" %864, %852, %902 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %904 = waveamd.fragment_unpack %903 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %905 = waveamd.mma "mfma.f32.16x16x32.f16" %857, %853, %873 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %906 = waveamd.mma "mfma.f32.16x16x32.f16" %858, %854, %905 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %907 = waveamd.fragment_unpack %906 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %908 = waveamd.mma "mfma.f32.16x16x32.f16" %859, %853, %874 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %909 = waveamd.mma "mfma.f32.16x16x32.f16" %860, %854, %908 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %910 = waveamd.fragment_unpack %909 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %911 = waveamd.mma "mfma.f32.16x16x32.f16" %861, %853, %875 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %912 = waveamd.mma "mfma.f32.16x16x32.f16" %862, %854, %911 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %913 = waveamd.fragment_unpack %912 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %914 = waveamd.mma "mfma.f32.16x16x32.f16" %863, %853, %876 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %915 = waveamd.mma "mfma.f32.16x16x32.f16" %864, %854, %914 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %916 = waveamd.fragment_unpack %915 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %917 = waveamd.mma "mfma.f32.16x16x32.f16" %857, %855, %877 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %918 = waveamd.mma "mfma.f32.16x16x32.f16" %858, %856, %917 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %919 = waveamd.fragment_unpack %918 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %920 = waveamd.mma "mfma.f32.16x16x32.f16" %859, %855, %878 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %921 = waveamd.mma "mfma.f32.16x16x32.f16" %860, %856, %920 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %922 = waveamd.fragment_unpack %921 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %923 = waveamd.mma "mfma.f32.16x16x32.f16" %861, %855, %879 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %924 = waveamd.mma "mfma.f32.16x16x32.f16" %862, %856, %923 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %925 = waveamd.fragment_unpack %924 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %926 = waveamd.mma "mfma.f32.16x16x32.f16" %863, %855, %880 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %927 = waveamd.mma "mfma.f32.16x16x32.f16" %864, %856, %926 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %928 = waveamd.fragment_unpack %927 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %929 = wave.barrier %arg59 : (!wave.mem.token) -> !wave.mem.token
        %930 = wave.ptr_add %42, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_94, %token_95 = wave.load %930 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %931 = wave.ptr_add %42, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_96, %token_97 = wave.load %931 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %932 = wave.ptr_add %42, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_98, %token_99 = wave.load %932 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %933 = wave.ptr_add %42, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_100, %token_101 = wave.load %933 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %934 = wave.ptr_add %42, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_102, %token_103 = wave.load %934 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %935 = wave.ptr_add %42, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_104, %token_105 = wave.load %935 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %936 = wave.ptr_add %42, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_106, %token_107 = wave.load %936 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %937 = wave.ptr_add %42, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_108, %token_109 = wave.load %937 after %929 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %938 = wave.join %token_95, %token_97, %token_99, %token_101, %token_103, %token_105, %token_107, %token_109 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %939 = wave.index_expr <"s1 + s0*s2 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %arg9, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %940 = wave.assume %939 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %941 = wave.ptr_add %90, %940 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %942 = waveamd.dma_load_lds %941 -> %100 after %929 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %943 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %arg9, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %944 = wave.assume %943 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %945 = wave.ptr_add %90, %944 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %946 = waveamd.dma_load_lds %945 -> %106 after %929 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %947 = wave.index_expr <"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %arg9, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %948 = wave.assume %947 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %949 = wave.ptr_add %90, %948 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %950 = waveamd.dma_load_lds %949 -> %112 after %929 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %951 = wave.index_expr <"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %arg9, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %952 = wave.assume %951 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %953 = wave.ptr_add %90, %952 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %954 = waveamd.dma_load_lds %953 -> %118 after %929 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %955 = wave.join %942, %946, %950, %954 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %956 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %arg10, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %957 = wave.assume %956 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %958 = wave.ptr_add %121, %957 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %959 = waveamd.dma_load_lds %958 -> %126 after %929 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %960 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %arg10, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %961 = wave.assume %960 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %962 = wave.ptr_add %121, %961 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %963 = waveamd.dma_load_lds %962 -> %131 after %929 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %964 = wave.join %959, %963 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %965 = wave.join %955, %964 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %966 = waveamd.fragment_pack %value_94 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %967 = waveamd.fragment_pack %value_96 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %968 = waveamd.fragment_pack %value_98 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %969 = waveamd.fragment_pack %value_100 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %970 = waveamd.fragment_pack %value_102 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %971 = waveamd.fragment_pack %value_104 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %972 = waveamd.fragment_pack %value_106 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %973 = waveamd.fragment_pack %value_108 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %974 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %975 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %976 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %977 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %978 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %979 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %980 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %981 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %982 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %983 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %984 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %985 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %986 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %987 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %988 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %989 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %990 = waveamd.mma "mfma.f32.16x16x32.f16" %966, %849, %974 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %991 = waveamd.mma "mfma.f32.16x16x32.f16" %967, %850, %990 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %992 = waveamd.fragment_unpack %991 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %993 = waveamd.mma "mfma.f32.16x16x32.f16" %968, %849, %975 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %994 = waveamd.mma "mfma.f32.16x16x32.f16" %969, %850, %993 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %995 = waveamd.fragment_unpack %994 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %996 = waveamd.mma "mfma.f32.16x16x32.f16" %970, %849, %976 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %997 = waveamd.mma "mfma.f32.16x16x32.f16" %971, %850, %996 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %998 = waveamd.fragment_unpack %997 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %999 = waveamd.mma "mfma.f32.16x16x32.f16" %972, %849, %977 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1000 = waveamd.mma "mfma.f32.16x16x32.f16" %973, %850, %999 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1001 = waveamd.fragment_unpack %1000 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1002 = waveamd.mma "mfma.f32.16x16x32.f16" %966, %851, %978 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1003 = waveamd.mma "mfma.f32.16x16x32.f16" %967, %852, %1002 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1004 = waveamd.fragment_unpack %1003 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1005 = waveamd.mma "mfma.f32.16x16x32.f16" %968, %851, %979 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1006 = waveamd.mma "mfma.f32.16x16x32.f16" %969, %852, %1005 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1007 = waveamd.fragment_unpack %1006 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1008 = waveamd.mma "mfma.f32.16x16x32.f16" %970, %851, %980 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1009 = waveamd.mma "mfma.f32.16x16x32.f16" %971, %852, %1008 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1010 = waveamd.fragment_unpack %1009 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1011 = waveamd.mma "mfma.f32.16x16x32.f16" %972, %851, %981 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1012 = waveamd.mma "mfma.f32.16x16x32.f16" %973, %852, %1011 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1013 = waveamd.fragment_unpack %1012 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1014 = waveamd.mma "mfma.f32.16x16x32.f16" %966, %853, %982 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1015 = waveamd.mma "mfma.f32.16x16x32.f16" %967, %854, %1014 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1016 = waveamd.fragment_unpack %1015 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1017 = waveamd.mma "mfma.f32.16x16x32.f16" %968, %853, %983 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1018 = waveamd.mma "mfma.f32.16x16x32.f16" %969, %854, %1017 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1019 = waveamd.fragment_unpack %1018 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1020 = waveamd.mma "mfma.f32.16x16x32.f16" %970, %853, %984 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1021 = waveamd.mma "mfma.f32.16x16x32.f16" %971, %854, %1020 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1022 = waveamd.fragment_unpack %1021 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1023 = waveamd.mma "mfma.f32.16x16x32.f16" %972, %853, %985 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1024 = waveamd.mma "mfma.f32.16x16x32.f16" %973, %854, %1023 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1025 = waveamd.fragment_unpack %1024 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1026 = waveamd.mma "mfma.f32.16x16x32.f16" %966, %855, %986 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1027 = waveamd.mma "mfma.f32.16x16x32.f16" %967, %856, %1026 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1028 = waveamd.fragment_unpack %1027 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1029 = waveamd.mma "mfma.f32.16x16x32.f16" %968, %855, %987 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1030 = waveamd.mma "mfma.f32.16x16x32.f16" %969, %856, %1029 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1031 = waveamd.fragment_unpack %1030 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1032 = waveamd.mma "mfma.f32.16x16x32.f16" %970, %855, %988 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1033 = waveamd.mma "mfma.f32.16x16x32.f16" %971, %856, %1032 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1034 = waveamd.fragment_unpack %1033 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1035 = waveamd.mma "mfma.f32.16x16x32.f16" %972, %855, %989 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1036 = waveamd.mma "mfma.f32.16x16x32.f16" %973, %856, %1035 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1037 = waveamd.fragment_unpack %1036 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1038 = wave.barrier %arg60 : (!wave.mem.token) -> !wave.mem.token
        %1039 = wave.ptr_add %147, %201 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_110, %token_111 = wave.load %1039 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1040 = wave.ptr_add %147, %203 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_112, %token_113 = wave.load %1040 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1041 = wave.ptr_add %147, %205 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_114, %token_115 = wave.load %1041 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1042 = wave.ptr_add %147, %207 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_116, %token_117 = wave.load %1042 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1043 = wave.ptr_add %147, %209 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_118, %token_119 = wave.load %1043 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1044 = wave.ptr_add %147, %211 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_120, %token_121 = wave.load %1044 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1045 = wave.ptr_add %147, %213 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_122, %token_123 = wave.load %1045 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1046 = wave.ptr_add %147, %215 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_124, %token_125 = wave.load %1046 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1047 = wave.join %token_111, %token_113, %token_115, %token_117, %token_119, %token_121, %token_123, %token_125 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1048 = wave.ptr_add %173, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_126, %token_127 = wave.load %1048 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1049 = wave.ptr_add %173, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_128, %token_129 = wave.load %1049 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1050 = wave.ptr_add %173, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_130, %token_131 = wave.load %1050 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1051 = wave.ptr_add %173, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_132, %token_133 = wave.load %1051 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1052 = wave.ptr_add %173, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_134, %token_135 = wave.load %1052 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1053 = wave.ptr_add %173, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_136, %token_137 = wave.load %1053 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1054 = wave.ptr_add %173, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_138, %token_139 = wave.load %1054 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1055 = wave.ptr_add %173, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_140, %token_141 = wave.load %1055 after %1038 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1056 = wave.join %token_127, %token_129, %token_131, %token_133, %token_135, %token_137, %token_139, %token_141 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1057 = wave.index_expr <"s1 + s2 + s0*s3 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*s3 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%45, %88, %arg10, %89, %76) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %1058 = wave.assume %1057 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1059 = wave.ptr_add %121, %1058 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1060 = waveamd.dma_load_lds %1059 -> %139 after %1038 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1061 = wave.index_expr <"s1 + s2 + s0*s3 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*s3 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%45, %88, %arg10, %89, %76) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %1062 = wave.assume %1061 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1063 = wave.ptr_add %121, %1062 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1064 = waveamd.dma_load_lds %1063 -> %144 after %1038 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1065 = wave.join %1060, %1064 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1066 = wave.binary addi %arg9, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1067 = wave.binary addi %arg10, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1068 = waveamd.fragment_pack %value_110 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1069 = waveamd.fragment_pack %value_112 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1070 = waveamd.fragment_pack %value_114 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1071 = waveamd.fragment_pack %value_116 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1072 = waveamd.fragment_pack %value_118 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1073 = waveamd.fragment_pack %value_120 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1074 = waveamd.fragment_pack %value_122 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1075 = waveamd.fragment_pack %value_124 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1076 = waveamd.fragment_pack %value_126 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1077 = waveamd.fragment_pack %value_128 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1078 = waveamd.fragment_pack %value_130 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1079 = waveamd.fragment_pack %value_132 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1080 = waveamd.fragment_pack %value_134 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1081 = waveamd.fragment_pack %value_136 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1082 = waveamd.fragment_pack %value_138 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1083 = waveamd.fragment_pack %value_140 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1084 = waveamd.fragment_pack %883 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1085 = waveamd.fragment_pack %886 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1086 = waveamd.fragment_pack %889 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1087 = waveamd.fragment_pack %892 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1088 = waveamd.fragment_pack %895 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1089 = waveamd.fragment_pack %898 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1090 = waveamd.fragment_pack %901 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1091 = waveamd.fragment_pack %904 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1092 = waveamd.fragment_pack %907 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1093 = waveamd.fragment_pack %910 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1094 = waveamd.fragment_pack %913 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1095 = waveamd.fragment_pack %916 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1096 = waveamd.fragment_pack %919 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1097 = waveamd.fragment_pack %922 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1098 = waveamd.fragment_pack %925 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1099 = waveamd.fragment_pack %928 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1100 = waveamd.mma "mfma.f32.16x16x32.f16" %1076, %1068, %1084 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1101 = waveamd.mma "mfma.f32.16x16x32.f16" %1077, %1069, %1100 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1102 = waveamd.fragment_unpack %1101 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1103 = waveamd.mma "mfma.f32.16x16x32.f16" %1078, %1068, %1085 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1104 = waveamd.mma "mfma.f32.16x16x32.f16" %1079, %1069, %1103 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1105 = waveamd.fragment_unpack %1104 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1106 = waveamd.mma "mfma.f32.16x16x32.f16" %1080, %1068, %1086 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1107 = waveamd.mma "mfma.f32.16x16x32.f16" %1081, %1069, %1106 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1108 = waveamd.fragment_unpack %1107 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1109 = waveamd.mma "mfma.f32.16x16x32.f16" %1082, %1068, %1087 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1110 = waveamd.mma "mfma.f32.16x16x32.f16" %1083, %1069, %1109 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1111 = waveamd.fragment_unpack %1110 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1112 = waveamd.mma "mfma.f32.16x16x32.f16" %1076, %1070, %1088 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1113 = waveamd.mma "mfma.f32.16x16x32.f16" %1077, %1071, %1112 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1114 = waveamd.fragment_unpack %1113 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1115 = waveamd.mma "mfma.f32.16x16x32.f16" %1078, %1070, %1089 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1116 = waveamd.mma "mfma.f32.16x16x32.f16" %1079, %1071, %1115 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1117 = waveamd.fragment_unpack %1116 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1118 = waveamd.mma "mfma.f32.16x16x32.f16" %1080, %1070, %1090 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1119 = waveamd.mma "mfma.f32.16x16x32.f16" %1081, %1071, %1118 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1120 = waveamd.fragment_unpack %1119 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1121 = waveamd.mma "mfma.f32.16x16x32.f16" %1082, %1070, %1091 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1122 = waveamd.mma "mfma.f32.16x16x32.f16" %1083, %1071, %1121 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1123 = waveamd.fragment_unpack %1122 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1124 = waveamd.mma "mfma.f32.16x16x32.f16" %1076, %1072, %1092 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1125 = waveamd.mma "mfma.f32.16x16x32.f16" %1077, %1073, %1124 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1126 = waveamd.fragment_unpack %1125 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1127 = waveamd.mma "mfma.f32.16x16x32.f16" %1078, %1072, %1093 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1128 = waveamd.mma "mfma.f32.16x16x32.f16" %1079, %1073, %1127 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1129 = waveamd.fragment_unpack %1128 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1130 = waveamd.mma "mfma.f32.16x16x32.f16" %1080, %1072, %1094 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1131 = waveamd.mma "mfma.f32.16x16x32.f16" %1081, %1073, %1130 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1132 = waveamd.fragment_unpack %1131 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1133 = waveamd.mma "mfma.f32.16x16x32.f16" %1082, %1072, %1095 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1134 = waveamd.mma "mfma.f32.16x16x32.f16" %1083, %1073, %1133 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1135 = waveamd.fragment_unpack %1134 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1136 = waveamd.mma "mfma.f32.16x16x32.f16" %1076, %1074, %1096 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1137 = waveamd.mma "mfma.f32.16x16x32.f16" %1077, %1075, %1136 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1138 = waveamd.fragment_unpack %1137 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1139 = waveamd.mma "mfma.f32.16x16x32.f16" %1078, %1074, %1097 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1140 = waveamd.mma "mfma.f32.16x16x32.f16" %1079, %1075, %1139 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1141 = waveamd.fragment_unpack %1140 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1142 = waveamd.mma "mfma.f32.16x16x32.f16" %1080, %1074, %1098 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1143 = waveamd.mma "mfma.f32.16x16x32.f16" %1081, %1075, %1142 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1144 = waveamd.fragment_unpack %1143 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1145 = waveamd.mma "mfma.f32.16x16x32.f16" %1082, %1074, %1099 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1146 = waveamd.mma "mfma.f32.16x16x32.f16" %1083, %1075, %1145 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1147 = waveamd.fragment_unpack %1146 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1148 = wave.barrier %arg61 : (!wave.mem.token) -> !wave.mem.token
        %1149 = wave.ptr_add %188, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_142, %token_143 = wave.load %1149 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1150 = wave.ptr_add %188, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_144, %token_145 = wave.load %1150 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1151 = wave.ptr_add %188, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_146, %token_147 = wave.load %1151 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1152 = wave.ptr_add %188, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_148, %token_149 = wave.load %1152 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1153 = wave.ptr_add %188, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_150, %token_151 = wave.load %1153 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1154 = wave.ptr_add %188, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_152, %token_153 = wave.load %1154 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1155 = wave.ptr_add %188, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_154, %token_155 = wave.load %1155 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1156 = wave.ptr_add %188, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_156, %token_157 = wave.load %1156 after %1148 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1157 = wave.join %token_143, %token_145, %token_147, %token_149, %token_151, %token_153, %token_155, %token_157 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1158 = wave.index_expr <"s1 + s0*s2 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 128*s0*Mod(floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %1066, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %1159 = wave.assume %1158 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1160 = wave.ptr_add %90, %1159 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1161 = waveamd.dma_load_lds %1160 -> %152 after %1148 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1162 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 128*s0*Mod(floor(1/2 + 1/1024*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %1066, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %1163 = wave.assume %1162 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1164 = wave.ptr_add %90, %1163 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1165 = waveamd.dma_load_lds %1164 -> %158 after %1148 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1166 = wave.index_expr <"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 128*s0*Mod(1 + floor(1/1024*wi), 2) + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %1066, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %1167 = wave.assume %1166 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1168 = wave.ptr_add %90, %1167 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1169 = waveamd.dma_load_lds %1168 -> %164 after %1148 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1170 = wave.index_expr <"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 128*s0*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %39, %1066, %44) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %1171 = wave.assume %1170 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1172 = wave.ptr_add %90, %1171 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1173 = waveamd.dma_load_lds %1172 -> %170 after %1148 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1174 = wave.join %1161, %1165, %1169, %1173 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1175 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %1067, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %1176 = wave.assume %1175 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1177 = wave.ptr_add %121, %1176 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1178 = waveamd.dma_load_lds %1177 -> %178 after %1148 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1179 = wave.index_expr <"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s0*s2 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2"](%45, %88, %1067, %76) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %1180 = wave.assume %1179 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1181 = wave.ptr_add %121, %1180 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1182 = waveamd.dma_load_lds %1181 -> %184 after %1148 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1183 = wave.join %1178, %1182 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1184 = wave.join %1174, %1183 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1185 = waveamd.fragment_pack %value_142 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1186 = waveamd.fragment_pack %value_144 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1187 = waveamd.fragment_pack %value_146 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1188 = waveamd.fragment_pack %value_148 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1189 = waveamd.fragment_pack %value_150 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1190 = waveamd.fragment_pack %value_152 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1191 = waveamd.fragment_pack %value_154 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1192 = waveamd.fragment_pack %value_156 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1193 = waveamd.fragment_pack %992 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1194 = waveamd.fragment_pack %995 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1195 = waveamd.fragment_pack %998 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1196 = waveamd.fragment_pack %1001 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1197 = waveamd.fragment_pack %1004 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1198 = waveamd.fragment_pack %1007 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1199 = waveamd.fragment_pack %1010 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1200 = waveamd.fragment_pack %1013 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1201 = waveamd.fragment_pack %1016 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1202 = waveamd.fragment_pack %1019 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1203 = waveamd.fragment_pack %1022 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1204 = waveamd.fragment_pack %1025 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1205 = waveamd.fragment_pack %1028 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1206 = waveamd.fragment_pack %1031 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1207 = waveamd.fragment_pack %1034 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1208 = waveamd.fragment_pack %1037 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1209 = waveamd.mma "mfma.f32.16x16x32.f16" %1185, %1068, %1193 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1210 = waveamd.mma "mfma.f32.16x16x32.f16" %1186, %1069, %1209 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1211 = waveamd.fragment_unpack %1210 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1212 = waveamd.mma "mfma.f32.16x16x32.f16" %1187, %1068, %1194 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1213 = waveamd.mma "mfma.f32.16x16x32.f16" %1188, %1069, %1212 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1214 = waveamd.fragment_unpack %1213 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1215 = waveamd.mma "mfma.f32.16x16x32.f16" %1189, %1068, %1195 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1216 = waveamd.mma "mfma.f32.16x16x32.f16" %1190, %1069, %1215 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1217 = waveamd.fragment_unpack %1216 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1218 = waveamd.mma "mfma.f32.16x16x32.f16" %1191, %1068, %1196 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1219 = waveamd.mma "mfma.f32.16x16x32.f16" %1192, %1069, %1218 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1220 = waveamd.fragment_unpack %1219 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1221 = waveamd.mma "mfma.f32.16x16x32.f16" %1185, %1070, %1197 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1222 = waveamd.mma "mfma.f32.16x16x32.f16" %1186, %1071, %1221 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1223 = waveamd.fragment_unpack %1222 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1224 = waveamd.mma "mfma.f32.16x16x32.f16" %1187, %1070, %1198 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1225 = waveamd.mma "mfma.f32.16x16x32.f16" %1188, %1071, %1224 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1226 = waveamd.fragment_unpack %1225 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1227 = waveamd.mma "mfma.f32.16x16x32.f16" %1189, %1070, %1199 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1228 = waveamd.mma "mfma.f32.16x16x32.f16" %1190, %1071, %1227 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1229 = waveamd.fragment_unpack %1228 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1230 = waveamd.mma "mfma.f32.16x16x32.f16" %1191, %1070, %1200 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1231 = waveamd.mma "mfma.f32.16x16x32.f16" %1192, %1071, %1230 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1232 = waveamd.fragment_unpack %1231 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1233 = waveamd.mma "mfma.f32.16x16x32.f16" %1185, %1072, %1201 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1234 = waveamd.mma "mfma.f32.16x16x32.f16" %1186, %1073, %1233 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1235 = waveamd.fragment_unpack %1234 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1236 = waveamd.mma "mfma.f32.16x16x32.f16" %1187, %1072, %1202 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1237 = waveamd.mma "mfma.f32.16x16x32.f16" %1188, %1073, %1236 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1238 = waveamd.fragment_unpack %1237 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1239 = waveamd.mma "mfma.f32.16x16x32.f16" %1189, %1072, %1203 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1240 = waveamd.mma "mfma.f32.16x16x32.f16" %1190, %1073, %1239 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1241 = waveamd.fragment_unpack %1240 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1242 = waveamd.mma "mfma.f32.16x16x32.f16" %1191, %1072, %1204 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1243 = waveamd.mma "mfma.f32.16x16x32.f16" %1192, %1073, %1242 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1244 = waveamd.fragment_unpack %1243 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1245 = waveamd.mma "mfma.f32.16x16x32.f16" %1185, %1074, %1205 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1246 = waveamd.mma "mfma.f32.16x16x32.f16" %1186, %1075, %1245 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1247 = waveamd.fragment_unpack %1246 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1248 = waveamd.mma "mfma.f32.16x16x32.f16" %1187, %1074, %1206 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1249 = waveamd.mma "mfma.f32.16x16x32.f16" %1188, %1075, %1248 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1250 = waveamd.fragment_unpack %1249 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1251 = waveamd.mma "mfma.f32.16x16x32.f16" %1189, %1074, %1207 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1252 = waveamd.mma "mfma.f32.16x16x32.f16" %1190, %1075, %1251 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1253 = waveamd.fragment_unpack %1252 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1254 = waveamd.mma "mfma.f32.16x16x32.f16" %1191, %1074, %1208 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1255 = waveamd.mma "mfma.f32.16x16x32.f16" %1192, %1075, %1254 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1256 = waveamd.fragment_unpack %1255 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1257 = wave.barrier %965 : (!wave.mem.token) -> !wave.mem.token
        %value_158, %token_159 = wave.load %202 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_160, %token_161 = wave.load %204 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_162, %token_163 = wave.load %206 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_164, %token_165 = wave.load %208 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_166, %token_167 = wave.load %210 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_168, %token_169 = wave.load %212 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_170, %token_171 = wave.load %214 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_172, %token_173 = wave.load %216 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1258 = wave.join %token_159, %token_161, %token_163, %token_165, %token_167, %token_169, %token_171, %token_173 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_174, %token_175 = wave.load %219 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_176, %token_177 = wave.load %221 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_178, %token_179 = wave.load %223 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_180, %token_181 = wave.load %225 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_182, %token_183 = wave.load %227 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_184, %token_185 = wave.load %229 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_186, %token_187 = wave.load %231 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %value_188, %token_189 = wave.load %233 after %1257 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1259 = wave.join %token_175, %token_177, %token_179, %token_181, %token_183, %token_185, %token_187, %token_189 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1260 = wave.index_expr <"s1 + s2 + s0*s3 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*s3 + 64*s0*Mod(floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%45, %88, %89, %1067, %76) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %1261 = wave.assume %1260 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1262 = wave.ptr_add %121, %1261 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1263 = waveamd.dma_load_lds %1262 -> %192 after %1257 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1264 = wave.index_expr <"s1 + s2 + s0*s3 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*s3 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*s3 + 64*s0*Mod(1 + floor(1/512*wi), 2) + 32*s0*Mod(floor(1/256*wi), 2) + 16*s0*Mod(floor(1/128*wi), 2) + 8*s0*Mod(floor(1/64*wi), 2) + 4*s0*Mod(floor(1/32*wi), 2) + 2*s0*Mod(floor(1/16*wi), 2) + s0*Mod(floor(1/8*wi), 2) + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1", "s2", "s3"](%45, %88, %89, %1067, %76) : (!wave.simd<i32, 64>, i32, i32, i32, i32) -> !wave.simd<index, 64>
        %1265 = wave.assume %1264 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1266 = wave.ptr_add %121, %1265 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1267 = waveamd.dma_load_lds %1266 -> %197 after %1257 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1268 = wave.join %1263, %1267 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1269 = wave.binary addi %arg9, %c128_i32 overflow<nsw> : i32, i32 -> i32
        %1270 = wave.binary addi %arg10, %c128_i32 overflow<nsw> : i32, i32 -> i32
        %1271 = wave.join %arg62, %955, %1047, %1174, %1258 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1272 = wave.join %arg63, %964, %1056, %1183, %1259 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1273 = wave.join %arg64, %938, %1065, %1157, %1268 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        scf.yield %1269, %1270, %1102, %1105, %1108, %1111, %1114, %1117, %1120, %1123, %1126, %1129, %1132, %1135, %1138, %1141, %1144, %1147, %1211, %1214, %1217, %1220, %1223, %1226, %1229, %1232, %1235, %1238, %1241, %1244, %1247, %1250, %1253, %1256, %value_158, %value_160, %value_162, %value_164, %value_166, %value_168, %value_170, %value_172, %value_174, %value_176, %value_178, %value_180, %value_182, %value_184, %value_186, %value_188, %1065, %1184, %1268, %1271, %1272, %1273 : i32, i32, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %239 = waveamd.fragment_pack %238#34 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %240 = waveamd.fragment_pack %238#35 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %241 = waveamd.fragment_pack %238#36 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %242 = waveamd.fragment_pack %238#37 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %243 = waveamd.fragment_pack %238#38 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %244 = waveamd.fragment_pack %238#39 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %245 = waveamd.fragment_pack %238#40 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %246 = waveamd.fragment_pack %238#41 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %247 = waveamd.fragment_pack %238#42 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %248 = waveamd.fragment_pack %238#43 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %249 = waveamd.fragment_pack %238#44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %250 = waveamd.fragment_pack %238#45 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %251 = waveamd.fragment_pack %238#46 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %252 = waveamd.fragment_pack %238#47 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %253 = waveamd.fragment_pack %238#48 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %254 = waveamd.fragment_pack %238#49 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %255 = waveamd.fragment_pack %238#2 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %256 = waveamd.fragment_pack %238#3 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %257 = waveamd.fragment_pack %238#4 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %258 = waveamd.fragment_pack %238#5 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %259 = waveamd.fragment_pack %238#6 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %260 = waveamd.fragment_pack %238#7 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %261 = waveamd.fragment_pack %238#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %262 = waveamd.fragment_pack %238#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %263 = waveamd.fragment_pack %238#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %264 = waveamd.fragment_pack %238#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %265 = waveamd.fragment_pack %238#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %266 = waveamd.fragment_pack %238#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %267 = waveamd.fragment_pack %238#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %268 = waveamd.fragment_pack %238#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %269 = waveamd.fragment_pack %238#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %270 = waveamd.fragment_pack %238#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %271 = waveamd.mma "mfma.f32.16x16x32.f16" %247, %239, %255 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %272 = waveamd.mma "mfma.f32.16x16x32.f16" %248, %240, %271 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %273 = waveamd.fragment_unpack %272 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %274 = waveamd.mma "mfma.f32.16x16x32.f16" %249, %239, %256 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %275 = waveamd.mma "mfma.f32.16x16x32.f16" %250, %240, %274 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %276 = waveamd.fragment_unpack %275 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %277 = waveamd.mma "mfma.f32.16x16x32.f16" %251, %239, %257 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %278 = waveamd.mma "mfma.f32.16x16x32.f16" %252, %240, %277 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %279 = waveamd.fragment_unpack %278 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %280 = waveamd.mma "mfma.f32.16x16x32.f16" %253, %239, %258 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %281 = waveamd.mma "mfma.f32.16x16x32.f16" %254, %240, %280 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %282 = waveamd.fragment_unpack %281 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %283 = waveamd.mma "mfma.f32.16x16x32.f16" %247, %241, %259 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %284 = waveamd.mma "mfma.f32.16x16x32.f16" %248, %242, %283 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %285 = waveamd.fragment_unpack %284 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %286 = waveamd.mma "mfma.f32.16x16x32.f16" %249, %241, %260 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %287 = waveamd.mma "mfma.f32.16x16x32.f16" %250, %242, %286 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %288 = waveamd.fragment_unpack %287 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %289 = waveamd.mma "mfma.f32.16x16x32.f16" %251, %241, %261 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %290 = waveamd.mma "mfma.f32.16x16x32.f16" %252, %242, %289 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %291 = waveamd.fragment_unpack %290 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %292 = waveamd.mma "mfma.f32.16x16x32.f16" %253, %241, %262 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %293 = waveamd.mma "mfma.f32.16x16x32.f16" %254, %242, %292 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %294 = waveamd.fragment_unpack %293 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %295 = waveamd.mma "mfma.f32.16x16x32.f16" %247, %243, %263 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %296 = waveamd.mma "mfma.f32.16x16x32.f16" %248, %244, %295 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %297 = waveamd.fragment_unpack %296 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %298 = waveamd.mma "mfma.f32.16x16x32.f16" %249, %243, %264 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %299 = waveamd.mma "mfma.f32.16x16x32.f16" %250, %244, %298 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %300 = waveamd.fragment_unpack %299 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %301 = waveamd.mma "mfma.f32.16x16x32.f16" %251, %243, %265 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %302 = waveamd.mma "mfma.f32.16x16x32.f16" %252, %244, %301 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %303 = waveamd.fragment_unpack %302 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %304 = waveamd.mma "mfma.f32.16x16x32.f16" %253, %243, %266 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %305 = waveamd.mma "mfma.f32.16x16x32.f16" %254, %244, %304 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %306 = waveamd.fragment_unpack %305 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %307 = waveamd.mma "mfma.f32.16x16x32.f16" %247, %245, %267 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %308 = waveamd.mma "mfma.f32.16x16x32.f16" %248, %246, %307 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %309 = waveamd.fragment_unpack %308 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %310 = waveamd.mma "mfma.f32.16x16x32.f16" %249, %245, %268 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %311 = waveamd.mma "mfma.f32.16x16x32.f16" %250, %246, %310 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %312 = waveamd.fragment_unpack %311 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %313 = waveamd.mma "mfma.f32.16x16x32.f16" %251, %245, %269 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %314 = waveamd.mma "mfma.f32.16x16x32.f16" %252, %246, %313 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %315 = waveamd.fragment_unpack %314 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %316 = waveamd.mma "mfma.f32.16x16x32.f16" %253, %245, %270 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %317 = waveamd.mma "mfma.f32.16x16x32.f16" %254, %246, %316 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %318 = waveamd.fragment_unpack %317 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %319 = wave.barrier %238#50, %238#51, %238#52 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %320 = wave.ptr_add %42, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_30, %token_31 = wave.load %320 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %321 = wave.ptr_add %42, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_32, %token_33 = wave.load %321 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %322 = wave.ptr_add %42, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_34, %token_35 = wave.load %322 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %323 = wave.ptr_add %42, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_36, %token_37 = wave.load %323 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %324 = wave.ptr_add %42, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_38, %token_39 = wave.load %324 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %325 = wave.ptr_add %42, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_40, %token_41 = wave.load %325 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %326 = wave.ptr_add %42, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_42, %token_43 = wave.load %326 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %327 = wave.ptr_add %42, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_44, %token_45 = wave.load %327 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %328 = waveamd.fragment_pack %value_30 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %329 = waveamd.fragment_pack %value_32 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %330 = waveamd.fragment_pack %value_34 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %331 = waveamd.fragment_pack %value_36 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %332 = waveamd.fragment_pack %value_38 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %333 = waveamd.fragment_pack %value_40 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %334 = waveamd.fragment_pack %value_42 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %335 = waveamd.fragment_pack %value_44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %336 = waveamd.fragment_pack %238#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %337 = waveamd.fragment_pack %238#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %338 = waveamd.fragment_pack %238#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %339 = waveamd.fragment_pack %238#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %340 = waveamd.fragment_pack %238#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %341 = waveamd.fragment_pack %238#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %342 = waveamd.fragment_pack %238#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %343 = waveamd.fragment_pack %238#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %344 = waveamd.fragment_pack %238#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %345 = waveamd.fragment_pack %238#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %346 = waveamd.fragment_pack %238#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %347 = waveamd.fragment_pack %238#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %348 = waveamd.fragment_pack %238#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %349 = waveamd.fragment_pack %238#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %350 = waveamd.fragment_pack %238#32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %351 = waveamd.fragment_pack %238#33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %352 = waveamd.mma "mfma.f32.16x16x32.f16" %328, %239, %336 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %353 = waveamd.mma "mfma.f32.16x16x32.f16" %329, %240, %352 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %354 = waveamd.fragment_unpack %353 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %355 = waveamd.mma "mfma.f32.16x16x32.f16" %330, %239, %337 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %356 = waveamd.mma "mfma.f32.16x16x32.f16" %331, %240, %355 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %357 = waveamd.fragment_unpack %356 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %358 = waveamd.mma "mfma.f32.16x16x32.f16" %332, %239, %338 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %359 = waveamd.mma "mfma.f32.16x16x32.f16" %333, %240, %358 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %360 = waveamd.fragment_unpack %359 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %361 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %239, %339 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %362 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %240, %361 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %363 = waveamd.fragment_unpack %362 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %364 = waveamd.mma "mfma.f32.16x16x32.f16" %328, %241, %340 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %365 = waveamd.mma "mfma.f32.16x16x32.f16" %329, %242, %364 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %366 = waveamd.fragment_unpack %365 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %367 = waveamd.mma "mfma.f32.16x16x32.f16" %330, %241, %341 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %368 = waveamd.mma "mfma.f32.16x16x32.f16" %331, %242, %367 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %369 = waveamd.fragment_unpack %368 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %370 = waveamd.mma "mfma.f32.16x16x32.f16" %332, %241, %342 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %371 = waveamd.mma "mfma.f32.16x16x32.f16" %333, %242, %370 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %372 = waveamd.fragment_unpack %371 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %373 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %241, %343 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %374 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %242, %373 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %375 = waveamd.fragment_unpack %374 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %376 = waveamd.mma "mfma.f32.16x16x32.f16" %328, %243, %344 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %377 = waveamd.mma "mfma.f32.16x16x32.f16" %329, %244, %376 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %378 = waveamd.fragment_unpack %377 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %379 = waveamd.mma "mfma.f32.16x16x32.f16" %330, %243, %345 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %380 = waveamd.mma "mfma.f32.16x16x32.f16" %331, %244, %379 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %381 = waveamd.fragment_unpack %380 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %382 = waveamd.mma "mfma.f32.16x16x32.f16" %332, %243, %346 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %383 = waveamd.mma "mfma.f32.16x16x32.f16" %333, %244, %382 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %384 = waveamd.fragment_unpack %383 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %385 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %243, %347 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %386 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %244, %385 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %387 = waveamd.fragment_unpack %386 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %388 = waveamd.mma "mfma.f32.16x16x32.f16" %328, %245, %348 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %389 = waveamd.mma "mfma.f32.16x16x32.f16" %329, %246, %388 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %390 = waveamd.fragment_unpack %389 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %391 = waveamd.mma "mfma.f32.16x16x32.f16" %330, %245, %349 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %392 = waveamd.mma "mfma.f32.16x16x32.f16" %331, %246, %391 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %393 = waveamd.fragment_unpack %392 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %394 = waveamd.mma "mfma.f32.16x16x32.f16" %332, %245, %350 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %395 = waveamd.mma "mfma.f32.16x16x32.f16" %333, %246, %394 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %396 = waveamd.fragment_unpack %395 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %397 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %245, %351 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %398 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %246, %397 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %399 = waveamd.fragment_unpack %398 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %400 = wave.ptr_add %147, %201 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_46, %token_47 = wave.load %400 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %401 = wave.ptr_add %147, %203 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_48, %token_49 = wave.load %401 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %402 = wave.ptr_add %147, %205 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_50, %token_51 = wave.load %402 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %403 = wave.ptr_add %147, %207 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_52, %token_53 = wave.load %403 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %404 = wave.ptr_add %147, %209 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_54, %token_55 = wave.load %404 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %405 = wave.ptr_add %147, %211 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_56, %token_57 = wave.load %405 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %406 = wave.ptr_add %147, %213 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_58, %token_59 = wave.load %406 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %407 = wave.ptr_add %147, %215 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_60, %token_61 = wave.load %407 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %408 = wave.ptr_add %173, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_62, %token_63 = wave.load %408 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %409 = wave.ptr_add %173, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_64, %token_65 = wave.load %409 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %410 = wave.ptr_add %173, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_66, %token_67 = wave.load %410 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %411 = wave.ptr_add %173, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_68, %token_69 = wave.load %411 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %412 = wave.ptr_add %173, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_70, %token_71 = wave.load %412 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %413 = wave.ptr_add %173, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_72, %token_73 = wave.load %413 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %414 = wave.ptr_add %173, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_74, %token_75 = wave.load %414 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %415 = wave.ptr_add %173, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_76, %token_77 = wave.load %415 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %416 = waveamd.fragment_pack %value_46 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %417 = waveamd.fragment_pack %value_48 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %418 = waveamd.fragment_pack %value_50 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %419 = waveamd.fragment_pack %value_52 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %420 = waveamd.fragment_pack %value_54 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %421 = waveamd.fragment_pack %value_56 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %422 = waveamd.fragment_pack %value_58 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %423 = waveamd.fragment_pack %value_60 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %424 = waveamd.fragment_pack %value_62 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %425 = waveamd.fragment_pack %value_64 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %426 = waveamd.fragment_pack %value_66 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %427 = waveamd.fragment_pack %value_68 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %428 = waveamd.fragment_pack %value_70 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %429 = waveamd.fragment_pack %value_72 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %430 = waveamd.fragment_pack %value_74 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %431 = waveamd.fragment_pack %value_76 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %432 = waveamd.fragment_pack %273 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %433 = waveamd.fragment_pack %276 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %434 = waveamd.fragment_pack %279 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %435 = waveamd.fragment_pack %282 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %436 = waveamd.fragment_pack %285 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %437 = waveamd.fragment_pack %288 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %438 = waveamd.fragment_pack %291 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %439 = waveamd.fragment_pack %294 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %440 = waveamd.fragment_pack %297 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %441 = waveamd.fragment_pack %300 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %442 = waveamd.fragment_pack %303 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %443 = waveamd.fragment_pack %306 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %444 = waveamd.fragment_pack %309 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %445 = waveamd.fragment_pack %312 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %446 = waveamd.fragment_pack %315 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %447 = waveamd.fragment_pack %318 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %448 = waveamd.mma "mfma.f32.16x16x32.f16" %424, %416, %432 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %449 = waveamd.mma "mfma.f32.16x16x32.f16" %425, %417, %448 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %450 = waveamd.fragment_unpack %449 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %451 = waveamd.mma "mfma.f32.16x16x32.f16" %426, %416, %433 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %452 = waveamd.mma "mfma.f32.16x16x32.f16" %427, %417, %451 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %453 = waveamd.fragment_unpack %452 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %454 = waveamd.mma "mfma.f32.16x16x32.f16" %428, %416, %434 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %455 = waveamd.mma "mfma.f32.16x16x32.f16" %429, %417, %454 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %456 = waveamd.fragment_unpack %455 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %457 = waveamd.mma "mfma.f32.16x16x32.f16" %430, %416, %435 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %458 = waveamd.mma "mfma.f32.16x16x32.f16" %431, %417, %457 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %459 = waveamd.fragment_unpack %458 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %460 = waveamd.mma "mfma.f32.16x16x32.f16" %424, %418, %436 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %461 = waveamd.mma "mfma.f32.16x16x32.f16" %425, %419, %460 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %462 = waveamd.fragment_unpack %461 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %463 = waveamd.mma "mfma.f32.16x16x32.f16" %426, %418, %437 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %464 = waveamd.mma "mfma.f32.16x16x32.f16" %427, %419, %463 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %465 = waveamd.fragment_unpack %464 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %466 = waveamd.mma "mfma.f32.16x16x32.f16" %428, %418, %438 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %467 = waveamd.mma "mfma.f32.16x16x32.f16" %429, %419, %466 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %468 = waveamd.fragment_unpack %467 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %469 = waveamd.mma "mfma.f32.16x16x32.f16" %430, %418, %439 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %470 = waveamd.mma "mfma.f32.16x16x32.f16" %431, %419, %469 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %471 = waveamd.fragment_unpack %470 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %472 = waveamd.mma "mfma.f32.16x16x32.f16" %424, %420, %440 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %473 = waveamd.mma "mfma.f32.16x16x32.f16" %425, %421, %472 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %474 = waveamd.fragment_unpack %473 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %475 = waveamd.mma "mfma.f32.16x16x32.f16" %426, %420, %441 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %476 = waveamd.mma "mfma.f32.16x16x32.f16" %427, %421, %475 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %477 = waveamd.fragment_unpack %476 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %478 = waveamd.mma "mfma.f32.16x16x32.f16" %428, %420, %442 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %479 = waveamd.mma "mfma.f32.16x16x32.f16" %429, %421, %478 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %480 = waveamd.fragment_unpack %479 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %481 = waveamd.mma "mfma.f32.16x16x32.f16" %430, %420, %443 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %482 = waveamd.mma "mfma.f32.16x16x32.f16" %431, %421, %481 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %483 = waveamd.fragment_unpack %482 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %484 = waveamd.mma "mfma.f32.16x16x32.f16" %424, %422, %444 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %485 = waveamd.mma "mfma.f32.16x16x32.f16" %425, %423, %484 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %486 = waveamd.fragment_unpack %485 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %487 = waveamd.mma "mfma.f32.16x16x32.f16" %426, %422, %445 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %488 = waveamd.mma "mfma.f32.16x16x32.f16" %427, %423, %487 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %489 = waveamd.fragment_unpack %488 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %490 = waveamd.mma "mfma.f32.16x16x32.f16" %428, %422, %446 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %491 = waveamd.mma "mfma.f32.16x16x32.f16" %429, %423, %490 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %492 = waveamd.fragment_unpack %491 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %493 = waveamd.mma "mfma.f32.16x16x32.f16" %430, %422, %447 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %494 = waveamd.mma "mfma.f32.16x16x32.f16" %431, %423, %493 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %495 = waveamd.fragment_unpack %494 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %496 = wave.ptr_add %188, %218 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_78, %token_79 = wave.load %496 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %497 = wave.ptr_add %188, %220 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_80, %token_81 = wave.load %497 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %498 = wave.ptr_add %188, %222 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_82, %token_83 = wave.load %498 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %499 = wave.ptr_add %188, %224 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_84, %token_85 = wave.load %499 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %500 = wave.ptr_add %188, %226 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_86, %token_87 = wave.load %500 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %501 = wave.ptr_add %188, %228 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_88, %token_89 = wave.load %501 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %502 = wave.ptr_add %188, %230 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_90, %token_91 = wave.load %502 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %503 = wave.ptr_add %188, %232 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_92, %token_93 = wave.load %503 after %319 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %504 = wave.cast fpconvert %450 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %505 = wave.cast fpconvert %453 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %506 = wave.cast fpconvert %456 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %507 = wave.cast fpconvert %459 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %508 = wave.cast fpconvert %462 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %509 = wave.cast fpconvert %465 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %510 = wave.cast fpconvert %468 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %511 = wave.cast fpconvert %471 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %512 = wave.cast fpconvert %474 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %513 = wave.cast fpconvert %477 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %514 = wave.cast fpconvert %480 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %515 = wave.cast fpconvert %483 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %516 = wave.cast fpconvert %486 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %517 = wave.cast fpconvert %489 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %518 = wave.cast fpconvert %492 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %519 = wave.cast fpconvert %495 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %520 = wave.assume %arg7 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %521 = wave.binary muli %520, %44 overflow<nsw> : i32, i32 -> i32
      %522 = wave.splat %520 : i32 -> !wave.simd<i32, 64>
      %523 = wave.binary muli %522, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %524 = wave.binary muli %522, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %525 = wave.binary muli %522, %68 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %526 = wave.binary muli %522, %69 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %527 = wave.binary addi %521, %76 overflow<nsw> : i32, i32 -> i32
      %528 = wave.binary addi %523, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %529 = wave.binary addi %523, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %530 = wave.binary addi %523, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %531 = wave.binary addi %523, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %532 = wave.binary addi %524, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %533 = wave.binary addi %524, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %534 = wave.binary addi %524, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %535 = wave.binary addi %524, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %536 = wave.binary addi %525, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %537 = wave.binary addi %525, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %538 = wave.binary addi %525, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %539 = wave.binary addi %525, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %540 = wave.binary addi %526, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %541 = wave.binary addi %526, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %542 = wave.binary addi %526, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %543 = wave.binary addi %526, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %544 = wave.splat %527 : i32 -> !wave.simd<i32, 64>
      %545 = wave.binary addi %544, %528 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %546 = wave.binary addi %544, %529 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %547 = wave.binary addi %544, %530 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %548 = wave.binary addi %544, %531 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %549 = wave.binary addi %544, %532 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %550 = wave.binary addi %544, %533 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %551 = wave.binary addi %544, %534 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %552 = wave.binary addi %544, %535 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %553 = wave.binary addi %544, %536 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %554 = wave.binary addi %544, %537 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %555 = wave.binary addi %544, %538 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %556 = wave.binary addi %544, %539 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %557 = wave.binary addi %544, %540 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %558 = wave.binary addi %544, %541 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %559 = wave.binary addi %544, %542 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %560 = wave.binary addi %544, %543 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %561 = wave.splat %21 : i32 -> !wave.simd<i32, 64>
      %562 = wave.cmpi slt %71, %561 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %563 = wave.cmpi slt %72, %561 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %564 = wave.cmpi slt %73, %561 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %565 = wave.cmpi slt %74, %561 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %566 = wave.splat %22 : i32 -> !wave.simd<i32, 64>
      %567 = wave.cmpi slt %84, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %568 = wave.cmpi slt %85, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %569 = wave.cmpi slt %86, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %570 = wave.cmpi slt %87, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %571 = wave.select %562, %567, %11 : !wave.mask<64>, !wave.mask<64>
      %572 = wave.select %562, %568, %11 : !wave.mask<64>, !wave.mask<64>
      %573 = wave.select %562, %569, %11 : !wave.mask<64>, !wave.mask<64>
      %574 = wave.select %562, %570, %11 : !wave.mask<64>, !wave.mask<64>
      %575 = wave.select %563, %567, %11 : !wave.mask<64>, !wave.mask<64>
      %576 = wave.select %563, %568, %11 : !wave.mask<64>, !wave.mask<64>
      %577 = wave.select %563, %569, %11 : !wave.mask<64>, !wave.mask<64>
      %578 = wave.select %563, %570, %11 : !wave.mask<64>, !wave.mask<64>
      %579 = wave.select %564, %567, %11 : !wave.mask<64>, !wave.mask<64>
      %580 = wave.select %564, %568, %11 : !wave.mask<64>, !wave.mask<64>
      %581 = wave.select %564, %569, %11 : !wave.mask<64>, !wave.mask<64>
      %582 = wave.select %564, %570, %11 : !wave.mask<64>, !wave.mask<64>
      %583 = wave.select %565, %567, %11 : !wave.mask<64>, !wave.mask<64>
      %584 = wave.select %565, %568, %11 : !wave.mask<64>, !wave.mask<64>
      %585 = wave.select %565, %569, %11 : !wave.mask<64>, !wave.mask<64>
      %586 = wave.select %565, %570, %11 : !wave.mask<64>, !wave.mask<64>
      %587 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %588 = wave.assume %545 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %589 = wave.ptr_add %587, %588 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %590 = wave.ptr_add %587, %0 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %591 = wave.select %571, %589, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %592 = wave.store %504 -> %591 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %593 = wave.assume %546 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %594 = wave.ptr_add %587, %593 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %595 = wave.select %572, %594, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %596 = wave.store %505 -> %595 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %597 = wave.assume %547 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %598 = wave.ptr_add %587, %597 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %599 = wave.select %573, %598, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %600 = wave.store %506 -> %599 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %601 = wave.assume %548 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %602 = wave.ptr_add %587, %601 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %603 = wave.select %574, %602, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %604 = wave.store %507 -> %603 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %605 = wave.assume %549 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %606 = wave.ptr_add %587, %605 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %607 = wave.select %575, %606, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %608 = wave.store %508 -> %607 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %609 = wave.assume %550 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %610 = wave.ptr_add %587, %609 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %611 = wave.select %576, %610, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %612 = wave.store %509 -> %611 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %613 = wave.assume %551 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %614 = wave.ptr_add %587, %613 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %615 = wave.select %577, %614, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %616 = wave.store %510 -> %615 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %617 = wave.assume %552 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %618 = wave.ptr_add %587, %617 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %619 = wave.select %578, %618, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %620 = wave.store %511 -> %619 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %621 = wave.assume %553 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %622 = wave.ptr_add %587, %621 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %623 = wave.select %579, %622, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %624 = wave.store %512 -> %623 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %625 = wave.assume %554 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %626 = wave.ptr_add %587, %625 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %627 = wave.select %580, %626, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %628 = wave.store %513 -> %627 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %629 = wave.assume %555 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %630 = wave.ptr_add %587, %629 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %631 = wave.select %581, %630, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %632 = wave.store %514 -> %631 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %633 = wave.assume %556 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %634 = wave.ptr_add %587, %633 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %635 = wave.select %582, %634, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %636 = wave.store %515 -> %635 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %637 = wave.assume %557 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %638 = wave.ptr_add %587, %637 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %639 = wave.select %583, %638, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %640 = wave.store %516 -> %639 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %641 = wave.assume %558 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %642 = wave.ptr_add %587, %641 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %643 = wave.select %584, %642, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %644 = wave.store %517 -> %643 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %645 = wave.assume %559 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %646 = wave.ptr_add %587, %645 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %647 = wave.select %585, %646, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %648 = wave.store %518 -> %647 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %649 = wave.assume %560 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %650 = wave.ptr_add %587, %649 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %651 = wave.select %586, %650, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %652 = wave.store %519 -> %651 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %653 = waveamd.fragment_pack %value_78 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %654 = waveamd.fragment_pack %value_80 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %655 = waveamd.fragment_pack %value_82 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %656 = waveamd.fragment_pack %value_84 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %657 = waveamd.fragment_pack %value_86 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %658 = waveamd.fragment_pack %value_88 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %659 = waveamd.fragment_pack %value_90 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %660 = waveamd.fragment_pack %value_92 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %661 = waveamd.fragment_pack %354 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.fragment_pack %357 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.fragment_pack %360 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %664 = waveamd.fragment_pack %363 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.fragment_pack %366 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.fragment_pack %369 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %667 = waveamd.fragment_pack %372 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.fragment_pack %375 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.fragment_pack %378 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %670 = waveamd.fragment_pack %381 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.fragment_pack %384 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %672 = waveamd.fragment_pack %387 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %673 = waveamd.fragment_pack %390 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %674 = waveamd.fragment_pack %393 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %675 = waveamd.fragment_pack %396 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %676 = waveamd.fragment_pack %399 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %677 = waveamd.mma "mfma.f32.16x16x32.f16" %653, %416, %661 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %678 = waveamd.mma "mfma.f32.16x16x32.f16" %654, %417, %677 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %679 = waveamd.fragment_unpack %678 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %680 = waveamd.mma "mfma.f32.16x16x32.f16" %655, %416, %662 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %681 = waveamd.mma "mfma.f32.16x16x32.f16" %656, %417, %680 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %682 = waveamd.fragment_unpack %681 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %683 = waveamd.mma "mfma.f32.16x16x32.f16" %657, %416, %663 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %684 = waveamd.mma "mfma.f32.16x16x32.f16" %658, %417, %683 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %685 = waveamd.fragment_unpack %684 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %686 = waveamd.mma "mfma.f32.16x16x32.f16" %659, %416, %664 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %687 = waveamd.mma "mfma.f32.16x16x32.f16" %660, %417, %686 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %688 = waveamd.fragment_unpack %687 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %689 = waveamd.mma "mfma.f32.16x16x32.f16" %653, %418, %665 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %690 = waveamd.mma "mfma.f32.16x16x32.f16" %654, %419, %689 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %691 = waveamd.fragment_unpack %690 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %692 = waveamd.mma "mfma.f32.16x16x32.f16" %655, %418, %666 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %693 = waveamd.mma "mfma.f32.16x16x32.f16" %656, %419, %692 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %694 = waveamd.fragment_unpack %693 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %695 = waveamd.mma "mfma.f32.16x16x32.f16" %657, %418, %667 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %696 = waveamd.mma "mfma.f32.16x16x32.f16" %658, %419, %695 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %697 = waveamd.fragment_unpack %696 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %698 = waveamd.mma "mfma.f32.16x16x32.f16" %659, %418, %668 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %699 = waveamd.mma "mfma.f32.16x16x32.f16" %660, %419, %698 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %700 = waveamd.fragment_unpack %699 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %701 = waveamd.mma "mfma.f32.16x16x32.f16" %653, %420, %669 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %702 = waveamd.mma "mfma.f32.16x16x32.f16" %654, %421, %701 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %703 = waveamd.fragment_unpack %702 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %704 = waveamd.mma "mfma.f32.16x16x32.f16" %655, %420, %670 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %705 = waveamd.mma "mfma.f32.16x16x32.f16" %656, %421, %704 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %706 = waveamd.fragment_unpack %705 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %707 = waveamd.mma "mfma.f32.16x16x32.f16" %657, %420, %671 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %708 = waveamd.mma "mfma.f32.16x16x32.f16" %658, %421, %707 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %709 = waveamd.fragment_unpack %708 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %710 = waveamd.mma "mfma.f32.16x16x32.f16" %659, %420, %672 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %711 = waveamd.mma "mfma.f32.16x16x32.f16" %660, %421, %710 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %712 = waveamd.fragment_unpack %711 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %713 = waveamd.mma "mfma.f32.16x16x32.f16" %653, %422, %673 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %714 = waveamd.mma "mfma.f32.16x16x32.f16" %654, %423, %713 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %715 = waveamd.fragment_unpack %714 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %716 = waveamd.mma "mfma.f32.16x16x32.f16" %655, %422, %674 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %717 = waveamd.mma "mfma.f32.16x16x32.f16" %656, %423, %716 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %718 = waveamd.fragment_unpack %717 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %719 = waveamd.mma "mfma.f32.16x16x32.f16" %657, %422, %675 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %720 = waveamd.mma "mfma.f32.16x16x32.f16" %658, %423, %719 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %721 = waveamd.fragment_unpack %720 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %722 = waveamd.mma "mfma.f32.16x16x32.f16" %659, %422, %676 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %723 = waveamd.mma "mfma.f32.16x16x32.f16" %660, %423, %722 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %724 = waveamd.fragment_unpack %723 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %725 = wave.cast fpconvert %679 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %726 = wave.cast fpconvert %682 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %727 = wave.cast fpconvert %685 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %728 = wave.cast fpconvert %688 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %729 = wave.cast fpconvert %691 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %730 = wave.cast fpconvert %694 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %731 = wave.cast fpconvert %697 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %732 = wave.cast fpconvert %700 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %733 = wave.cast fpconvert %703 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %734 = wave.cast fpconvert %706 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %735 = wave.cast fpconvert %709 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %736 = wave.cast fpconvert %712 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %737 = wave.cast fpconvert %715 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %738 = wave.cast fpconvert %718 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %739 = wave.cast fpconvert %721 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %740 = wave.cast fpconvert %724 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %741 = wave.binary addi %76, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %742 = wave.splat %741 : i32 -> !wave.simd<i32, 64>
      %743 = wave.binary addi %742, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %744 = wave.binary addi %742, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %745 = wave.binary addi %742, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %746 = wave.binary addi %742, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %747 = wave.binary addi %521, %741 overflow<nsw> : i32, i32 -> i32
      %748 = wave.splat %747 : i32 -> !wave.simd<i32, 64>
      %749 = wave.binary addi %748, %528 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %750 = wave.binary addi %748, %529 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %751 = wave.binary addi %748, %530 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %752 = wave.binary addi %748, %531 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %753 = wave.binary addi %748, %532 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %754 = wave.binary addi %748, %533 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %755 = wave.binary addi %748, %534 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %756 = wave.binary addi %748, %535 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %757 = wave.binary addi %748, %536 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %758 = wave.binary addi %748, %537 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %759 = wave.binary addi %748, %538 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %760 = wave.binary addi %748, %539 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %761 = wave.binary addi %748, %540 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %762 = wave.binary addi %748, %541 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %763 = wave.binary addi %748, %542 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %764 = wave.binary addi %748, %543 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %765 = wave.cmpi slt %743, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %766 = wave.cmpi slt %744, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %767 = wave.cmpi slt %745, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %768 = wave.cmpi slt %746, %566 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %769 = wave.select %562, %765, %11 : !wave.mask<64>, !wave.mask<64>
      %770 = wave.select %562, %766, %11 : !wave.mask<64>, !wave.mask<64>
      %771 = wave.select %562, %767, %11 : !wave.mask<64>, !wave.mask<64>
      %772 = wave.select %562, %768, %11 : !wave.mask<64>, !wave.mask<64>
      %773 = wave.select %563, %765, %11 : !wave.mask<64>, !wave.mask<64>
      %774 = wave.select %563, %766, %11 : !wave.mask<64>, !wave.mask<64>
      %775 = wave.select %563, %767, %11 : !wave.mask<64>, !wave.mask<64>
      %776 = wave.select %563, %768, %11 : !wave.mask<64>, !wave.mask<64>
      %777 = wave.select %564, %765, %11 : !wave.mask<64>, !wave.mask<64>
      %778 = wave.select %564, %766, %11 : !wave.mask<64>, !wave.mask<64>
      %779 = wave.select %564, %767, %11 : !wave.mask<64>, !wave.mask<64>
      %780 = wave.select %564, %768, %11 : !wave.mask<64>, !wave.mask<64>
      %781 = wave.select %565, %765, %11 : !wave.mask<64>, !wave.mask<64>
      %782 = wave.select %565, %766, %11 : !wave.mask<64>, !wave.mask<64>
      %783 = wave.select %565, %767, %11 : !wave.mask<64>, !wave.mask<64>
      %784 = wave.select %565, %768, %11 : !wave.mask<64>, !wave.mask<64>
      %785 = wave.assume %749 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %786 = wave.ptr_add %587, %785 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %787 = wave.select %769, %786, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %788 = wave.store %725 -> %787 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %789 = wave.assume %750 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %790 = wave.ptr_add %587, %789 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %791 = wave.select %770, %790, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %792 = wave.store %726 -> %791 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %793 = wave.assume %751 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %794 = wave.ptr_add %587, %793 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %795 = wave.select %771, %794, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %796 = wave.store %727 -> %795 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %797 = wave.assume %752 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %798 = wave.ptr_add %587, %797 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %799 = wave.select %772, %798, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %800 = wave.store %728 -> %799 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %801 = wave.assume %753 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %802 = wave.ptr_add %587, %801 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %803 = wave.select %773, %802, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %804 = wave.store %729 -> %803 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %805 = wave.assume %754 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %806 = wave.ptr_add %587, %805 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %807 = wave.select %774, %806, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %808 = wave.store %730 -> %807 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %809 = wave.assume %755 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %810 = wave.ptr_add %587, %809 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %811 = wave.select %775, %810, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %812 = wave.store %731 -> %811 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %813 = wave.assume %756 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %814 = wave.ptr_add %587, %813 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %815 = wave.select %776, %814, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %816 = wave.store %732 -> %815 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %817 = wave.assume %757 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %818 = wave.ptr_add %587, %817 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %819 = wave.select %777, %818, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %820 = wave.store %733 -> %819 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %821 = wave.assume %758 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %822 = wave.ptr_add %587, %821 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %823 = wave.select %778, %822, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %824 = wave.store %734 -> %823 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %825 = wave.assume %759 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %826 = wave.ptr_add %587, %825 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %827 = wave.select %779, %826, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %828 = wave.store %735 -> %827 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %829 = wave.assume %760 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %830 = wave.ptr_add %587, %829 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %831 = wave.select %780, %830, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %832 = wave.store %736 -> %831 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %833 = wave.assume %761 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %834 = wave.ptr_add %587, %833 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %835 = wave.select %781, %834, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %836 = wave.store %737 -> %835 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %837 = wave.assume %762 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %838 = wave.ptr_add %587, %837 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %839 = wave.select %782, %838, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %840 = wave.store %738 -> %839 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %841 = wave.assume %763 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %842 = wave.ptr_add %587, %841 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %843 = wave.select %783, %842, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %844 = wave.store %739 -> %843 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %845 = wave.assume %764 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %846 = wave.ptr_add %587, %845 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %847 = wave.select %784, %846, %590 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %848 = wave.store %740 -> %847 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      return
    }
  }
}
