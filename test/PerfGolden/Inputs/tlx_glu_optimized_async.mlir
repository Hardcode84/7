module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_optimized_async(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 8192 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 1024 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 512 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
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
      %27 = wave.constant false -> !wave.mask<64>
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
      %c4224_i32 = arith.constant 4224 : i32
      %c8448_i32 = arith.constant 8448 : i32
      %c2112_i32 = arith.constant 2112 : i32
      %c264_i32 = arith.constant 264 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c66_i32 = arith.constant 66 : i32
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
      %28 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %29 = wave.pack %28, %28, %28, %28 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %30 = wave.assume %arg8 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %31 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %32 = wave.assume %arg10 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %33 = wave.workgroup_id 0
      %34 = wave.binary addi %arg5, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %35 = wave.binary divsi %34, %c128_i32 : i32, i32 -> i32
      %36 = wave.binary addi %arg6, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %37 = wave.binary divsi %36, %c128_i32 : i32, i32 -> i32
      %38 = wave.binary muli %35, %37 : i32, i32 -> i32
      %39 = wave.binary divsi %38, %c32_i32 : i32, i32 -> i32
      %40 = wave.binary muli %39, %c32_i32 : i32, i32 -> i32
      %41 = arith.cmpi sge, %33, %40 : i32
      %42 = scf.if %41 -> (i32) {
        scf.yield %33 : i32
      } else {
        %1131 = wave.binary remui %33, %c8_i32 : i32, i32 -> i32
        %1132 = wave.binary divui %33, %c8_i32 : i32, i32 -> i32
        %1133 = wave.binary divui %1132, %c4_i32 : i32, i32 -> i32
        %1134 = wave.binary muli %1133, %c32_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1135 = wave.binary muli %1131, %c4_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1136 = wave.binary addi %1134, %1135 overflow<nsw, nuw> : i32, i32 -> i32
        %1137 = wave.binary remui %1132, %c4_i32 : i32, i32 -> i32
        %1138 = wave.binary addi %1136, %1137 overflow<nsw, nuw> : i32, i32 -> i32
        scf.yield %1138 : i32
      }
      %43 = wave.binary muli %37, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %44 = wave.binary divsi %42, %43 : i32, i32 -> i32
      %45 = wave.binary muli %44, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %46 = wave.binary subi %35, %45 overflow<nsw> : i32, i32 -> i32
      %47 = arith.cmpi slt, %46, %c4_i32 : i32
      %48 = wave.select %47, %46, %c4_i32 : i32
      %49 = wave.binary remsi %42, %43 : i32, i32 -> i32
      %50 = wave.binary remsi %49, %48 : i32, i32 -> i32
      %51 = wave.binary addi %45, %50 overflow<nsw> : i32, i32 -> i32
      %52 = wave.binary divsi %49, %48 : i32, i32 -> i32
      %53 = wave.binary muli %51, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %54 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %55 = wave.binary divui %54, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %56 = wave.binary remui %55, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %57 = wave.binary muli %56, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %58 = wave.binary divui %54, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary remui %58, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary muli %59, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary addi %57, %60 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary divui %54, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary remui %62, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary muli %63, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary addi %61, %64 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary divui %54, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary remui %66, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary addi %65, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.binary divui %54, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.binary remui %69, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary muli %70, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary addi %68, %71 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary divui %54, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary remui %73, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.binary muli %74, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %76 = wave.binary addi %72, %75 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary addi %76, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary remui %54, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary muli %78, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary remui %54, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary muli %80, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary remui %58, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary muli %82, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.binary addi %83, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.binary remui %66, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary addi %85, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary addi %85, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.binary addi %85, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %89 = wave.binary addi %85, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %90 = wave.binary addi %85, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary addi %85, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %92 = wave.binary addi %85, %15 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %93 = wave.binary addi %85, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %94 = wave.binary addi %85, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %95 = wave.binary addi %85, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %96 = wave.binary addi %85, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %97 = wave.binary addi %85, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %98 = wave.binary addi %85, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %99 = wave.binary addi %85, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %100 = wave.binary addi %85, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %101 = wave.binary remui %54, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %102 = wave.binary divui %54, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %103 = wave.binary remui %102, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %104 = wave.binary muli %103, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %105 = wave.binary addi %101, %104 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %106 = wave.binary divui %54, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %107 = wave.binary remui %106, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %108 = wave.binary muli %107, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %109 = wave.binary addi %105, %108 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %110 = wave.binary muli %56, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %111 = wave.binary addi %109, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %112 = wave.binary muli %74, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %113 = wave.binary addi %111, %112 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %114 = wave.binary addi %113, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %115 = wave.binary addi %113, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %116 = wave.binary addi %113, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %117 = wave.splat %53 : i32 -> !wave.simd<i32, 64>
      %118 = wave.binary addi %117, %76 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %119 = wave.binary addi %117, %77 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %120 = wave.binary addi %117, %85 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %121 = wave.binary addi %117, %86 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %122 = wave.binary addi %117, %87 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %123 = wave.binary addi %117, %88 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %124 = wave.binary addi %117, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %125 = wave.binary addi %117, %90 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %126 = wave.binary addi %117, %91 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %127 = wave.binary addi %117, %92 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %128 = wave.binary addi %117, %93 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %129 = wave.binary addi %117, %94 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %130 = wave.binary addi %117, %95 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %131 = wave.binary addi %117, %96 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %132 = wave.binary addi %117, %97 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %133 = wave.binary addi %117, %98 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %134 = wave.binary addi %117, %99 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %135 = wave.binary addi %117, %100 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %136 = wave.binary addi %117, %113 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %137 = wave.binary addi %117, %114 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %138 = wave.binary addi %117, %115 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %139 = wave.binary addi %117, %116 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %140 = wave.binary muli %52, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %141 = wave.splat %140 : i32 -> !wave.simd<i32, 64>
      %142 = wave.binary addi %141, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %143 = wave.binary addi %141, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %144 = wave.binary addi %141, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %145 = wave.binary addi %141, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %146 = wave.splat %arg5 : i32 -> !wave.simd<i32, 64>
      %147 = wave.binary remsi %118, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %148 = wave.binary remsi %119, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %149 = wave.binary remsi %120, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %150 = wave.binary remsi %121, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %151 = wave.binary remsi %122, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %152 = wave.binary remsi %123, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %153 = wave.binary remsi %124, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %154 = wave.binary remsi %125, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %155 = wave.binary remsi %126, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %156 = wave.binary remsi %127, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %157 = wave.binary remsi %128, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %158 = wave.binary remsi %129, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %159 = wave.binary remsi %130, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %160 = wave.binary remsi %131, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %161 = wave.binary remsi %132, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %162 = wave.binary remsi %133, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %163 = wave.binary remsi %134, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %164 = wave.binary remsi %135, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %165 = wave.splat %arg6 : i32 -> !wave.simd<i32, 64>
      %166 = wave.binary remsi %142, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %167 = wave.binary remsi %143, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %168 = wave.binary remsi %144, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %169 = wave.binary remsi %145, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %170 = wave.binary addi %arg7, %c63_i32 overflow<nsw> : i32, i32 -> i32
      %171 = wave.binary divsi %170, %c64_i32 : i32, i32 -> i32
      %172 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %173 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %174 = wave.binary remui %54, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %175 = wave.binary muli %174, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %176 = wave.binary muli %59, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %177 = wave.binary muli %63, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %178 = wave.binary addi %176, %177 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %179 = wave.binary addi %178, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %180 = wave.binary addi %179, %71 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %181 = wave.binary muli %74, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %182 = wave.binary addi %180, %181 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %183 = wave.binary addi %182, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %184 = wave.splat %arg7 : i32 -> !wave.simd<i32, 64>
      %185 = wave.cmpi slt %175, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %186 = wave.splat %30 : i32 -> !wave.simd<i32, 64>
      %187 = wave.binary muli %147, %186 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %188 = wave.binary muli %148, %186 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %189 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %190 = wave.token : !wave.mem.token
      %191 = wave.ptr_cast %172 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %192 = wave.read_first %54 : !wave.simd<i32, 64> -> i32
      %193 = wave.assume %192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
      %194 = wave.binary divui %193, %c64_i32 : i32, i32 -> i32
      %195 = wave.binary muli %194, %c264_i32 overflow<nsw> : i32, i32 -> i32
      %196 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%54, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %197 = wave.assume %196 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %198 = wave.ptr_add %189, %197 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %199 = wave.ptr_add %191, %195 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %200 = wave.ptr_add %189, %7 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %201 = wave.select %185, %198, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %202 = waveamd.dma_load_lds %201 -> %199 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %203 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%54, %188) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %204 = wave.assume %203 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %205 = wave.ptr_add %189, %204 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %206 = wave.binary addi %195, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %207 = wave.ptr_add %191, %206 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %208 = wave.select %185, %205, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %209 = waveamd.dma_load_lds %208 -> %207 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %210 = wave.join %202, %209 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %211 = wave.cmpi slt %182, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %212 = wave.cmpi slt %183, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %213 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %214 = wave.ptr_cast %173 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %215 = wave.index_expr <"s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1"](%54, %31, %166) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %216 = wave.assume %215 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %217 = wave.ptr_add %213, %216 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %218 = wave.ptr_add %214, %195 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %219 = wave.ptr_add %213, %7 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %220 = wave.select %211, %217, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %221 = waveamd.dma_load_lds %220 -> %218 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %222 = wave.index_expr <"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1"](%54, %31, %166) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %223 = wave.assume %222 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %224 = wave.ptr_add %213, %223 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %225 = wave.ptr_add %214, %206 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %226 = wave.select %212, %224, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %227 = waveamd.dma_load_lds %226 -> %225 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %228 = wave.join %221, %227 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %229 = wave.join %210, %228 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %230 = wave.binary subi %arg7, %c64_i32 : i32, i32 -> i32
      %231 = wave.splat %230 : i32 -> !wave.simd<i32, 64>
      %232 = wave.cmpi slt %175, %231 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %233 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%54, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %234 = wave.assume %233 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %235 = wave.ptr_add %189, %234 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %236 = wave.binary addi %c4224_i32, %195 overflow<nsw> : i32, i32 -> i32
      %237 = wave.ptr_add %191, %236 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %238 = wave.select %232, %235, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %239 = waveamd.dma_load_lds %238 -> %237 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %240 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741752 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%54, %188) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %241 = wave.assume %240 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %242 = wave.ptr_add %189, %241 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %243 = wave.binary addi %c4224_i32, %206 overflow<nsw> : i32, i32 -> i32
      %244 = wave.ptr_add %191, %243 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %245 = wave.select %232, %242, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %246 = waveamd.dma_load_lds %245 -> %244 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %247 = wave.join %239, %246 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %248 = wave.cmpi slt %182, %231 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %249 = wave.cmpi slt %183, %231 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %250 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %251 = wave.binary muli %250, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %252 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%54, %250, %166, %251) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %253 = wave.assume %252 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %254 = wave.ptr_add %213, %253 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %255 = wave.ptr_add %214, %236 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %256 = wave.select %248, %254, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %257 = waveamd.dma_load_lds %256 -> %255 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %258 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%54, %250, %166, %251) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %259 = wave.assume %258 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %260 = wave.ptr_add %213, %259 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %261 = wave.ptr_add %214, %243 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %262 = wave.select %249, %260, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %263 = waveamd.dma_load_lds %262 -> %261 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %264 = wave.join %257, %263 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %265 = wave.join %247, %264 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %266 = wave.binary subi %arg7, %c128_i32 : i32, i32 -> i32
      %267 = wave.splat %266 : i32 -> !wave.simd<i32, 64>
      %268 = wave.cmpi slt %175, %267 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %269 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%54, %187) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %270 = wave.assume %269 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %271 = wave.ptr_add %189, %270 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %272 = wave.binary addi %c8448_i32, %195 overflow<nsw> : i32, i32 -> i32
      %273 = wave.ptr_add %191, %272 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %274 = wave.select %268, %271, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %275 = waveamd.dma_load_lds %274 -> %273 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %276 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741688 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0"](%54, %188) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %277 = wave.assume %276 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %278 = wave.ptr_add %189, %277 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %279 = wave.binary addi %c8448_i32, %206 overflow<nsw> : i32, i32 -> i32
      %280 = wave.ptr_add %191, %279 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %281 = wave.select %268, %278, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %282 = waveamd.dma_load_lds %281 -> %280 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %283 = wave.join %275, %282 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %284 = wave.cmpi slt %182, %267 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %285 = wave.cmpi slt %183, %267 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %286 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %287 = wave.binary muli %286, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %288 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%54, %286, %287, %166) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %289 = wave.assume %288 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %290 = wave.ptr_add %213, %289 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %291 = wave.ptr_add %214, %272 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %292 = wave.select %284, %290, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %293 = waveamd.dma_load_lds %292 -> %291 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %294 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%54, %286, %287, %166) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %295 = wave.assume %294 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %296 = wave.ptr_add %213, %295 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %297 = wave.ptr_add %214, %279 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %298 = wave.select %285, %296, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %299 = waveamd.dma_load_lds %298 -> %297 after %190 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %300 = wave.join %293, %299 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %301 = wave.join %283, %300 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %302 = wave.barrier %229, %265 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %303 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %304 = wave.ptr_add %172, %303 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %304 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %305 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %306 = wave.ptr_add %172, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %306 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %307 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %308 = wave.ptr_add %172, %307 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %308 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %309 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 128*Mod(1 + floor(1/512*wi), 2) + 256*Mod(floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %310 = wave.ptr_add %172, %309 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %310 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %311 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %312 = wave.ptr_add %172, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %312 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %313 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %314 = wave.ptr_add %172, %313 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %314 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %315 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %316 = wave.ptr_add %172, %315 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %316 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %317 = wave.index_expr <"32 + 8*floor(1/16*Mod(wi, 64)) + 256*Mod(1 + floor(1/2 + 1/4*floor(1/256*wi) + 1/64*Mod(Mod(wi, 64), 16)), 2) + 128*Mod(1 + floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %318 = wave.ptr_add %172, %317 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %318 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %319 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %320 = wave.index_expr <"128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %321 = wave.ptr_add %173, %320 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_14, %token_15 = waveamd.transpose_load %321 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %322 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %323 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %324 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %325 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %326 = wave.index_expr <"4224 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %327 = wave.ptr_add %173, %326 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_16, %token_17 = waveamd.transpose_load %327 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %328 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %329 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %330 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %331 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %332 = wave.pack %322, %323, %324, %325, %328, %329, %330, %331 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %333 = wave.index_expr <"256 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %334 = wave.ptr_add %173, %333 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_18, %token_19 = waveamd.transpose_load %334 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %335 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %336 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %337 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %338 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %339 = wave.index_expr <"4480 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %340 = wave.ptr_add %173, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_20, %token_21 = waveamd.transpose_load %340 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %341 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %342 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %343 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %344 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %345 = wave.pack %335, %336, %337, %338, %341, %342, %343, %344 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %346 = wave.index_expr <"64 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %347 = wave.ptr_add %173, %346 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_22, %token_23 = waveamd.transpose_load %347 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %348 = wave.extract %value_22[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %349 = wave.extract %value_22[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %350 = wave.extract %value_22[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %351 = wave.extract %value_22[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %352 = wave.index_expr <"4288 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %353 = wave.ptr_add %173, %352 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_24, %token_25 = waveamd.transpose_load %353 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %354 = wave.extract %value_24[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %355 = wave.extract %value_24[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %356 = wave.extract %value_24[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %357 = wave.extract %value_24[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %358 = wave.pack %348, %349, %350, %351, %354, %355, %356, %357 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %359 = wave.index_expr <"320 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %360 = wave.ptr_add %173, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_26, %token_27 = waveamd.transpose_load %360 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %361 = wave.extract %value_26[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %362 = wave.extract %value_26[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %363 = wave.extract %value_26[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %364 = wave.extract %value_26[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %365 = wave.index_expr <"4544 + 128*floor(1/32*Mod(wi, 64)) + 528*floor(1/4*Mod(Mod(wi, 64), 16)) + 16*Mod(floor(1/64*wi), 4) + 2112*Mod(floor(1/16*Mod(wi, 64)), 2) + 4*Mod(Mod(Mod(wi, 64), 16), 4)"> ["wi"](%54) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %366 = wave.ptr_add %173, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_28, %token_29 = waveamd.transpose_load %366 after %302 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %367 = wave.extract %value_28[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %368 = wave.extract %value_28[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %369 = wave.extract %value_28[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %370 = wave.extract %value_28[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %371 = wave.pack %361, %362, %363, %364, %367, %368, %369, %370 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %372 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %373 = wave.binary subi %171, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %374 = wave.join %210, %247, %283, %319 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %375 = wave.join %228, %264, %300, %372 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %376:26 = scf.for %arg12 = %c0_i32 to %373 step %c1_i32 iter_args(%arg13 = %value, %arg14 = %value_0, %arg15 = %value_2, %arg16 = %value_4, %arg17 = %value_6, %arg18 = %value_8, %arg19 = %value_10, %arg20 = %value_12, %arg21 = %332, %arg22 = %345, %arg23 = %358, %arg24 = %371, %arg25 = %29, %arg26 = %29, %arg27 = %29, %arg28 = %29, %arg29 = %29, %arg30 = %29, %arg31 = %29, %arg32 = %29, %arg33 = %301, %arg34 = %190, %arg35 = %190, %arg36 = %301, %arg37 = %374, %arg38 = %375) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %1131 = wave.binary remui %arg12, %c3_i32 : i32, i32 -> i32
        %1132 = wave.binary addi %arg12, %c1_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1133 = wave.binary remui %1132, %c3_i32 : i32, i32 -> i32
        %1134 = wave.binary addi %arg12, %c3_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1135 = wave.binary muli %1134, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1136 = waveamd.fragment_pack %arg13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1137 = waveamd.fragment_pack %arg14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1138 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1139 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1140 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1141 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1142 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1143 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1144 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1145 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1146 = waveamd.fragment_pack %arg23 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1147 = waveamd.fragment_pack %arg24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1148 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1149 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1150 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1151 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1152 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1153 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1154 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1155 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1156 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1136, %1148 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1157 = waveamd.mma "mfma.f32.16x16x32.f16" %1145, %1137, %1156 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1158 = waveamd.fragment_unpack %1157 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1159 = waveamd.mma "mfma.f32.16x16x32.f16" %1146, %1136, %1149 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1160 = waveamd.mma "mfma.f32.16x16x32.f16" %1147, %1137, %1159 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1161 = waveamd.fragment_unpack %1160 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1162 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1138, %1150 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1163 = waveamd.mma "mfma.f32.16x16x32.f16" %1145, %1139, %1162 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1164 = waveamd.fragment_unpack %1163 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1165 = waveamd.mma "mfma.f32.16x16x32.f16" %1146, %1138, %1151 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1166 = waveamd.mma "mfma.f32.16x16x32.f16" %1147, %1139, %1165 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1167 = waveamd.fragment_unpack %1166 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1168 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1140, %1152 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1169 = waveamd.mma "mfma.f32.16x16x32.f16" %1145, %1141, %1168 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1170 = waveamd.fragment_unpack %1169 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1171 = waveamd.mma "mfma.f32.16x16x32.f16" %1146, %1140, %1153 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1172 = waveamd.mma "mfma.f32.16x16x32.f16" %1147, %1141, %1171 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1173 = waveamd.fragment_unpack %1172 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1174 = waveamd.mma "mfma.f32.16x16x32.f16" %1144, %1142, %1154 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1175 = waveamd.mma "mfma.f32.16x16x32.f16" %1145, %1143, %1174 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1176 = waveamd.fragment_unpack %1175 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1177 = waveamd.mma "mfma.f32.16x16x32.f16" %1146, %1142, %1155 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1178 = waveamd.mma "mfma.f32.16x16x32.f16" %1147, %1143, %1177 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1179 = waveamd.fragment_unpack %1178 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1180 = wave.binary subi %arg7, %1135 : i32, i32 -> i32
        %1181 = wave.splat %1180 : i32 -> !wave.simd<i32, 64>
        %1182 = wave.binary muli %1131, %c4224_i32 overflow<nsw> : i32, i32 -> i32
        %1183 = wave.cmpi slt %175, %1181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1184 = wave.select %1183, %6, %5 : !wave.mask<64>, !wave.simd<i32, 64>
        %1185 = wave.splat %arg12 : i32 -> !wave.simd<i32, 64>
        %1186 = wave.lane_id : !wave.simd<i32, 64>
        %1187 = wave.binary addi %1186, %1185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1188 = wave.binary addi %1184, %1187 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1189 = wave.binary addi %6, %1187 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1190 = wave.cmpi eq %1188, %1189 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1191 = wave.barrier : () -> !wave.mem.token
        %1192 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%54, %1135, %187) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1193 = wave.assume %1192 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1194 = wave.ptr_add %189, %1193 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1195 = wave.binary addi %1182, %195 overflow<nsw> : i32, i32 -> i32
        %1196 = wave.ptr_add %191, %1195 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1197 = wave.select %1190, %1194, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1198 = waveamd.dma_load_lds %1197 -> %1196 after %1191 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1199 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2) <= 0">] ["wi", "s0", "s1"](%54, %1135, %188) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1200 = wave.assume %1199 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1201 = wave.ptr_add %189, %1200 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1202 = wave.binary addi %1182, %206 overflow<nsw> : i32, i32 -> i32
        %1203 = wave.ptr_add %191, %1202 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1204 = wave.select %1190, %1201, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1205 = waveamd.dma_load_lds %1204 -> %1203 after %1191 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1206 = wave.join %1198, %1205 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1207 = wave.assume %arg9 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1208 = wave.binary muli %1135, %1207 overflow<nsw> : i32, i32 -> i32
        %1209 = wave.cmpi slt %182, %1181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1210 = wave.select %1209, %6, %5 : !wave.mask<64>, !wave.simd<i32, 64>
        %1211 = wave.binary addi %1210, %1187 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1212 = wave.cmpi eq %1211, %1189 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1213 = wave.cmpi slt %183, %1181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1214 = wave.select %1213, %6, %5 : !wave.mask<64>, !wave.simd<i32, 64>
        %1215 = wave.binary addi %1214, %1187 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1216 = wave.cmpi eq %1215, %1189 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1217 = wave.index_expr <"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%54, %1207, %1208, %166) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1218 = wave.assume %1217 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1219 = wave.ptr_add %213, %1218 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1220 = wave.ptr_add %214, %1195 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1221 = wave.select %1212, %1219, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1222 = waveamd.dma_load_lds %1221 -> %1220 after %1191 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1223 = wave.index_expr <"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2))"> assuming [#wave.pred<"s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*(4*Mod(1 + floor(1/512*wi), 2) + 8*Mod(floor(1/256*wi), 2) + 2*Mod(floor(1/128*wi), 2) + Mod(floor(1/64*wi), 2) + 32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2)) <= 0">] ["wi", "s0", "s1", "s2"](%54, %1207, %1208, %166) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1224 = wave.assume %1223 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1225 = wave.ptr_add %213, %1224 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1226 = wave.ptr_add %214, %1202 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1227 = wave.select %1216, %1225, %219 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1228 = waveamd.dma_load_lds %1227 -> %1226 after %1191 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1229 = wave.join %1222, %1228 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1230 = wave.join %1206, %1229 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1231 = wave.binary muli %1133, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1232 = wave.ptr_add %172, %1231 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1233 = wave.ptr_add %1232, %303 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_114, %token_115 = wave.load %1233 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1234 = wave.ptr_add %1232, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_116, %token_117 = wave.load %1234 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1235 = wave.ptr_add %1232, %307 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_118, %token_119 = wave.load %1235 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1236 = wave.ptr_add %1232, %309 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_120, %token_121 = wave.load %1236 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1237 = wave.ptr_add %1232, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_122, %token_123 = wave.load %1237 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1238 = wave.ptr_add %1232, %313 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_124, %token_125 = wave.load %1238 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1239 = wave.ptr_add %1232, %315 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_126, %token_127 = wave.load %1239 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1240 = wave.ptr_add %1232, %317 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_128, %token_129 = wave.load %1240 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1241 = wave.join %token_115, %token_117, %token_119, %token_121, %token_123, %token_125, %token_127, %token_129 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1242 = wave.join %arg35, %1241 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1243 = wave.ptr_add %173, %1231 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1244 = wave.ptr_add %1243, %320 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_130, %token_131 = waveamd.transpose_load %1244 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1245 = wave.extract %value_130[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1246 = wave.extract %value_130[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1247 = wave.extract %value_130[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1248 = wave.extract %value_130[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1249 = wave.ptr_add %1243, %326 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_132, %token_133 = waveamd.transpose_load %1249 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1250 = wave.extract %value_132[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1251 = wave.extract %value_132[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1252 = wave.extract %value_132[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1253 = wave.extract %value_132[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1254 = wave.pack %1245, %1246, %1247, %1248, %1250, %1251, %1252, %1253 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1255 = wave.ptr_add %1243, %333 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_134, %token_135 = waveamd.transpose_load %1255 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1256 = wave.extract %value_134[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1257 = wave.extract %value_134[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1258 = wave.extract %value_134[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1259 = wave.extract %value_134[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1260 = wave.ptr_add %1243, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_136, %token_137 = waveamd.transpose_load %1260 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1261 = wave.extract %value_136[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1262 = wave.extract %value_136[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1263 = wave.extract %value_136[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1264 = wave.extract %value_136[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1265 = wave.pack %1256, %1257, %1258, %1259, %1261, %1262, %1263, %1264 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1266 = wave.ptr_add %1243, %346 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_138, %token_139 = waveamd.transpose_load %1266 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1267 = wave.extract %value_138[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1268 = wave.extract %value_138[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1269 = wave.extract %value_138[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1270 = wave.extract %value_138[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1271 = wave.ptr_add %1243, %352 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_140, %token_141 = waveamd.transpose_load %1271 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1272 = wave.extract %value_140[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1273 = wave.extract %value_140[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1274 = wave.extract %value_140[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1275 = wave.extract %value_140[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1276 = wave.pack %1267, %1268, %1269, %1270, %1272, %1273, %1274, %1275 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1277 = wave.ptr_add %1243, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_142, %token_143 = waveamd.transpose_load %1277 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1278 = wave.extract %value_142[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1279 = wave.extract %value_142[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1280 = wave.extract %value_142[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1281 = wave.extract %value_142[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1282 = wave.ptr_add %1243, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_144, %token_145 = waveamd.transpose_load %1282 after %190 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1283 = wave.extract %value_144[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1284 = wave.extract %value_144[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1285 = wave.extract %value_144[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1286 = wave.extract %value_144[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1287 = wave.pack %1278, %1279, %1280, %1281, %1283, %1284, %1285, %1286 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1288 = wave.join %token_131, %token_133, %token_135, %token_137, %token_139, %token_141, %token_143, %token_145 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1289 = wave.join %arg34, %1288 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1290 = wave.barrier %arg33 : (!wave.mem.token) -> !wave.mem.token
        %1291 = wave.join %arg37, %1206, %1241 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1292 = wave.join %arg38, %1229, %1288 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        scf.yield %value_114, %value_116, %value_118, %value_120, %value_122, %value_124, %value_126, %value_128, %1254, %1265, %1276, %1287, %1158, %1161, %1164, %1167, %1170, %1173, %1176, %1179, %1230, %1289, %1242, %1290, %1291, %1292 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %377 = wave.alloc() {align = 16 : i64, bytesize = 33792 : i64} : !wave.ptr<#wave.shared, f16>
      %378 = wave.splat %32 : i32 -> !wave.simd<i32, 64>
      %379 = wave.binary muli %149, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %380 = wave.binary muli %150, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %381 = wave.binary muli %151, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %382 = wave.binary muli %152, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %383 = wave.binary muli %153, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %384 = wave.binary muli %154, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %385 = wave.binary muli %155, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %386 = wave.binary muli %156, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %387 = wave.binary muli %157, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %388 = wave.binary muli %158, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %389 = wave.binary muli %159, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %390 = wave.binary muli %160, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %391 = wave.binary muli %161, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %392 = wave.binary muli %162, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %393 = wave.binary muli %163, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %394 = wave.binary muli %164, %378 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %395 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %396 = wave.ptr_cast %377 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %397 = wave.binary muli %194, %c66_i32 overflow<nsw> : i32, i32 -> i32
      %398 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %379) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %399 = wave.assume %398 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %400 = wave.ptr_add %395, %399 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %401 = wave.ptr_add %396, %397 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %402 = waveamd.dma_load_lds %400 -> %401 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %403 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %380) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %404 = wave.assume %403 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %405 = wave.ptr_add %395, %404 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %406 = wave.binary addi %397, %c528_i32 overflow<nsw> : i32, i32 -> i32
      %407 = wave.ptr_add %396, %406 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %408 = waveamd.dma_load_lds %405 -> %407 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %409 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %381) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %410 = wave.assume %409 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %411 = wave.ptr_add %395, %410 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %412 = wave.binary addi %397, %c1056_i32 overflow<nsw> : i32, i32 -> i32
      %413 = wave.ptr_add %396, %412 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %414 = waveamd.dma_load_lds %411 -> %413 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %415 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %382) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %416 = wave.assume %415 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %417 = wave.ptr_add %395, %416 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %418 = wave.binary addi %397, %c1584_i32 overflow<nsw> : i32, i32 -> i32
      %419 = wave.ptr_add %396, %418 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %420 = waveamd.dma_load_lds %417 -> %419 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %421 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %383) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %422 = wave.assume %421 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %423 = wave.ptr_add %395, %422 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %424 = wave.binary addi %397, %c2112_i32 overflow<nsw> : i32, i32 -> i32
      %425 = wave.ptr_add %396, %424 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %426 = waveamd.dma_load_lds %423 -> %425 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %427 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %384) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %428 = wave.assume %427 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %429 = wave.ptr_add %395, %428 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %430 = wave.binary addi %397, %c2640_i32 overflow<nsw> : i32, i32 -> i32
      %431 = wave.ptr_add %396, %430 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %432 = waveamd.dma_load_lds %429 -> %431 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %433 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %385) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %434 = wave.assume %433 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %435 = wave.ptr_add %395, %434 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %436 = wave.binary addi %397, %c3168_i32 overflow<nsw> : i32, i32 -> i32
      %437 = wave.ptr_add %396, %436 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %438 = waveamd.dma_load_lds %435 -> %437 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %439 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %386) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %440 = wave.assume %439 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %441 = wave.ptr_add %395, %440 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %442 = wave.binary addi %397, %c3696_i32 overflow<nsw> : i32, i32 -> i32
      %443 = wave.ptr_add %396, %442 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %444 = waveamd.dma_load_lds %441 -> %443 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %445 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %387) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %446 = wave.assume %445 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %447 = wave.ptr_add %395, %446 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %448 = wave.binary addi %397, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %449 = wave.ptr_add %396, %448 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %450 = waveamd.dma_load_lds %447 -> %449 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %451 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %388) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %452 = wave.assume %451 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %453 = wave.ptr_add %395, %452 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %454 = wave.binary addi %397, %c4752_i32 overflow<nsw> : i32, i32 -> i32
      %455 = wave.ptr_add %396, %454 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %456 = waveamd.dma_load_lds %453 -> %455 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %457 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %389) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %458 = wave.assume %457 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %459 = wave.ptr_add %395, %458 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %460 = wave.binary addi %397, %c5280_i32 overflow<nsw> : i32, i32 -> i32
      %461 = wave.ptr_add %396, %460 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %462 = waveamd.dma_load_lds %459 -> %461 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %463 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %390) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %464 = wave.assume %463 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %465 = wave.ptr_add %395, %464 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %466 = wave.binary addi %397, %c5808_i32 overflow<nsw> : i32, i32 -> i32
      %467 = wave.ptr_add %396, %466 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %468 = waveamd.dma_load_lds %465 -> %467 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %469 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %391) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %470 = wave.assume %469 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %471 = wave.ptr_add %395, %470 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %472 = wave.binary addi %397, %c6336_i32 overflow<nsw> : i32, i32 -> i32
      %473 = wave.ptr_add %396, %472 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %474 = waveamd.dma_load_lds %471 -> %473 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %475 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %392) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %476 = wave.assume %475 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %477 = wave.ptr_add %395, %476 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %478 = wave.binary addi %397, %c6864_i32 overflow<nsw> : i32, i32 -> i32
      %479 = wave.ptr_add %396, %478 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %480 = waveamd.dma_load_lds %477 -> %479 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %481 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %393) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %482 = wave.assume %481 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %483 = wave.ptr_add %395, %482 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %484 = wave.binary addi %397, %c7392_i32 overflow<nsw> : i32, i32 -> i32
      %485 = wave.ptr_add %396, %484 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %486 = waveamd.dma_load_lds %483 -> %485 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %487 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%167, %394) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %488 = wave.assume %487 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %489 = wave.ptr_add %395, %488 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %490 = wave.binary addi %397, %c7920_i32 overflow<nsw> : i32, i32 -> i32
      %491 = wave.ptr_add %396, %490 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %492 = waveamd.dma_load_lds %489 -> %491 after %190 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %493 = wave.join %402, %408, %414, %420, %426, %432, %438, %444, %450, %456, %462, %468, %474, %480, %486, %492 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %494 = waveamd.fragment_pack %376#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %495 = waveamd.fragment_pack %376#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %496 = waveamd.fragment_pack %376#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %497 = waveamd.fragment_pack %376#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %498 = waveamd.fragment_pack %376#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %499 = waveamd.fragment_pack %376#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %500 = waveamd.fragment_pack %376#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %501 = waveamd.fragment_pack %376#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %502 = waveamd.fragment_pack %376#8 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %503 = waveamd.fragment_pack %376#9 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %504 = waveamd.fragment_pack %376#10 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %505 = waveamd.fragment_pack %376#11 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %506 = waveamd.fragment_pack %376#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %507 = waveamd.fragment_pack %376#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %508 = waveamd.fragment_pack %376#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %509 = waveamd.fragment_pack %376#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %510 = waveamd.fragment_pack %376#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %511 = waveamd.fragment_pack %376#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %512 = waveamd.fragment_pack %376#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %513 = waveamd.fragment_pack %376#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %514 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %494, %506 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %515 = waveamd.mma "mfma.f32.16x16x32.f16" %503, %495, %514 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %516 = waveamd.fragment_unpack %515 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %517 = waveamd.mma "mfma.f32.16x16x32.f16" %504, %494, %507 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %518 = waveamd.mma "mfma.f32.16x16x32.f16" %505, %495, %517 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %519 = waveamd.fragment_unpack %518 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %520 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %496, %508 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %521 = waveamd.mma "mfma.f32.16x16x32.f16" %503, %497, %520 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %522 = waveamd.fragment_unpack %521 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %523 = waveamd.mma "mfma.f32.16x16x32.f16" %504, %496, %509 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %524 = waveamd.mma "mfma.f32.16x16x32.f16" %505, %497, %523 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %525 = waveamd.fragment_unpack %524 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %526 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %498, %510 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %527 = waveamd.mma "mfma.f32.16x16x32.f16" %503, %499, %526 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %528 = waveamd.fragment_unpack %527 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %529 = waveamd.mma "mfma.f32.16x16x32.f16" %504, %498, %511 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %530 = waveamd.mma "mfma.f32.16x16x32.f16" %505, %499, %529 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %531 = waveamd.fragment_unpack %530 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %532 = waveamd.mma "mfma.f32.16x16x32.f16" %502, %500, %512 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %533 = waveamd.mma "mfma.f32.16x16x32.f16" %503, %501, %532 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %534 = waveamd.fragment_unpack %533 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %535 = waveamd.mma "mfma.f32.16x16x32.f16" %504, %500, %513 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %536 = waveamd.mma "mfma.f32.16x16x32.f16" %505, %501, %535 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %537 = waveamd.fragment_unpack %536 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %538 = wave.barrier %376#20, %493 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %539 = wave.binary subi %171, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %540 = wave.binary remsi %539, %c3_i32 : i32, i32 -> i32
      %541 = wave.binary muli %540, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %542 = wave.ptr_add %172, %541 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %543 = wave.join %376#22, %538, %376#23, %302, %319 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %544 = wave.ptr_add %542, %303 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_30, %token_31 = wave.load %544 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %545 = wave.ptr_add %542, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_32, %token_33 = wave.load %545 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %546 = wave.ptr_add %542, %307 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_34, %token_35 = wave.load %546 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %547 = wave.ptr_add %542, %309 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_36, %token_37 = wave.load %547 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %548 = wave.ptr_add %542, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_38, %token_39 = wave.load %548 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %549 = wave.ptr_add %542, %313 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_40, %token_41 = wave.load %549 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %550 = wave.ptr_add %542, %315 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_42, %token_43 = wave.load %550 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %551 = wave.ptr_add %542, %317 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_44, %token_45 = wave.load %551 after %543 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %552 = wave.join %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %553 = wave.ptr_add %173, %541 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %554 = wave.join %376#21, %538, %376#23, %302, %372 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %555 = wave.ptr_add %553, %320 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_46, %token_47 = waveamd.transpose_load %555 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %556 = wave.extract %value_46[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %557 = wave.extract %value_46[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %558 = wave.extract %value_46[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %559 = wave.extract %value_46[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %560 = wave.ptr_add %553, %326 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_48, %token_49 = waveamd.transpose_load %560 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %561 = wave.extract %value_48[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %562 = wave.extract %value_48[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %563 = wave.extract %value_48[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %564 = wave.extract %value_48[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %565 = wave.pack %556, %557, %558, %559, %561, %562, %563, %564 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %566 = wave.ptr_add %553, %333 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_50, %token_51 = waveamd.transpose_load %566 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %567 = wave.extract %value_50[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %568 = wave.extract %value_50[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %569 = wave.extract %value_50[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %570 = wave.extract %value_50[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %571 = wave.ptr_add %553, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_52, %token_53 = waveamd.transpose_load %571 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %572 = wave.extract %value_52[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %573 = wave.extract %value_52[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %574 = wave.extract %value_52[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %575 = wave.extract %value_52[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %576 = wave.pack %567, %568, %569, %570, %572, %573, %574, %575 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %577 = wave.ptr_add %553, %346 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_54, %token_55 = waveamd.transpose_load %577 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %578 = wave.extract %value_54[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %579 = wave.extract %value_54[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %580 = wave.extract %value_54[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %581 = wave.extract %value_54[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %582 = wave.ptr_add %553, %352 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_56, %token_57 = waveamd.transpose_load %582 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %583 = wave.extract %value_56[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %584 = wave.extract %value_56[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %585 = wave.extract %value_56[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %586 = wave.extract %value_56[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %587 = wave.pack %578, %579, %580, %581, %583, %584, %585, %586 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %588 = wave.ptr_add %553, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_58, %token_59 = waveamd.transpose_load %588 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %589 = wave.extract %value_58[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %590 = wave.extract %value_58[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %591 = wave.extract %value_58[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %592 = wave.extract %value_58[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %593 = wave.ptr_add %553, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_60, %token_61 = waveamd.transpose_load %593 after %554 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %594 = wave.extract %value_60[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %595 = wave.extract %value_60[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %596 = wave.extract %value_60[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %597 = wave.extract %value_60[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %598 = wave.pack %589, %590, %591, %592, %594, %595, %596, %597 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %599 = wave.join %token_47, %token_49, %token_51, %token_53, %token_55, %token_57, %token_59, %token_61 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %600 = waveamd.fragment_pack %value_30 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %601 = waveamd.fragment_pack %value_32 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %602 = waveamd.fragment_pack %value_34 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %603 = waveamd.fragment_pack %value_36 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %604 = waveamd.fragment_pack %value_38 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %605 = waveamd.fragment_pack %value_40 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %606 = waveamd.fragment_pack %value_42 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %607 = waveamd.fragment_pack %value_44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %608 = waveamd.fragment_pack %565 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %609 = waveamd.fragment_pack %576 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %610 = waveamd.fragment_pack %587 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %611 = waveamd.fragment_pack %598 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %612 = waveamd.fragment_pack %516 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %613 = waveamd.fragment_pack %519 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %614 = waveamd.fragment_pack %522 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %615 = waveamd.fragment_pack %525 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %616 = waveamd.fragment_pack %528 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %617 = waveamd.fragment_pack %531 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %618 = waveamd.fragment_pack %534 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %619 = waveamd.fragment_pack %537 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %620 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %600, %612 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %621 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %601, %620 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %622 = waveamd.fragment_unpack %621 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %623 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %600, %613 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %624 = waveamd.mma "mfma.f32.16x16x32.f16" %611, %601, %623 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %625 = waveamd.fragment_unpack %624 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %626 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %602, %614 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %627 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %603, %626 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %628 = waveamd.fragment_unpack %627 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %629 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %602, %615 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %630 = waveamd.mma "mfma.f32.16x16x32.f16" %611, %603, %629 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %631 = waveamd.fragment_unpack %630 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %632 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %604, %616 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %633 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %605, %632 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %634 = waveamd.fragment_unpack %633 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %635 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %604, %617 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %636 = waveamd.mma "mfma.f32.16x16x32.f16" %611, %605, %635 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %637 = waveamd.fragment_unpack %636 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %638 = waveamd.mma "mfma.f32.16x16x32.f16" %608, %606, %618 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.mma "mfma.f32.16x16x32.f16" %609, %607, %638 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %640 = waveamd.fragment_unpack %639 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %641 = waveamd.mma "mfma.f32.16x16x32.f16" %610, %606, %619 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.mma "mfma.f32.16x16x32.f16" %611, %607, %641 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %643 = waveamd.fragment_unpack %642 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %644 = wave.binary addi %171, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %645 = wave.binary remsi %644, %c3_i32 : i32, i32 -> i32
      %646 = wave.binary muli %645, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %647 = wave.ptr_add %172, %646 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %648 = wave.join %376#22, %538, %376#23, %302, %319, %552 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %649 = wave.ptr_add %647, %303 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_62, %token_63 = wave.load %649 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %650 = wave.ptr_add %647, %305 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_64, %token_65 = wave.load %650 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %651 = wave.ptr_add %647, %307 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_66, %token_67 = wave.load %651 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %652 = wave.ptr_add %647, %309 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_68, %token_69 = wave.load %652 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %653 = wave.ptr_add %647, %311 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_70, %token_71 = wave.load %653 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %654 = wave.ptr_add %647, %313 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_72, %token_73 = wave.load %654 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %655 = wave.ptr_add %647, %315 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_74, %token_75 = wave.load %655 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %656 = wave.ptr_add %647, %317 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_76, %token_77 = wave.load %656 after %648 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %657 = wave.ptr_add %173, %646 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %658 = wave.join %376#21, %538, %376#23, %302, %372, %599 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %659 = wave.ptr_add %657, %320 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_78, %token_79 = waveamd.transpose_load %659 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %660 = wave.extract %value_78[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %661 = wave.extract %value_78[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %662 = wave.extract %value_78[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %663 = wave.extract %value_78[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %664 = wave.ptr_add %657, %326 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_80, %token_81 = waveamd.transpose_load %664 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %665 = wave.extract %value_80[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %666 = wave.extract %value_80[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %667 = wave.extract %value_80[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %668 = wave.extract %value_80[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %669 = wave.pack %660, %661, %662, %663, %665, %666, %667, %668 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %670 = wave.ptr_add %657, %333 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_82, %token_83 = waveamd.transpose_load %670 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %671 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %672 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %673 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %674 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %675 = wave.ptr_add %657, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_84, %token_85 = waveamd.transpose_load %675 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %676 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %677 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %678 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %679 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %680 = wave.pack %671, %672, %673, %674, %676, %677, %678, %679 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %681 = wave.ptr_add %657, %346 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_86, %token_87 = waveamd.transpose_load %681 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %682 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %683 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %684 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %685 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %686 = wave.ptr_add %657, %352 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_88, %token_89 = waveamd.transpose_load %686 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %687 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %688 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %689 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %690 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %691 = wave.pack %682, %683, %684, %685, %687, %688, %689, %690 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %692 = wave.ptr_add %657, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_90, %token_91 = waveamd.transpose_load %692 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %693 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %694 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %695 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %696 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %697 = wave.ptr_add %657, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_92, %token_93 = waveamd.transpose_load %697 after %658 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %698 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %699 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %700 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %701 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %702 = wave.pack %693, %694, %695, %696, %698, %699, %700, %701 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %703 = waveamd.fragment_pack %value_62 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %704 = waveamd.fragment_pack %value_64 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %705 = waveamd.fragment_pack %value_66 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %706 = waveamd.fragment_pack %value_68 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %707 = waveamd.fragment_pack %value_70 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %708 = waveamd.fragment_pack %value_72 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %709 = waveamd.fragment_pack %value_74 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %710 = waveamd.fragment_pack %value_76 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %711 = waveamd.fragment_pack %669 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %712 = waveamd.fragment_pack %680 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %713 = waveamd.fragment_pack %691 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %714 = waveamd.fragment_pack %702 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %715 = waveamd.fragment_pack %622 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %716 = waveamd.fragment_pack %625 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %717 = waveamd.fragment_pack %628 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %718 = waveamd.fragment_pack %631 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %719 = waveamd.fragment_pack %634 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %720 = waveamd.fragment_pack %637 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %721 = waveamd.fragment_pack %640 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %722 = waveamd.fragment_pack %643 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %723 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %703, %715 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %724 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %704, %723 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %725 = waveamd.fragment_unpack %724 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %726 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %703, %716 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %727 = waveamd.mma "mfma.f32.16x16x32.f16" %714, %704, %726 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %728 = waveamd.fragment_unpack %727 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %729 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %705, %717 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %730 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %706, %729 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %731 = waveamd.fragment_unpack %730 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %732 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %705, %718 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %733 = waveamd.mma "mfma.f32.16x16x32.f16" %714, %706, %732 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %734 = waveamd.fragment_unpack %733 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %735 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %707, %719 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %736 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %708, %735 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %737 = waveamd.fragment_unpack %736 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %738 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %707, %720 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %739 = waveamd.mma "mfma.f32.16x16x32.f16" %714, %708, %738 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %740 = waveamd.fragment_unpack %739 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %741 = waveamd.mma "mfma.f32.16x16x32.f16" %711, %709, %721 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %742 = waveamd.mma "mfma.f32.16x16x32.f16" %712, %710, %741 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %743 = waveamd.fragment_unpack %742 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %744 = waveamd.mma "mfma.f32.16x16x32.f16" %713, %709, %722 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %745 = waveamd.mma "mfma.f32.16x16x32.f16" %714, %710, %744 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %746 = waveamd.fragment_unpack %745 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %747 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %748 = wave.assume %168 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %749 = wave.ptr_add %747, %748 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_94, %token_95 = wave.load %749 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %750 = wave.extract %value_94[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %751 = wave.extract %value_94[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %752 = wave.extract %value_94[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %753 = wave.extract %value_94[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %754 = wave.assume %169 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %755 = wave.ptr_add %747, %754 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %value_96, %token_97 = wave.load %755 : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %756 = wave.extract %value_96[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %757 = wave.extract %value_96[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %758 = wave.extract %value_96[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %759 = wave.extract %value_96[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %760 = wave.cast fpconvert %750 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %761 = wave.cast fpconvert %751 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %762 = wave.cast fpconvert %752 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %763 = wave.cast fpconvert %753 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %764 = wave.cast fpconvert %756 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %765 = wave.cast fpconvert %757 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %766 = wave.cast fpconvert %758 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %767 = wave.cast fpconvert %759 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %768 = wave.pack %760, %761, %762, %763 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %769 = wave.pack %764, %765, %766, %767 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %770 = wave.fadd %725, %768 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %771 = wave.fadd %728, %769 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %772 = wave.fadd %731, %768 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %773 = wave.fadd %734, %769 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %774 = wave.fadd %737, %768 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %775 = wave.fadd %740, %769 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %776 = wave.fadd %743, %768 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %777 = wave.fadd %746, %769 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %778 = wave.binary xori %101, %104 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %779 = wave.binary xori %778, %108 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %780 = wave.binary xori %779, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %781 = wave.binary xori %780, %112 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %782 = wave.binary muli %59, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %783 = wave.binary muli %63, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %784 = wave.binary xori %782, %783 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %785 = wave.binary muli %67, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %786 = wave.binary xori %784, %785 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %787 = wave.binary muli %70, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %788 = wave.binary xori %786, %787 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %789 = wave.binary remui %788, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %790 = wave.binary divui %788, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %791 = wave.binary remui %790, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %792 = wave.binary muli %791, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %793 = wave.binary addi %789, %792 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %794 = wave.binary divui %788, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %795 = wave.binary remui %794, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %796 = wave.binary muli %795, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %797 = wave.binary addi %793, %796 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %798 = wave.binary divui %788, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %799 = wave.binary remui %798, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %800 = wave.binary muli %799, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %801 = wave.binary addi %797, %800 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %802 = wave.binary divui %788, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %803 = wave.binary remui %802, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %804 = wave.binary muli %803, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %805 = wave.binary addi %801, %804 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %806 = wave.binary divui %788, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %807 = wave.binary remui %806, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %808 = wave.binary muli %807, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %809 = wave.binary addi %805, %808 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %810 = wave.binary divui %788, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %811 = wave.binary remui %810, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %812 = wave.binary muli %811, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %813 = wave.binary addi %809, %812 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %814 = wave.binary remui %781, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %815 = wave.binary muli %814, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %816 = wave.binary addi %813, %815 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %817 = wave.binary divui %781, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %818 = wave.binary remui %817, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %819 = wave.binary muli %818, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %820 = wave.binary addi %816, %819 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %821 = wave.binary divui %781, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %822 = wave.binary remui %821, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %823 = wave.binary muli %822, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %824 = wave.binary addi %820, %823 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %825 = wave.binary divui %781, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %826 = wave.binary remui %825, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %827 = wave.binary muli %826, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %828 = wave.binary addi %824, %827 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %829 = wave.binary divui %781, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %830 = wave.binary remui %829, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %831 = wave.binary muli %830, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %832 = wave.binary addi %828, %831 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %833 = wave.binary divui %781, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %834 = wave.binary remui %833, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %835 = wave.binary muli %834, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %836 = wave.binary addi %832, %835 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %837 = wave.binary divui %781, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %838 = wave.binary remui %837, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %839 = wave.binary muli %838, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %840 = wave.binary addi %836, %839 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %841 = wave.binary divui %840, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %842 = wave.binary muli %841, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %843 = wave.binary addi %840, %842 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %844 = wave.assume %843 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %845 = wave.binary xori %22, %782 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %846 = wave.binary xori %845, %783 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %847 = wave.binary xori %846, %785 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %848 = wave.binary xori %847, %787 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %849 = wave.binary remui %848, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %850 = wave.binary divui %848, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %851 = wave.binary remui %850, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %852 = wave.binary muli %851, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %853 = wave.binary addi %849, %852 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %854 = wave.binary divui %848, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %855 = wave.binary remui %854, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %856 = wave.binary muli %855, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %857 = wave.binary addi %853, %856 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %858 = wave.binary divui %848, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %859 = wave.binary remui %858, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %860 = wave.binary muli %859, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %861 = wave.binary addi %857, %860 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %862 = wave.binary divui %848, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %863 = wave.binary remui %862, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %864 = wave.binary muli %863, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %865 = wave.binary addi %861, %864 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %866 = wave.binary divui %848, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %867 = wave.binary remui %866, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %868 = wave.binary muli %867, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %869 = wave.binary addi %865, %868 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %870 = wave.binary divui %848, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %871 = wave.binary remui %870, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %872 = wave.binary muli %871, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %873 = wave.binary addi %869, %872 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %874 = wave.binary addi %873, %815 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %875 = wave.binary addi %874, %819 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %876 = wave.binary addi %875, %823 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %877 = wave.binary addi %876, %827 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %878 = wave.binary addi %877, %831 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %879 = wave.binary addi %878, %835 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %880 = wave.binary addi %879, %839 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %881 = wave.binary divui %880, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %882 = wave.binary muli %881, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %883 = wave.binary addi %880, %882 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %884 = wave.assume %883 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %885 = wave.binary xori %23, %101 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %886 = wave.binary xori %885, %104 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %887 = wave.binary xori %886, %108 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %888 = wave.binary xori %887, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %889 = wave.binary xori %888, %112 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %890 = wave.binary remui %889, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %891 = wave.binary muli %890, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %892 = wave.binary addi %813, %891 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %893 = wave.binary divui %889, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %894 = wave.binary remui %893, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %895 = wave.binary muli %894, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %896 = wave.binary addi %892, %895 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %897 = wave.binary divui %889, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %898 = wave.binary remui %897, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %899 = wave.binary muli %898, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %900 = wave.binary addi %896, %899 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %901 = wave.binary divui %889, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %902 = wave.binary remui %901, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %903 = wave.binary muli %902, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %904 = wave.binary addi %900, %903 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %905 = wave.binary divui %889, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %906 = wave.binary remui %905, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %907 = wave.binary muli %906, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %908 = wave.binary addi %904, %907 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %909 = wave.binary divui %889, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %910 = wave.binary remui %909, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %911 = wave.binary muli %910, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %912 = wave.binary addi %908, %911 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %913 = wave.binary divui %889, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %914 = wave.binary remui %913, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %915 = wave.binary muli %914, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %916 = wave.binary addi %912, %915 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %917 = wave.binary divui %916, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %918 = wave.binary muli %917, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %919 = wave.binary addi %916, %918 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %920 = wave.assume %919 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %921 = wave.binary addi %873, %891 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %922 = wave.binary addi %921, %895 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %923 = wave.binary addi %922, %899 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %924 = wave.binary addi %923, %903 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %925 = wave.binary addi %924, %907 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %926 = wave.binary addi %925, %911 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %927 = wave.binary addi %926, %915 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %928 = wave.binary divui %927, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %929 = wave.binary muli %928, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %930 = wave.binary addi %927, %929 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %931 = wave.assume %930 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %932 = wave.binary xori %22, %101 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %933 = wave.binary xori %932, %104 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %934 = wave.binary xori %933, %108 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary xori %934, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.binary xori %935, %112 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %937 = wave.binary remui %936, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary muli %937, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary addi %813, %938 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary divui %936, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary remui %940, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary muli %941, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary addi %939, %942 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary divui %936, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary remui %944, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary muli %945, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.binary addi %943, %946 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %948 = wave.binary divui %936, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %949 = wave.binary remui %948, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.binary muli %949, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %951 = wave.binary addi %947, %950 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary divui %936, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary remui %952, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary muli %953, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary addi %951, %954 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary divui %936, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary remui %956, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary muli %957, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary addi %955, %958 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary divui %936, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.binary remui %960, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %962 = wave.binary muli %961, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %963 = wave.binary addi %959, %962 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %964 = wave.binary divui %963, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %965 = wave.binary muli %964, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %966 = wave.binary addi %963, %965 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %967 = wave.assume %966 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %968 = wave.binary addi %873, %938 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %969 = wave.binary addi %968, %942 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %970 = wave.binary addi %969, %946 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %971 = wave.binary addi %970, %950 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %972 = wave.binary addi %971, %954 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %973 = wave.binary addi %972, %958 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %974 = wave.binary addi %973, %962 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %975 = wave.binary divui %974, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %976 = wave.binary muli %975, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %977 = wave.binary addi %974, %976 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %978 = wave.assume %977 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %979 = wave.binary xori %11, %101 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %980 = wave.binary xori %979, %104 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %981 = wave.binary xori %980, %108 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %982 = wave.binary xori %981, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %983 = wave.binary xori %982, %112 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %984 = wave.binary remui %983, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %985 = wave.binary muli %984, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %986 = wave.binary addi %813, %985 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %987 = wave.binary divui %983, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %988 = wave.binary remui %987, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %989 = wave.binary muli %988, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %990 = wave.binary addi %986, %989 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %991 = wave.binary divui %983, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %992 = wave.binary remui %991, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %993 = wave.binary muli %992, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %994 = wave.binary addi %990, %993 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %995 = wave.binary divui %983, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %996 = wave.binary remui %995, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %997 = wave.binary muli %996, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %998 = wave.binary addi %994, %997 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %999 = wave.binary divui %983, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1000 = wave.binary remui %999, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1001 = wave.binary muli %1000, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1002 = wave.binary addi %998, %1001 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1003 = wave.binary divui %983, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1004 = wave.binary remui %1003, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1005 = wave.binary muli %1004, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1006 = wave.binary addi %1002, %1005 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1007 = wave.binary divui %983, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1008 = wave.binary remui %1007, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1009 = wave.binary muli %1008, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1010 = wave.binary addi %1006, %1009 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1011 = wave.binary divui %1010, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1012 = wave.binary muli %1011, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1013 = wave.binary addi %1010, %1012 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1014 = wave.assume %1013 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1015 = wave.binary addi %873, %985 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1016 = wave.binary addi %1015, %989 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1017 = wave.binary addi %1016, %993 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1018 = wave.binary addi %1017, %997 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1019 = wave.binary addi %1018, %1001 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1020 = wave.binary addi %1019, %1005 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1021 = wave.binary addi %1020, %1009 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1022 = wave.binary divui %1021, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1023 = wave.binary muli %1022, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1024 = wave.binary addi %1021, %1023 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1025 = wave.assume %1024 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1026 = wave.ptr_add %377, %844 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_98, %token_99 = wave.load %1026 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1027 = wave.ptr_add %377, %884 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_100, %token_101 = wave.load %1027 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1028 = wave.ptr_add %377, %920 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_102, %token_103 = wave.load %1028 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1029 = wave.ptr_add %377, %931 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_104, %token_105 = wave.load %1029 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1030 = wave.ptr_add %377, %967 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_106, %token_107 = wave.load %1030 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1031 = wave.ptr_add %377, %978 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_108, %token_109 = wave.load %1031 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1032 = wave.ptr_add %377, %1014 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_110, %token_111 = wave.load %1032 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1033 = wave.ptr_add %377, %1025 : !wave.ptr<#wave.shared, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_112, %token_113 = wave.load %1033 after %538 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %1034 = wave.cast fpconvert %value_98 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1035 = wave.cast fpconvert %value_100 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1036 = wave.cast fpconvert %value_102 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1037 = wave.cast fpconvert %value_104 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1038 = wave.cast fpconvert %value_106 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1039 = wave.cast fpconvert %value_108 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1040 = wave.cast fpconvert %value_110 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1041 = wave.cast fpconvert %value_112 : !wave.simd<vector<4xf16>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1042 = wave.fma %770, %1034, %770 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1043 = wave.fma %771, %1035, %771 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1044 = wave.fma %772, %1036, %772 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1045 = wave.fma %773, %1037, %773 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1046 = wave.fma %774, %1038, %774 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1047 = wave.fma %775, %1039, %775 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1048 = wave.fma %776, %1040, %776 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1049 = wave.fma %777, %1041, %777 fastmath<contract> : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf32>, 64>
      %1050 = wave.cmpi slt %136, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1051 = wave.cmpi slt %137, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1052 = wave.cmpi slt %138, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1053 = wave.cmpi slt %139, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1054 = wave.cmpi slt %144, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1055 = wave.cmpi slt %145, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1056 = wave.select %1050, %1054, %27 : !wave.mask<64>, !wave.mask<64>
      %1057 = wave.select %1050, %1055, %27 : !wave.mask<64>, !wave.mask<64>
      %1058 = wave.select %1051, %1054, %27 : !wave.mask<64>, !wave.mask<64>
      %1059 = wave.select %1051, %1055, %27 : !wave.mask<64>, !wave.mask<64>
      %1060 = wave.select %1052, %1054, %27 : !wave.mask<64>, !wave.mask<64>
      %1061 = wave.select %1052, %1055, %27 : !wave.mask<64>, !wave.mask<64>
      %1062 = wave.select %1053, %1054, %27 : !wave.mask<64>, !wave.mask<64>
      %1063 = wave.select %1053, %1055, %27 : !wave.mask<64>, !wave.mask<64>
      %1064 = wave.assume %arg11 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %1065 = wave.binary muli %53, %1064 overflow<nsw> : i32, i32 -> i32
      %1066 = wave.splat %1064 : i32 -> !wave.simd<i32, 64>
      %1067 = wave.binary muli %113, %1066 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1068 = wave.binary muli %114, %1066 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1069 = wave.binary muli %115, %1066 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1070 = wave.binary muli %116, %1066 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1071 = wave.binary addi %1065, %140 overflow<nsw> : i32, i32 -> i32
      %1072 = wave.binary addi %1067, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1073 = wave.binary addi %1067, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1074 = wave.binary addi %1068, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1075 = wave.binary addi %1068, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1076 = wave.binary addi %1069, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1077 = wave.binary addi %1069, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1078 = wave.binary addi %1070, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1079 = wave.binary addi %1070, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1080 = wave.splat %1071 : i32 -> !wave.simd<i32, 64>
      %1081 = wave.binary addi %1080, %1072 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1082 = wave.binary addi %1080, %1073 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1083 = wave.binary addi %1080, %1074 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1084 = wave.binary addi %1080, %1075 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1085 = wave.binary addi %1080, %1076 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1086 = wave.binary addi %1080, %1077 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1087 = wave.binary addi %1080, %1078 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1088 = wave.binary addi %1080, %1079 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1089 = wave.cast fpconvert %1042 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1090 = wave.cast fpconvert %1043 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1091 = wave.cast fpconvert %1044 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1092 = wave.cast fpconvert %1045 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1093 = wave.cast fpconvert %1046 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1094 = wave.cast fpconvert %1047 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1095 = wave.cast fpconvert %1048 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1096 = wave.cast fpconvert %1049 : !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<4xf16>, 64>
      %1097 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %1098 = wave.assume %1081 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1099 = wave.ptr_add %1097, %1098 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1100 = wave.ptr_add %1097, %7 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1101 = wave.select %1056, %1099, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1102 = wave.store %1089 -> %1101 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1103 = wave.assume %1082 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1104 = wave.ptr_add %1097, %1103 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1105 = wave.select %1057, %1104, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1106 = wave.store %1090 -> %1105 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1107 = wave.assume %1083 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1108 = wave.ptr_add %1097, %1107 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1109 = wave.select %1058, %1108, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1110 = wave.store %1091 -> %1109 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1111 = wave.assume %1084 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1112 = wave.ptr_add %1097, %1111 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1113 = wave.select %1059, %1112, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1114 = wave.store %1092 -> %1113 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1115 = wave.assume %1085 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1116 = wave.ptr_add %1097, %1115 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1117 = wave.select %1060, %1116, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1118 = wave.store %1093 -> %1117 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1119 = wave.assume %1086 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1120 = wave.ptr_add %1097, %1119 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1121 = wave.select %1061, %1120, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1122 = wave.store %1094 -> %1121 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1123 = wave.assume %1087 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1124 = wave.ptr_add %1097, %1123 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1125 = wave.select %1062, %1124, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1126 = wave.store %1095 -> %1125 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      %1127 = wave.assume %1088 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741820 + x <= 0">] : !wave.simd<i32, 64>
      %1128 = wave.ptr_add %1097, %1127 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<i32, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1129 = wave.select %1063, %1128, %1100 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %1130 = wave.store %1096 -> %1129 {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
      return
    }
  }
}
