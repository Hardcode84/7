module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_optimized(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 36 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 192 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %c16896_i32 = arith.constant 16896 : i32
      %c8448_i32 = arith.constant 8448 : i32
      %c6336_i32 = arith.constant 6336 : i32
      %c4224_i32 = arith.constant 4224 : i32
      %c2112_i32 = arith.constant 2112 : i32
      %c264_i32 = arith.constant 264 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c64_i32 = arith.constant 64 : i32
      %c1_i32 = arith.constant 1 : i32
      %c256_i32 = arith.constant 256 : i32
      %c128_i32 = arith.constant 128 : i32
      %c8_i32 = arith.constant 8 : i32
      %c2_i32 = arith.constant 2 : i32
      %c3_i32 = arith.constant 3 : i32
      %c-1_i32 = arith.constant -1 : i32
      %c127_i32 = arith.constant 127 : i32
      %c255_i32 = arith.constant 255 : i32
      %c4_i32 = arith.constant 4 : i32
      %c32_i32 = arith.constant 32 : i32
      %c63_i32 = arith.constant 63 : i32
      %c0_i32 = arith.constant 0 : i32
      %14 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %15 = wave.pack %14, %14, %14, %14 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %16 = wave.assume %arg8 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %17 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %18 = wave.assume %arg10 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %19 = wave.assume %arg11 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %20 = wave.workgroup_id 0
      %21 = wave.binary addi %arg5, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %22 = wave.binary divsi %21, %c128_i32 : i32, i32 -> i32
      %23 = wave.binary addi %arg6, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %24 = wave.binary divsi %23, %c256_i32 : i32, i32 -> i32
      %25 = wave.binary muli %22, %24 : i32, i32 -> i32
      %26 = wave.binary divsi %25, %c32_i32 : i32, i32 -> i32
      %27 = wave.binary muli %26, %c32_i32 : i32, i32 -> i32
      %28 = arith.cmpi sge, %20, %27 : i32
      %29 = scf.if %28 -> (i32) {
        scf.yield %20 : i32
      } else {
        %1336 = wave.binary remui %20, %c8_i32 : i32, i32 -> i32
        %1337 = wave.binary divui %20, %c8_i32 : i32, i32 -> i32
        %1338 = wave.binary divui %1337, %c4_i32 : i32, i32 -> i32
        %1339 = wave.binary muli %1338, %c32_i32 overflow<nsw> : i32, i32 -> i32
        %1340 = wave.binary muli %1336, %c4_i32 overflow<nsw> : i32, i32 -> i32
        %1341 = wave.binary addi %1339, %1340 overflow<nsw> : i32, i32 -> i32
        %1342 = wave.binary remui %1337, %c4_i32 : i32, i32 -> i32
        %1343 = wave.binary addi %1341, %1342 overflow<nsw> : i32, i32 -> i32
        scf.yield %1343 : i32
      }
      %30 = wave.binary muli %24, %c8_i32 overflow<nsw> : i32, i32 -> i32
      %31 = wave.binary divsi %29, %30 : i32, i32 -> i32
      %32 = wave.binary muli %31, %c8_i32 overflow<nsw> : i32, i32 -> i32
      %33 = wave.binary subi %22, %32 overflow<nsw> : i32, i32 -> i32
      %34 = arith.cmpi slt, %33, %c8_i32 : i32
      %35 = wave.select %34, %33, %c8_i32 : i32
      %36 = wave.binary remsi %29, %30 : i32, i32 -> i32
      %37 = wave.binary remsi %36, %35 : i32, i32 -> i32
      %38 = wave.binary addi %32, %37 overflow<nsw> : i32, i32 -> i32
      %39 = wave.binary divsi %36, %35 : i32, i32 -> i32
      %40 = wave.binary muli %38, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %41 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %42 = wave.binary divui %41, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %43 = wave.binary remui %42, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %44 = wave.binary muli %43, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %45 = wave.binary divui %41, %11 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %46 = wave.binary remui %45, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %47 = wave.binary muli %46, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %48 = wave.binary addi %44, %47 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %49 = wave.binary divui %41, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %50 = wave.binary remui %49, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %51 = wave.binary muli %50, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %52 = wave.binary addi %48, %51 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %53 = wave.binary divui %41, %9 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %54 = wave.binary remui %53, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %55 = wave.binary addi %52, %54 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %56 = wave.binary divui %41, %8 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %57 = wave.binary remui %56, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %58 = wave.binary muli %57, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary addi %55, %58 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary divui %41, %7 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary remui %60, %12 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary muli %61, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary addi %59, %62 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary addi %63, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary remui %49, %11 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary addi %65, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary addi %65, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary addi %65, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.binary addi %65, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.binary addi %65, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary addi %65, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary addi %65, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.splat %40 : i32 -> !wave.simd<i32, 64>
      %74 = wave.binary addi %73, %63 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.binary addi %73, %64 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %76 = wave.binary addi %73, %65 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary addi %73, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary addi %73, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary addi %73, %68 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary addi %73, %69 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary addi %73, %70 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary addi %73, %71 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary addi %73, %72 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.splat %arg5 : i32 -> !wave.simd<i32, 64>
      %85 = wave.binary remsi %74, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary remsi %75, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary remsi %76, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.binary remsi %77, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %89 = wave.binary remsi %78, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %90 = wave.binary remsi %79, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary remsi %80, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %92 = wave.binary remsi %81, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %93 = wave.binary remsi %82, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %94 = wave.binary remsi %83, %84 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %95 = wave.binary muli %39, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %96 = wave.binary remui %41, %10 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %97 = wave.binary muli %96, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %98 = wave.binary remui %45, %11 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %99 = wave.binary muli %98, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %100 = wave.binary addi %99, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %101 = wave.binary addi %99, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %102 = wave.binary addi %99, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %103 = wave.splat %95 : i32 -> !wave.simd<i32, 64>
      %104 = wave.binary addi %103, %97 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %105 = wave.binary addi %103, %99 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %106 = wave.binary addi %103, %100 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %107 = wave.binary addi %103, %101 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %108 = wave.binary addi %103, %102 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %109 = wave.splat %arg6 : i32 -> !wave.simd<i32, 64>
      %110 = wave.binary remsi %104, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %111 = wave.binary remsi %105, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %112 = wave.binary remsi %106, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %113 = wave.binary remsi %107, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %114 = wave.binary remsi %108, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %115 = wave.binary addi %arg7, %c63_i32 overflow<nsw> : i32, i32 -> i32
      %116 = wave.binary divsi %115, %c64_i32 : i32, i32 -> i32
      %117 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %118 = wave.alloc() {align = 16 : i64, bytesize = 101344 : i64} : !wave.ptr<#wave.shared, f16>
      %119 = wave.binary remui %41, %13 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %120 = wave.binary muli %119, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %121 = wave.binary muli %50, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %122 = wave.binary addi %121, %54 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %123 = wave.binary addi %122, %58 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %124 = wave.binary muli %61, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %125 = wave.binary addi %123, %124 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %126 = wave.binary addi %125, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %127 = wave.binary addi %125, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %128 = wave.binary addi %125, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %129 = wave.splat %arg7 : i32 -> !wave.simd<i32, 64>
      %130 = wave.cmpi slt %120, %129 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %131 = wave.splat %16 : i32 -> !wave.simd<i32, 64>
      %132 = wave.binary muli %85, %131 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %133 = wave.binary muli %86, %131 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %134 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %135 = wave.token : !wave.mem.token
      %136 = wave.ptr_cast %117 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %137 = wave.read_first %41 : !wave.simd<i32, 64> -> i32
      %138 = wave.assume %137 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
      %139 = wave.binary divui %138, %c64_i32 : i32, i32 -> i32
      %140 = wave.binary muli %139, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %141 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%41, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %142 = wave.assume %141 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %143 = wave.ptr_add %134, %142 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %144 = wave.ptr_add %136, %140 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %145 = wave.where %130 {
        %1336 = waveamd.dma_load_lds %143 -> %144 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %146 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%41, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %147 = wave.assume %146 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %148 = wave.ptr_add %134, %147 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %149 = wave.binary addi %140, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %150 = wave.ptr_add %136, %149 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %151 = wave.where %130 {
        %1336 = waveamd.dma_load_lds %148 -> %150 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %152 = wave.join %145, %151 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %153 = wave.cmpi slt %125, %129 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %154 = wave.cmpi slt %126, %129 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %155 = wave.cmpi slt %127, %129 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %156 = wave.cmpi slt %128, %129 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %157 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %158 = wave.ptr_cast %118 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %159 = wave.index_expr <"s1 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%41, %17, %110) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %160 = wave.assume %159 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %161 = wave.ptr_add %157, %160 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %162 = wave.ptr_add %158, %140 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %163 = wave.where %153 {
        %1336 = waveamd.dma_load_lds %161 -> %162 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %164 = wave.index_expr <"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%41, %17, %110) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %165 = wave.assume %164 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %166 = wave.ptr_add %157, %165 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %167 = wave.ptr_add %158, %149 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %168 = wave.where %154 {
        %1336 = waveamd.dma_load_lds %166 -> %167 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %169 = wave.index_expr <"s1 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%41, %17, %110) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %170 = wave.assume %169 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %171 = wave.ptr_add %157, %170 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %172 = wave.binary addi %140, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %173 = wave.ptr_add %158, %172 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %174 = wave.where %155 {
        %1336 = waveamd.dma_load_lds %171 -> %173 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %175 = wave.index_expr <"s1 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%41, %17, %110) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %176 = wave.assume %175 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %177 = wave.ptr_add %157, %176 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %178 = wave.binary addi %140, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %179 = wave.ptr_add %158, %178 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %180 = wave.where %156 {
        %1336 = waveamd.dma_load_lds %177 -> %179 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %181 = wave.join %163, %168, %174, %180 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %182 = wave.join %152, %181 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %183 = wave.binary subi %arg7, %c64_i32 : i32, i32 -> i32
      %184 = wave.splat %183 : i32 -> !wave.simd<i32, 64>
      %185 = wave.cmpi slt %120, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %186 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%41, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %187 = wave.assume %186 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %188 = wave.ptr_add %134, %187 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %189 = wave.binary addi %c4224_i32, %140 overflow<nsw> : i32, i32 -> i32
      %190 = wave.ptr_add %136, %189 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %191 = wave.where %185 {
        %1336 = waveamd.dma_load_lds %188 -> %190 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %192 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%41, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %193 = wave.assume %192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %194 = wave.ptr_add %134, %193 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %195 = wave.binary addi %c4224_i32, %149 overflow<nsw> : i32, i32 -> i32
      %196 = wave.ptr_add %136, %195 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %197 = wave.where %185 {
        %1336 = waveamd.dma_load_lds %194 -> %196 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %198 = wave.join %191, %197 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %199 = wave.cmpi slt %125, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %200 = wave.cmpi slt %126, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %201 = wave.cmpi slt %127, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %202 = wave.cmpi slt %128, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %203 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %204 = wave.binary muli %203, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %205 = wave.index_expr <"s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %203, %110, %204) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %206 = wave.assume %205 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %207 = wave.ptr_add %157, %206 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %208 = wave.binary addi %c8448_i32, %140 overflow<nsw> : i32, i32 -> i32
      %209 = wave.ptr_add %158, %208 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %210 = wave.where %199 {
        %1336 = waveamd.dma_load_lds %207 -> %209 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %211 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %203, %110, %204) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %212 = wave.assume %211 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %213 = wave.ptr_add %157, %212 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %214 = wave.binary addi %c8448_i32, %149 overflow<nsw> : i32, i32 -> i32
      %215 = wave.ptr_add %158, %214 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %216 = wave.where %200 {
        %1336 = waveamd.dma_load_lds %213 -> %215 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %217 = wave.index_expr <"s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %203, %110, %204) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %218 = wave.assume %217 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %219 = wave.ptr_add %157, %218 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %220 = wave.binary addi %c8448_i32, %172 overflow<nsw> : i32, i32 -> i32
      %221 = wave.ptr_add %158, %220 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %222 = wave.where %201 {
        %1336 = waveamd.dma_load_lds %219 -> %221 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %223 = wave.index_expr <"s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %203, %110, %204) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %224 = wave.assume %223 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %225 = wave.ptr_add %157, %224 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %226 = wave.binary addi %c8448_i32, %178 overflow<nsw> : i32, i32 -> i32
      %227 = wave.ptr_add %158, %226 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %228 = wave.where %202 {
        %1336 = waveamd.dma_load_lds %225 -> %227 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %229 = wave.join %210, %216, %222, %228 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %230 = wave.join %198, %229 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %231 = wave.binary subi %arg7, %c128_i32 : i32, i32 -> i32
      %232 = wave.splat %231 : i32 -> !wave.simd<i32, 64>
      %233 = wave.cmpi slt %120, %232 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %234 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%41, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %235 = wave.assume %234 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %236 = wave.ptr_add %134, %235 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %237 = wave.ptr_add %136, %208 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %238 = wave.where %233 {
        %1336 = waveamd.dma_load_lds %236 -> %237 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %239 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%41, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %240 = wave.assume %239 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %241 = wave.ptr_add %134, %240 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %242 = wave.ptr_add %136, %214 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %243 = wave.where %233 {
        %1336 = waveamd.dma_load_lds %241 -> %242 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %244 = wave.join %238, %243 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %245 = wave.cmpi slt %125, %232 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %246 = wave.cmpi slt %126, %232 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %247 = wave.cmpi slt %127, %232 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %248 = wave.cmpi slt %128, %232 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %249 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %250 = wave.binary muli %249, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %251 = wave.index_expr <"s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %249, %250, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %252 = wave.assume %251 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %253 = wave.ptr_add %157, %252 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %254 = wave.binary addi %c16896_i32, %140 overflow<nsw> : i32, i32 -> i32
      %255 = wave.ptr_add %158, %254 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %256 = wave.where %245 {
        %1336 = waveamd.dma_load_lds %253 -> %255 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %257 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %249, %250, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %258 = wave.assume %257 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %259 = wave.ptr_add %157, %258 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %260 = wave.binary addi %c16896_i32, %149 overflow<nsw> : i32, i32 -> i32
      %261 = wave.ptr_add %158, %260 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %262 = wave.where %246 {
        %1336 = waveamd.dma_load_lds %259 -> %261 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %263 = wave.index_expr <"s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %249, %250, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %264 = wave.assume %263 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %265 = wave.ptr_add %157, %264 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %266 = wave.binary addi %c16896_i32, %172 overflow<nsw> : i32, i32 -> i32
      %267 = wave.ptr_add %158, %266 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %268 = wave.where %247 {
        %1336 = waveamd.dma_load_lds %265 -> %267 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %269 = wave.index_expr <"s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %249, %250, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %270 = wave.assume %269 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %271 = wave.ptr_add %157, %270 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %272 = wave.binary addi %c16896_i32, %178 overflow<nsw> : i32, i32 -> i32
      %273 = wave.ptr_add %158, %272 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %274 = wave.where %248 {
        %1336 = waveamd.dma_load_lds %271 -> %273 after %135 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1336 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %275 = wave.join %256, %262, %268, %274 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %276 = wave.join %244, %275 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %277 = wave.barrier %182, %230 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %278 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %279 = wave.ptr_add %117, %278 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %279 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %280 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %281 = wave.ptr_add %117, %280 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %281 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %282 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %283 = wave.ptr_add %117, %282 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %283 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %284 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %285 = wave.ptr_add %117, %284 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %285 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %286 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %287 = wave.ptr_add %117, %286 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %287 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %288 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %289 = wave.ptr_add %117, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %289 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %290 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %291 = wave.ptr_add %117, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %291 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %292 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %293 = wave.ptr_add %117, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %293 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %294 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %295 = wave.index_expr <"256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %296 = wave.ptr_add %118, %295 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_14, %token_15 = waveamd.transpose_load %296 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %297 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %298 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %299 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %300 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %301 = wave.index_expr <"4224 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %302 = wave.ptr_add %118, %301 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_16, %token_17 = waveamd.transpose_load %302 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %303 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %304 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %305 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %306 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %307 = wave.pack %297, %298, %299, %300, %303, %304, %305, %306 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %308 = wave.index_expr <"8448 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %309 = wave.ptr_add %118, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_18, %token_19 = waveamd.transpose_load %309 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %310 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %311 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %312 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %313 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %314 = wave.index_expr <"12672 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %315 = wave.ptr_add %118, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_20, %token_21 = waveamd.transpose_load %315 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %316 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %317 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %318 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %319 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %320 = wave.pack %310, %311, %312, %313, %316, %317, %318, %319 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %321 = wave.index_expr <"64 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %322 = wave.ptr_add %118, %321 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_22, %token_23 = waveamd.transpose_load %322 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %323 = wave.extract %value_22[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %324 = wave.extract %value_22[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %325 = wave.extract %value_22[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %326 = wave.extract %value_22[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %327 = wave.index_expr <"4288 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %328 = wave.ptr_add %118, %327 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_24, %token_25 = waveamd.transpose_load %328 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %329 = wave.extract %value_24[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %330 = wave.extract %value_24[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %331 = wave.extract %value_24[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %332 = wave.extract %value_24[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %333 = wave.pack %323, %324, %325, %326, %329, %330, %331, %332 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %334 = wave.index_expr <"8512 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %335 = wave.ptr_add %118, %334 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_26, %token_27 = waveamd.transpose_load %335 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %336 = wave.extract %value_26[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %337 = wave.extract %value_26[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %338 = wave.extract %value_26[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %339 = wave.extract %value_26[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %340 = wave.index_expr <"12736 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %341 = wave.ptr_add %118, %340 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_28, %token_29 = waveamd.transpose_load %341 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %342 = wave.extract %value_28[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %343 = wave.extract %value_28[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %344 = wave.extract %value_28[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %345 = wave.extract %value_28[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %346 = wave.pack %336, %337, %338, %339, %342, %343, %344, %345 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %347 = wave.index_expr <"128 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %348 = wave.ptr_add %118, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_30, %token_31 = waveamd.transpose_load %348 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %349 = wave.extract %value_30[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %350 = wave.extract %value_30[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %351 = wave.extract %value_30[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %352 = wave.extract %value_30[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %353 = wave.index_expr <"4352 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %354 = wave.ptr_add %118, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_32, %token_33 = waveamd.transpose_load %354 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %355 = wave.extract %value_32[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %356 = wave.extract %value_32[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %357 = wave.extract %value_32[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %358 = wave.extract %value_32[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %359 = wave.pack %349, %350, %351, %352, %355, %356, %357, %358 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %360 = wave.index_expr <"8576 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %361 = wave.ptr_add %118, %360 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_34, %token_35 = waveamd.transpose_load %361 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %362 = wave.extract %value_34[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %363 = wave.extract %value_34[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %364 = wave.extract %value_34[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %365 = wave.extract %value_34[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %366 = wave.index_expr <"12800 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %367 = wave.ptr_add %118, %366 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_36, %token_37 = waveamd.transpose_load %367 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %368 = wave.extract %value_36[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %369 = wave.extract %value_36[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %370 = wave.extract %value_36[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %371 = wave.extract %value_36[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %372 = wave.pack %362, %363, %364, %365, %368, %369, %370, %371 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %373 = wave.index_expr <"192 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %374 = wave.ptr_add %118, %373 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_38, %token_39 = waveamd.transpose_load %374 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %375 = wave.extract %value_38[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %376 = wave.extract %value_38[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %377 = wave.extract %value_38[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %378 = wave.extract %value_38[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %379 = wave.index_expr <"4416 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %380 = wave.ptr_add %118, %379 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_40, %token_41 = waveamd.transpose_load %380 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %381 = wave.extract %value_40[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %382 = wave.extract %value_40[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %383 = wave.extract %value_40[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %384 = wave.extract %value_40[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %385 = wave.pack %375, %376, %377, %378, %381, %382, %383, %384 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %386 = wave.index_expr <"8640 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %387 = wave.ptr_add %118, %386 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_42, %token_43 = waveamd.transpose_load %387 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %388 = wave.extract %value_42[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %389 = wave.extract %value_42[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %390 = wave.extract %value_42[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %391 = wave.extract %value_42[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %392 = wave.index_expr <"12864 + 256*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %393 = wave.ptr_add %118, %392 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_44, %token_45 = waveamd.transpose_load %393 after %277 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %394 = wave.extract %value_44[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %395 = wave.extract %value_44[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %396 = wave.extract %value_44[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %397 = wave.extract %value_44[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %398 = wave.pack %388, %389, %390, %391, %394, %395, %396, %397 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %399 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29, %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %400 = wave.binary subi %116, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %401:34 = scf.for %arg12 = %c0_i32 to %400 step %c1_i32 iter_args(%arg13 = %value, %arg14 = %value_0, %arg15 = %value_2, %arg16 = %value_4, %arg17 = %value_6, %arg18 = %value_8, %arg19 = %value_10, %arg20 = %value_12, %arg21 = %307, %arg22 = %320, %arg23 = %333, %arg24 = %346, %arg25 = %359, %arg26 = %372, %arg27 = %385, %arg28 = %398, %arg29 = %15, %arg30 = %15, %arg31 = %15, %arg32 = %15, %arg33 = %15, %arg34 = %15, %arg35 = %15, %arg36 = %15, %arg37 = %15, %arg38 = %15, %arg39 = %15, %arg40 = %15, %arg41 = %15, %arg42 = %15, %arg43 = %15, %arg44 = %15, %arg45 = %276, %arg46 = %276) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token)  : i32 {
        %1336 = wave.binary remui %arg12, %c3_i32 : i32, i32 -> i32
        %1337 = wave.binary addi %arg12, %c1_i32 overflow<nsw> : i32, i32 -> i32
        %1338 = wave.binary remui %1337, %c3_i32 : i32, i32 -> i32
        %1339 = wave.binary addi %arg12, %c3_i32 overflow<nsw> : i32, i32 -> i32
        %1340 = wave.binary muli %1339, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1341 = waveamd.fragment_pack %arg13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1342 = waveamd.fragment_pack %arg14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1343 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1344 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1345 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1346 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1347 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1348 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1349 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1350 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1351 = waveamd.fragment_pack %arg23 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1352 = waveamd.fragment_pack %arg24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1353 = waveamd.fragment_pack %arg25 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1354 = waveamd.fragment_pack %arg26 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1355 = waveamd.fragment_pack %arg27 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1356 = waveamd.fragment_pack %arg28 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1357 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1358 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1359 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1360 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1361 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1362 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1363 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1364 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1365 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1366 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1367 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1368 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1369 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1370 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1371 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1372 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1373 = waveamd.mma "mfma.f32.16x16x32.f16" %1349, %1341, %1357 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1374 = waveamd.mma "mfma.f32.16x16x32.f16" %1350, %1342, %1373 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1375 = waveamd.fragment_unpack %1374 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1376 = waveamd.mma "mfma.f32.16x16x32.f16" %1351, %1341, %1358 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1377 = waveamd.mma "mfma.f32.16x16x32.f16" %1352, %1342, %1376 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1378 = waveamd.fragment_unpack %1377 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1379 = waveamd.mma "mfma.f32.16x16x32.f16" %1353, %1341, %1359 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1380 = waveamd.mma "mfma.f32.16x16x32.f16" %1354, %1342, %1379 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1381 = waveamd.fragment_unpack %1380 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1382 = waveamd.mma "mfma.f32.16x16x32.f16" %1355, %1341, %1360 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1383 = waveamd.mma "mfma.f32.16x16x32.f16" %1356, %1342, %1382 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1384 = waveamd.fragment_unpack %1383 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1385 = waveamd.mma "mfma.f32.16x16x32.f16" %1349, %1343, %1361 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1386 = waveamd.mma "mfma.f32.16x16x32.f16" %1350, %1344, %1385 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1387 = waveamd.fragment_unpack %1386 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1388 = waveamd.mma "mfma.f32.16x16x32.f16" %1351, %1343, %1362 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1389 = waveamd.mma "mfma.f32.16x16x32.f16" %1352, %1344, %1388 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1390 = waveamd.fragment_unpack %1389 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1391 = waveamd.mma "mfma.f32.16x16x32.f16" %1353, %1343, %1363 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1392 = waveamd.mma "mfma.f32.16x16x32.f16" %1354, %1344, %1391 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1393 = waveamd.fragment_unpack %1392 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1394 = waveamd.mma "mfma.f32.16x16x32.f16" %1355, %1343, %1364 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1395 = waveamd.mma "mfma.f32.16x16x32.f16" %1356, %1344, %1394 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1396 = waveamd.fragment_unpack %1395 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1397 = waveamd.mma "mfma.f32.16x16x32.f16" %1349, %1345, %1365 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1398 = waveamd.mma "mfma.f32.16x16x32.f16" %1350, %1346, %1397 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1399 = waveamd.fragment_unpack %1398 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1400 = waveamd.mma "mfma.f32.16x16x32.f16" %1351, %1345, %1366 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1401 = waveamd.mma "mfma.f32.16x16x32.f16" %1352, %1346, %1400 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1402 = waveamd.fragment_unpack %1401 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1403 = waveamd.mma "mfma.f32.16x16x32.f16" %1353, %1345, %1367 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1404 = waveamd.mma "mfma.f32.16x16x32.f16" %1354, %1346, %1403 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1405 = waveamd.fragment_unpack %1404 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1406 = waveamd.mma "mfma.f32.16x16x32.f16" %1355, %1345, %1368 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1407 = waveamd.mma "mfma.f32.16x16x32.f16" %1356, %1346, %1406 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1408 = waveamd.fragment_unpack %1407 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1409 = waveamd.mma "mfma.f32.16x16x32.f16" %1349, %1347, %1369 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1410 = waveamd.mma "mfma.f32.16x16x32.f16" %1350, %1348, %1409 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1411 = waveamd.fragment_unpack %1410 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1412 = waveamd.mma "mfma.f32.16x16x32.f16" %1351, %1347, %1370 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1413 = waveamd.mma "mfma.f32.16x16x32.f16" %1352, %1348, %1412 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1414 = waveamd.fragment_unpack %1413 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1415 = waveamd.mma "mfma.f32.16x16x32.f16" %1353, %1347, %1371 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1416 = waveamd.mma "mfma.f32.16x16x32.f16" %1354, %1348, %1415 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1417 = waveamd.fragment_unpack %1416 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1418 = waveamd.mma "mfma.f32.16x16x32.f16" %1355, %1347, %1372 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1419 = waveamd.mma "mfma.f32.16x16x32.f16" %1356, %1348, %1418 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1420 = waveamd.fragment_unpack %1419 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1421 = wave.binary subi %arg7, %1340 : i32, i32 -> i32
        %1422 = wave.splat %1421 : i32 -> !wave.simd<i32, 64>
        %1423 = wave.cmpi slt %120, %1422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1424 = wave.binary muli %1336, %c4224_i32 overflow<nsw> : i32, i32 -> i32
        %1425 = wave.barrier : () -> !wave.mem.token
        %1426 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%41, %1340, %132) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1427 = wave.assume %1426 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1428 = wave.ptr_add %134, %1427 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1429 = wave.binary addi %1424, %140 overflow<nsw> : i32, i32 -> i32
        %1430 = wave.ptr_add %136, %1429 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1431 = wave.where %1423 {
          %1573 = waveamd.dma_load_lds %1428 -> %1430 after %1425 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1573 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1432 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%41, %1340, %133) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1433 = wave.assume %1432 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1434 = wave.ptr_add %134, %1433 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1435 = wave.binary addi %1424, %149 overflow<nsw> : i32, i32 -> i32
        %1436 = wave.ptr_add %136, %1435 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1437 = wave.where %1423 {
          %1573 = waveamd.dma_load_lds %1434 -> %1436 after %1425 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1573 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1438 = wave.join %1431, %1437 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1439 = wave.cmpi slt %125, %1422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1440 = wave.cmpi slt %126, %1422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1441 = wave.cmpi slt %127, %1422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1442 = wave.cmpi slt %128, %1422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1443 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1444 = wave.binary muli %1340, %1443 overflow<nsw> : i32, i32 -> i32
        %1445 = wave.binary muli %1336, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1446 = wave.index_expr <"s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %1443, %1444, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1447 = wave.assume %1446 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1448 = wave.ptr_add %157, %1447 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1449 = wave.binary addi %1445, %140 overflow<nsw> : i32, i32 -> i32
        %1450 = wave.ptr_add %158, %1449 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1451 = wave.where %1439 {
          %1573 = waveamd.dma_load_lds %1448 -> %1450 after %1425 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1573 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1452 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 32*Mod(floor(1/2 + 1/1024*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %1443, %1444, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1453 = wave.assume %1452 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1454 = wave.ptr_add %157, %1453 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1455 = wave.binary addi %1445, %149 overflow<nsw> : i32, i32 -> i32
        %1456 = wave.ptr_add %158, %1455 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1457 = wave.where %1440 {
          %1573 = waveamd.dma_load_lds %1454 -> %1456 after %1425 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1573 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1458 = wave.index_expr <"s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(1 + floor(1/1024*wi), 2) + 4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %1443, %1444, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1459 = wave.assume %1458 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1460 = wave.ptr_add %157, %1459 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1461 = wave.binary addi %1445, %172 overflow<nsw> : i32, i32 -> i32
        %1462 = wave.ptr_add %158, %1461 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1463 = wave.where %1441 {
          %1573 = waveamd.dma_load_lds %1460 -> %1462 after %1425 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1573 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1464 = wave.index_expr <"s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(32*Mod(1 + floor(1/2 + 1/1024*wi), 2) + 4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%41, %1443, %1444, %110) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1465 = wave.assume %1464 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1466 = wave.ptr_add %157, %1465 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1467 = wave.binary addi %1445, %178 overflow<nsw> : i32, i32 -> i32
        %1468 = wave.ptr_add %158, %1467 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1469 = wave.where %1442 {
          %1573 = waveamd.dma_load_lds %1466 -> %1468 after %1425 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1573 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1470 = wave.join %1451, %1457, %1463, %1469 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1471 = wave.join %1438, %1470 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1472 = wave.binary muli %1338, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1473 = wave.ptr_add %117, %1472 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1474 = wave.ptr_add %1473, %278 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_198, %token_199 = wave.load %1474 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1475 = wave.ptr_add %1473, %280 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_200, %token_201 = wave.load %1475 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1476 = wave.ptr_add %1473, %282 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_202, %token_203 = wave.load %1476 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1477 = wave.ptr_add %1473, %284 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_204, %token_205 = wave.load %1477 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1478 = wave.ptr_add %1473, %286 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_206, %token_207 = wave.load %1478 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1479 = wave.ptr_add %1473, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_208, %token_209 = wave.load %1479 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1480 = wave.ptr_add %1473, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_210, %token_211 = wave.load %1480 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1481 = wave.ptr_add %1473, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_212, %token_213 = wave.load %1481 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1482 = wave.binary muli %1338, %c16896_i32 overflow<nsw> : i32, i32 -> i32
        %1483 = wave.ptr_add %118, %1482 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1484 = wave.ptr_add %1483, %295 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_214, %token_215 = waveamd.transpose_load %1484 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1485 = wave.extract %value_214[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1486 = wave.extract %value_214[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1487 = wave.extract %value_214[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1488 = wave.extract %value_214[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1489 = wave.ptr_add %1483, %301 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_216, %token_217 = waveamd.transpose_load %1489 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1490 = wave.extract %value_216[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1491 = wave.extract %value_216[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1492 = wave.extract %value_216[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1493 = wave.extract %value_216[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1494 = wave.pack %1485, %1486, %1487, %1488, %1490, %1491, %1492, %1493 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1495 = wave.ptr_add %1483, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_218, %token_219 = waveamd.transpose_load %1495 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1496 = wave.extract %value_218[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1497 = wave.extract %value_218[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1498 = wave.extract %value_218[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1499 = wave.extract %value_218[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1500 = wave.ptr_add %1483, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_220, %token_221 = waveamd.transpose_load %1500 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1501 = wave.extract %value_220[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1502 = wave.extract %value_220[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1503 = wave.extract %value_220[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1504 = wave.extract %value_220[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1505 = wave.pack %1496, %1497, %1498, %1499, %1501, %1502, %1503, %1504 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1506 = wave.ptr_add %1483, %321 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_222, %token_223 = waveamd.transpose_load %1506 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1507 = wave.extract %value_222[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1508 = wave.extract %value_222[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1509 = wave.extract %value_222[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1510 = wave.extract %value_222[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1511 = wave.ptr_add %1483, %327 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_224, %token_225 = waveamd.transpose_load %1511 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1512 = wave.extract %value_224[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1513 = wave.extract %value_224[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1514 = wave.extract %value_224[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1515 = wave.extract %value_224[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1516 = wave.pack %1507, %1508, %1509, %1510, %1512, %1513, %1514, %1515 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1517 = wave.ptr_add %1483, %334 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_226, %token_227 = waveamd.transpose_load %1517 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1518 = wave.extract %value_226[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1519 = wave.extract %value_226[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1520 = wave.extract %value_226[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1521 = wave.extract %value_226[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1522 = wave.ptr_add %1483, %340 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_228, %token_229 = waveamd.transpose_load %1522 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1523 = wave.extract %value_228[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1524 = wave.extract %value_228[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1525 = wave.extract %value_228[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1526 = wave.extract %value_228[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1527 = wave.pack %1518, %1519, %1520, %1521, %1523, %1524, %1525, %1526 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1528 = wave.ptr_add %1483, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_230, %token_231 = waveamd.transpose_load %1528 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1529 = wave.extract %value_230[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1530 = wave.extract %value_230[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1531 = wave.extract %value_230[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1532 = wave.extract %value_230[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1533 = wave.ptr_add %1483, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_232, %token_233 = waveamd.transpose_load %1533 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1534 = wave.extract %value_232[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1535 = wave.extract %value_232[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1536 = wave.extract %value_232[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1537 = wave.extract %value_232[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1538 = wave.pack %1529, %1530, %1531, %1532, %1534, %1535, %1536, %1537 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1539 = wave.ptr_add %1483, %360 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_234, %token_235 = waveamd.transpose_load %1539 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1540 = wave.extract %value_234[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1541 = wave.extract %value_234[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1542 = wave.extract %value_234[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1543 = wave.extract %value_234[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1544 = wave.ptr_add %1483, %366 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_236, %token_237 = waveamd.transpose_load %1544 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1545 = wave.extract %value_236[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1546 = wave.extract %value_236[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1547 = wave.extract %value_236[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1548 = wave.extract %value_236[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1549 = wave.pack %1540, %1541, %1542, %1543, %1545, %1546, %1547, %1548 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1550 = wave.ptr_add %1483, %373 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_238, %token_239 = waveamd.transpose_load %1550 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1551 = wave.extract %value_238[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1552 = wave.extract %value_238[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1553 = wave.extract %value_238[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1554 = wave.extract %value_238[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1555 = wave.ptr_add %1483, %379 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_240, %token_241 = waveamd.transpose_load %1555 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1556 = wave.extract %value_240[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1557 = wave.extract %value_240[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1558 = wave.extract %value_240[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1559 = wave.extract %value_240[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1560 = wave.pack %1551, %1552, %1553, %1554, %1556, %1557, %1558, %1559 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1561 = wave.ptr_add %1483, %386 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_242, %token_243 = waveamd.transpose_load %1561 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1562 = wave.extract %value_242[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1563 = wave.extract %value_242[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1564 = wave.extract %value_242[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1565 = wave.extract %value_242[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1566 = wave.ptr_add %1483, %392 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_244, %token_245 = waveamd.transpose_load %1566 after %135 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1567 = wave.extract %value_244[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1568 = wave.extract %value_244[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1569 = wave.extract %value_244[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1570 = wave.extract %value_244[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1571 = wave.pack %1562, %1563, %1564, %1565, %1567, %1568, %1569, %1570 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1572 = wave.barrier %arg45 : (!wave.mem.token) -> !wave.mem.token
        scf.yield %value_198, %value_200, %value_202, %value_204, %value_206, %value_208, %value_210, %value_212, %1494, %1505, %1516, %1527, %1538, %1549, %1560, %1571, %1375, %1378, %1381, %1384, %1387, %1390, %1393, %1396, %1399, %1402, %1405, %1408, %1411, %1414, %1417, %1420, %1471, %1572 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token
      }
      %402 = waveamd.fragment_pack %401#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %403 = waveamd.fragment_pack %401#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %404 = waveamd.fragment_pack %401#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %405 = waveamd.fragment_pack %401#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %406 = waveamd.fragment_pack %401#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %407 = waveamd.fragment_pack %401#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %408 = waveamd.fragment_pack %401#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %409 = waveamd.fragment_pack %401#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %410 = waveamd.fragment_pack %401#8 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %411 = waveamd.fragment_pack %401#9 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %412 = waveamd.fragment_pack %401#10 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %413 = waveamd.fragment_pack %401#11 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %414 = waveamd.fragment_pack %401#12 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %415 = waveamd.fragment_pack %401#13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %416 = waveamd.fragment_pack %401#14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %417 = waveamd.fragment_pack %401#15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %418 = waveamd.fragment_pack %401#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %419 = waveamd.fragment_pack %401#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %420 = waveamd.fragment_pack %401#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %421 = waveamd.fragment_pack %401#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %422 = waveamd.fragment_pack %401#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %423 = waveamd.fragment_pack %401#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %424 = waveamd.fragment_pack %401#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %425 = waveamd.fragment_pack %401#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %426 = waveamd.fragment_pack %401#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %427 = waveamd.fragment_pack %401#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %428 = waveamd.fragment_pack %401#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %429 = waveamd.fragment_pack %401#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %430 = waveamd.fragment_pack %401#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %431 = waveamd.fragment_pack %401#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %432 = waveamd.fragment_pack %401#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %433 = waveamd.fragment_pack %401#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %434 = waveamd.mma "mfma.f32.16x16x32.f16" %410, %402, %418 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %435 = waveamd.mma "mfma.f32.16x16x32.f16" %411, %403, %434 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %436 = waveamd.fragment_unpack %435 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %437 = waveamd.mma "mfma.f32.16x16x32.f16" %412, %402, %419 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %438 = waveamd.mma "mfma.f32.16x16x32.f16" %413, %403, %437 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %439 = waveamd.fragment_unpack %438 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %440 = waveamd.mma "mfma.f32.16x16x32.f16" %414, %402, %420 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %441 = waveamd.mma "mfma.f32.16x16x32.f16" %415, %403, %440 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %442 = waveamd.fragment_unpack %441 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %443 = waveamd.mma "mfma.f32.16x16x32.f16" %416, %402, %421 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %444 = waveamd.mma "mfma.f32.16x16x32.f16" %417, %403, %443 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %445 = waveamd.fragment_unpack %444 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %446 = waveamd.mma "mfma.f32.16x16x32.f16" %410, %404, %422 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %447 = waveamd.mma "mfma.f32.16x16x32.f16" %411, %405, %446 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %448 = waveamd.fragment_unpack %447 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %449 = waveamd.mma "mfma.f32.16x16x32.f16" %412, %404, %423 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %450 = waveamd.mma "mfma.f32.16x16x32.f16" %413, %405, %449 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %451 = waveamd.fragment_unpack %450 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %452 = waveamd.mma "mfma.f32.16x16x32.f16" %414, %404, %424 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %453 = waveamd.mma "mfma.f32.16x16x32.f16" %415, %405, %452 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %454 = waveamd.fragment_unpack %453 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %455 = waveamd.mma "mfma.f32.16x16x32.f16" %416, %404, %425 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %456 = waveamd.mma "mfma.f32.16x16x32.f16" %417, %405, %455 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %457 = waveamd.fragment_unpack %456 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %458 = waveamd.mma "mfma.f32.16x16x32.f16" %410, %406, %426 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %459 = waveamd.mma "mfma.f32.16x16x32.f16" %411, %407, %458 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %460 = waveamd.fragment_unpack %459 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %461 = waveamd.mma "mfma.f32.16x16x32.f16" %412, %406, %427 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %462 = waveamd.mma "mfma.f32.16x16x32.f16" %413, %407, %461 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %463 = waveamd.fragment_unpack %462 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %464 = waveamd.mma "mfma.f32.16x16x32.f16" %414, %406, %428 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %465 = waveamd.mma "mfma.f32.16x16x32.f16" %415, %407, %464 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %466 = waveamd.fragment_unpack %465 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %467 = waveamd.mma "mfma.f32.16x16x32.f16" %416, %406, %429 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %468 = waveamd.mma "mfma.f32.16x16x32.f16" %417, %407, %467 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %469 = waveamd.fragment_unpack %468 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %470 = waveamd.mma "mfma.f32.16x16x32.f16" %410, %408, %430 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %471 = waveamd.mma "mfma.f32.16x16x32.f16" %411, %409, %470 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %472 = waveamd.fragment_unpack %471 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %473 = waveamd.mma "mfma.f32.16x16x32.f16" %412, %408, %431 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %474 = waveamd.mma "mfma.f32.16x16x32.f16" %413, %409, %473 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %475 = waveamd.fragment_unpack %474 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %476 = waveamd.mma "mfma.f32.16x16x32.f16" %414, %408, %432 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %477 = waveamd.mma "mfma.f32.16x16x32.f16" %415, %409, %476 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %478 = waveamd.fragment_unpack %477 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %479 = waveamd.mma "mfma.f32.16x16x32.f16" %416, %408, %433 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %480 = waveamd.mma "mfma.f32.16x16x32.f16" %417, %409, %479 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %481 = waveamd.fragment_unpack %480 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %482 = wave.barrier %401#32 : (!wave.mem.token) -> !wave.mem.token
      %483 = wave.binary subi %116, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %484 = wave.binary remsi %483, %c3_i32 : i32, i32 -> i32
      %485 = wave.binary muli %484, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %486 = wave.ptr_add %117, %485 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %487 = wave.barrier %401#33, %277 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %488 = wave.join %294, %482, %487 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %489 = wave.ptr_add %486, %278 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_46, %token_47 = wave.load %489 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %490 = wave.ptr_add %486, %280 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_48, %token_49 = wave.load %490 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %491 = wave.ptr_add %486, %282 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_50, %token_51 = wave.load %491 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %492 = wave.ptr_add %486, %284 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_52, %token_53 = wave.load %492 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %493 = wave.ptr_add %486, %286 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_54, %token_55 = wave.load %493 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %494 = wave.ptr_add %486, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_56, %token_57 = wave.load %494 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %495 = wave.ptr_add %486, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_58, %token_59 = wave.load %495 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %496 = wave.ptr_add %486, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_60, %token_61 = wave.load %496 after %488 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %497 = wave.join %token_47, %token_49, %token_51, %token_53, %token_55, %token_57, %token_59, %token_61 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %498 = wave.binary muli %484, %c16896_i32 overflow<nsw> : i32, i32 -> i32
      %499 = wave.ptr_add %118, %498 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %500 = wave.barrier %401#33, %277 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %501 = wave.join %399, %482, %500 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %502 = wave.ptr_add %499, %295 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_62, %token_63 = waveamd.transpose_load %502 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %503 = wave.extract %value_62[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %504 = wave.extract %value_62[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %505 = wave.extract %value_62[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %506 = wave.extract %value_62[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %507 = wave.ptr_add %499, %301 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_64, %token_65 = waveamd.transpose_load %507 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %508 = wave.extract %value_64[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %509 = wave.extract %value_64[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %510 = wave.extract %value_64[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %511 = wave.extract %value_64[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %512 = wave.pack %503, %504, %505, %506, %508, %509, %510, %511 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %513 = wave.ptr_add %499, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_66, %token_67 = waveamd.transpose_load %513 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %514 = wave.extract %value_66[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %515 = wave.extract %value_66[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %516 = wave.extract %value_66[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %517 = wave.extract %value_66[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %518 = wave.ptr_add %499, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_68, %token_69 = waveamd.transpose_load %518 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %519 = wave.extract %value_68[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %520 = wave.extract %value_68[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %521 = wave.extract %value_68[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %522 = wave.extract %value_68[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %523 = wave.pack %514, %515, %516, %517, %519, %520, %521, %522 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %524 = wave.ptr_add %499, %321 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_70, %token_71 = waveamd.transpose_load %524 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %525 = wave.extract %value_70[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %526 = wave.extract %value_70[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %527 = wave.extract %value_70[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %528 = wave.extract %value_70[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %529 = wave.ptr_add %499, %327 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_72, %token_73 = waveamd.transpose_load %529 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %530 = wave.extract %value_72[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %531 = wave.extract %value_72[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %532 = wave.extract %value_72[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %533 = wave.extract %value_72[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %534 = wave.pack %525, %526, %527, %528, %530, %531, %532, %533 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %535 = wave.ptr_add %499, %334 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_74, %token_75 = waveamd.transpose_load %535 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %536 = wave.extract %value_74[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %537 = wave.extract %value_74[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %538 = wave.extract %value_74[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %539 = wave.extract %value_74[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %540 = wave.ptr_add %499, %340 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_76, %token_77 = waveamd.transpose_load %540 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %541 = wave.extract %value_76[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %542 = wave.extract %value_76[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %543 = wave.extract %value_76[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %544 = wave.extract %value_76[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %545 = wave.pack %536, %537, %538, %539, %541, %542, %543, %544 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %546 = wave.ptr_add %499, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_78, %token_79 = waveamd.transpose_load %546 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %547 = wave.extract %value_78[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %548 = wave.extract %value_78[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %549 = wave.extract %value_78[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %550 = wave.extract %value_78[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %551 = wave.ptr_add %499, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_80, %token_81 = waveamd.transpose_load %551 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %552 = wave.extract %value_80[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %553 = wave.extract %value_80[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %554 = wave.extract %value_80[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %555 = wave.extract %value_80[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %556 = wave.pack %547, %548, %549, %550, %552, %553, %554, %555 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %557 = wave.ptr_add %499, %360 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_82, %token_83 = waveamd.transpose_load %557 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %558 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %559 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %560 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %561 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %562 = wave.ptr_add %499, %366 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_84, %token_85 = waveamd.transpose_load %562 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %563 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %564 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %565 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %566 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %567 = wave.pack %558, %559, %560, %561, %563, %564, %565, %566 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %568 = wave.ptr_add %499, %373 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_86, %token_87 = waveamd.transpose_load %568 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %569 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %570 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %571 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %572 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %573 = wave.ptr_add %499, %379 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_88, %token_89 = waveamd.transpose_load %573 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %574 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %575 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %576 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %577 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %578 = wave.pack %569, %570, %571, %572, %574, %575, %576, %577 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %579 = wave.ptr_add %499, %386 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_90, %token_91 = waveamd.transpose_load %579 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %580 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %581 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %582 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %583 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %584 = wave.ptr_add %499, %392 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_92, %token_93 = waveamd.transpose_load %584 after %501 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %585 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %586 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %587 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %588 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %589 = wave.pack %580, %581, %582, %583, %585, %586, %587, %588 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %590 = wave.join %token_63, %token_65, %token_67, %token_69, %token_71, %token_73, %token_75, %token_77, %token_79, %token_81, %token_83, %token_85, %token_87, %token_89, %token_91, %token_93 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %591 = waveamd.fragment_pack %value_46 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %592 = waveamd.fragment_pack %value_48 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %593 = waveamd.fragment_pack %value_50 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %594 = waveamd.fragment_pack %value_52 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %595 = waveamd.fragment_pack %value_54 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %596 = waveamd.fragment_pack %value_56 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %597 = waveamd.fragment_pack %value_58 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %598 = waveamd.fragment_pack %value_60 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %599 = waveamd.fragment_pack %512 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %600 = waveamd.fragment_pack %523 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %601 = waveamd.fragment_pack %534 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %602 = waveamd.fragment_pack %545 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %603 = waveamd.fragment_pack %556 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %604 = waveamd.fragment_pack %567 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %605 = waveamd.fragment_pack %578 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %606 = waveamd.fragment_pack %589 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %607 = waveamd.fragment_pack %436 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %608 = waveamd.fragment_pack %439 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %609 = waveamd.fragment_pack %442 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %610 = waveamd.fragment_pack %445 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %611 = waveamd.fragment_pack %448 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.fragment_pack %451 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %613 = waveamd.fragment_pack %454 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.fragment_pack %457 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_pack %460 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %616 = waveamd.fragment_pack %463 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.fragment_pack %466 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_pack %469 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %619 = waveamd.fragment_pack %472 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.fragment_pack %475 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.fragment_pack %478 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %622 = waveamd.fragment_pack %481 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %623 = waveamd.mma "mfma.f32.16x16x32.f16" %599, %591, %607 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.mma "mfma.f32.16x16x32.f16" %600, %592, %623 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %625 = waveamd.fragment_unpack %624 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %626 = waveamd.mma "mfma.f32.16x16x32.f16" %601, %591, %608 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.mma "mfma.f32.16x16x32.f16" %602, %592, %626 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %628 = waveamd.fragment_unpack %627 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %629 = waveamd.mma "mfma.f32.16x16x32.f16" %603, %591, %609 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %630 = waveamd.mma "mfma.f32.16x16x32.f16" %604, %592, %629 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %631 = waveamd.fragment_unpack %630 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %632 = waveamd.mma "mfma.f32.16x16x32.f16" %605, %591, %610 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %633 = waveamd.mma "mfma.f32.16x16x32.f16" %606, %592, %632 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %634 = waveamd.fragment_unpack %633 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %635 = waveamd.mma "mfma.f32.16x16x32.f16" %599, %593, %611 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %636 = waveamd.mma "mfma.f32.16x16x32.f16" %600, %594, %635 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %637 = waveamd.fragment_unpack %636 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %638 = waveamd.mma "mfma.f32.16x16x32.f16" %601, %593, %612 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.mma "mfma.f32.16x16x32.f16" %602, %594, %638 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %640 = waveamd.fragment_unpack %639 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %641 = waveamd.mma "mfma.f32.16x16x32.f16" %603, %593, %613 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.mma "mfma.f32.16x16x32.f16" %604, %594, %641 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %643 = waveamd.fragment_unpack %642 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %644 = waveamd.mma "mfma.f32.16x16x32.f16" %605, %593, %614 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %645 = waveamd.mma "mfma.f32.16x16x32.f16" %606, %594, %644 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %646 = waveamd.fragment_unpack %645 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %647 = waveamd.mma "mfma.f32.16x16x32.f16" %599, %595, %615 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %648 = waveamd.mma "mfma.f32.16x16x32.f16" %600, %596, %647 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %649 = waveamd.fragment_unpack %648 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %650 = waveamd.mma "mfma.f32.16x16x32.f16" %601, %595, %616 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %651 = waveamd.mma "mfma.f32.16x16x32.f16" %602, %596, %650 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %652 = waveamd.fragment_unpack %651 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %653 = waveamd.mma "mfma.f32.16x16x32.f16" %603, %595, %617 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %654 = waveamd.mma "mfma.f32.16x16x32.f16" %604, %596, %653 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %655 = waveamd.fragment_unpack %654 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %656 = waveamd.mma "mfma.f32.16x16x32.f16" %605, %595, %618 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %657 = waveamd.mma "mfma.f32.16x16x32.f16" %606, %596, %656 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %658 = waveamd.fragment_unpack %657 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %659 = waveamd.mma "mfma.f32.16x16x32.f16" %599, %597, %619 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %660 = waveamd.mma "mfma.f32.16x16x32.f16" %600, %598, %659 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %661 = waveamd.fragment_unpack %660 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %662 = waveamd.mma "mfma.f32.16x16x32.f16" %601, %597, %620 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.mma "mfma.f32.16x16x32.f16" %602, %598, %662 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %664 = waveamd.fragment_unpack %663 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %665 = waveamd.mma "mfma.f32.16x16x32.f16" %603, %597, %621 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.mma "mfma.f32.16x16x32.f16" %604, %598, %665 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %667 = waveamd.fragment_unpack %666 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %668 = waveamd.mma "mfma.f32.16x16x32.f16" %605, %597, %622 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.mma "mfma.f32.16x16x32.f16" %606, %598, %668 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %670 = waveamd.fragment_unpack %669 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %671 = wave.binary addi %116, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %672 = wave.binary remsi %671, %c3_i32 : i32, i32 -> i32
      %673 = wave.binary muli %672, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %674 = wave.ptr_add %117, %673 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %675 = wave.join %487, %294, %497 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %676 = wave.ptr_add %674, %278 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_94, %token_95 = wave.load %676 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %677 = wave.ptr_add %674, %280 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_96, %token_97 = wave.load %677 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %678 = wave.ptr_add %674, %282 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_98, %token_99 = wave.load %678 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %679 = wave.ptr_add %674, %284 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_100, %token_101 = wave.load %679 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %680 = wave.ptr_add %674, %286 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_102, %token_103 = wave.load %680 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %681 = wave.ptr_add %674, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_104, %token_105 = wave.load %681 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %682 = wave.ptr_add %674, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_106, %token_107 = wave.load %682 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %683 = wave.ptr_add %674, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_108, %token_109 = wave.load %683 after %675 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %684 = wave.join %token_95, %token_97, %token_99, %token_101, %token_103, %token_105, %token_107, %token_109 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %685 = wave.join %497, %684 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %686 = wave.binary muli %672, %c16896_i32 overflow<nsw> : i32, i32 -> i32
      %687 = wave.ptr_add %118, %686 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %688 = wave.join %500, %399, %590 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %689 = wave.ptr_add %687, %295 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_110, %token_111 = waveamd.transpose_load %689 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %690 = wave.extract %value_110[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %691 = wave.extract %value_110[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %692 = wave.extract %value_110[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %693 = wave.extract %value_110[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %694 = wave.ptr_add %687, %301 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_112, %token_113 = waveamd.transpose_load %694 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %695 = wave.extract %value_112[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %696 = wave.extract %value_112[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %697 = wave.extract %value_112[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %698 = wave.extract %value_112[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %699 = wave.pack %690, %691, %692, %693, %695, %696, %697, %698 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %700 = wave.ptr_add %687, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_114, %token_115 = waveamd.transpose_load %700 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %701 = wave.extract %value_114[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %702 = wave.extract %value_114[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %703 = wave.extract %value_114[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %704 = wave.extract %value_114[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %705 = wave.ptr_add %687, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_116, %token_117 = waveamd.transpose_load %705 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %706 = wave.extract %value_116[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %707 = wave.extract %value_116[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %708 = wave.extract %value_116[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %709 = wave.extract %value_116[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %710 = wave.pack %701, %702, %703, %704, %706, %707, %708, %709 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %711 = wave.ptr_add %687, %321 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_118, %token_119 = waveamd.transpose_load %711 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %712 = wave.extract %value_118[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %713 = wave.extract %value_118[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %714 = wave.extract %value_118[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %715 = wave.extract %value_118[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %716 = wave.ptr_add %687, %327 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_120, %token_121 = waveamd.transpose_load %716 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %717 = wave.extract %value_120[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %718 = wave.extract %value_120[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %719 = wave.extract %value_120[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %720 = wave.extract %value_120[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %721 = wave.pack %712, %713, %714, %715, %717, %718, %719, %720 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %722 = wave.ptr_add %687, %334 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_122, %token_123 = waveamd.transpose_load %722 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %723 = wave.extract %value_122[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %724 = wave.extract %value_122[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %725 = wave.extract %value_122[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %726 = wave.extract %value_122[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %727 = wave.ptr_add %687, %340 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_124, %token_125 = waveamd.transpose_load %727 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %728 = wave.extract %value_124[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %729 = wave.extract %value_124[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %730 = wave.extract %value_124[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %731 = wave.extract %value_124[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %732 = wave.pack %723, %724, %725, %726, %728, %729, %730, %731 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %733 = wave.ptr_add %687, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_126, %token_127 = waveamd.transpose_load %733 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %734 = wave.extract %value_126[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %735 = wave.extract %value_126[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %736 = wave.extract %value_126[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %737 = wave.extract %value_126[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %738 = wave.ptr_add %687, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_128, %token_129 = waveamd.transpose_load %738 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %739 = wave.extract %value_128[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %740 = wave.extract %value_128[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %741 = wave.extract %value_128[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %742 = wave.extract %value_128[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %743 = wave.pack %734, %735, %736, %737, %739, %740, %741, %742 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %744 = wave.ptr_add %687, %360 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_130, %token_131 = waveamd.transpose_load %744 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %745 = wave.extract %value_130[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %746 = wave.extract %value_130[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %747 = wave.extract %value_130[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %748 = wave.extract %value_130[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %749 = wave.ptr_add %687, %366 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_132, %token_133 = waveamd.transpose_load %749 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %750 = wave.extract %value_132[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %751 = wave.extract %value_132[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %752 = wave.extract %value_132[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %753 = wave.extract %value_132[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %754 = wave.pack %745, %746, %747, %748, %750, %751, %752, %753 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %755 = wave.ptr_add %687, %373 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_134, %token_135 = waveamd.transpose_load %755 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %756 = wave.extract %value_134[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %757 = wave.extract %value_134[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %758 = wave.extract %value_134[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %759 = wave.extract %value_134[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %760 = wave.ptr_add %687, %379 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_136, %token_137 = waveamd.transpose_load %760 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %761 = wave.extract %value_136[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %762 = wave.extract %value_136[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %763 = wave.extract %value_136[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %764 = wave.extract %value_136[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %765 = wave.pack %756, %757, %758, %759, %761, %762, %763, %764 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %766 = wave.ptr_add %687, %386 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_138, %token_139 = waveamd.transpose_load %766 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %767 = wave.extract %value_138[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %768 = wave.extract %value_138[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %769 = wave.extract %value_138[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %770 = wave.extract %value_138[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %771 = wave.ptr_add %687, %392 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_140, %token_141 = waveamd.transpose_load %771 after %688 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %772 = wave.extract %value_140[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %773 = wave.extract %value_140[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %774 = wave.extract %value_140[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %775 = wave.extract %value_140[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %776 = wave.pack %767, %768, %769, %770, %772, %773, %774, %775 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %777 = wave.join %token_111, %token_113, %token_115, %token_117, %token_119, %token_121, %token_123, %token_125, %token_127, %token_129, %token_131, %token_133, %token_135, %token_137, %token_139, %token_141 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %778 = wave.join %590, %777 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %779 = waveamd.fragment_pack %value_94 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %780 = waveamd.fragment_pack %value_96 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %781 = waveamd.fragment_pack %value_98 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %782 = waveamd.fragment_pack %value_100 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %783 = waveamd.fragment_pack %value_102 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %784 = waveamd.fragment_pack %value_104 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %785 = waveamd.fragment_pack %value_106 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %786 = waveamd.fragment_pack %value_108 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %787 = waveamd.fragment_pack %699 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %788 = waveamd.fragment_pack %710 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %789 = waveamd.fragment_pack %721 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %790 = waveamd.fragment_pack %732 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %791 = waveamd.fragment_pack %743 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %792 = waveamd.fragment_pack %754 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %793 = waveamd.fragment_pack %765 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %794 = waveamd.fragment_pack %776 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %795 = waveamd.fragment_pack %625 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %796 = waveamd.fragment_pack %628 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %797 = waveamd.fragment_pack %631 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %798 = waveamd.fragment_pack %634 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %799 = waveamd.fragment_pack %637 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %800 = waveamd.fragment_pack %640 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %801 = waveamd.fragment_pack %643 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %802 = waveamd.fragment_pack %646 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %803 = waveamd.fragment_pack %649 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %804 = waveamd.fragment_pack %652 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %805 = waveamd.fragment_pack %655 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %806 = waveamd.fragment_pack %658 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %807 = waveamd.fragment_pack %661 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %808 = waveamd.fragment_pack %664 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.fragment_pack %667 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %810 = waveamd.fragment_pack %670 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %811 = waveamd.mma "mfma.f32.16x16x32.f16" %787, %779, %795 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = waveamd.mma "mfma.f32.16x16x32.f16" %788, %780, %811 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %813 = waveamd.fragment_unpack %812 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %814 = waveamd.mma "mfma.f32.16x16x32.f16" %789, %779, %796 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.mma "mfma.f32.16x16x32.f16" %790, %780, %814 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %816 = waveamd.fragment_unpack %815 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %817 = waveamd.mma "mfma.f32.16x16x32.f16" %791, %779, %797 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.mma "mfma.f32.16x16x32.f16" %792, %780, %817 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %819 = waveamd.fragment_unpack %818 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %820 = waveamd.mma "mfma.f32.16x16x32.f16" %793, %779, %798 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.mma "mfma.f32.16x16x32.f16" %794, %780, %820 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %822 = waveamd.fragment_unpack %821 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %823 = waveamd.mma "mfma.f32.16x16x32.f16" %787, %781, %799 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.mma "mfma.f32.16x16x32.f16" %788, %782, %823 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %825 = waveamd.fragment_unpack %824 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %826 = waveamd.mma "mfma.f32.16x16x32.f16" %789, %781, %800 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.mma "mfma.f32.16x16x32.f16" %790, %782, %826 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %828 = waveamd.fragment_unpack %827 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %829 = waveamd.mma "mfma.f32.16x16x32.f16" %791, %781, %801 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.mma "mfma.f32.16x16x32.f16" %792, %782, %829 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %831 = waveamd.fragment_unpack %830 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %832 = waveamd.mma "mfma.f32.16x16x32.f16" %793, %781, %802 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.mma "mfma.f32.16x16x32.f16" %794, %782, %832 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %834 = waveamd.fragment_unpack %833 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %835 = waveamd.mma "mfma.f32.16x16x32.f16" %787, %783, %803 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.mma "mfma.f32.16x16x32.f16" %788, %784, %835 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %837 = waveamd.fragment_unpack %836 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %838 = waveamd.mma "mfma.f32.16x16x32.f16" %789, %783, %804 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %839 = waveamd.mma "mfma.f32.16x16x32.f16" %790, %784, %838 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %840 = waveamd.fragment_unpack %839 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %841 = waveamd.mma "mfma.f32.16x16x32.f16" %791, %783, %805 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %842 = waveamd.mma "mfma.f32.16x16x32.f16" %792, %784, %841 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %843 = waveamd.fragment_unpack %842 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %844 = waveamd.mma "mfma.f32.16x16x32.f16" %793, %783, %806 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %845 = waveamd.mma "mfma.f32.16x16x32.f16" %794, %784, %844 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %846 = waveamd.fragment_unpack %845 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %847 = waveamd.mma "mfma.f32.16x16x32.f16" %787, %785, %807 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %848 = waveamd.mma "mfma.f32.16x16x32.f16" %788, %786, %847 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %849 = waveamd.fragment_unpack %848 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %850 = waveamd.mma "mfma.f32.16x16x32.f16" %789, %785, %808 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %851 = waveamd.mma "mfma.f32.16x16x32.f16" %790, %786, %850 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %852 = waveamd.fragment_unpack %851 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %853 = waveamd.mma "mfma.f32.16x16x32.f16" %791, %785, %809 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %854 = waveamd.mma "mfma.f32.16x16x32.f16" %792, %786, %853 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %855 = waveamd.fragment_unpack %854 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %856 = waveamd.mma "mfma.f32.16x16x32.f16" %793, %785, %810 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %857 = waveamd.mma "mfma.f32.16x16x32.f16" %794, %786, %856 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %858 = waveamd.fragment_unpack %857 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %859 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %860 = wave.assume %111 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %861 = wave.ptr_add %859, %860 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_142, %token_143 = wave.load %861 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %862 = wave.assume %112 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %863 = wave.ptr_add %859, %862 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_144, %token_145 = wave.load %863 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %864 = wave.assume %113 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %865 = wave.ptr_add %859, %864 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_146, %token_147 = wave.load %865 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %866 = wave.assume %114 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %867 = wave.ptr_add %859, %866 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_148, %token_149 = wave.load %867 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %868 = wave.cast fpconvert %value_142 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %869 = wave.cast fpconvert %value_144 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %870 = wave.cast fpconvert %value_146 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %871 = wave.cast fpconvert %value_148 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %872 = wave.splat %18 : i32 -> !wave.simd<i32, 64>
      %873 = wave.binary muli %87, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %874 = wave.binary muli %88, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %875 = wave.binary muli %89, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %876 = wave.binary muli %90, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %877 = wave.binary muli %91, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %878 = wave.binary muli %92, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %879 = wave.binary muli %93, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %880 = wave.binary muli %94, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %881 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %882 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%873, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %883 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%874, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %884 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%875, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %885 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%876, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %886 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%877, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %887 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%878, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %888 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%879, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %889 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741816 + s0 + s1 <= 0">] ["s0", "s1"](%880, %110) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %890 = wave.assume %882 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %891 = wave.ptr_add %881, %890 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_150, %token_151 = wave.load %891 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %892 = wave.extract %value_150[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %893 = wave.extract %value_150[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %894 = wave.extract %value_150[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %895 = wave.extract %value_150[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %896 = wave.extract %value_150[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %897 = wave.extract %value_150[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %898 = wave.extract %value_150[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %899 = wave.extract %value_150[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %900 = wave.assume %883 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %901 = wave.ptr_add %881, %900 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_152, %token_153 = wave.load %901 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %902 = wave.extract %value_152[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %903 = wave.extract %value_152[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %904 = wave.extract %value_152[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %905 = wave.extract %value_152[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %906 = wave.extract %value_152[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %907 = wave.extract %value_152[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %908 = wave.extract %value_152[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %909 = wave.extract %value_152[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %910 = wave.assume %884 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %911 = wave.ptr_add %881, %910 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_154, %token_155 = wave.load %911 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %912 = wave.extract %value_154[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %913 = wave.extract %value_154[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %914 = wave.extract %value_154[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %915 = wave.extract %value_154[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %916 = wave.extract %value_154[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %917 = wave.extract %value_154[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %918 = wave.extract %value_154[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %919 = wave.extract %value_154[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %920 = wave.assume %885 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %921 = wave.ptr_add %881, %920 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_156, %token_157 = wave.load %921 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %922 = wave.extract %value_156[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %923 = wave.extract %value_156[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %924 = wave.extract %value_156[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %925 = wave.extract %value_156[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %926 = wave.extract %value_156[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %927 = wave.extract %value_156[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %928 = wave.extract %value_156[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %929 = wave.extract %value_156[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %930 = wave.assume %886 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %931 = wave.ptr_add %881, %930 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_158, %token_159 = wave.load %931 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %932 = wave.extract %value_158[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %933 = wave.extract %value_158[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %934 = wave.extract %value_158[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %935 = wave.extract %value_158[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %936 = wave.extract %value_158[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %937 = wave.extract %value_158[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %938 = wave.extract %value_158[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %939 = wave.extract %value_158[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %940 = wave.assume %887 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %941 = wave.ptr_add %881, %940 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_160, %token_161 = wave.load %941 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %942 = wave.extract %value_160[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %943 = wave.extract %value_160[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %944 = wave.extract %value_160[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %945 = wave.extract %value_160[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %946 = wave.extract %value_160[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %947 = wave.extract %value_160[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %948 = wave.extract %value_160[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %949 = wave.extract %value_160[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %950 = wave.assume %888 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %951 = wave.ptr_add %881, %950 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_162, %token_163 = wave.load %951 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %952 = wave.extract %value_162[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %953 = wave.extract %value_162[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %954 = wave.extract %value_162[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %955 = wave.extract %value_162[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %956 = wave.extract %value_162[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %957 = wave.extract %value_162[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %958 = wave.extract %value_162[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %959 = wave.extract %value_162[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %960 = wave.assume %889 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %961 = wave.ptr_add %881, %960 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_164, %token_165 = wave.load %961 {cache = #waveamd.load_cache<cs>} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %962 = wave.extract %value_164[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %963 = wave.extract %value_164[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %964 = wave.extract %value_164[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %965 = wave.extract %value_164[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %966 = wave.extract %value_164[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %967 = wave.extract %value_164[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %968 = wave.extract %value_164[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %969 = wave.extract %value_164[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %970 = wave.cast fpconvert %892 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %971 = wave.cast fpconvert %893 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %972 = wave.cast fpconvert %894 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %973 = wave.cast fpconvert %895 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %974 = wave.cast fpconvert %896 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %975 = wave.cast fpconvert %897 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %976 = wave.cast fpconvert %898 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %977 = wave.cast fpconvert %899 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %978 = wave.cast fpconvert %902 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %979 = wave.cast fpconvert %903 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %980 = wave.cast fpconvert %904 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %981 = wave.cast fpconvert %905 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %982 = wave.cast fpconvert %906 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %983 = wave.cast fpconvert %907 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %984 = wave.cast fpconvert %908 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %985 = wave.cast fpconvert %909 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %986 = wave.cast fpconvert %912 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %987 = wave.cast fpconvert %913 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %988 = wave.cast fpconvert %914 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %989 = wave.cast fpconvert %915 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %990 = wave.cast fpconvert %916 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %991 = wave.cast fpconvert %917 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %992 = wave.cast fpconvert %918 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %993 = wave.cast fpconvert %919 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %994 = wave.cast fpconvert %922 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %995 = wave.cast fpconvert %923 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %996 = wave.cast fpconvert %924 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %997 = wave.cast fpconvert %925 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %998 = wave.cast fpconvert %926 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %999 = wave.cast fpconvert %927 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1000 = wave.cast fpconvert %928 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1001 = wave.cast fpconvert %929 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1002 = wave.cast fpconvert %932 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1003 = wave.cast fpconvert %933 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1004 = wave.cast fpconvert %934 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1005 = wave.cast fpconvert %935 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1006 = wave.cast fpconvert %936 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1007 = wave.cast fpconvert %937 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1008 = wave.cast fpconvert %938 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1009 = wave.cast fpconvert %939 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1010 = wave.cast fpconvert %942 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1011 = wave.cast fpconvert %943 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1012 = wave.cast fpconvert %944 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1013 = wave.cast fpconvert %945 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1014 = wave.cast fpconvert %946 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1015 = wave.cast fpconvert %947 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1016 = wave.cast fpconvert %948 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1017 = wave.cast fpconvert %949 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1018 = wave.cast fpconvert %952 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1019 = wave.cast fpconvert %953 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1020 = wave.cast fpconvert %954 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1021 = wave.cast fpconvert %955 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1022 = wave.cast fpconvert %956 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1023 = wave.cast fpconvert %957 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1024 = wave.cast fpconvert %958 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1025 = wave.cast fpconvert %959 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1026 = wave.cast fpconvert %962 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1027 = wave.cast fpconvert %963 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1028 = wave.cast fpconvert %964 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1029 = wave.cast fpconvert %965 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1030 = wave.cast fpconvert %966 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1031 = wave.cast fpconvert %967 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1032 = wave.cast fpconvert %968 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1033 = wave.cast fpconvert %969 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1034 = wave.fadd %813, %868 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1035 = wave.fadd %816, %869 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1036 = wave.fadd %819, %870 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1037 = wave.fadd %822, %871 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1038 = wave.fadd %825, %868 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1039 = wave.fadd %828, %869 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1040 = wave.fadd %831, %870 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1041 = wave.fadd %834, %871 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1042 = wave.fadd %837, %868 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1043 = wave.fadd %840, %869 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1044 = wave.fadd %843, %870 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1045 = wave.fadd %846, %871 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1046 = wave.fadd %849, %868 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1047 = wave.fadd %852, %869 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1048 = wave.fadd %855, %870 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1049 = wave.fadd %858, %871 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1050 = wave.alloc() {align = 16 : i64, bytesize = 32768 : i64} : !wave.ptr<#wave.shared, f32>
      %1051 = wave.barrier %399, %294, %685, %778 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1052 = wave.index_expr <"xor(256*Mod(floor(1/256*wi), 2), xor(128*Mod(floor(1/128*wi), 2), xor(1032*Mod(floor(1/64*wi), 2), xor(4*Mod(wi, 2) + 64*Mod(floor(1/16*wi), 2) + 32*Mod(floor(1/8*wi), 2) + 16*Mod(floor(1/4*wi), 2) + 8*Mod(floor(1/2*wi), 2), 516*Mod(floor(1/32*wi), 2)))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1053 = wave.ptr_add %1050, %1052 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %1054 = wave.store %1034 -> %1053 after %1051 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1055 = wave.index_expr <"xor(256*Mod(floor(1/256*wi), 2), xor(128*Mod(floor(1/128*wi), 2), xor(1032*Mod(floor(1/64*wi), 2), xor(516*Mod(floor(1/32*wi), 2), xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(2064 + 4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2)))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1056 = wave.ptr_add %1050, %1055 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %1057 = wave.store %1035 -> %1056 after %1051 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1058 = wave.index_expr <"xor(256*Mod(floor(1/256*wi), 2), xor(128*Mod(floor(1/128*wi), 2), xor(1032*Mod(floor(1/64*wi), 2), xor(516*Mod(floor(1/32*wi), 2), xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(4128 + 4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2)))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1059 = wave.ptr_add %1050, %1058 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %1060 = wave.store %1036 -> %1059 after %1051 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1061 = wave.index_expr <"xor(256*Mod(floor(1/256*wi), 2), xor(128*Mod(floor(1/128*wi), 2), xor(1032*Mod(floor(1/64*wi), 2), xor(516*Mod(floor(1/32*wi), 2), xor(64*Mod(floor(1/16*wi), 2), xor(32*Mod(floor(1/8*wi), 2), xor(16*Mod(floor(1/4*wi), 2), xor(6192 + 4*Mod(wi, 2), 8*Mod(floor(1/2*wi), 2)))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1062 = wave.ptr_add %1050, %1061 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %1063 = wave.store %1037 -> %1062 after %1051 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1064 = wave.barrier %1054, %1057, %1060, %1063 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1065 = wave.index_expr <"xor(32*Mod(floor(1/256*wi), 2), xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(4128*Mod(floor(1/16*wi), 2), xor(2064*Mod(floor(1/8*wi), 2), xor(128*Mod(floor(1/4*wi), 2), xor(516*Mod(wi, 2), 1032*Mod(floor(1/2*wi), 2)))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1066 = wave.ptr_add %1050, %1065 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %value_166, %token_167 = wave.load %1066 after %1064 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1067 = wave.extract %value_166[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1068 = wave.extract %value_166[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1069 = wave.extract %value_166[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1070 = wave.extract %value_166[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1071 = wave.index_expr <"xor(32*Mod(floor(1/256*wi), 2), xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(4128*Mod(floor(1/16*wi), 2), xor(2064*Mod(floor(1/8*wi), 2), xor(128*Mod(floor(1/4*wi), 2), xor(1032*Mod(floor(1/2*wi), 2), xor(64, 516*Mod(wi, 2))))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1072 = wave.ptr_add %1050, %1071 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %value_168, %token_169 = wave.load %1072 after %1064 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1073 = wave.extract %value_168[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1074 = wave.extract %value_168[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1075 = wave.extract %value_168[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1076 = wave.extract %value_168[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1077 = wave.index_expr <"xor(32*Mod(floor(1/256*wi), 2), xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(4128*Mod(floor(1/16*wi), 2), xor(2064*Mod(floor(1/8*wi), 2), xor(128*Mod(floor(1/4*wi), 2), xor(1032*Mod(floor(1/2*wi), 2), xor(256, 516*Mod(wi, 2))))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1078 = wave.ptr_add %1050, %1077 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %value_170, %token_171 = wave.load %1078 after %1064 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1079 = wave.extract %value_170[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1080 = wave.extract %value_170[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1081 = wave.extract %value_170[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1082 = wave.extract %value_170[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1083 = wave.index_expr <"xor(32*Mod(floor(1/256*wi), 2), xor(16*Mod(floor(1/128*wi), 2), xor(8*Mod(floor(1/64*wi), 2), xor(4*Mod(floor(1/32*wi), 2), xor(4128*Mod(floor(1/16*wi), 2), xor(2064*Mod(floor(1/8*wi), 2), xor(128*Mod(floor(1/4*wi), 2), xor(1032*Mod(floor(1/2*wi), 2), xor(320, 516*Mod(wi, 2))))))))))"> ["wi"](%41) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1084 = wave.ptr_add %1050, %1083 : !wave.ptr<#wave.shared, f32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f32>, 64>
      %value_172, %token_173 = wave.load %1084 after %1064 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1085 = wave.extract %value_172[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1086 = wave.extract %value_172[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1087 = wave.extract %value_172[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1088 = wave.extract %value_172[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1089 = wave.join %token_167, %token_169, %token_171, %token_173 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1090 = wave.barrier %1089 : (!wave.mem.token) -> !wave.mem.token
      %1091 = wave.store %1038 -> %1053 after %1090 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1092 = wave.store %1039 -> %1056 after %1090 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1093 = wave.store %1040 -> %1059 after %1090 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1094 = wave.store %1041 -> %1062 after %1090 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1095 = wave.barrier %1091, %1092, %1093, %1094 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_174, %token_175 = wave.load %1066 after %1095 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1096 = wave.extract %value_174[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1097 = wave.extract %value_174[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1098 = wave.extract %value_174[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1099 = wave.extract %value_174[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_176, %token_177 = wave.load %1072 after %1095 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1100 = wave.extract %value_176[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1101 = wave.extract %value_176[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1102 = wave.extract %value_176[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1103 = wave.extract %value_176[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_178, %token_179 = wave.load %1078 after %1095 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1104 = wave.extract %value_178[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1105 = wave.extract %value_178[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1106 = wave.extract %value_178[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1107 = wave.extract %value_178[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_180, %token_181 = wave.load %1084 after %1095 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1108 = wave.extract %value_180[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1109 = wave.extract %value_180[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1110 = wave.extract %value_180[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1111 = wave.extract %value_180[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1112 = wave.join %token_175, %token_177, %token_179, %token_181 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1113 = wave.barrier %1112 : (!wave.mem.token) -> !wave.mem.token
      %1114 = wave.store %1042 -> %1053 after %1113 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1115 = wave.store %1043 -> %1056 after %1113 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1116 = wave.store %1044 -> %1059 after %1113 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1117 = wave.store %1045 -> %1062 after %1113 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1118 = wave.barrier %1114, %1115, %1116, %1117 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_182, %token_183 = wave.load %1066 after %1118 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1119 = wave.extract %value_182[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1120 = wave.extract %value_182[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1121 = wave.extract %value_182[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1122 = wave.extract %value_182[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_184, %token_185 = wave.load %1072 after %1118 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1123 = wave.extract %value_184[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1124 = wave.extract %value_184[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1125 = wave.extract %value_184[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1126 = wave.extract %value_184[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_186, %token_187 = wave.load %1078 after %1118 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1127 = wave.extract %value_186[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1128 = wave.extract %value_186[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1129 = wave.extract %value_186[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1130 = wave.extract %value_186[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_188, %token_189 = wave.load %1084 after %1118 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1131 = wave.extract %value_188[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1132 = wave.extract %value_188[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1133 = wave.extract %value_188[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1134 = wave.extract %value_188[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1135 = wave.join %token_183, %token_185, %token_187, %token_189 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1136 = wave.barrier %1135 : (!wave.mem.token) -> !wave.mem.token
      %1137 = wave.store %1046 -> %1053 after %1136 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1138 = wave.store %1047 -> %1056 after %1136 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1139 = wave.store %1048 -> %1059 after %1136 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1140 = wave.store %1049 -> %1062 after %1136 : (!wave.simd<vector<4xf32>, 64>, !wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> !wave.mem.token
      %1141 = wave.barrier %1137, %1138, %1139, %1140 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %value_190, %token_191 = wave.load %1066 after %1141 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1142 = wave.extract %value_190[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1143 = wave.extract %value_190[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1144 = wave.extract %value_190[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1145 = wave.extract %value_190[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_192, %token_193 = wave.load %1072 after %1141 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1146 = wave.extract %value_192[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1147 = wave.extract %value_192[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1148 = wave.extract %value_192[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1149 = wave.extract %value_192[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_194, %token_195 = wave.load %1078 after %1141 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1150 = wave.extract %value_194[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1151 = wave.extract %value_194[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1152 = wave.extract %value_194[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1153 = wave.extract %value_194[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %value_196, %token_197 = wave.load %1084 after %1141 : (!wave.simd<!wave.ptr<#wave.shared, f32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf32>, 64>, !wave.mem.token)
      %1154 = wave.extract %value_196[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1155 = wave.extract %value_196[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1156 = wave.extract %value_196[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1157 = wave.extract %value_196[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
      %1158 = wave.fma %1067, %970, %1067 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1159 = wave.fma %1068, %971, %1068 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1160 = wave.fma %1069, %972, %1069 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1161 = wave.fma %1070, %973, %1070 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1162 = wave.fma %1073, %974, %1073 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1163 = wave.fma %1074, %975, %1074 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1164 = wave.fma %1075, %976, %1075 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1165 = wave.fma %1076, %977, %1076 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1166 = wave.fma %1079, %978, %1079 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1167 = wave.fma %1080, %979, %1080 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1168 = wave.fma %1081, %980, %1081 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1169 = wave.fma %1082, %981, %1082 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1170 = wave.fma %1085, %982, %1085 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1171 = wave.fma %1086, %983, %1086 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1172 = wave.fma %1087, %984, %1087 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1173 = wave.fma %1088, %985, %1088 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1174 = wave.fma %1096, %986, %1096 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1175 = wave.fma %1097, %987, %1097 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1176 = wave.fma %1098, %988, %1098 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1177 = wave.fma %1099, %989, %1099 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1178 = wave.fma %1100, %990, %1100 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1179 = wave.fma %1101, %991, %1101 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1180 = wave.fma %1102, %992, %1102 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1181 = wave.fma %1103, %993, %1103 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1182 = wave.fma %1104, %994, %1104 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1183 = wave.fma %1105, %995, %1105 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1184 = wave.fma %1106, %996, %1106 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1185 = wave.fma %1107, %997, %1107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1186 = wave.fma %1108, %998, %1108 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1187 = wave.fma %1109, %999, %1109 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1188 = wave.fma %1110, %1000, %1110 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1189 = wave.fma %1111, %1001, %1111 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1190 = wave.fma %1119, %1002, %1119 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1191 = wave.fma %1120, %1003, %1120 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1192 = wave.fma %1121, %1004, %1121 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1193 = wave.fma %1122, %1005, %1122 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1194 = wave.fma %1123, %1006, %1123 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1195 = wave.fma %1124, %1007, %1124 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1196 = wave.fma %1125, %1008, %1125 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1197 = wave.fma %1126, %1009, %1126 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1198 = wave.fma %1127, %1010, %1127 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1199 = wave.fma %1128, %1011, %1128 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1200 = wave.fma %1129, %1012, %1129 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1201 = wave.fma %1130, %1013, %1130 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1202 = wave.fma %1131, %1014, %1131 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1203 = wave.fma %1132, %1015, %1132 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1204 = wave.fma %1133, %1016, %1133 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1205 = wave.fma %1134, %1017, %1134 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1206 = wave.fma %1142, %1018, %1142 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1207 = wave.fma %1143, %1019, %1143 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1208 = wave.fma %1144, %1020, %1144 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1209 = wave.fma %1145, %1021, %1145 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1210 = wave.fma %1146, %1022, %1146 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1211 = wave.fma %1147, %1023, %1147 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1212 = wave.fma %1148, %1024, %1148 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1213 = wave.fma %1149, %1025, %1149 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1214 = wave.fma %1150, %1026, %1150 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1215 = wave.fma %1151, %1027, %1151 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1216 = wave.fma %1152, %1028, %1152 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1217 = wave.fma %1153, %1029, %1153 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1218 = wave.fma %1154, %1030, %1154 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1219 = wave.fma %1155, %1031, %1155 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1220 = wave.fma %1156, %1032, %1156 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1221 = wave.fma %1157, %1033, %1157 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1222 = wave.splat %19 : i32 -> !wave.simd<i32, 64>
      %1223 = wave.binary muli %87, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1224 = wave.binary muli %88, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1225 = wave.binary muli %89, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1226 = wave.binary muli %90, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1227 = wave.binary muli %91, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1228 = wave.binary muli %92, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1229 = wave.binary muli %93, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1230 = wave.binary muli %94, %1222 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1231 = wave.binary addi %1223, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1232 = wave.binary addi %1224, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1233 = wave.binary addi %1225, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1234 = wave.binary addi %1226, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1235 = wave.binary addi %1227, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1236 = wave.binary addi %1228, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1237 = wave.binary addi %1229, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1238 = wave.binary addi %1230, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1239 = wave.cast fpconvert %1158 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1240 = wave.cast fpconvert %1159 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1241 = wave.cast fpconvert %1160 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1242 = wave.cast fpconvert %1161 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1243 = wave.cast fpconvert %1162 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1244 = wave.cast fpconvert %1163 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1245 = wave.cast fpconvert %1164 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1246 = wave.cast fpconvert %1165 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1247 = wave.cast fpconvert %1166 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1248 = wave.cast fpconvert %1167 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1249 = wave.cast fpconvert %1168 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1250 = wave.cast fpconvert %1169 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1251 = wave.cast fpconvert %1170 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1252 = wave.cast fpconvert %1171 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1253 = wave.cast fpconvert %1172 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1254 = wave.cast fpconvert %1173 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1255 = wave.cast fpconvert %1174 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1256 = wave.cast fpconvert %1175 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1257 = wave.cast fpconvert %1176 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1258 = wave.cast fpconvert %1177 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1259 = wave.cast fpconvert %1178 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1260 = wave.cast fpconvert %1179 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1261 = wave.cast fpconvert %1180 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1262 = wave.cast fpconvert %1181 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1263 = wave.cast fpconvert %1182 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1264 = wave.cast fpconvert %1183 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1265 = wave.cast fpconvert %1184 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1266 = wave.cast fpconvert %1185 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1267 = wave.cast fpconvert %1186 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1268 = wave.cast fpconvert %1187 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1269 = wave.cast fpconvert %1188 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1270 = wave.cast fpconvert %1189 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1271 = wave.cast fpconvert %1190 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1272 = wave.cast fpconvert %1191 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1273 = wave.cast fpconvert %1192 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1274 = wave.cast fpconvert %1193 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1275 = wave.cast fpconvert %1194 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1276 = wave.cast fpconvert %1195 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1277 = wave.cast fpconvert %1196 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1278 = wave.cast fpconvert %1197 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1279 = wave.cast fpconvert %1198 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1280 = wave.cast fpconvert %1199 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1281 = wave.cast fpconvert %1200 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1282 = wave.cast fpconvert %1201 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1283 = wave.cast fpconvert %1202 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1284 = wave.cast fpconvert %1203 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1285 = wave.cast fpconvert %1204 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1286 = wave.cast fpconvert %1205 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1287 = wave.cast fpconvert %1206 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1288 = wave.cast fpconvert %1207 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1289 = wave.cast fpconvert %1208 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1290 = wave.cast fpconvert %1209 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1291 = wave.cast fpconvert %1210 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1292 = wave.cast fpconvert %1211 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1293 = wave.cast fpconvert %1212 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1294 = wave.cast fpconvert %1213 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1295 = wave.cast fpconvert %1214 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1296 = wave.cast fpconvert %1215 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1297 = wave.cast fpconvert %1216 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1298 = wave.cast fpconvert %1217 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1299 = wave.cast fpconvert %1218 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1300 = wave.cast fpconvert %1219 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1301 = wave.cast fpconvert %1220 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1302 = wave.cast fpconvert %1221 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1303 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %1304 = wave.pack %1239, %1240, %1241, %1242, %1243, %1244, %1245, %1246 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1305 = wave.assume %1231 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1306 = wave.ptr_add %1303, %1305 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1307 = wave.store %1304 -> %1306 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1308 = wave.pack %1247, %1248, %1249, %1250, %1251, %1252, %1253, %1254 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1309 = wave.assume %1232 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1310 = wave.ptr_add %1303, %1309 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1311 = wave.store %1308 -> %1310 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1312 = wave.pack %1255, %1256, %1257, %1258, %1259, %1260, %1261, %1262 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1313 = wave.assume %1233 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1314 = wave.ptr_add %1303, %1313 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1315 = wave.store %1312 -> %1314 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1316 = wave.pack %1263, %1264, %1265, %1266, %1267, %1268, %1269, %1270 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1317 = wave.assume %1234 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1318 = wave.ptr_add %1303, %1317 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1319 = wave.store %1316 -> %1318 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1320 = wave.pack %1271, %1272, %1273, %1274, %1275, %1276, %1277, %1278 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1321 = wave.assume %1235 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1322 = wave.ptr_add %1303, %1321 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1323 = wave.store %1320 -> %1322 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1324 = wave.pack %1279, %1280, %1281, %1282, %1283, %1284, %1285, %1286 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1325 = wave.assume %1236 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1326 = wave.ptr_add %1303, %1325 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1327 = wave.store %1324 -> %1326 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1328 = wave.pack %1287, %1288, %1289, %1290, %1291, %1292, %1293, %1294 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1329 = wave.assume %1237 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1330 = wave.ptr_add %1303, %1329 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1331 = wave.store %1328 -> %1330 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1332 = wave.pack %1295, %1296, %1297, %1298, %1299, %1300, %1301, %1302 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %1333 = wave.assume %1238 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<i32, 64>
      %1334 = wave.ptr_add %1303, %1333 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1335 = wave.store %1332 -> %1334 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<8xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      return
    }
  }
}
