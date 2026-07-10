module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_optimized_async(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 8192 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 1024 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 512 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %8 = wave.constant 120 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 104 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 88 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %14 = wave.constant 72 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 56 : i32 -> !wave.simd<i32, 64>
      %16 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %17 = wave.constant 40 : i32 -> !wave.simd<i32, 64>
      %18 = wave.constant 24 : i32 -> !wave.simd<i32, 64>
      %19 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %20 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %21 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %22 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %23 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %24 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %25 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %26 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %c7920_i32 = arith.constant 7920 : i32
      %c7392_i32 = arith.constant 7392 : i32
      %c6864_i32 = arith.constant 6864 : i32
      %c6336_i32 = arith.constant 6336 : i32
      %c5808_i32 = arith.constant 5808 : i32
      %c5280_i32 = arith.constant 5280 : i32
      %c4752_i32 = arith.constant 4752 : i32
      %c3696_i32 = arith.constant 3696 : i32
      %c3168_i32 = arith.constant 3168 : i32
      %c2640_i32 = arith.constant 2640 : i32
      %c1584_i32 = arith.constant 1584 : i32
      %c1056_i32 = arith.constant 1056 : i32
      %c528_i32 = arith.constant 528 : i32
      %c66_i32 = arith.constant 66 : i32
      %c4224_i32 = arith.constant 4224 : i32
      %c8448_i32 = arith.constant 8448 : i32
      %c2112_i32 = arith.constant 2112 : i32
      %c264_i32 = arith.constant 264 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c4_i32 = arith.constant 4 : i32
      %c128_i32 = arith.constant 128 : i32
      %c1_i32 = arith.constant 1 : i32
      %c3_i32 = arith.constant 3 : i32
      %c64_i32 = arith.constant 64 : i32
      %c2_i32 = arith.constant 2 : i32
      %c-1_i32 = arith.constant -1 : i32
      %c127_i32 = arith.constant 127 : i32
      %c8_i32 = arith.constant 8 : i32
      %c32_i32 = arith.constant 32 : i32
      %c63_i32 = arith.constant 63 : i32
      %c0_i32 = arith.constant 0 : i32
      %27 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %28 = wave.pack %27, %27, %27, %27 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %29 = wave.assume %arg8 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %30 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %31 = wave.assume %arg10 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %32 = wave.workgroup_id 0
      %33 = wave.binary addi %arg5, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %34 = wave.binary divsi %33, %c128_i32 : i32, i32 -> i32
      %35 = wave.binary addi %arg6, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %36 = wave.binary divsi %35, %c128_i32 : i32, i32 -> i32
      %37 = wave.binary muli %34, %36 : i32, i32 -> i32
      %38 = wave.binary divsi %37, %c32_i32 : i32, i32 -> i32
      %39 = wave.binary muli %38, %c32_i32 : i32, i32 -> i32
      %40 = arith.cmpi sge, %32, %39 : i32
      %41 = scf.if %40 -> (i32) {
        scf.yield %32 : i32
      } else {
        %1128 = wave.binary remui %32, %c8_i32 : i32, i32 -> i32
        %1129 = wave.binary divui %32, %c8_i32 : i32, i32 -> i32
        %1130 = wave.binary divui %1129, %c4_i32 : i32, i32 -> i32
        %1131 = wave.binary muli %1130, %c32_i32 overflow<nsw> : i32, i32 -> i32
        %1132 = wave.binary muli %1128, %c4_i32 overflow<nsw> : i32, i32 -> i32
        %1133 = wave.binary addi %1131, %1132 overflow<nsw> : i32, i32 -> i32
        %1134 = wave.binary remui %1129, %c4_i32 : i32, i32 -> i32
        %1135 = wave.binary addi %1133, %1134 overflow<nsw> : i32, i32 -> i32
        scf.yield %1135 : i32
      }
      %42 = wave.binary muli %36, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %43 = wave.binary divsi %41, %42 : i32, i32 -> i32
      %44 = wave.binary muli %43, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %45 = wave.binary subi %34, %44 overflow<nsw> : i32, i32 -> i32
      %46 = arith.cmpi slt, %45, %c4_i32 : i32
      %47 = wave.select %46, %45, %c4_i32 : i32
      %48 = wave.binary remsi %41, %42 : i32, i32 -> i32
      %49 = wave.binary remsi %48, %47 : i32, i32 -> i32
      %50 = wave.binary addi %44, %49 overflow<nsw> : i32, i32 -> i32
      %51 = wave.binary divsi %48, %47 : i32, i32 -> i32
      %52 = wave.binary muli %50, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %53 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %54 = wave.binary divui %53, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %55 = wave.binary remui %54, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %56 = wave.binary muli %55, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %57 = wave.binary divui %53, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %58 = wave.binary remui %57, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary muli %58, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary addi %56, %59 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary divui %53, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary remui %61, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary muli %62, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary addi %60, %63 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary divui %53, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary remui %65, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary addi %64, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary divui %53, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.binary remui %68, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.binary muli %69, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary addi %67, %70 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary divui %53, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary remui %72, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary muli %73, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.binary addi %71, %74 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %76 = wave.binary addi %75, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary remui %53, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary muli %77, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary remui %53, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary muli %79, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary remui %57, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary muli %81, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary addi %82, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.binary remui %65, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.binary addi %84, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary addi %84, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary addi %84, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.binary addi %84, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %89 = wave.binary addi %84, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %90 = wave.binary addi %84, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary addi %84, %15 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %92 = wave.binary addi %84, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %93 = wave.binary addi %84, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %94 = wave.binary addi %84, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %95 = wave.binary addi %84, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %96 = wave.binary addi %84, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %97 = wave.binary addi %84, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %98 = wave.binary addi %84, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %99 = wave.binary addi %84, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %100 = wave.binary remui %53, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %101 = wave.binary divui %53, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %102 = wave.binary remui %101, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %103 = wave.binary muli %102, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %104 = wave.binary addi %100, %103 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %105 = wave.binary divui %53, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %106 = wave.binary remui %105, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %107 = wave.binary muli %106, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %108 = wave.binary addi %104, %107 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %109 = wave.binary muli %55, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %110 = wave.binary addi %108, %109 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %111 = wave.binary muli %73, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %112 = wave.binary addi %110, %111 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %113 = wave.binary addi %112, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %114 = wave.binary addi %112, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %115 = wave.binary addi %112, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %116 = wave.splat %52 : i32 -> !wave.simd<i32, 64>
      %117 = wave.binary addi %116, %75 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %118 = wave.binary addi %116, %76 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %119 = wave.binary addi %116, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %120 = wave.binary addi %116, %85 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %121 = wave.binary addi %116, %86 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %122 = wave.binary addi %116, %87 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %123 = wave.binary addi %116, %88 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %124 = wave.binary addi %116, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %125 = wave.binary addi %116, %90 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %126 = wave.binary addi %116, %91 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %127 = wave.binary addi %116, %92 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %128 = wave.binary addi %116, %93 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %129 = wave.binary addi %116, %94 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %130 = wave.binary addi %116, %95 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %131 = wave.binary addi %116, %96 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %132 = wave.binary addi %116, %97 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %133 = wave.binary addi %116, %98 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %134 = wave.binary addi %116, %99 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %135 = wave.binary addi %116, %112 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %136 = wave.binary addi %116, %113 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %137 = wave.binary addi %116, %114 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %138 = wave.binary addi %116, %115 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %139 = wave.binary muli %51, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %140 = wave.splat %139 : i32 -> !wave.simd<i32, 64>
      %141 = wave.binary addi %140, %78 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %142 = wave.binary addi %140, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %143 = wave.binary addi %140, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %144 = wave.binary addi %140, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %145 = wave.splat %arg5 : i32 -> !wave.simd<i32, 64>
      %146 = wave.binary remsi %117, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %147 = wave.binary remsi %118, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %148 = wave.binary remsi %119, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %149 = wave.binary remsi %120, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %150 = wave.binary remsi %121, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %151 = wave.binary remsi %122, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %152 = wave.binary remsi %123, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %153 = wave.binary remsi %124, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %154 = wave.binary remsi %125, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %155 = wave.binary remsi %126, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %156 = wave.binary remsi %127, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %157 = wave.binary remsi %128, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %158 = wave.binary remsi %129, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %159 = wave.binary remsi %130, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %160 = wave.binary remsi %131, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %161 = wave.binary remsi %132, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %162 = wave.binary remsi %133, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %163 = wave.binary remsi %134, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %164 = wave.splat %arg6 : i32 -> !wave.simd<i32, 64>
      %165 = wave.binary remsi %141, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %166 = wave.binary remsi %142, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %167 = wave.binary remsi %143, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %168 = wave.binary remsi %144, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %169 = wave.binary addi %arg7, %c63_i32 overflow<nsw> : i32, i32 -> i32
      %170 = wave.binary divsi %169, %c64_i32 : i32, i32 -> i32
      %171 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %172 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %173 = wave.binary remui %53, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %174 = wave.binary muli %173, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %175 = wave.binary muli %58, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %176 = wave.binary muli %62, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %177 = wave.binary addi %175, %176 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %178 = wave.binary addi %177, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %179 = wave.binary addi %178, %70 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %180 = wave.binary muli %73, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %181 = wave.binary addi %179, %180 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %182 = wave.binary addi %181, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %183 = wave.splat %arg7 : i32 -> !wave.simd<i32, 64>
      %184 = wave.cmpi slt %174, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %185 = wave.splat %29 : i32 -> !wave.simd<i32, 64>
      %186 = wave.binary muli %146, %185 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %187 = wave.binary muli %147, %185 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %188 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %189 = wave.token : !wave.mem.token
      %190 = wave.ptr_cast %171 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %191 = wave.read_first %53 : !wave.simd<i32, 64> -> i32
      %192 = wave.assume %191 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
      %193 = wave.binary divui %192, %c64_i32 : i32, i32 -> i32
      %194 = wave.binary muli %193, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %195 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %186) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %196 = wave.assume %195 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %197 = wave.ptr_add %188, %196 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %198 = wave.ptr_add %190, %194 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %199 = wave.ptr_add %188, %7 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %200 = wave.select %184, %197, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %201 = waveamd.dma_load_lds %200 -> %198 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %202 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %203 = wave.assume %202 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %204 = wave.ptr_add %188, %203 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %205 = wave.binary addi %194, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %206 = wave.ptr_add %190, %205 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %207 = wave.select %184, %204, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %208 = waveamd.dma_load_lds %207 -> %206 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %209 = wave.join %201, %208 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %210 = wave.cmpi slt %181, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %211 = wave.cmpi slt %182, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %212 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %213 = wave.ptr_cast %172 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %214 = wave.index_expr <"s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1"](%53, %30, %165) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %215 = wave.assume %214 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %216 = wave.ptr_add %212, %215 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %217 = wave.ptr_add %213, %194 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %218 = wave.ptr_add %212, %7 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %219 = wave.select %210, %216, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %220 = waveamd.dma_load_lds %219 -> %217 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %221 = wave.index_expr <"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1"](%53, %30, %165) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %222 = wave.assume %221 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %223 = wave.ptr_add %212, %222 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %224 = wave.ptr_add %213, %205 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %225 = wave.select %211, %223, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %226 = waveamd.dma_load_lds %225 -> %224 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %227 = wave.join %220, %226 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %228 = wave.join %209, %227 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %229 = wave.binary subi %arg7, %c64_i32 : i32, i32 -> i32
      %230 = wave.splat %229 : i32 -> !wave.simd<i32, 64>
      %231 = wave.cmpi slt %174, %230 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %232 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %186) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %233 = wave.assume %232 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %234 = wave.ptr_add %188, %233 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %235 = wave.binary addi %c4224_i32, %194 overflow<nsw> : i32, i32 -> i32
      %236 = wave.ptr_add %190, %235 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %237 = wave.select %231, %234, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %238 = waveamd.dma_load_lds %237 -> %236 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %239 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %240 = wave.assume %239 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %241 = wave.ptr_add %188, %240 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %242 = wave.binary addi %c4224_i32, %205 overflow<nsw> : i32, i32 -> i32
      %243 = wave.ptr_add %190, %242 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %244 = wave.select %231, %241, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %245 = waveamd.dma_load_lds %244 -> %243 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %246 = wave.join %238, %245 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %247 = wave.cmpi slt %181, %230 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %248 = wave.cmpi slt %182, %230 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %249 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %250 = wave.binary muli %249, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %251 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %249, %165, %250) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %252 = wave.assume %251 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %253 = wave.ptr_add %212, %252 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %254 = wave.ptr_add %213, %235 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %255 = wave.select %247, %253, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %256 = waveamd.dma_load_lds %255 -> %254 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %257 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %249, %165, %250) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %258 = wave.assume %257 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %259 = wave.ptr_add %212, %258 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %260 = wave.ptr_add %213, %242 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %261 = wave.select %248, %259, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %262 = waveamd.dma_load_lds %261 -> %260 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %263 = wave.join %256, %262 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %264 = wave.join %246, %263 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %265 = wave.binary subi %arg7, %c128_i32 : i32, i32 -> i32
      %266 = wave.splat %265 : i32 -> !wave.simd<i32, 64>
      %267 = wave.cmpi slt %174, %266 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %268 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %186) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %269 = wave.assume %268 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %270 = wave.ptr_add %188, %269 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %271 = wave.binary addi %c8448_i32, %194 overflow<nsw> : i32, i32 -> i32
      %272 = wave.ptr_add %190, %271 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %273 = wave.select %267, %270, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %274 = waveamd.dma_load_lds %273 -> %272 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %275 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %276 = wave.assume %275 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %277 = wave.ptr_add %188, %276 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %278 = wave.binary addi %c8448_i32, %205 overflow<nsw> : i32, i32 -> i32
      %279 = wave.ptr_add %190, %278 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %280 = wave.select %267, %277, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %281 = waveamd.dma_load_lds %280 -> %279 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %282 = wave.join %274, %281 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %283 = wave.cmpi slt %181, %266 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %284 = wave.cmpi slt %182, %266 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %285 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %286 = wave.binary muli %285, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %287 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %285, %286, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %288 = wave.assume %287 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %289 = wave.ptr_add %212, %288 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %290 = wave.ptr_add %213, %271 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %291 = wave.select %283, %289, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %292 = waveamd.dma_load_lds %291 -> %290 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %293 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %285, %286, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %294 = wave.assume %293 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %295 = wave.ptr_add %212, %294 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %296 = wave.ptr_add %213, %278 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %297 = wave.select %284, %295, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %298 = waveamd.dma_load_lds %297 -> %296 after %189 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %299 = wave.join %292, %298 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %300 = wave.join %282, %299 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %301 = wave.barrier %228, %264 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %302 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %303 = wave.ptr_add %171, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %303 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %304 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %305 = wave.ptr_add %171, %304 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %305 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %306 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %307 = wave.ptr_add %171, %306 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %307 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %308 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %309 = wave.ptr_add %171, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %309 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %310 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %311 = wave.ptr_add %171, %310 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %311 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %312 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %313 = wave.ptr_add %171, %312 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %313 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %314 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %315 = wave.ptr_add %171, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %315 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %316 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %317 = wave.ptr_add %171, %316 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %317 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %318 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %319 = wave.index_expr <"128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %320 = wave.ptr_add %172, %319 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_14, %token_15 = waveamd.transpose_load %320 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %321 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %322 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %323 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %324 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %325 = wave.index_expr <"4224 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %326 = wave.ptr_add %172, %325 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_16, %token_17 = waveamd.transpose_load %326 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %327 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %328 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %329 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %330 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %331 = wave.pack %321, %322, %323, %324, %327, %328, %329, %330 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %332 = wave.index_expr <"256 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %333 = wave.ptr_add %172, %332 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_18, %token_19 = waveamd.transpose_load %333 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %334 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %335 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %336 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %337 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %338 = wave.index_expr <"4480 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %339 = wave.ptr_add %172, %338 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_20, %token_21 = waveamd.transpose_load %339 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %340 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %341 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %342 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %343 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %344 = wave.pack %334, %335, %336, %337, %340, %341, %342, %343 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %345 = wave.index_expr <"64 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %346 = wave.ptr_add %172, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_22, %token_23 = waveamd.transpose_load %346 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %347 = wave.extract %value_22[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %348 = wave.extract %value_22[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %349 = wave.extract %value_22[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %350 = wave.extract %value_22[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %351 = wave.index_expr <"4288 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %352 = wave.ptr_add %172, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_24, %token_25 = waveamd.transpose_load %352 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %353 = wave.extract %value_24[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %354 = wave.extract %value_24[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %355 = wave.extract %value_24[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %356 = wave.extract %value_24[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %357 = wave.pack %347, %348, %349, %350, %353, %354, %355, %356 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %358 = wave.index_expr <"320 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %359 = wave.ptr_add %172, %358 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_26, %token_27 = waveamd.transpose_load %359 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %360 = wave.extract %value_26[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %361 = wave.extract %value_26[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %362 = wave.extract %value_26[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %363 = wave.extract %value_26[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %364 = wave.index_expr <"4544 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %365 = wave.ptr_add %172, %364 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_28, %token_29 = waveamd.transpose_load %365 after %301 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %366 = wave.extract %value_28[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %367 = wave.extract %value_28[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %368 = wave.extract %value_28[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %369 = wave.extract %value_28[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %370 = wave.pack %360, %361, %362, %363, %366, %367, %368, %369 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %371 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %372 = wave.binary subi %170, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %373:22 = scf.for %arg12 = %c0_i32 to %372 step %c1_i32 iter_args(%arg13 = %value, %arg14 = %value_0, %arg15 = %value_2, %arg16 = %value_4, %arg17 = %value_6, %arg18 = %value_8, %arg19 = %value_10, %arg20 = %value_12, %arg21 = %331, %arg22 = %344, %arg23 = %357, %arg24 = %370, %arg25 = %28, %arg26 = %28, %arg27 = %28, %arg28 = %28, %arg29 = %28, %arg30 = %28, %arg31 = %28, %arg32 = %28, %arg33 = %300, %arg34 = %300) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token)  : i32 {
        %1128 = wave.binary remui %arg12, %c3_i32 : i32, i32 -> i32
        %1129 = wave.binary addi %arg12, %c1_i32 overflow<nsw> : i32, i32 -> i32
        %1130 = wave.binary remui %1129, %c3_i32 : i32, i32 -> i32
        %1131 = wave.binary addi %arg12, %c3_i32 overflow<nsw> : i32, i32 -> i32
        %1132 = wave.binary muli %1131, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1133 = waveamd.fragment_pack %arg13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1134 = waveamd.fragment_pack %arg14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1135 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1136 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1137 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1138 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1139 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1140 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1141 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1142 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1143 = waveamd.fragment_pack %arg23 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1144 = waveamd.fragment_pack %arg24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1145 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1146 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1147 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1148 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1149 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1150 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1151 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1152 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1153 = waveamd.mma "mfma.f32.16x16x32.f16" %1141, %1133, %1145 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1154 = waveamd.mma "mfma.f32.16x16x32.f16" %1142, %1134, %1153 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1155 = waveamd.fragment_unpack %1154 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1156 = waveamd.mma "mfma.f32.16x16x32.f16" %1143, %1133, %1146 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1157 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1134, %1156 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1158 = waveamd.fragment_unpack %1157 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1159 = waveamd.mma "mfma.f32.16x16x32.f16" %1141, %1135, %1147 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1160 = waveamd.mma "mfma.f32.16x16x32.f16" %1142, %1136, %1159 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1161 = waveamd.fragment_unpack %1160 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1162 = waveamd.mma "mfma.f32.16x16x32.f16" %1143, %1135, %1148 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1163 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1136, %1162 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1164 = waveamd.fragment_unpack %1163 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1165 = waveamd.mma "mfma.f32.16x16x32.f16" %1141, %1137, %1149 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1166 = waveamd.mma "mfma.f32.16x16x32.f16" %1142, %1138, %1165 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1167 = waveamd.fragment_unpack %1166 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1168 = waveamd.mma "mfma.f32.16x16x32.f16" %1143, %1137, %1150 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1169 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1138, %1168 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1170 = waveamd.fragment_unpack %1169 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1171 = waveamd.mma "mfma.f32.16x16x32.f16" %1141, %1139, %1151 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1172 = waveamd.mma "mfma.f32.16x16x32.f16" %1142, %1140, %1171 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1173 = waveamd.fragment_unpack %1172 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1174 = waveamd.mma "mfma.f32.16x16x32.f16" %1143, %1139, %1152 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1175 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1140, %1174 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1176 = waveamd.fragment_unpack %1175 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1177 = wave.binary subi %arg7, %1132 : i32, i32 -> i32
        %1178 = wave.splat %1177 : i32 -> !wave.simd<i32, 64>
        %1179 = wave.cmpi slt %174, %1178 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1180 = wave.binary muli %1128, %c4224_i32 overflow<nsw> : i32, i32 -> i32
        %1181 = wave.barrier : () -> !wave.mem.token
        %1182 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%53, %1132, %186) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1183 = wave.assume %1182 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1184 = wave.ptr_add %188, %1183 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1185 = wave.binary addi %1180, %194 overflow<nsw> : i32, i32 -> i32
        %1186 = wave.ptr_add %190, %1185 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1187 = wave.select %1179, %1184, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1188 = waveamd.dma_load_lds %1187 -> %1186 after %1181 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1189 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%53, %1132, %187) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1190 = wave.assume %1189 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1191 = wave.ptr_add %188, %1190 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1192 = wave.binary addi %1180, %205 overflow<nsw> : i32, i32 -> i32
        %1193 = wave.ptr_add %190, %1192 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1194 = wave.select %1179, %1191, %199 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1195 = waveamd.dma_load_lds %1194 -> %1193 after %1181 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1196 = wave.join %1188, %1195 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1197 = wave.cmpi slt %181, %1178 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1198 = wave.cmpi slt %182, %1178 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1199 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1200 = wave.binary muli %1132, %1199 overflow<nsw> : i32, i32 -> i32
        %1201 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %1199, %1200, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1202 = wave.assume %1201 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1203 = wave.ptr_add %212, %1202 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1204 = wave.ptr_add %213, %1185 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1205 = wave.select %1197, %1203, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1206 = waveamd.dma_load_lds %1205 -> %1204 after %1181 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1207 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %1199, %1200, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1208 = wave.assume %1207 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1209 = wave.ptr_add %212, %1208 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1210 = wave.ptr_add %213, %1192 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1211 = wave.select %1198, %1209, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1212 = waveamd.dma_load_lds %1211 -> %1210 after %1181 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1213 = wave.join %1206, %1212 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1214 = wave.join %1196, %1213 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1215 = wave.binary muli %1130, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1216 = wave.ptr_add %171, %1215 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1217 = wave.ptr_add %1216, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_114, %token_115 = wave.load %1217 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1218 = wave.ptr_add %1216, %304 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_116, %token_117 = wave.load %1218 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1219 = wave.ptr_add %1216, %306 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_118, %token_119 = wave.load %1219 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1220 = wave.ptr_add %1216, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_120, %token_121 = wave.load %1220 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1221 = wave.ptr_add %1216, %310 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_122, %token_123 = wave.load %1221 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1222 = wave.ptr_add %1216, %312 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_124, %token_125 = wave.load %1222 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1223 = wave.ptr_add %1216, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_126, %token_127 = wave.load %1223 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1224 = wave.ptr_add %1216, %316 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_128, %token_129 = wave.load %1224 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1225 = wave.ptr_add %172, %1215 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1226 = wave.ptr_add %1225, %319 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_130, %token_131 = waveamd.transpose_load %1226 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1227 = wave.extract %value_130[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1228 = wave.extract %value_130[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1229 = wave.extract %value_130[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1230 = wave.extract %value_130[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1231 = wave.ptr_add %1225, %325 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_132, %token_133 = waveamd.transpose_load %1231 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1232 = wave.extract %value_132[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1233 = wave.extract %value_132[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1234 = wave.extract %value_132[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1235 = wave.extract %value_132[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1236 = wave.pack %1227, %1228, %1229, %1230, %1232, %1233, %1234, %1235 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1237 = wave.ptr_add %1225, %332 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_134, %token_135 = waveamd.transpose_load %1237 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1238 = wave.extract %value_134[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1239 = wave.extract %value_134[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1240 = wave.extract %value_134[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1241 = wave.extract %value_134[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1242 = wave.ptr_add %1225, %338 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_136, %token_137 = waveamd.transpose_load %1242 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1243 = wave.extract %value_136[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1244 = wave.extract %value_136[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1245 = wave.extract %value_136[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1246 = wave.extract %value_136[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1247 = wave.pack %1238, %1239, %1240, %1241, %1243, %1244, %1245, %1246 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1248 = wave.ptr_add %1225, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_138, %token_139 = waveamd.transpose_load %1248 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1249 = wave.extract %value_138[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1250 = wave.extract %value_138[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1251 = wave.extract %value_138[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1252 = wave.extract %value_138[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1253 = wave.ptr_add %1225, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_140, %token_141 = waveamd.transpose_load %1253 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1254 = wave.extract %value_140[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1255 = wave.extract %value_140[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1256 = wave.extract %value_140[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1257 = wave.extract %value_140[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1258 = wave.pack %1249, %1250, %1251, %1252, %1254, %1255, %1256, %1257 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1259 = wave.ptr_add %1225, %358 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_142, %token_143 = waveamd.transpose_load %1259 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1260 = wave.extract %value_142[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1261 = wave.extract %value_142[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1262 = wave.extract %value_142[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1263 = wave.extract %value_142[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1264 = wave.ptr_add %1225, %364 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_144, %token_145 = waveamd.transpose_load %1264 after %189 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1265 = wave.extract %value_144[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1266 = wave.extract %value_144[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1267 = wave.extract %value_144[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1268 = wave.extract %value_144[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1269 = wave.pack %1260, %1261, %1262, %1263, %1265, %1266, %1267, %1268 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1270 = wave.barrier %arg33 : (!wave.mem.token) -> !wave.mem.token
        scf.yield %value_114, %value_116, %value_118, %value_120, %value_122, %value_124, %value_126, %value_128, %1236, %1247, %1258, %1269, %1155, %1158, %1161, %1164, %1167, %1170, %1173, %1176, %1214, %1270 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token
      }
      %374 = wave.alloc() {align = 16 : i64, bytesize = 33792 : i64} : !wave.ptr<#wave.shared, f16>
      %375 = wave.splat %31 : i32 -> !wave.simd<i32, 64>
      %376 = wave.binary muli %148, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %377 = wave.binary muli %149, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %378 = wave.binary muli %150, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %379 = wave.binary muli %151, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %380 = wave.binary muli %152, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %381 = wave.binary muli %153, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %382 = wave.binary muli %154, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %383 = wave.binary muli %155, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %384 = wave.binary muli %156, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %385 = wave.binary muli %157, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %386 = wave.binary muli %158, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %387 = wave.binary muli %159, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %388 = wave.binary muli %160, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %389 = wave.binary muli %161, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %390 = wave.binary muli %162, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %391 = wave.binary muli %163, %375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %392 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %393 = wave.ptr_cast %374 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %394 = wave.binary muli %193, %c66_i32 overflow<nsw> : i32, i32 -> i32
      %395 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%376, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %396 = wave.assume %395 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %397 = wave.ptr_add %392, %396 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %398 = wave.ptr_add %393, %394 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %399 = waveamd.dma_load_lds %397 -> %398 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %400 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%377, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %401 = wave.assume %400 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %402 = wave.ptr_add %392, %401 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %403 = wave.binary addi %394, %c528_i32 overflow<nsw> : i32, i32 -> i32
      %404 = wave.ptr_add %393, %403 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %405 = waveamd.dma_load_lds %402 -> %404 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %406 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%378, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %407 = wave.assume %406 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %408 = wave.ptr_add %392, %407 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %409 = wave.binary addi %394, %c1056_i32 overflow<nsw> : i32, i32 -> i32
      %410 = wave.ptr_add %393, %409 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %411 = waveamd.dma_load_lds %408 -> %410 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %412 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%379, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %413 = wave.assume %412 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %414 = wave.ptr_add %392, %413 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %415 = wave.binary addi %394, %c1584_i32 overflow<nsw> : i32, i32 -> i32
      %416 = wave.ptr_add %393, %415 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %417 = waveamd.dma_load_lds %414 -> %416 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %418 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%380, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %419 = wave.assume %418 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %420 = wave.ptr_add %392, %419 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %421 = wave.binary addi %394, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %422 = wave.ptr_add %393, %421 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %423 = waveamd.dma_load_lds %420 -> %422 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %424 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%381, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %425 = wave.assume %424 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %426 = wave.ptr_add %392, %425 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %427 = wave.binary addi %394, %c2640_i32 overflow<nsw> : i32, i32 -> i32
      %428 = wave.ptr_add %393, %427 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %429 = waveamd.dma_load_lds %426 -> %428 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %430 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%382, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %431 = wave.assume %430 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %432 = wave.ptr_add %392, %431 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %433 = wave.binary addi %394, %c3168_i32 overflow<nsw> : i32, i32 -> i32
      %434 = wave.ptr_add %393, %433 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %435 = waveamd.dma_load_lds %432 -> %434 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %436 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%383, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %437 = wave.assume %436 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %438 = wave.ptr_add %392, %437 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %439 = wave.binary addi %394, %c3696_i32 overflow<nsw> : i32, i32 -> i32
      %440 = wave.ptr_add %393, %439 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %441 = waveamd.dma_load_lds %438 -> %440 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %442 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%384, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %443 = wave.assume %442 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %444 = wave.ptr_add %392, %443 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %445 = wave.binary addi %394, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %446 = wave.ptr_add %393, %445 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %447 = waveamd.dma_load_lds %444 -> %446 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %448 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%385, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %449 = wave.assume %448 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %450 = wave.ptr_add %392, %449 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %451 = wave.binary addi %394, %c4752_i32 overflow<nsw> : i32, i32 -> i32
      %452 = wave.ptr_add %393, %451 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %453 = waveamd.dma_load_lds %450 -> %452 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %454 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%386, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %455 = wave.assume %454 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %456 = wave.ptr_add %392, %455 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %457 = wave.binary addi %394, %c5280_i32 overflow<nsw> : i32, i32 -> i32
      %458 = wave.ptr_add %393, %457 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %459 = waveamd.dma_load_lds %456 -> %458 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %460 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%387, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %461 = wave.assume %460 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %462 = wave.ptr_add %392, %461 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %463 = wave.binary addi %394, %c5808_i32 overflow<nsw> : i32, i32 -> i32
      %464 = wave.ptr_add %393, %463 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %465 = waveamd.dma_load_lds %462 -> %464 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %466 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%388, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %467 = wave.assume %466 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %468 = wave.ptr_add %392, %467 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %469 = wave.binary addi %394, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %470 = wave.ptr_add %393, %469 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %471 = waveamd.dma_load_lds %468 -> %470 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %472 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%389, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %473 = wave.assume %472 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %474 = wave.ptr_add %392, %473 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %475 = wave.binary addi %394, %c6864_i32 overflow<nsw> : i32, i32 -> i32
      %476 = wave.ptr_add %393, %475 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %477 = waveamd.dma_load_lds %474 -> %476 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %478 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%390, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %479 = wave.assume %478 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %480 = wave.ptr_add %392, %479 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %481 = wave.binary addi %394, %c7392_i32 overflow<nsw> : i32, i32 -> i32
      %482 = wave.ptr_add %393, %481 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %483 = waveamd.dma_load_lds %480 -> %482 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %484 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%391, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %485 = wave.assume %484 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %486 = wave.ptr_add %392, %485 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %487 = wave.binary addi %394, %c7920_i32 overflow<nsw> : i32, i32 -> i32
      %488 = wave.ptr_add %393, %487 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %489 = waveamd.dma_load_lds %486 -> %488 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %490 = wave.join %399, %405, %411, %417, %423, %429, %435, %441, %447, %453, %459, %465, %471, %477, %483, %489 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %491 = waveamd.fragment_pack %373#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %492 = waveamd.fragment_pack %373#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %493 = waveamd.fragment_pack %373#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %494 = waveamd.fragment_pack %373#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %495 = waveamd.fragment_pack %373#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %496 = waveamd.fragment_pack %373#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %497 = waveamd.fragment_pack %373#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %498 = waveamd.fragment_pack %373#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %499 = waveamd.fragment_pack %373#8 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %500 = waveamd.fragment_pack %373#9 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %501 = waveamd.fragment_pack %373#10 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %502 = waveamd.fragment_pack %373#11 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %503 = waveamd.fragment_pack %373#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %504 = waveamd.fragment_pack %373#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %505 = waveamd.fragment_pack %373#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %506 = waveamd.fragment_pack %373#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %507 = waveamd.fragment_pack %373#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %508 = waveamd.fragment_pack %373#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %509 = waveamd.fragment_pack %373#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %510 = waveamd.fragment_pack %373#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %511 = waveamd.mma "mfma.f32.16x16x32.f16" %499, %491, %503 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %512 = waveamd.mma "mfma.f32.16x16x32.f16" %500, %492, %511 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %513 = waveamd.fragment_unpack %512 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %514 = waveamd.mma "mfma.f32.16x16x32.f16" %501, %491, %504 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %515 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %492, %514 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %516 = waveamd.fragment_unpack %515 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %517 = waveamd.mma "mfma.f32.16x16x32.f16" %499, %493, %505 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %518 = waveamd.mma "mfma.f32.16x16x32.f16" %500, %494, %517 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %519 = waveamd.fragment_unpack %518 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %520 = waveamd.mma "mfma.f32.16x16x32.f16" %501, %493, %506 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %521 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %494, %520 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %522 = waveamd.fragment_unpack %521 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %523 = waveamd.mma "mfma.f32.16x16x32.f16" %499, %495, %507 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %524 = waveamd.mma "mfma.f32.16x16x32.f16" %500, %496, %523 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %525 = waveamd.fragment_unpack %524 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %526 = waveamd.mma "mfma.f32.16x16x32.f16" %501, %495, %508 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %527 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %496, %526 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %528 = waveamd.fragment_unpack %527 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %529 = waveamd.mma "mfma.f32.16x16x32.f16" %499, %497, %509 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %530 = waveamd.mma "mfma.f32.16x16x32.f16" %500, %498, %529 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %531 = waveamd.fragment_unpack %530 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %532 = waveamd.mma "mfma.f32.16x16x32.f16" %501, %497, %510 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %533 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %498, %532 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %534 = waveamd.fragment_unpack %533 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %535 = wave.barrier %373#20, %490 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %536 = wave.binary subi %170, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %537 = wave.binary remsi %536, %c3_i32 : i32, i32 -> i32
      %538 = wave.binary muli %537, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %539 = wave.ptr_add %171, %538 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %540 = wave.barrier %373#21, %301 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %541 = wave.join %318, %535, %540 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %542 = wave.ptr_add %539, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_30, %token_31 = wave.load %542 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %543 = wave.ptr_add %539, %304 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_32, %token_33 = wave.load %543 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %544 = wave.ptr_add %539, %306 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_34, %token_35 = wave.load %544 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %545 = wave.ptr_add %539, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_36, %token_37 = wave.load %545 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %546 = wave.ptr_add %539, %310 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_38, %token_39 = wave.load %546 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %547 = wave.ptr_add %539, %312 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_40, %token_41 = wave.load %547 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %548 = wave.ptr_add %539, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_42, %token_43 = wave.load %548 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %549 = wave.ptr_add %539, %316 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_44, %token_45 = wave.load %549 after %541 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %550 = wave.join %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %551 = wave.ptr_add %172, %538 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %552 = wave.barrier %373#21, %301 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %553 = wave.join %371, %535, %552 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %554 = wave.ptr_add %551, %319 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_46, %token_47 = waveamd.transpose_load %554 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %555 = wave.extract %value_46[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %556 = wave.extract %value_46[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %557 = wave.extract %value_46[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %558 = wave.extract %value_46[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %559 = wave.ptr_add %551, %325 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_48, %token_49 = waveamd.transpose_load %559 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %560 = wave.extract %value_48[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %561 = wave.extract %value_48[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %562 = wave.extract %value_48[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %563 = wave.extract %value_48[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %564 = wave.pack %555, %556, %557, %558, %560, %561, %562, %563 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %565 = wave.ptr_add %551, %332 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_50, %token_51 = waveamd.transpose_load %565 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %566 = wave.extract %value_50[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %567 = wave.extract %value_50[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %568 = wave.extract %value_50[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %569 = wave.extract %value_50[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %570 = wave.ptr_add %551, %338 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_52, %token_53 = waveamd.transpose_load %570 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %571 = wave.extract %value_52[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %572 = wave.extract %value_52[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %573 = wave.extract %value_52[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %574 = wave.extract %value_52[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %575 = wave.pack %566, %567, %568, %569, %571, %572, %573, %574 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %576 = wave.ptr_add %551, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_54, %token_55 = waveamd.transpose_load %576 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %577 = wave.extract %value_54[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %578 = wave.extract %value_54[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %579 = wave.extract %value_54[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %580 = wave.extract %value_54[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %581 = wave.ptr_add %551, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_56, %token_57 = waveamd.transpose_load %581 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %582 = wave.extract %value_56[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %583 = wave.extract %value_56[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %584 = wave.extract %value_56[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %585 = wave.extract %value_56[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %586 = wave.pack %577, %578, %579, %580, %582, %583, %584, %585 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %587 = wave.ptr_add %551, %358 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_58, %token_59 = waveamd.transpose_load %587 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %588 = wave.extract %value_58[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %589 = wave.extract %value_58[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %590 = wave.extract %value_58[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %591 = wave.extract %value_58[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %592 = wave.ptr_add %551, %364 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_60, %token_61 = waveamd.transpose_load %592 after %553 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %593 = wave.extract %value_60[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %594 = wave.extract %value_60[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %595 = wave.extract %value_60[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %596 = wave.extract %value_60[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %597 = wave.pack %588, %589, %590, %591, %593, %594, %595, %596 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %598 = wave.join %token_47, %token_49, %token_51, %token_53, %token_55, %token_57, %token_59, %token_61 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %599 = waveamd.fragment_pack %value_30 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %600 = waveamd.fragment_pack %value_32 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %601 = waveamd.fragment_pack %value_34 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %602 = waveamd.fragment_pack %value_36 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %603 = waveamd.fragment_pack %value_38 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %604 = waveamd.fragment_pack %value_40 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %605 = waveamd.fragment_pack %value_42 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %606 = waveamd.fragment_pack %value_44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %607 = waveamd.fragment_pack %564 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %608 = waveamd.fragment_pack %575 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %609 = waveamd.fragment_pack %586 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %610 = waveamd.fragment_pack %597 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %611 = waveamd.fragment_pack %513 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.fragment_pack %516 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %613 = waveamd.fragment_pack %519 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.fragment_pack %522 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_pack %525 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %616 = waveamd.fragment_pack %528 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.fragment_pack %531 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_pack %534 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %619 = waveamd.mma "mfma.f32.16x16x32.f16" %607, %599, %611 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %600, %619 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.fragment_unpack %620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %622 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %599, %612 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %623 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %600, %622 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.fragment_unpack %623 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %625 = waveamd.mma "mfma.f32.16x16x32.f16" %607, %601, %613 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %626 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %602, %625 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.fragment_unpack %626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %628 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %601, %614 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %629 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %602, %628 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %630 = waveamd.fragment_unpack %629 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %631 = waveamd.mma "mfma.f32.16x16x32.f16" %607, %603, %615 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %632 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %604, %631 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %633 = waveamd.fragment_unpack %632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %634 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %603, %616 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %635 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %604, %634 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %636 = waveamd.fragment_unpack %635 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %637 = waveamd.mma "mfma.f32.16x16x32.f16" %607, %605, %617 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %606, %637 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.fragment_unpack %638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %640 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %605, %618 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %606, %640 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.fragment_unpack %641 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %643 = wave.binary addi %170, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %644 = wave.binary remsi %643, %c3_i32 : i32, i32 -> i32
      %645 = wave.binary muli %644, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %646 = wave.ptr_add %171, %645 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %647 = wave.join %540, %318, %550 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %648 = wave.ptr_add %646, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_62, %token_63 = wave.load %648 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %649 = wave.ptr_add %646, %304 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_64, %token_65 = wave.load %649 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %650 = wave.ptr_add %646, %306 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_66, %token_67 = wave.load %650 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %651 = wave.ptr_add %646, %308 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_68, %token_69 = wave.load %651 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %652 = wave.ptr_add %646, %310 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_70, %token_71 = wave.load %652 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %653 = wave.ptr_add %646, %312 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_72, %token_73 = wave.load %653 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %654 = wave.ptr_add %646, %314 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_74, %token_75 = wave.load %654 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %655 = wave.ptr_add %646, %316 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_76, %token_77 = wave.load %655 after %647 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %656 = wave.ptr_add %172, %645 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %657 = wave.join %552, %371, %598 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %658 = wave.ptr_add %656, %319 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_78, %token_79 = waveamd.transpose_load %658 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %659 = wave.extract %value_78[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %660 = wave.extract %value_78[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %661 = wave.extract %value_78[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %662 = wave.extract %value_78[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %663 = wave.ptr_add %656, %325 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_80, %token_81 = waveamd.transpose_load %663 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %664 = wave.extract %value_80[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %665 = wave.extract %value_80[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %666 = wave.extract %value_80[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %667 = wave.extract %value_80[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %668 = wave.pack %659, %660, %661, %662, %664, %665, %666, %667 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %669 = wave.ptr_add %656, %332 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_82, %token_83 = waveamd.transpose_load %669 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %670 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %671 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %672 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %673 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %674 = wave.ptr_add %656, %338 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_84, %token_85 = waveamd.transpose_load %674 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %675 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %676 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %677 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %678 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %679 = wave.pack %670, %671, %672, %673, %675, %676, %677, %678 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %680 = wave.ptr_add %656, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_86, %token_87 = waveamd.transpose_load %680 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %681 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %682 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %683 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %684 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %685 = wave.ptr_add %656, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_88, %token_89 = waveamd.transpose_load %685 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %686 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %687 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %688 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %689 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %690 = wave.pack %681, %682, %683, %684, %686, %687, %688, %689 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %691 = wave.ptr_add %656, %358 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_90, %token_91 = waveamd.transpose_load %691 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %692 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %693 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %694 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %695 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %696 = wave.ptr_add %656, %364 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_92, %token_93 = waveamd.transpose_load %696 after %657 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %697 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %698 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %699 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %700 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %701 = wave.pack %692, %693, %694, %695, %697, %698, %699, %700 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %702 = waveamd.fragment_pack %value_62 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %703 = waveamd.fragment_pack %value_64 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %704 = waveamd.fragment_pack %value_66 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %705 = waveamd.fragment_pack %value_68 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %706 = waveamd.fragment_pack %value_70 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %707 = waveamd.fragment_pack %value_72 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %708 = waveamd.fragment_pack %value_74 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %709 = waveamd.fragment_pack %value_76 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %710 = waveamd.fragment_pack %668 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %711 = waveamd.fragment_pack %679 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %712 = waveamd.fragment_pack %690 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %713 = waveamd.fragment_pack %701 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %714 = waveamd.fragment_pack %621 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %715 = waveamd.fragment_pack %624 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %716 = waveamd.fragment_pack %627 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %717 = waveamd.fragment_pack %630 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %718 = waveamd.fragment_pack %633 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %719 = waveamd.fragment_pack %636 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %720 = waveamd.fragment_pack %639 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %721 = waveamd.fragment_pack %642 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %722 = waveamd.mma "mfma.f32.16x16x32.f16" %710, %702, %714 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %723 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %703, %722 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %724 = waveamd.fragment_unpack %723 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %725 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %702, %715 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %726 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %703, %725 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %727 = waveamd.fragment_unpack %726 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %728 = waveamd.mma "mfma.f32.16x16x32.f16" %710, %704, %716 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %729 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %705, %728 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %730 = waveamd.fragment_unpack %729 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %731 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %704, %717 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %732 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %705, %731 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %733 = waveamd.fragment_unpack %732 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %734 = waveamd.mma "mfma.f32.16x16x32.f16" %710, %706, %718 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %735 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %707, %734 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %736 = waveamd.fragment_unpack %735 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %737 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %706, %719 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %738 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %707, %737 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %739 = waveamd.fragment_unpack %738 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %740 = waveamd.mma "mfma.f32.16x16x32.f16" %710, %708, %720 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %741 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %709, %740 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %742 = waveamd.fragment_unpack %741 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %743 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %708, %721 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %744 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %709, %743 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %745 = waveamd.fragment_unpack %744 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %746 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %747 = wave.assume %167 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %748 = wave.ptr_add %746, %747 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_94, %token_95 = wave.load %748 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %749 = wave.assume %168 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %750 = wave.ptr_add %746, %749 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_96, %token_97 = wave.load %750 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %751 = wave.cast fpconvert %value_94 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %752 = wave.cast fpconvert %value_96 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %753 = wave.fadd %724, %751 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %754 = wave.fadd %727, %752 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %755 = wave.fadd %730, %751 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %756 = wave.fadd %733, %752 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %757 = wave.fadd %736, %751 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %758 = wave.fadd %739, %752 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %759 = wave.fadd %742, %751 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %760 = wave.fadd %745, %752 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %761 = wave.binary xori %100, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %762 = wave.binary xori %761, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %763 = wave.binary xori %762, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %764 = wave.binary xori %763, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %765 = wave.binary muli %58, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %766 = wave.binary muli %62, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %767 = wave.binary xori %765, %766 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %768 = wave.binary muli %66, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %769 = wave.binary xori %767, %768 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %770 = wave.binary muli %69, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %771 = wave.binary xori %769, %770 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %772 = wave.binary remui %771, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %773 = wave.binary divui %771, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %774 = wave.binary remui %773, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %775 = wave.binary muli %774, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %776 = wave.binary addi %772, %775 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %777 = wave.binary divui %771, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %778 = wave.binary remui %777, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %779 = wave.binary muli %778, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %780 = wave.binary addi %776, %779 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %781 = wave.binary divui %771, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %782 = wave.binary remui %781, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %783 = wave.binary muli %782, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %784 = wave.binary addi %780, %783 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %785 = wave.binary divui %771, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %786 = wave.binary remui %785, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %787 = wave.binary muli %786, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %788 = wave.binary addi %784, %787 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %789 = wave.binary divui %771, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %790 = wave.binary remui %789, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %791 = wave.binary muli %790, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %792 = wave.binary addi %788, %791 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %793 = wave.binary divui %771, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %794 = wave.binary remui %793, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %795 = wave.binary muli %794, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %796 = wave.binary addi %792, %795 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %797 = wave.binary remui %764, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %798 = wave.binary muli %797, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %799 = wave.binary addi %796, %798 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %800 = wave.binary divui %764, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %801 = wave.binary remui %800, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %802 = wave.binary muli %801, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %803 = wave.binary addi %799, %802 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %804 = wave.binary divui %764, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %805 = wave.binary remui %804, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %806 = wave.binary muli %805, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %807 = wave.binary addi %803, %806 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %808 = wave.binary divui %764, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %809 = wave.binary remui %808, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %810 = wave.binary muli %809, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %811 = wave.binary addi %807, %810 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %812 = wave.binary divui %764, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %813 = wave.binary remui %812, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %814 = wave.binary muli %813, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %815 = wave.binary addi %811, %814 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %816 = wave.binary divui %764, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %817 = wave.binary remui %816, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %818 = wave.binary muli %817, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %819 = wave.binary addi %815, %818 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %820 = wave.binary divui %764, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %821 = wave.binary remui %820, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %822 = wave.binary muli %821, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %823 = wave.binary addi %819, %822 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %824 = wave.binary divui %823, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %825 = wave.binary muli %824, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %826 = wave.binary addi %823, %825 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %827 = wave.assume %826 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %828 = wave.binary xori %22, %765 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %829 = wave.binary xori %828, %766 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %830 = wave.binary xori %829, %768 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %831 = wave.binary xori %830, %770 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %832 = wave.binary remui %831, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %833 = wave.binary divui %831, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %834 = wave.binary remui %833, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %835 = wave.binary muli %834, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %836 = wave.binary addi %832, %835 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %837 = wave.binary divui %831, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %838 = wave.binary remui %837, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %839 = wave.binary muli %838, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %840 = wave.binary addi %836, %839 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %841 = wave.binary divui %831, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %842 = wave.binary remui %841, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %843 = wave.binary muli %842, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %844 = wave.binary addi %840, %843 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %845 = wave.binary divui %831, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %846 = wave.binary remui %845, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %847 = wave.binary muli %846, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %848 = wave.binary addi %844, %847 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %849 = wave.binary divui %831, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %850 = wave.binary remui %849, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %851 = wave.binary muli %850, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %852 = wave.binary addi %848, %851 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %853 = wave.binary divui %831, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %854 = wave.binary remui %853, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %855 = wave.binary muli %854, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %856 = wave.binary addi %852, %855 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %857 = wave.binary addi %856, %798 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %858 = wave.binary addi %857, %802 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %859 = wave.binary addi %858, %806 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %860 = wave.binary addi %859, %810 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %861 = wave.binary addi %860, %814 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %862 = wave.binary addi %861, %818 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %863 = wave.binary addi %862, %822 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %864 = wave.binary divui %863, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %865 = wave.binary muli %864, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %866 = wave.binary addi %863, %865 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %867 = wave.assume %866 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %868 = wave.binary xori %23, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %869 = wave.binary xori %868, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %870 = wave.binary xori %869, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %871 = wave.binary xori %870, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %872 = wave.binary xori %871, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %873 = wave.binary remui %872, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %874 = wave.binary muli %873, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %875 = wave.binary addi %796, %874 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %876 = wave.binary divui %872, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %877 = wave.binary remui %876, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %878 = wave.binary muli %877, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %879 = wave.binary addi %875, %878 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %880 = wave.binary divui %872, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %881 = wave.binary remui %880, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %882 = wave.binary muli %881, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %883 = wave.binary addi %879, %882 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %884 = wave.binary divui %872, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %885 = wave.binary remui %884, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %886 = wave.binary muli %885, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %887 = wave.binary addi %883, %886 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %888 = wave.binary divui %872, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %889 = wave.binary remui %888, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %890 = wave.binary muli %889, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %891 = wave.binary addi %887, %890 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %892 = wave.binary divui %872, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %893 = wave.binary remui %892, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %894 = wave.binary muli %893, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %895 = wave.binary addi %891, %894 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %896 = wave.binary divui %872, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %897 = wave.binary remui %896, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %898 = wave.binary muli %897, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %899 = wave.binary addi %895, %898 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %900 = wave.binary divui %899, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %901 = wave.binary muli %900, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %902 = wave.binary addi %899, %901 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %903 = wave.assume %902 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %904 = wave.binary addi %856, %874 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %905 = wave.binary addi %904, %878 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %906 = wave.binary addi %905, %882 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %907 = wave.binary addi %906, %886 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %908 = wave.binary addi %907, %890 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %909 = wave.binary addi %908, %894 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %910 = wave.binary addi %909, %898 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %911 = wave.binary divui %910, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %912 = wave.binary muli %911, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %913 = wave.binary addi %910, %912 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %914 = wave.assume %913 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %915 = wave.binary xori %22, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %916 = wave.binary xori %915, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %917 = wave.binary xori %916, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %918 = wave.binary xori %917, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %919 = wave.binary xori %918, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %920 = wave.binary remui %919, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %921 = wave.binary muli %920, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %922 = wave.binary addi %796, %921 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %923 = wave.binary divui %919, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %924 = wave.binary remui %923, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %925 = wave.binary muli %924, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %926 = wave.binary addi %922, %925 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %927 = wave.binary divui %919, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %928 = wave.binary remui %927, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %929 = wave.binary muli %928, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %930 = wave.binary addi %926, %929 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %931 = wave.binary divui %919, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %932 = wave.binary remui %931, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %933 = wave.binary muli %932, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %934 = wave.binary addi %930, %933 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary divui %919, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.binary remui %935, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %937 = wave.binary muli %936, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary addi %934, %937 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary divui %919, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary remui %939, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary muli %940, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary addi %938, %941 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary divui %919, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary remui %943, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary muli %944, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary addi %942, %945 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.binary divui %946, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %948 = wave.binary muli %947, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %949 = wave.binary addi %946, %948 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.assume %949 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %951 = wave.binary addi %856, %921 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary addi %951, %925 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary addi %952, %929 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary addi %953, %933 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary addi %954, %937 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary addi %955, %941 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary addi %956, %945 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary divui %957, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary muli %958, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary addi %957, %959 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.assume %960 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %962 = wave.binary xori %11, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %963 = wave.binary xori %962, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %964 = wave.binary xori %963, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %965 = wave.binary xori %964, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %966 = wave.binary xori %965, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %967 = wave.binary remui %966, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %968 = wave.binary muli %967, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %969 = wave.binary addi %796, %968 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %970 = wave.binary divui %966, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %971 = wave.binary remui %970, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %972 = wave.binary muli %971, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %973 = wave.binary addi %969, %972 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %974 = wave.binary divui %966, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %975 = wave.binary remui %974, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %976 = wave.binary muli %975, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %977 = wave.binary addi %973, %976 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %978 = wave.binary divui %966, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %979 = wave.binary remui %978, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %980 = wave.binary muli %979, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %981 = wave.binary addi %977, %980 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %982 = wave.binary divui %966, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %983 = wave.binary remui %982, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %984 = wave.binary muli %983, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %985 = wave.binary addi %981, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %986 = wave.binary divui %966, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %987 = wave.binary remui %986, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %988 = wave.binary muli %987, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %989 = wave.binary addi %985, %988 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %990 = wave.binary divui %966, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %991 = wave.binary remui %990, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %992 = wave.binary muli %991, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %993 = wave.binary addi %989, %992 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %994 = wave.binary divui %993, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %995 = wave.binary muli %994, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %996 = wave.binary addi %993, %995 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %997 = wave.assume %996 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %998 = wave.binary addi %856, %968 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %999 = wave.binary addi %998, %972 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1000 = wave.binary addi %999, %976 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1001 = wave.binary addi %1000, %980 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1002 = wave.binary addi %1001, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1003 = wave.binary addi %1002, %988 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1004 = wave.binary addi %1003, %992 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1005 = wave.binary divui %1004, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1006 = wave.binary muli %1005, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1007 = wave.binary addi %1004, %1006 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1008 = wave.assume %1007 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1009 = wave.ptr_add %374, %827 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_98, %token_99 = wave.load %1009 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1010 = wave.ptr_add %374, %867 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_100, %token_101 = wave.load %1010 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1011 = wave.ptr_add %374, %903 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_102, %token_103 = wave.load %1011 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1012 = wave.ptr_add %374, %914 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_104, %token_105 = wave.load %1012 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1013 = wave.ptr_add %374, %950 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_106, %token_107 = wave.load %1013 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1014 = wave.ptr_add %374, %961 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_108, %token_109 = wave.load %1014 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1015 = wave.ptr_add %374, %997 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_110, %token_111 = wave.load %1015 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1016 = wave.ptr_add %374, %1008 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_112, %token_113 = wave.load %1016 after %535 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1017 = wave.cast fpconvert %value_98 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1018 = wave.cast fpconvert %value_100 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1019 = wave.cast fpconvert %value_102 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1020 = wave.cast fpconvert %value_104 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1021 = wave.cast fpconvert %value_106 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1022 = wave.cast fpconvert %value_108 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1023 = wave.cast fpconvert %value_110 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1024 = wave.cast fpconvert %value_112 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1025 = wave.fma %753, %1017, %753 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1026 = wave.fma %754, %1018, %754 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1027 = wave.fma %755, %1019, %755 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1028 = wave.fma %756, %1020, %756 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1029 = wave.fma %757, %1021, %757 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1030 = wave.fma %758, %1022, %758 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1031 = wave.fma %759, %1023, %759 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1032 = wave.fma %760, %1024, %760 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1033 = wave.cmpi slt %135, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1034 = wave.cmpi slt %136, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1035 = wave.cmpi slt %137, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1036 = wave.cmpi slt %138, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1037 = wave.select %1033, %1, %0 : !wave.mask<64>, !wave.simd<i32, 64>
      %1038 = wave.select %1034, %1, %0 : !wave.mask<64>, !wave.simd<i32, 64>
      %1039 = wave.select %1035, %1, %0 : !wave.mask<64>, !wave.simd<i32, 64>
      %1040 = wave.select %1036, %1, %0 : !wave.mask<64>, !wave.simd<i32, 64>
      %1041 = wave.cmpi slt %143, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1042 = wave.cmpi slt %144, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1043 = wave.select %1041, %1, %0 : !wave.mask<64>, !wave.simd<i32, 64>
      %1044 = wave.select %1042, %1, %0 : !wave.mask<64>, !wave.simd<i32, 64>
      %1045 = wave.binary andi %1037, %1043 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1046 = wave.binary andi %1037, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1047 = wave.binary andi %1038, %1043 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1048 = wave.binary andi %1038, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1049 = wave.binary andi %1039, %1043 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1050 = wave.binary andi %1039, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1051 = wave.binary andi %1040, %1043 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1052 = wave.binary andi %1040, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1053 = wave.assume %arg11 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %1054 = wave.binary muli %52, %1053 overflow<nsw> : i32, i32 -> i32
      %1055 = wave.splat %1053 : i32 -> !wave.simd<i32, 64>
      %1056 = wave.binary muli %112, %1055 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1057 = wave.binary muli %113, %1055 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1058 = wave.binary muli %114, %1055 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1059 = wave.binary muli %115, %1055 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1060 = wave.binary addi %1054, %139 overflow<nsw> : i32, i32 -> i32
      %1061 = wave.binary addi %1056, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1062 = wave.binary addi %1056, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1063 = wave.binary addi %1057, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1064 = wave.binary addi %1057, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1065 = wave.binary addi %1058, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1066 = wave.binary addi %1058, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1067 = wave.binary addi %1059, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1068 = wave.binary addi %1059, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1069 = wave.splat %1060 : i32 -> !wave.simd<i32, 64>
      %1070 = wave.binary addi %1069, %1061 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1071 = wave.binary addi %1069, %1062 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1072 = wave.binary addi %1069, %1063 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1073 = wave.binary addi %1069, %1064 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1074 = wave.binary addi %1069, %1065 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1075 = wave.binary addi %1069, %1066 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1076 = wave.binary addi %1069, %1067 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1077 = wave.binary addi %1069, %1068 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1078 = wave.cast fpconvert %1025 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1079 = wave.cast fpconvert %1026 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1080 = wave.cast fpconvert %1027 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1081 = wave.cast fpconvert %1028 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1082 = wave.cast fpconvert %1029 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1083 = wave.cast fpconvert %1030 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1084 = wave.cast fpconvert %1031 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1085 = wave.cast fpconvert %1032 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1086 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %1087 = wave.cmpi ne %1045, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1088 = wave.assume %1070 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1089 = wave.ptr_add %1086, %1088 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1090 = wave.ptr_add %1086, %7 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1091 = wave.select %1087, %1089, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1092 = wave.store %1078 -> %1091 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1093 = wave.cmpi ne %1046, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1094 = wave.assume %1071 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1095 = wave.ptr_add %1086, %1094 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1096 = wave.select %1093, %1095, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1097 = wave.store %1079 -> %1096 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1098 = wave.cmpi ne %1047, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1099 = wave.assume %1072 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1100 = wave.ptr_add %1086, %1099 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1101 = wave.select %1098, %1100, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1102 = wave.store %1080 -> %1101 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1103 = wave.cmpi ne %1048, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1104 = wave.assume %1073 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1105 = wave.ptr_add %1086, %1104 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1106 = wave.select %1103, %1105, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1107 = wave.store %1081 -> %1106 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1108 = wave.cmpi ne %1049, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1109 = wave.assume %1074 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1110 = wave.ptr_add %1086, %1109 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1111 = wave.select %1108, %1110, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1112 = wave.store %1082 -> %1111 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1113 = wave.cmpi ne %1050, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1114 = wave.assume %1075 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1115 = wave.ptr_add %1086, %1114 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1116 = wave.select %1113, %1115, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1117 = wave.store %1083 -> %1116 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1118 = wave.cmpi ne %1051, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1119 = wave.assume %1076 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1120 = wave.ptr_add %1086, %1119 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1121 = wave.select %1118, %1120, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1122 = wave.store %1084 -> %1121 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1123 = wave.cmpi ne %1052, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1124 = wave.assume %1077 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1125 = wave.ptr_add %1086, %1124 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1126 = wave.select %1123, %1125, %1090 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1127 = wave.store %1085 -> %1126 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      return
    }
  }
}
