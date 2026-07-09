module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_optimized_async(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %1 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 8192 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 1024 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 512 : i32 -> !wave.simd<i32, 64>
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
        %1114 = wave.binary remui %32, %c8_i32 : i32, i32 -> i32
        %1115 = wave.binary divui %32, %c8_i32 : i32, i32 -> i32
        %1116 = wave.binary divui %1115, %c4_i32 : i32, i32 -> i32
        %1117 = wave.binary muli %1116, %c32_i32 overflow<nsw> : i32, i32 -> i32
        %1118 = wave.binary muli %1114, %c4_i32 overflow<nsw> : i32, i32 -> i32
        %1119 = wave.binary addi %1117, %1118 overflow<nsw> : i32, i32 -> i32
        %1120 = wave.binary remui %1115, %c4_i32 : i32, i32 -> i32
        %1121 = wave.binary addi %1119, %1120 overflow<nsw> : i32, i32 -> i32
        scf.yield %1121 : i32
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
      %199 = wave.where %184 {
        %1114 = waveamd.dma_load_lds %197 -> %198 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %200 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %201 = wave.assume %200 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %202 = wave.ptr_add %188, %201 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %203 = wave.binary addi %194, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %204 = wave.ptr_add %190, %203 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %205 = wave.where %184 {
        %1114 = waveamd.dma_load_lds %202 -> %204 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %206 = wave.join %199, %205 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %207 = wave.cmpi slt %181, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %208 = wave.cmpi slt %182, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %209 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %210 = wave.ptr_cast %172 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %211 = wave.index_expr <"s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1"](%53, %30, %165) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %212 = wave.assume %211 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %213 = wave.ptr_add %209, %212 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %214 = wave.ptr_add %210, %194 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %215 = wave.where %207 {
        %1114 = waveamd.dma_load_lds %213 -> %214 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %216 = wave.index_expr <"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1"](%53, %30, %165) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %217 = wave.assume %216 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %218 = wave.ptr_add %209, %217 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %219 = wave.ptr_add %210, %203 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %220 = wave.where %208 {
        %1114 = waveamd.dma_load_lds %218 -> %219 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %221 = wave.join %215, %220 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %222 = wave.join %206, %221 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %223 = wave.binary subi %arg7, %c64_i32 : i32, i32 -> i32
      %224 = wave.splat %223 : i32 -> !wave.simd<i32, 64>
      %225 = wave.cmpi slt %174, %224 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %226 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %186) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %227 = wave.assume %226 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %228 = wave.ptr_add %188, %227 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %229 = wave.binary addi %c4224_i32, %194 overflow<nsw> : i32, i32 -> i32
      %230 = wave.ptr_add %190, %229 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %231 = wave.where %225 {
        %1114 = waveamd.dma_load_lds %228 -> %230 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %232 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %233 = wave.assume %232 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %234 = wave.ptr_add %188, %233 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %235 = wave.binary addi %c4224_i32, %203 overflow<nsw> : i32, i32 -> i32
      %236 = wave.ptr_add %190, %235 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %237 = wave.where %225 {
        %1114 = waveamd.dma_load_lds %234 -> %236 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %238 = wave.join %231, %237 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %239 = wave.cmpi slt %181, %224 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %240 = wave.cmpi slt %182, %224 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %241 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %242 = wave.binary muli %241, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %243 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %241, %242, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %244 = wave.assume %243 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %245 = wave.ptr_add %209, %244 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %246 = wave.ptr_add %210, %229 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %247 = wave.where %239 {
        %1114 = waveamd.dma_load_lds %245 -> %246 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %248 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %241, %242, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %249 = wave.assume %248 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %250 = wave.ptr_add %209, %249 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %251 = wave.ptr_add %210, %235 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %252 = wave.where %240 {
        %1114 = waveamd.dma_load_lds %250 -> %251 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %253 = wave.join %247, %252 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %254 = wave.join %238, %253 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %255 = wave.binary subi %arg7, %c128_i32 : i32, i32 -> i32
      %256 = wave.splat %255 : i32 -> !wave.simd<i32, 64>
      %257 = wave.cmpi slt %174, %256 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %258 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %186) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %259 = wave.assume %258 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %260 = wave.ptr_add %188, %259 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %261 = wave.binary addi %c8448_i32, %194 overflow<nsw> : i32, i32 -> i32
      %262 = wave.ptr_add %190, %261 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %263 = wave.where %257 {
        %1114 = waveamd.dma_load_lds %260 -> %262 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %264 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%53, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %265 = wave.assume %264 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %266 = wave.ptr_add %188, %265 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %267 = wave.binary addi %c8448_i32, %203 overflow<nsw> : i32, i32 -> i32
      %268 = wave.ptr_add %190, %267 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %269 = wave.where %257 {
        %1114 = waveamd.dma_load_lds %266 -> %268 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %270 = wave.join %263, %269 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %271 = wave.cmpi slt %181, %256 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %272 = wave.cmpi slt %182, %256 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %273 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %274 = wave.binary muli %273, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %275 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %273, %274, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %276 = wave.assume %275 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %277 = wave.ptr_add %209, %276 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %278 = wave.ptr_add %210, %261 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %279 = wave.where %271 {
        %1114 = waveamd.dma_load_lds %277 -> %278 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %280 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %273, %274, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %281 = wave.assume %280 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %282 = wave.ptr_add %209, %281 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %283 = wave.ptr_add %210, %267 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %284 = wave.where %272 {
        %1114 = waveamd.dma_load_lds %282 -> %283 after %189 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        wave.yield %1114 : !wave.mem.token
      } : !wave.mask<64> -> !wave.mem.token
      %285 = wave.join %279, %284 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %286 = wave.join %270, %285 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %287 = wave.barrier %222, %254 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %288 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %289 = wave.ptr_add %171, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %289 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %290 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %291 = wave.ptr_add %171, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %291 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %292 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %293 = wave.ptr_add %171, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %293 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %294 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %295 = wave.ptr_add %171, %294 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %295 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %296 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %297 = wave.ptr_add %171, %296 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %297 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %298 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %299 = wave.ptr_add %171, %298 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %299 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %300 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %301 = wave.ptr_add %171, %300 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %301 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %302 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %303 = wave.ptr_add %171, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %303 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %304 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %305 = wave.index_expr <"128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %306 = wave.ptr_add %172, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_14, %token_15 = waveamd.transpose_load %306 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %307 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %308 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %309 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %310 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %311 = wave.index_expr <"4224 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %312 = wave.ptr_add %172, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_16, %token_17 = waveamd.transpose_load %312 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %313 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %314 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %315 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %316 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %317 = wave.pack %307, %308, %309, %310, %313, %314, %315, %316 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %318 = wave.index_expr <"256 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %319 = wave.ptr_add %172, %318 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_18, %token_19 = waveamd.transpose_load %319 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %320 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %321 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %322 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %323 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %324 = wave.index_expr <"4480 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %325 = wave.ptr_add %172, %324 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_20, %token_21 = waveamd.transpose_load %325 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %326 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %327 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %328 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %329 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %330 = wave.pack %320, %321, %322, %323, %326, %327, %328, %329 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %331 = wave.index_expr <"64 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %332 = wave.ptr_add %172, %331 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_22, %token_23 = waveamd.transpose_load %332 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %333 = wave.extract %value_22[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %334 = wave.extract %value_22[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %335 = wave.extract %value_22[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %336 = wave.extract %value_22[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %337 = wave.index_expr <"4288 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %338 = wave.ptr_add %172, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_24, %token_25 = waveamd.transpose_load %338 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %339 = wave.extract %value_24[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %340 = wave.extract %value_24[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %341 = wave.extract %value_24[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %342 = wave.extract %value_24[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %343 = wave.pack %333, %334, %335, %336, %339, %340, %341, %342 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %344 = wave.index_expr <"320 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %345 = wave.ptr_add %172, %344 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_26, %token_27 = waveamd.transpose_load %345 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %346 = wave.extract %value_26[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %347 = wave.extract %value_26[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %348 = wave.extract %value_26[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %349 = wave.extract %value_26[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %350 = wave.index_expr <"4544 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%53) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %351 = wave.ptr_add %172, %350 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_28, %token_29 = waveamd.transpose_load %351 after %287 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %352 = wave.extract %value_28[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %353 = wave.extract %value_28[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %354 = wave.extract %value_28[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %355 = wave.extract %value_28[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %356 = wave.pack %346, %347, %348, %349, %352, %353, %354, %355 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %357 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %358 = wave.binary subi %170, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %359:22 = scf.for %arg12 = %c0_i32 to %358 step %c1_i32 iter_args(%arg13 = %value, %arg14 = %value_0, %arg15 = %value_2, %arg16 = %value_4, %arg17 = %value_6, %arg18 = %value_8, %arg19 = %value_10, %arg20 = %value_12, %arg21 = %317, %arg22 = %330, %arg23 = %343, %arg24 = %356, %arg25 = %28, %arg26 = %28, %arg27 = %28, %arg28 = %28, %arg29 = %28, %arg30 = %28, %arg31 = %28, %arg32 = %28, %arg33 = %286, %arg34 = %286) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token)  : i32 {
        %1114 = wave.binary remui %arg12, %c3_i32 : i32, i32 -> i32
        %1115 = wave.binary addi %arg12, %c1_i32 overflow<nsw> : i32, i32 -> i32
        %1116 = wave.binary remui %1115, %c3_i32 : i32, i32 -> i32
        %1117 = wave.binary addi %arg12, %c3_i32 overflow<nsw> : i32, i32 -> i32
        %1118 = wave.binary muli %1117, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1119 = waveamd.fragment_pack %arg13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1120 = waveamd.fragment_pack %arg14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1121 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1122 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1123 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1124 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1125 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1126 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1127 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1128 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1129 = waveamd.fragment_pack %arg23 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1130 = waveamd.fragment_pack %arg24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1131 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1132 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1133 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1134 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1135 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1136 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1137 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1138 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1139 = waveamd.mma "mfma.f32.16x16x32.f16" %1127, %1119, %1131 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1140 = waveamd.mma "mfma.f32.16x16x32.f16" %1128, %1120, %1139 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1141 = waveamd.fragment_unpack %1140 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1142 = waveamd.mma "mfma.f32.16x16x32.f16" %1129, %1119, %1132 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1143 = waveamd.mma "mfma.f32.16x16x32.f16" %1130, %1120, %1142 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1144 = waveamd.fragment_unpack %1143 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1145 = waveamd.mma "mfma.f32.16x16x32.f16" %1127, %1121, %1133 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1146 = waveamd.mma "mfma.f32.16x16x32.f16" %1128, %1122, %1145 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1147 = waveamd.fragment_unpack %1146 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1148 = waveamd.mma "mfma.f32.16x16x32.f16" %1129, %1121, %1134 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1149 = waveamd.mma "mfma.f32.16x16x32.f16" %1130, %1122, %1148 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1150 = waveamd.fragment_unpack %1149 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1151 = waveamd.mma "mfma.f32.16x16x32.f16" %1127, %1123, %1135 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1152 = waveamd.mma "mfma.f32.16x16x32.f16" %1128, %1124, %1151 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1153 = waveamd.fragment_unpack %1152 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1154 = waveamd.mma "mfma.f32.16x16x32.f16" %1129, %1123, %1136 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1155 = waveamd.mma "mfma.f32.16x16x32.f16" %1130, %1124, %1154 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1156 = waveamd.fragment_unpack %1155 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1157 = waveamd.mma "mfma.f32.16x16x32.f16" %1127, %1125, %1137 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1158 = waveamd.mma "mfma.f32.16x16x32.f16" %1128, %1126, %1157 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1159 = waveamd.fragment_unpack %1158 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1160 = waveamd.mma "mfma.f32.16x16x32.f16" %1129, %1125, %1138 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1161 = waveamd.mma "mfma.f32.16x16x32.f16" %1130, %1126, %1160 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1162 = waveamd.fragment_unpack %1161 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1163 = wave.binary subi %arg7, %1118 : i32, i32 -> i32
        %1164 = wave.splat %1163 : i32 -> !wave.simd<i32, 64>
        %1165 = wave.cmpi slt %174, %1164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1166 = wave.binary muli %1114, %c4224_i32 overflow<nsw> : i32, i32 -> i32
        %1167 = wave.barrier %304 : (!wave.mem.token) -> !wave.mem.token
        %1168 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%53, %1118, %186) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1169 = wave.assume %1168 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1170 = wave.ptr_add %188, %1169 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1171 = wave.binary addi %1166, %194 overflow<nsw> : i32, i32 -> i32
        %1172 = wave.ptr_add %190, %1171 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1173 = wave.where %1165 {
          %1254 = waveamd.dma_load_lds %1170 -> %1172 after %1167 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1254 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1174 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%53, %1118, %187) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1175 = wave.assume %1174 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1176 = wave.ptr_add %188, %1175 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1177 = wave.binary addi %1166, %203 overflow<nsw> : i32, i32 -> i32
        %1178 = wave.ptr_add %190, %1177 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1179 = wave.where %1165 {
          %1254 = waveamd.dma_load_lds %1176 -> %1178 after %1167 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1254 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1180 = wave.join %1173, %1179 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1181 = wave.cmpi slt %181, %1164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1182 = wave.cmpi slt %182, %1164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1183 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1184 = wave.binary muli %1118, %1183 overflow<nsw> : i32, i32 -> i32
        %1185 = wave.barrier %357 : (!wave.mem.token) -> !wave.mem.token
        %1186 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %1183, %1184, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1187 = wave.assume %1186 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1188 = wave.ptr_add %209, %1187 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1189 = wave.ptr_add %210, %1171 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1190 = wave.where %1181 {
          %1254 = waveamd.dma_load_lds %1188 -> %1189 after %1185 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1254 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1191 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%53, %1183, %1184, %165) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1192 = wave.assume %1191 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1193 = wave.ptr_add %209, %1192 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1194 = wave.ptr_add %210, %1177 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1195 = wave.where %1182 {
          %1254 = waveamd.dma_load_lds %1193 -> %1194 after %1185 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          wave.yield %1254 : !wave.mem.token
        } : !wave.mask<64> -> !wave.mem.token
        %1196 = wave.join %1190, %1195 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1197 = wave.join %1180, %1196 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1198 = wave.barrier %arg33 : (!wave.mem.token) -> !wave.mem.token
        %1199 = wave.binary muli %1116, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1200 = wave.ptr_add %171, %1199 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1201 = wave.ptr_add %1200, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_114, %token_115 = wave.load %1201 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1202 = wave.ptr_add %1200, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_116, %token_117 = wave.load %1202 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1203 = wave.ptr_add %1200, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_118, %token_119 = wave.load %1203 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1204 = wave.ptr_add %1200, %294 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_120, %token_121 = wave.load %1204 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1205 = wave.ptr_add %1200, %296 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_122, %token_123 = wave.load %1205 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1206 = wave.ptr_add %1200, %298 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_124, %token_125 = wave.load %1206 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1207 = wave.ptr_add %1200, %300 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_126, %token_127 = wave.load %1207 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1208 = wave.ptr_add %1200, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_128, %token_129 = wave.load %1208 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1209 = wave.ptr_add %172, %1199 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1210 = wave.ptr_add %1209, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_130, %token_131 = waveamd.transpose_load %1210 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1211 = wave.extract %value_130[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1212 = wave.extract %value_130[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1213 = wave.extract %value_130[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1214 = wave.extract %value_130[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1215 = wave.ptr_add %1209, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_132, %token_133 = waveamd.transpose_load %1215 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1216 = wave.extract %value_132[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1217 = wave.extract %value_132[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1218 = wave.extract %value_132[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1219 = wave.extract %value_132[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1220 = wave.pack %1211, %1212, %1213, %1214, %1216, %1217, %1218, %1219 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1221 = wave.ptr_add %1209, %318 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_134, %token_135 = waveamd.transpose_load %1221 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1222 = wave.extract %value_134[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1223 = wave.extract %value_134[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1224 = wave.extract %value_134[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1225 = wave.extract %value_134[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1226 = wave.ptr_add %1209, %324 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_136, %token_137 = waveamd.transpose_load %1226 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1227 = wave.extract %value_136[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1228 = wave.extract %value_136[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1229 = wave.extract %value_136[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1230 = wave.extract %value_136[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1231 = wave.pack %1222, %1223, %1224, %1225, %1227, %1228, %1229, %1230 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1232 = wave.ptr_add %1209, %331 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_138, %token_139 = waveamd.transpose_load %1232 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1233 = wave.extract %value_138[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1234 = wave.extract %value_138[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1235 = wave.extract %value_138[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1236 = wave.extract %value_138[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1237 = wave.ptr_add %1209, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_140, %token_141 = waveamd.transpose_load %1237 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1238 = wave.extract %value_140[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1239 = wave.extract %value_140[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1240 = wave.extract %value_140[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1241 = wave.extract %value_140[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1242 = wave.pack %1233, %1234, %1235, %1236, %1238, %1239, %1240, %1241 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1243 = wave.ptr_add %1209, %344 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_142, %token_143 = waveamd.transpose_load %1243 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1244 = wave.extract %value_142[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1245 = wave.extract %value_142[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1246 = wave.extract %value_142[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1247 = wave.extract %value_142[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1248 = wave.ptr_add %1209, %350 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_144, %token_145 = waveamd.transpose_load %1248 after %1198 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1249 = wave.extract %value_144[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1250 = wave.extract %value_144[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1251 = wave.extract %value_144[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1252 = wave.extract %value_144[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1253 = wave.pack %1244, %1245, %1246, %1247, %1249, %1250, %1251, %1252 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        scf.yield %value_114, %value_116, %value_118, %value_120, %value_122, %value_124, %value_126, %value_128, %1220, %1231, %1242, %1253, %1141, %1144, %1147, %1150, %1153, %1156, %1159, %1162, %1197, %1198 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token
      }
      %360 = wave.alloc() {align = 16 : i64, bytesize = 33792 : i64} : !wave.ptr<#wave.shared, f16>
      %361 = wave.splat %31 : i32 -> !wave.simd<i32, 64>
      %362 = wave.binary muli %148, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %363 = wave.binary muli %149, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %364 = wave.binary muli %150, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %365 = wave.binary muli %151, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %366 = wave.binary muli %152, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %367 = wave.binary muli %153, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %368 = wave.binary muli %154, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %369 = wave.binary muli %155, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %370 = wave.binary muli %156, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %371 = wave.binary muli %157, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %372 = wave.binary muli %158, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %373 = wave.binary muli %159, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %374 = wave.binary muli %160, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %375 = wave.binary muli %161, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %376 = wave.binary muli %162, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %377 = wave.binary muli %163, %361 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %378 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %379 = wave.ptr_cast %360 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %380 = wave.binary muli %193, %c66_i32 overflow<nsw> : i32, i32 -> i32
      %381 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%362, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %382 = wave.assume %381 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %383 = wave.ptr_add %378, %382 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %384 = wave.ptr_add %379, %380 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %385 = waveamd.dma_load_lds %383 -> %384 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %386 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%363, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %387 = wave.assume %386 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %388 = wave.ptr_add %378, %387 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %389 = wave.binary addi %380, %c528_i32 overflow<nsw> : i32, i32 -> i32
      %390 = wave.ptr_add %379, %389 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %391 = waveamd.dma_load_lds %388 -> %390 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %392 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%364, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %393 = wave.assume %392 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %394 = wave.ptr_add %378, %393 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %395 = wave.binary addi %380, %c1056_i32 overflow<nsw> : i32, i32 -> i32
      %396 = wave.ptr_add %379, %395 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %397 = waveamd.dma_load_lds %394 -> %396 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %398 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%365, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %399 = wave.assume %398 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %400 = wave.ptr_add %378, %399 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %401 = wave.binary addi %380, %c1584_i32 overflow<nsw> : i32, i32 -> i32
      %402 = wave.ptr_add %379, %401 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %403 = waveamd.dma_load_lds %400 -> %402 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %404 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%366, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %405 = wave.assume %404 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %406 = wave.ptr_add %378, %405 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %407 = wave.binary addi %380, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %408 = wave.ptr_add %379, %407 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %409 = waveamd.dma_load_lds %406 -> %408 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %410 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%367, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %411 = wave.assume %410 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %412 = wave.ptr_add %378, %411 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %413 = wave.binary addi %380, %c2640_i32 overflow<nsw> : i32, i32 -> i32
      %414 = wave.ptr_add %379, %413 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %415 = waveamd.dma_load_lds %412 -> %414 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %416 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%368, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %417 = wave.assume %416 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %418 = wave.ptr_add %378, %417 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %419 = wave.binary addi %380, %c3168_i32 overflow<nsw> : i32, i32 -> i32
      %420 = wave.ptr_add %379, %419 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %421 = waveamd.dma_load_lds %418 -> %420 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %422 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%369, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %423 = wave.assume %422 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %424 = wave.ptr_add %378, %423 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %425 = wave.binary addi %380, %c3696_i32 overflow<nsw> : i32, i32 -> i32
      %426 = wave.ptr_add %379, %425 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %427 = waveamd.dma_load_lds %424 -> %426 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %428 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%370, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %429 = wave.assume %428 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %430 = wave.ptr_add %378, %429 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %431 = wave.binary addi %380, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %432 = wave.ptr_add %379, %431 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %433 = waveamd.dma_load_lds %430 -> %432 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %434 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%371, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %435 = wave.assume %434 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %436 = wave.ptr_add %378, %435 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %437 = wave.binary addi %380, %c4752_i32 overflow<nsw> : i32, i32 -> i32
      %438 = wave.ptr_add %379, %437 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %439 = waveamd.dma_load_lds %436 -> %438 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %440 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%372, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %441 = wave.assume %440 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %442 = wave.ptr_add %378, %441 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %443 = wave.binary addi %380, %c5280_i32 overflow<nsw> : i32, i32 -> i32
      %444 = wave.ptr_add %379, %443 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %445 = waveamd.dma_load_lds %442 -> %444 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %446 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%373, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %447 = wave.assume %446 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %448 = wave.ptr_add %378, %447 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %449 = wave.binary addi %380, %c5808_i32 overflow<nsw> : i32, i32 -> i32
      %450 = wave.ptr_add %379, %449 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %451 = waveamd.dma_load_lds %448 -> %450 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %452 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%374, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %453 = wave.assume %452 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %454 = wave.ptr_add %378, %453 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %455 = wave.binary addi %380, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %456 = wave.ptr_add %379, %455 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %457 = waveamd.dma_load_lds %454 -> %456 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %458 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%375, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %459 = wave.assume %458 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %460 = wave.ptr_add %378, %459 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %461 = wave.binary addi %380, %c6864_i32 overflow<nsw> : i32, i32 -> i32
      %462 = wave.ptr_add %379, %461 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %463 = waveamd.dma_load_lds %460 -> %462 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %464 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%376, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %465 = wave.assume %464 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %466 = wave.ptr_add %378, %465 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %467 = wave.binary addi %380, %c7392_i32 overflow<nsw> : i32, i32 -> i32
      %468 = wave.ptr_add %379, %467 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %469 = waveamd.dma_load_lds %466 -> %468 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %470 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%377, %166) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %471 = wave.assume %470 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %472 = wave.ptr_add %378, %471 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %473 = wave.binary addi %380, %c7920_i32 overflow<nsw> : i32, i32 -> i32
      %474 = wave.ptr_add %379, %473 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %475 = waveamd.dma_load_lds %472 -> %474 after %189 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %476 = wave.join %385, %391, %397, %403, %409, %415, %421, %427, %433, %439, %445, %451, %457, %463, %469, %475 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %477 = waveamd.fragment_pack %359#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %478 = waveamd.fragment_pack %359#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %479 = waveamd.fragment_pack %359#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %480 = waveamd.fragment_pack %359#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %481 = waveamd.fragment_pack %359#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %482 = waveamd.fragment_pack %359#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %483 = waveamd.fragment_pack %359#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %484 = waveamd.fragment_pack %359#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %485 = waveamd.fragment_pack %359#8 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %486 = waveamd.fragment_pack %359#9 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %487 = waveamd.fragment_pack %359#10 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %488 = waveamd.fragment_pack %359#11 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %489 = waveamd.fragment_pack %359#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %490 = waveamd.fragment_pack %359#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %491 = waveamd.fragment_pack %359#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %492 = waveamd.fragment_pack %359#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %493 = waveamd.fragment_pack %359#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %494 = waveamd.fragment_pack %359#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %495 = waveamd.fragment_pack %359#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %496 = waveamd.fragment_pack %359#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %497 = waveamd.mma "mfma.f32.16x16x32.f16" %485, %477, %489 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %498 = waveamd.mma "mfma.f32.16x16x32.f16" %486, %478, %497 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %499 = waveamd.fragment_unpack %498 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %500 = waveamd.mma "mfma.f32.16x16x32.f16" %487, %477, %490 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %501 = waveamd.mma "mfma.f32.16x16x32.f16" %488, %478, %500 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %502 = waveamd.fragment_unpack %501 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %503 = waveamd.mma "mfma.f32.16x16x32.f16" %485, %479, %491 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %504 = waveamd.mma "mfma.f32.16x16x32.f16" %486, %480, %503 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %505 = waveamd.fragment_unpack %504 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %506 = waveamd.mma "mfma.f32.16x16x32.f16" %487, %479, %492 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %507 = waveamd.mma "mfma.f32.16x16x32.f16" %488, %480, %506 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %508 = waveamd.fragment_unpack %507 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %509 = waveamd.mma "mfma.f32.16x16x32.f16" %485, %481, %493 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %510 = waveamd.mma "mfma.f32.16x16x32.f16" %486, %482, %509 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %511 = waveamd.fragment_unpack %510 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %512 = waveamd.mma "mfma.f32.16x16x32.f16" %487, %481, %494 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %513 = waveamd.mma "mfma.f32.16x16x32.f16" %488, %482, %512 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %514 = waveamd.fragment_unpack %513 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %515 = waveamd.mma "mfma.f32.16x16x32.f16" %485, %483, %495 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %516 = waveamd.mma "mfma.f32.16x16x32.f16" %486, %484, %515 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %517 = waveamd.fragment_unpack %516 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %518 = waveamd.mma "mfma.f32.16x16x32.f16" %487, %483, %496 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %519 = waveamd.mma "mfma.f32.16x16x32.f16" %488, %484, %518 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %520 = waveamd.fragment_unpack %519 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %521 = wave.barrier %359#20, %476 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %522 = wave.binary subi %170, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %523 = wave.binary remsi %522, %c3_i32 : i32, i32 -> i32
      %524 = wave.binary muli %523, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %525 = wave.ptr_add %171, %524 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %526 = wave.barrier %359#21, %287 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %527 = wave.join %304, %521, %526 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %528 = wave.ptr_add %525, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_30, %token_31 = wave.load %528 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %529 = wave.ptr_add %525, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_32, %token_33 = wave.load %529 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %530 = wave.ptr_add %525, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_34, %token_35 = wave.load %530 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %531 = wave.ptr_add %525, %294 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_36, %token_37 = wave.load %531 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %532 = wave.ptr_add %525, %296 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_38, %token_39 = wave.load %532 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %533 = wave.ptr_add %525, %298 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_40, %token_41 = wave.load %533 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %534 = wave.ptr_add %525, %300 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_42, %token_43 = wave.load %534 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %535 = wave.ptr_add %525, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_44, %token_45 = wave.load %535 after %527 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %536 = wave.join %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %537 = wave.ptr_add %172, %524 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %538 = wave.barrier %359#21, %287 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %539 = wave.join %357, %521, %538 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %540 = wave.ptr_add %537, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_46, %token_47 = waveamd.transpose_load %540 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %541 = wave.extract %value_46[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %542 = wave.extract %value_46[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %543 = wave.extract %value_46[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %544 = wave.extract %value_46[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %545 = wave.ptr_add %537, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_48, %token_49 = waveamd.transpose_load %545 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %546 = wave.extract %value_48[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %547 = wave.extract %value_48[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %548 = wave.extract %value_48[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %549 = wave.extract %value_48[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %550 = wave.pack %541, %542, %543, %544, %546, %547, %548, %549 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %551 = wave.ptr_add %537, %318 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_50, %token_51 = waveamd.transpose_load %551 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %552 = wave.extract %value_50[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %553 = wave.extract %value_50[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %554 = wave.extract %value_50[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %555 = wave.extract %value_50[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %556 = wave.ptr_add %537, %324 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_52, %token_53 = waveamd.transpose_load %556 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %557 = wave.extract %value_52[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %558 = wave.extract %value_52[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %559 = wave.extract %value_52[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %560 = wave.extract %value_52[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %561 = wave.pack %552, %553, %554, %555, %557, %558, %559, %560 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %562 = wave.ptr_add %537, %331 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_54, %token_55 = waveamd.transpose_load %562 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %563 = wave.extract %value_54[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %564 = wave.extract %value_54[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %565 = wave.extract %value_54[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %566 = wave.extract %value_54[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %567 = wave.ptr_add %537, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_56, %token_57 = waveamd.transpose_load %567 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %568 = wave.extract %value_56[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %569 = wave.extract %value_56[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %570 = wave.extract %value_56[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %571 = wave.extract %value_56[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %572 = wave.pack %563, %564, %565, %566, %568, %569, %570, %571 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %573 = wave.ptr_add %537, %344 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_58, %token_59 = waveamd.transpose_load %573 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %574 = wave.extract %value_58[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %575 = wave.extract %value_58[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %576 = wave.extract %value_58[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %577 = wave.extract %value_58[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %578 = wave.ptr_add %537, %350 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_60, %token_61 = waveamd.transpose_load %578 after %539 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %579 = wave.extract %value_60[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %580 = wave.extract %value_60[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %581 = wave.extract %value_60[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %582 = wave.extract %value_60[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %583 = wave.pack %574, %575, %576, %577, %579, %580, %581, %582 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %584 = wave.join %token_47, %token_49, %token_51, %token_53, %token_55, %token_57, %token_59, %token_61 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %585 = waveamd.fragment_pack %value_30 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %586 = waveamd.fragment_pack %value_32 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %587 = waveamd.fragment_pack %value_34 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %588 = waveamd.fragment_pack %value_36 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %589 = waveamd.fragment_pack %value_38 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %590 = waveamd.fragment_pack %value_40 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %591 = waveamd.fragment_pack %value_42 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %592 = waveamd.fragment_pack %value_44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %593 = waveamd.fragment_pack %550 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %594 = waveamd.fragment_pack %561 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %595 = waveamd.fragment_pack %572 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %596 = waveamd.fragment_pack %583 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %597 = waveamd.fragment_pack %499 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %598 = waveamd.fragment_pack %502 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %599 = waveamd.fragment_pack %505 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %600 = waveamd.fragment_pack %508 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %601 = waveamd.fragment_pack %511 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %602 = waveamd.fragment_pack %514 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %603 = waveamd.fragment_pack %517 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %604 = waveamd.fragment_pack %520 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %605 = waveamd.mma "mfma.f32.16x16x32.f16" %593, %585, %597 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %606 = waveamd.mma "mfma.f32.16x16x32.f16" %594, %586, %605 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %607 = waveamd.fragment_unpack %606 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %608 = waveamd.mma "mfma.f32.16x16x32.f16" %595, %585, %598 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %609 = waveamd.mma "mfma.f32.16x16x32.f16" %596, %586, %608 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %610 = waveamd.fragment_unpack %609 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %611 = waveamd.mma "mfma.f32.16x16x32.f16" %593, %587, %599 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %612 = waveamd.mma "mfma.f32.16x16x32.f16" %594, %588, %611 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %613 = waveamd.fragment_unpack %612 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %614 = waveamd.mma "mfma.f32.16x16x32.f16" %595, %587, %600 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.mma "mfma.f32.16x16x32.f16" %596, %588, %614 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %616 = waveamd.fragment_unpack %615 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %617 = waveamd.mma "mfma.f32.16x16x32.f16" %593, %589, %601 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.mma "mfma.f32.16x16x32.f16" %594, %590, %617 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %619 = waveamd.fragment_unpack %618 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %620 = waveamd.mma "mfma.f32.16x16x32.f16" %595, %589, %602 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.mma "mfma.f32.16x16x32.f16" %596, %590, %620 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %622 = waveamd.fragment_unpack %621 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %623 = waveamd.mma "mfma.f32.16x16x32.f16" %593, %591, %603 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.mma "mfma.f32.16x16x32.f16" %594, %592, %623 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %625 = waveamd.fragment_unpack %624 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %626 = waveamd.mma "mfma.f32.16x16x32.f16" %595, %591, %604 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.mma "mfma.f32.16x16x32.f16" %596, %592, %626 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %628 = waveamd.fragment_unpack %627 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %629 = wave.binary addi %170, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %630 = wave.binary remsi %629, %c3_i32 : i32, i32 -> i32
      %631 = wave.binary muli %630, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %632 = wave.ptr_add %171, %631 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %633 = wave.join %526, %304, %536 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %634 = wave.ptr_add %632, %288 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_62, %token_63 = wave.load %634 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %635 = wave.ptr_add %632, %290 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_64, %token_65 = wave.load %635 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %636 = wave.ptr_add %632, %292 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_66, %token_67 = wave.load %636 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %637 = wave.ptr_add %632, %294 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_68, %token_69 = wave.load %637 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %638 = wave.ptr_add %632, %296 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_70, %token_71 = wave.load %638 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %639 = wave.ptr_add %632, %298 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_72, %token_73 = wave.load %639 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %640 = wave.ptr_add %632, %300 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_74, %token_75 = wave.load %640 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %641 = wave.ptr_add %632, %302 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_76, %token_77 = wave.load %641 after %633 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %642 = wave.ptr_add %172, %631 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %643 = wave.join %538, %357, %584 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %644 = wave.ptr_add %642, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_78, %token_79 = waveamd.transpose_load %644 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %645 = wave.extract %value_78[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %646 = wave.extract %value_78[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %647 = wave.extract %value_78[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %648 = wave.extract %value_78[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %649 = wave.ptr_add %642, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_80, %token_81 = waveamd.transpose_load %649 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %650 = wave.extract %value_80[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %651 = wave.extract %value_80[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %652 = wave.extract %value_80[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %653 = wave.extract %value_80[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %654 = wave.pack %645, %646, %647, %648, %650, %651, %652, %653 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %655 = wave.ptr_add %642, %318 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_82, %token_83 = waveamd.transpose_load %655 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %656 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %657 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %658 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %659 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %660 = wave.ptr_add %642, %324 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_84, %token_85 = waveamd.transpose_load %660 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %661 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %662 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %663 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %664 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %665 = wave.pack %656, %657, %658, %659, %661, %662, %663, %664 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %666 = wave.ptr_add %642, %331 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_86, %token_87 = waveamd.transpose_load %666 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %667 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %668 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %669 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %670 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %671 = wave.ptr_add %642, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_88, %token_89 = waveamd.transpose_load %671 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %672 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %673 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %674 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %675 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %676 = wave.pack %667, %668, %669, %670, %672, %673, %674, %675 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %677 = wave.ptr_add %642, %344 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_90, %token_91 = waveamd.transpose_load %677 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %678 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %679 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %680 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %681 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %682 = wave.ptr_add %642, %350 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_92, %token_93 = waveamd.transpose_load %682 after %643 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %683 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %684 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %685 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %686 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %687 = wave.pack %678, %679, %680, %681, %683, %684, %685, %686 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %688 = waveamd.fragment_pack %value_62 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %689 = waveamd.fragment_pack %value_64 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %690 = waveamd.fragment_pack %value_66 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %691 = waveamd.fragment_pack %value_68 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %692 = waveamd.fragment_pack %value_70 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %693 = waveamd.fragment_pack %value_72 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %694 = waveamd.fragment_pack %value_74 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %695 = waveamd.fragment_pack %value_76 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %696 = waveamd.fragment_pack %654 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %697 = waveamd.fragment_pack %665 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %698 = waveamd.fragment_pack %676 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %699 = waveamd.fragment_pack %687 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %700 = waveamd.fragment_pack %607 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %701 = waveamd.fragment_pack %610 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %702 = waveamd.fragment_pack %613 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %703 = waveamd.fragment_pack %616 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %704 = waveamd.fragment_pack %619 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %705 = waveamd.fragment_pack %622 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %706 = waveamd.fragment_pack %625 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %707 = waveamd.fragment_pack %628 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %708 = waveamd.mma "mfma.f32.16x16x32.f16" %696, %688, %700 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %709 = waveamd.mma "mfma.f32.16x16x32.f16" %697, %689, %708 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %710 = waveamd.fragment_unpack %709 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %711 = waveamd.mma "mfma.f32.16x16x32.f16" %698, %688, %701 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %712 = waveamd.mma "mfma.f32.16x16x32.f16" %699, %689, %711 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %713 = waveamd.fragment_unpack %712 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %714 = waveamd.mma "mfma.f32.16x16x32.f16" %696, %690, %702 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %715 = waveamd.mma "mfma.f32.16x16x32.f16" %697, %691, %714 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %716 = waveamd.fragment_unpack %715 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %717 = waveamd.mma "mfma.f32.16x16x32.f16" %698, %690, %703 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %718 = waveamd.mma "mfma.f32.16x16x32.f16" %699, %691, %717 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %719 = waveamd.fragment_unpack %718 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %720 = waveamd.mma "mfma.f32.16x16x32.f16" %696, %692, %704 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %721 = waveamd.mma "mfma.f32.16x16x32.f16" %697, %693, %720 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %722 = waveamd.fragment_unpack %721 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %723 = waveamd.mma "mfma.f32.16x16x32.f16" %698, %692, %705 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %724 = waveamd.mma "mfma.f32.16x16x32.f16" %699, %693, %723 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %725 = waveamd.fragment_unpack %724 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %726 = waveamd.mma "mfma.f32.16x16x32.f16" %696, %694, %706 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %727 = waveamd.mma "mfma.f32.16x16x32.f16" %697, %695, %726 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %728 = waveamd.fragment_unpack %727 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %729 = waveamd.mma "mfma.f32.16x16x32.f16" %698, %694, %707 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %730 = waveamd.mma "mfma.f32.16x16x32.f16" %699, %695, %729 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %731 = waveamd.fragment_unpack %730 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %732 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %733 = wave.assume %167 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %734 = wave.ptr_add %732, %733 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_94, %token_95 = wave.load %734 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %735 = wave.assume %168 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %736 = wave.ptr_add %732, %735 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_96, %token_97 = wave.load %736 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %737 = wave.cast fpconvert %value_94 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %738 = wave.cast fpconvert %value_96 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %739 = wave.fadd %710, %737 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %740 = wave.fadd %713, %738 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %741 = wave.fadd %716, %737 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %742 = wave.fadd %719, %738 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %743 = wave.fadd %722, %737 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %744 = wave.fadd %725, %738 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %745 = wave.fadd %728, %737 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %746 = wave.fadd %731, %738 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %747 = wave.binary xori %100, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %748 = wave.binary xori %747, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %749 = wave.binary xori %748, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %750 = wave.binary xori %749, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %751 = wave.binary muli %58, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %752 = wave.binary muli %62, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %753 = wave.binary xori %751, %752 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %754 = wave.binary muli %66, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %755 = wave.binary xori %753, %754 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %756 = wave.binary muli %69, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %757 = wave.binary xori %755, %756 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %758 = wave.binary remui %757, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %759 = wave.binary divui %757, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %760 = wave.binary remui %759, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %761 = wave.binary muli %760, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %762 = wave.binary addi %758, %761 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %763 = wave.binary divui %757, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %764 = wave.binary remui %763, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %765 = wave.binary muli %764, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %766 = wave.binary addi %762, %765 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %767 = wave.binary divui %757, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %768 = wave.binary remui %767, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %769 = wave.binary muli %768, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %770 = wave.binary addi %766, %769 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %771 = wave.binary divui %757, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %772 = wave.binary remui %771, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %773 = wave.binary muli %772, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %774 = wave.binary addi %770, %773 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %775 = wave.binary divui %757, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %776 = wave.binary remui %775, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %777 = wave.binary muli %776, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %778 = wave.binary addi %774, %777 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %779 = wave.binary divui %757, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %780 = wave.binary remui %779, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %781 = wave.binary muli %780, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %782 = wave.binary addi %778, %781 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %783 = wave.binary remui %750, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %784 = wave.binary muli %783, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %785 = wave.binary addi %782, %784 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %786 = wave.binary divui %750, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %787 = wave.binary remui %786, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %788 = wave.binary muli %787, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %789 = wave.binary addi %785, %788 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %790 = wave.binary divui %750, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %791 = wave.binary remui %790, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %792 = wave.binary muli %791, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %793 = wave.binary addi %789, %792 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %794 = wave.binary divui %750, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %795 = wave.binary remui %794, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %796 = wave.binary muli %795, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %797 = wave.binary addi %793, %796 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %798 = wave.binary divui %750, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %799 = wave.binary remui %798, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %800 = wave.binary muli %799, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %801 = wave.binary addi %797, %800 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %802 = wave.binary divui %750, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %803 = wave.binary remui %802, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %804 = wave.binary muli %803, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %805 = wave.binary addi %801, %804 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %806 = wave.binary divui %750, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %807 = wave.binary remui %806, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %808 = wave.binary muli %807, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %809 = wave.binary addi %805, %808 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %810 = wave.binary divui %809, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %811 = wave.binary muli %810, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %812 = wave.binary addi %809, %811 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %813 = wave.assume %812 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %814 = wave.binary xori %22, %751 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %815 = wave.binary xori %814, %752 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %816 = wave.binary xori %815, %754 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %817 = wave.binary xori %816, %756 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %818 = wave.binary remui %817, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %819 = wave.binary divui %817, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %820 = wave.binary remui %819, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %821 = wave.binary muli %820, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %822 = wave.binary addi %818, %821 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %823 = wave.binary divui %817, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %824 = wave.binary remui %823, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %825 = wave.binary muli %824, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %826 = wave.binary addi %822, %825 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %827 = wave.binary divui %817, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %828 = wave.binary remui %827, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %829 = wave.binary muli %828, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %830 = wave.binary addi %826, %829 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %831 = wave.binary divui %817, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %832 = wave.binary remui %831, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %833 = wave.binary muli %832, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %834 = wave.binary addi %830, %833 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %835 = wave.binary divui %817, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %836 = wave.binary remui %835, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %837 = wave.binary muli %836, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %838 = wave.binary addi %834, %837 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %839 = wave.binary divui %817, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %840 = wave.binary remui %839, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %841 = wave.binary muli %840, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %842 = wave.binary addi %838, %841 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %843 = wave.binary addi %842, %784 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %844 = wave.binary addi %843, %788 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %845 = wave.binary addi %844, %792 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %846 = wave.binary addi %845, %796 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %847 = wave.binary addi %846, %800 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %848 = wave.binary addi %847, %804 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %849 = wave.binary addi %848, %808 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %850 = wave.binary divui %849, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %851 = wave.binary muli %850, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %852 = wave.binary addi %849, %851 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %853 = wave.assume %852 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %854 = wave.binary xori %23, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %855 = wave.binary xori %854, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %856 = wave.binary xori %855, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %857 = wave.binary xori %856, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %858 = wave.binary xori %857, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %859 = wave.binary remui %858, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %860 = wave.binary muli %859, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %861 = wave.binary addi %782, %860 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %862 = wave.binary divui %858, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %863 = wave.binary remui %862, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %864 = wave.binary muli %863, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %865 = wave.binary addi %861, %864 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %866 = wave.binary divui %858, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %867 = wave.binary remui %866, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %868 = wave.binary muli %867, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %869 = wave.binary addi %865, %868 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %870 = wave.binary divui %858, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %871 = wave.binary remui %870, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %872 = wave.binary muli %871, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %873 = wave.binary addi %869, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %874 = wave.binary divui %858, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %875 = wave.binary remui %874, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %876 = wave.binary muli %875, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %877 = wave.binary addi %873, %876 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %878 = wave.binary divui %858, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %879 = wave.binary remui %878, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %880 = wave.binary muli %879, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %881 = wave.binary addi %877, %880 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %882 = wave.binary divui %858, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %883 = wave.binary remui %882, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %884 = wave.binary muli %883, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %885 = wave.binary addi %881, %884 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %886 = wave.binary divui %885, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %887 = wave.binary muli %886, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %888 = wave.binary addi %885, %887 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %889 = wave.assume %888 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %890 = wave.binary addi %842, %860 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %891 = wave.binary addi %890, %864 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %892 = wave.binary addi %891, %868 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %893 = wave.binary addi %892, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %894 = wave.binary addi %893, %876 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %895 = wave.binary addi %894, %880 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %896 = wave.binary addi %895, %884 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %897 = wave.binary divui %896, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %898 = wave.binary muli %897, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %899 = wave.binary addi %896, %898 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %900 = wave.assume %899 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %901 = wave.binary xori %22, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %902 = wave.binary xori %901, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %903 = wave.binary xori %902, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %904 = wave.binary xori %903, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %905 = wave.binary xori %904, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %906 = wave.binary remui %905, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %907 = wave.binary muli %906, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %908 = wave.binary addi %782, %907 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %909 = wave.binary divui %905, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %910 = wave.binary remui %909, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %911 = wave.binary muli %910, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %912 = wave.binary addi %908, %911 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %913 = wave.binary divui %905, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %914 = wave.binary remui %913, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %915 = wave.binary muli %914, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %916 = wave.binary addi %912, %915 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %917 = wave.binary divui %905, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %918 = wave.binary remui %917, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %919 = wave.binary muli %918, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %920 = wave.binary addi %916, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %921 = wave.binary divui %905, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %922 = wave.binary remui %921, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %923 = wave.binary muli %922, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %924 = wave.binary addi %920, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %925 = wave.binary divui %905, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %926 = wave.binary remui %925, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %927 = wave.binary muli %926, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %928 = wave.binary addi %924, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %929 = wave.binary divui %905, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %930 = wave.binary remui %929, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %931 = wave.binary muli %930, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %932 = wave.binary addi %928, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %933 = wave.binary divui %932, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %934 = wave.binary muli %933, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary addi %932, %934 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.assume %935 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %937 = wave.binary addi %842, %907 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary addi %937, %911 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary addi %938, %915 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary addi %939, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary addi %940, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary addi %941, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary addi %942, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary divui %943, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary muli %944, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary addi %943, %945 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.assume %946 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %948 = wave.binary xori %11, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %949 = wave.binary xori %948, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.binary xori %949, %107 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %951 = wave.binary xori %950, %109 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary xori %951, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary remui %952, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary muli %953, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary addi %782, %954 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary divui %952, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary remui %956, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary muli %957, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary addi %955, %958 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary divui %952, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.binary remui %960, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %962 = wave.binary muli %961, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %963 = wave.binary addi %959, %962 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %964 = wave.binary divui %952, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %965 = wave.binary remui %964, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %966 = wave.binary muli %965, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %967 = wave.binary addi %963, %966 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %968 = wave.binary divui %952, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %969 = wave.binary remui %968, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %970 = wave.binary muli %969, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %971 = wave.binary addi %967, %970 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %972 = wave.binary divui %952, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %973 = wave.binary remui %972, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %974 = wave.binary muli %973, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %975 = wave.binary addi %971, %974 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %976 = wave.binary divui %952, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %977 = wave.binary remui %976, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %978 = wave.binary muli %977, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %979 = wave.binary addi %975, %978 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %980 = wave.binary divui %979, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %981 = wave.binary muli %980, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %982 = wave.binary addi %979, %981 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %983 = wave.assume %982 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %984 = wave.binary addi %842, %954 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %985 = wave.binary addi %984, %958 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %986 = wave.binary addi %985, %962 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %987 = wave.binary addi %986, %966 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %988 = wave.binary addi %987, %970 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %989 = wave.binary addi %988, %974 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %990 = wave.binary addi %989, %978 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %991 = wave.binary divui %990, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %992 = wave.binary muli %991, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %993 = wave.binary addi %990, %992 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %994 = wave.assume %993 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %995 = wave.ptr_add %360, %813 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_98, %token_99 = wave.load %995 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %996 = wave.ptr_add %360, %853 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_100, %token_101 = wave.load %996 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %997 = wave.ptr_add %360, %889 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_102, %token_103 = wave.load %997 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %998 = wave.ptr_add %360, %900 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_104, %token_105 = wave.load %998 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %999 = wave.ptr_add %360, %936 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_106, %token_107 = wave.load %999 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1000 = wave.ptr_add %360, %947 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_108, %token_109 = wave.load %1000 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1001 = wave.ptr_add %360, %983 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_110, %token_111 = wave.load %1001 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1002 = wave.ptr_add %360, %994 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_112, %token_113 = wave.load %1002 after %521 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1003 = wave.cast fpconvert %value_98 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1004 = wave.cast fpconvert %value_100 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1005 = wave.cast fpconvert %value_102 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1006 = wave.cast fpconvert %value_104 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1007 = wave.cast fpconvert %value_106 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1008 = wave.cast fpconvert %value_108 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1009 = wave.cast fpconvert %value_110 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1010 = wave.cast fpconvert %value_112 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1011 = wave.fma %739, %1003, %739 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1012 = wave.fma %740, %1004, %740 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1013 = wave.fma %741, %1005, %741 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1014 = wave.fma %742, %1006, %742 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1015 = wave.fma %743, %1007, %743 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1016 = wave.fma %744, %1008, %744 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1017 = wave.fma %745, %1009, %745 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1018 = wave.fma %746, %1010, %746 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1019 = wave.cmpi slt %135, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1020 = wave.cmpi slt %136, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1021 = wave.cmpi slt %137, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1022 = wave.cmpi slt %138, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1023 = wave.select %1019, %2, %1 : !wave.mask<64>, !wave.simd<i32, 64>
      %1024 = wave.select %1020, %2, %1 : !wave.mask<64>, !wave.simd<i32, 64>
      %1025 = wave.select %1021, %2, %1 : !wave.mask<64>, !wave.simd<i32, 64>
      %1026 = wave.select %1022, %2, %1 : !wave.mask<64>, !wave.simd<i32, 64>
      %1027 = wave.cmpi slt %143, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1028 = wave.cmpi slt %144, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1029 = wave.select %1027, %2, %1 : !wave.mask<64>, !wave.simd<i32, 64>
      %1030 = wave.select %1028, %2, %1 : !wave.mask<64>, !wave.simd<i32, 64>
      %1031 = wave.binary andi %1023, %1029 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1032 = wave.binary andi %1023, %1030 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1033 = wave.binary andi %1024, %1029 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1034 = wave.binary andi %1024, %1030 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1035 = wave.binary andi %1025, %1029 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1036 = wave.binary andi %1025, %1030 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1037 = wave.binary andi %1026, %1029 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1038 = wave.binary andi %1026, %1030 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1039 = wave.assume %arg11 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %1040 = wave.binary muli %52, %1039 overflow<nsw> : i32, i32 -> i32
      %1041 = wave.splat %1039 : i32 -> !wave.simd<i32, 64>
      %1042 = wave.binary muli %112, %1041 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1043 = wave.binary muli %113, %1041 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1044 = wave.binary muli %114, %1041 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1045 = wave.binary muli %115, %1041 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1046 = wave.binary addi %1040, %139 overflow<nsw> : i32, i32 -> i32
      %1047 = wave.binary addi %1042, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1048 = wave.binary addi %1042, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1049 = wave.binary addi %1043, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1050 = wave.binary addi %1043, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1051 = wave.binary addi %1044, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1052 = wave.binary addi %1044, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1053 = wave.binary addi %1045, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1054 = wave.binary addi %1045, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1055 = wave.splat %1046 : i32 -> !wave.simd<i32, 64>
      %1056 = wave.binary addi %1055, %1047 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1057 = wave.binary addi %1055, %1048 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1058 = wave.binary addi %1055, %1049 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1059 = wave.binary addi %1055, %1050 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1060 = wave.binary addi %1055, %1051 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1061 = wave.binary addi %1055, %1052 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1062 = wave.binary addi %1055, %1053 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1063 = wave.binary addi %1055, %1054 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1064 = wave.cast fpconvert %1011 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1065 = wave.cast fpconvert %1012 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1066 = wave.cast fpconvert %1013 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1067 = wave.cast fpconvert %1014 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1068 = wave.cast fpconvert %1015 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1069 = wave.cast fpconvert %1016 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1070 = wave.cast fpconvert %1017 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1071 = wave.cast fpconvert %1018 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1072 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %1073 = wave.cmpi ne %1031, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1074 = wave.assume %1056 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1075 = wave.ptr_add %1072, %1074 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1076 = wave.ptr_add %1072, %0 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1077 = wave.select %1073, %1075, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1078 = wave.store %1064 -> %1077 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1079 = wave.cmpi ne %1032, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1080 = wave.assume %1057 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1081 = wave.ptr_add %1072, %1080 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1082 = wave.select %1079, %1081, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1083 = wave.store %1065 -> %1082 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1084 = wave.cmpi ne %1033, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1085 = wave.assume %1058 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1086 = wave.ptr_add %1072, %1085 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1087 = wave.select %1084, %1086, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1088 = wave.store %1066 -> %1087 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1089 = wave.cmpi ne %1034, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1090 = wave.assume %1059 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1091 = wave.ptr_add %1072, %1090 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1092 = wave.select %1089, %1091, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1093 = wave.store %1067 -> %1092 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1094 = wave.cmpi ne %1035, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1095 = wave.assume %1060 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1096 = wave.ptr_add %1072, %1095 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1097 = wave.select %1094, %1096, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1098 = wave.store %1068 -> %1097 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1099 = wave.cmpi ne %1036, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1100 = wave.assume %1061 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1101 = wave.ptr_add %1072, %1100 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1102 = wave.select %1099, %1101, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1103 = wave.store %1069 -> %1102 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1104 = wave.cmpi ne %1037, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1105 = wave.assume %1062 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1106 = wave.ptr_add %1072, %1105 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1107 = wave.select %1104, %1106, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1108 = wave.store %1070 -> %1107 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1109 = wave.cmpi ne %1038, %1 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1110 = wave.assume %1063 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1111 = wave.ptr_add %1072, %1110 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1112 = wave.select %1109, %1111, %1076 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1113 = wave.store %1071 -> %1112 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      return
    }
  }
}
