module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_optimized_async(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 8192 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 4096 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 2048 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 1024 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 512 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 416 : index -> !wave.simd<index, 64>
      %7 = wave.constant 384 : index -> !wave.simd<index, 64>
      %8 = wave.constant 288 : index -> !wave.simd<index, 64>
      %9 = wave.constant 256 : index -> !wave.simd<index, 64>
      %10 = wave.constant 160 : index -> !wave.simd<index, 64>
      %11 = wave.constant 128 : index -> !wave.simd<index, 64>
      %12 = wave.constant 32 : index -> !wave.simd<index, 64>
      %13 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %14 = wave.constant 120 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %16 = wave.constant 104 : i32 -> !wave.simd<i32, 64>
      %17 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %18 = wave.constant 88 : i32 -> !wave.simd<i32, 64>
      %19 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %20 = wave.constant 72 : i32 -> !wave.simd<i32, 64>
      %21 = wave.constant 56 : i32 -> !wave.simd<i32, 64>
      %22 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %23 = wave.constant 40 : i32 -> !wave.simd<i32, 64>
      %24 = wave.constant 24 : i32 -> !wave.simd<i32, 64>
      %25 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
      %26 = wave.constant 6 : i32 -> !wave.simd<i32, 64>
      %27 = wave.constant 5 : i32 -> !wave.simd<i32, 64>
      %28 = wave.constant 3 : i32 -> !wave.simd<i32, 64>
      %29 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %30 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %31 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %32 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %33 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %34 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %35 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %36 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %37 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %38 = wave.constant false -> !wave.mask<64>
      %c4224_i32 = arith.constant 4224 : i32
      %c8448_i32 = arith.constant 8448 : i32
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
      %39 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %c0_i32 = arith.constant 0 : i32
      %c256_i32 = arith.constant 256 : i32
      %40 = wave.assume %arg5 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %41 = wave.assume %arg6 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %42 = wave.assume %arg7 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %43 = wave.pack %39, %39, %39, %39 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %44 = wave.assume %arg8 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %45 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %46 = wave.assume %arg10 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %47 = wave.workgroup_id 0
      %48 = wave.binary addi %40, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %49 = wave.binary divsi %48, %c128_i32 : i32, i32 -> i32
      %50 = wave.binary addi %41, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %51 = wave.binary divsi %50, %c128_i32 : i32, i32 -> i32
      %52 = wave.binary muli %49, %51 : i32, i32 -> i32
      %53 = wave.binary divsi %52, %c32_i32 : i32, i32 -> i32
      %54 = wave.binary muli %53, %c32_i32 : i32, i32 -> i32
      %55 = arith.cmpi sge, %47, %54 : i32
      %56 = scf.if %55 -> (i32) {
        scf.yield %47 : i32
      } else {
        %1855 = wave.binary remui %47, %c8_i32 : i32, i32 -> i32
        %1856 = wave.binary divui %47, %c8_i32 : i32, i32 -> i32
        %1857 = wave.binary divui %1856, %c4_i32 : i32, i32 -> i32
        %1858 = wave.binary muli %1857, %c32_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1859 = wave.binary muli %1855, %c4_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1860 = wave.binary addi %1858, %1859 overflow<nsw, nuw> : i32, i32 -> i32
        %1861 = wave.binary remui %1856, %c4_i32 : i32, i32 -> i32
        %1862 = wave.binary addi %1860, %1861 overflow<nsw, nuw> : i32, i32 -> i32
        scf.yield %1862 : i32
      }
      %57 = wave.binary muli %51, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %58 = wave.binary divsi %56, %57 : i32, i32 -> i32
      %59 = wave.binary muli %58, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %60 = wave.binary subi %49, %59 overflow<nsw> : i32, i32 -> i32
      %61 = arith.cmpi slt, %60, %c4_i32 : i32
      %62 = wave.select %61, %60, %c4_i32 : i32
      %63 = wave.binary remsi %56, %57 : i32, i32 -> i32
      %64 = wave.binary remsi %63, %62 : i32, i32 -> i32
      %65 = wave.binary addi %59, %64 overflow<nsw> : i32, i32 -> i32
      %66 = wave.binary divsi %63, %62 : i32, i32 -> i32
      %67 = wave.binary muli %65, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %68 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %69 = wave.binary divui %68, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.binary remui %69, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary muli %70, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary divui %68, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary remui %72, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary muli %73, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.binary addi %71, %74 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %76 = wave.binary divui %68, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary remui %76, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary muli %77, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary addi %75, %78 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary divui %68, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary remui %80, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary addi %79, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary divui %68, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.binary remui %83, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.binary muli %84, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary addi %82, %85 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary divui %68, %31 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.binary remui %87, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %89 = wave.binary muli %88, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %90 = wave.binary addi %86, %89 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary addi %90, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %92 = wave.binary remui %68, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %93 = wave.binary muli %92, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %94 = wave.binary remui %68, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %95 = wave.binary muli %94, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %96 = wave.binary addi %93, %29 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %97 = wave.binary addi %93, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %98 = wave.binary addi %93, %28 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %99 = wave.binary addi %93, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %100 = wave.binary addi %93, %27 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %101 = wave.binary addi %93, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %102 = wave.binary addi %93, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %103 = wave.binary remui %80, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %104 = wave.binary addi %103, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %105 = wave.binary addi %103, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %106 = wave.binary addi %103, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %107 = wave.binary addi %103, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %108 = wave.binary addi %103, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %109 = wave.binary addi %103, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %110 = wave.binary addi %103, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %111 = wave.binary addi %103, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %112 = wave.binary addi %103, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %113 = wave.binary addi %103, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %114 = wave.binary addi %103, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %115 = wave.binary addi %103, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %116 = wave.binary addi %103, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %117 = wave.binary addi %103, %15 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %118 = wave.binary addi %103, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %119 = wave.splat %67 : i32 -> !wave.simd<i32, 64>
      %120 = wave.binary addi %119, %90 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %121 = wave.binary addi %119, %91 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %122 = wave.binary addi %119, %103 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %123 = wave.binary addi %119, %104 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %124 = wave.binary addi %119, %105 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %125 = wave.binary addi %119, %106 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %126 = wave.binary addi %119, %107 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %127 = wave.binary addi %119, %108 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %128 = wave.binary addi %119, %109 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %129 = wave.binary addi %119, %110 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %130 = wave.binary addi %119, %111 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %131 = wave.binary addi %119, %112 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %132 = wave.binary addi %119, %113 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %133 = wave.binary addi %119, %114 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %134 = wave.binary addi %119, %115 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %135 = wave.binary addi %119, %116 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %136 = wave.binary addi %119, %117 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %137 = wave.binary addi %119, %118 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %138 = wave.binary muli %66, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %139 = wave.splat %138 : i32 -> !wave.simd<i32, 64>
      %140 = wave.binary addi %139, %93 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %141 = wave.binary addi %139, %95 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %142 = wave.binary addi %139, %96 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %143 = wave.binary addi %139, %97 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %144 = wave.binary addi %139, %98 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %145 = wave.binary addi %139, %99 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %146 = wave.binary addi %139, %100 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %147 = wave.binary addi %139, %101 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %148 = wave.binary addi %139, %102 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %149 = wave.splat %40 : i32 -> !wave.simd<i32, 64>
      %150 = wave.binary remsi %120, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %151 = wave.binary remsi %121, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %152 = wave.binary remsi %122, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %153 = wave.binary remsi %123, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %154 = wave.binary remsi %124, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %155 = wave.binary remsi %125, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %156 = wave.binary remsi %126, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %157 = wave.binary remsi %127, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %158 = wave.binary remsi %128, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %159 = wave.binary remsi %129, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %160 = wave.binary remsi %130, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %161 = wave.binary remsi %131, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %162 = wave.binary remsi %132, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %163 = wave.binary remsi %133, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %164 = wave.binary remsi %134, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %165 = wave.binary remsi %135, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %166 = wave.binary remsi %136, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %167 = wave.binary remsi %137, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %168 = wave.splat %41 : i32 -> !wave.simd<i32, 64>
      %169 = wave.binary remsi %140, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %170 = wave.binary remsi %141, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %171 = wave.binary remsi %142, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %172 = wave.binary remsi %143, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %173 = wave.binary remsi %144, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %174 = wave.binary remsi %145, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %175 = wave.binary remsi %146, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %176 = wave.binary remsi %147, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %177 = wave.binary remsi %148, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %178 = wave.binary addi %42, %c63_i32 overflow<nsw> : i32, i32 -> i32
      %179 = wave.binary divsi %178, %c64_i32 : i32, i32 -> i32
      %180 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %181 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %182 = wave.binary remui %68, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %183 = wave.binary muli %182, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %184 = wave.binary divui %68, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %185 = wave.binary remui %184, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %186 = wave.binary muli %185, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %187 = wave.binary xori %183, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %188 = wave.binary divui %68, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %189 = wave.binary remui %188, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %190 = wave.binary muli %189, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %191 = wave.binary xori %187, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %192 = wave.splat %42 : i32 -> !wave.simd<i32, 64>
      %193 = wave.cmpi slt %191, %192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %194 = wave.splat %44 : i32 -> !wave.simd<i32, 64>
      %195 = wave.binary muli %150, %194 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %196 = wave.binary muli %151, %194 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %197 = wave.ptr_cast %180 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %198 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%68, %195) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %199 = wave.assume %198 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %200 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%199) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %201 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%68, %196) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %202 = wave.assume %201 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %203 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%202) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %204 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %205 = wave.read_first %68 : !wave.simd<i32, 64> -> i32
      %206 = wave.assume %205 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
      %207 = wave.token : !wave.mem.token
      %208 = wave.ptr_add %204, %200 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %209 = wave.index_expr <"264*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %210 = wave.ptr_add %197, %209 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %211 = wave.ptr_add %204, %13 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %212 = wave.select %193, %208, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %213 = waveamd.dma_load_lds %212 -> %210 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %214 = wave.ptr_add %204, %203 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %215 = wave.index_expr <"2112 + 264*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %216 = wave.ptr_add %197, %215 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %217 = wave.select %193, %214, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %218 = waveamd.dma_load_lds %217 -> %216 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %219 = wave.join %213, %218 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %220 = wave.binary muli %73, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %221 = wave.binary muli %77, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %222 = wave.binary xori %220, %221 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %223 = wave.binary xori %222, %81 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %224 = wave.binary xori %223, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %225 = wave.binary muli %88, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %226 = wave.binary xori %224, %225 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %227 = wave.binary xori %30, %220 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %228 = wave.binary xori %227, %221 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %229 = wave.binary xori %228, %81 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %230 = wave.binary xori %229, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %231 = wave.binary xori %230, %225 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %232 = wave.cmpi slt %226, %192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %233 = wave.cmpi slt %231, %192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %234 = wave.ptr_cast %181 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %235 = wave.index_expr <"s1 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1"](%68, %45, %169) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %236 = wave.assume %235 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %237 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%236) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %238 = wave.index_expr <"s1 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1"](%68, %45, %169) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %239 = wave.assume %238 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %240 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%239) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %241 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %242 = wave.ptr_add %241, %237 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %243 = wave.ptr_add %234, %209 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %244 = wave.ptr_add %241, %13 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %245 = wave.select %232, %242, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %246 = waveamd.dma_load_lds %245 -> %243 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %247 = wave.ptr_add %241, %240 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %248 = wave.ptr_add %234, %215 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %249 = wave.select %233, %247, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %250 = waveamd.dma_load_lds %249 -> %248 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %251 = wave.join %246, %250 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %252 = wave.join %219, %251 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %253 = wave.binary subi %42, %c64_i32 : i32, i32 -> i32
      %254 = wave.splat %253 : i32 -> !wave.simd<i32, 64>
      %255 = wave.cmpi slt %191, %254 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %256 = wave.ptr_add %197, %c4224_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %257 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741752 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%68, %195) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %258 = wave.assume %257 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %259 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%258) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %260 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741752 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%68, %196) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %261 = wave.assume %260 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %262 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%261) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %263 = wave.ptr_add %204, %259 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %264 = wave.ptr_add %256, %209 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %265 = wave.select %255, %263, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %266 = waveamd.dma_load_lds %265 -> %264 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %267 = wave.ptr_add %204, %262 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %268 = wave.ptr_add %256, %215 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %269 = wave.select %255, %267, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %270 = waveamd.dma_load_lds %269 -> %268 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %271 = wave.join %266, %270 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %272 = wave.cmpi slt %226, %254 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %273 = wave.cmpi slt %231, %254 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %274 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %275 = wave.binary muli %274, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %276 = wave.ptr_add %234, %c4224_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %277 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%68, %274, %275, %169) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %278 = wave.assume %277 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %279 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%278) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %280 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%68, %274, %275, %169) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %281 = wave.assume %280 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %282 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%281) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %283 = wave.ptr_add %241, %279 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %284 = wave.ptr_add %276, %209 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %285 = wave.select %272, %283, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %286 = waveamd.dma_load_lds %285 -> %284 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %287 = wave.ptr_add %241, %282 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %288 = wave.ptr_add %276, %215 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %289 = wave.select %273, %287, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %290 = waveamd.dma_load_lds %289 -> %288 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %291 = wave.join %286, %290 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %292 = wave.join %271, %291 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %293 = wave.binary subi %42, %c128_i32 : i32, i32 -> i32
      %294 = wave.splat %293 : i32 -> !wave.simd<i32, 64>
      %295 = wave.cmpi slt %191, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %296 = wave.ptr_add %197, %c8448_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %297 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741688 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%68, %195) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %298 = wave.assume %297 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %299 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%298) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %300 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741688 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%68, %196) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %301 = wave.assume %300 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %302 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%301) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %303 = wave.ptr_add %204, %299 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %304 = wave.ptr_add %296, %209 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %305 = wave.select %295, %303, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %306 = waveamd.dma_load_lds %305 -> %304 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %307 = wave.ptr_add %204, %302 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %308 = wave.ptr_add %296, %215 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %309 = wave.select %295, %307, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %310 = waveamd.dma_load_lds %309 -> %308 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %311 = wave.join %306, %310 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %312 = wave.cmpi slt %226, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %313 = wave.cmpi slt %231, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %314 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %315 = wave.binary muli %314, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %316 = wave.ptr_add %234, %c8448_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %317 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%68, %314, %169, %315) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %318 = wave.assume %317 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %319 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%318) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %320 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%68, %314, %169, %315) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
      %321 = wave.assume %320 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %322 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%321) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %323 = wave.ptr_add %241, %319 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %324 = wave.ptr_add %316, %209 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %325 = wave.select %312, %323, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %326 = waveamd.dma_load_lds %325 -> %324 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %327 = wave.ptr_add %241, %322 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %328 = wave.ptr_add %316, %215 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %329 = wave.select %313, %327, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %330 = waveamd.dma_load_lds %329 -> %328 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %331 = wave.join %326, %330 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %332 = wave.join %311, %331 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %333 = wave.issue_token %332 : !wave.mem.token -> !wave.mem.token
      %334 = wave.barrier %252, %292, %333 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %335 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%68) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %336 = wave.ptr_add %180, %335 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %336 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %337 = wave.binary addi %335, %12 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %338 = wave.ptr_add %180, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %338 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %339 = wave.binary addi %335, %11 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %340 = wave.ptr_add %180, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %340 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %341 = wave.binary addi %335, %10 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %342 = wave.ptr_add %180, %341 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %342 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %343 = wave.binary addi %335, %9 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %344 = wave.ptr_add %180, %343 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %344 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %345 = wave.binary addi %335, %8 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %346 = wave.ptr_add %180, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %346 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %347 = wave.binary addi %335, %7 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %348 = wave.ptr_add %180, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %348 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %349 = wave.binary addi %335, %6 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %350 = wave.ptr_add %180, %349 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %350 after %334 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %351 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_14, %token_15 = wave.gather %181 mapping <bit_offset = <"16*(128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %352 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %353 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %354 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %355 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_16, %token_17 = wave.gather %181 mapping <bit_offset = <"16*(4224 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %356 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %357 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %358 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %359 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %360 = wave.pack %352, %353, %354, %355, %356, %357, %358, %359 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_18, %token_19 = wave.gather %181 mapping <bit_offset = <"16*(256 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %361 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %362 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %363 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %364 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_20, %token_21 = wave.gather %181 mapping <bit_offset = <"16*(4480 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %365 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %366 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %367 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %368 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %369 = wave.pack %361, %362, %363, %364, %365, %366, %367, %368 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_22, %token_23 = wave.gather %181 mapping <bit_offset = <"16*(64 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %370 = wave.extract %value_22[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %371 = wave.extract %value_22[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %372 = wave.extract %value_22[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %373 = wave.extract %value_22[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_24, %token_25 = wave.gather %181 mapping <bit_offset = <"16*(4288 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %374 = wave.extract %value_24[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %375 = wave.extract %value_24[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %376 = wave.extract %value_24[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %377 = wave.extract %value_24[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %378 = wave.pack %370, %371, %372, %373, %374, %375, %376, %377 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_26, %token_27 = wave.gather %181 mapping <bit_offset = <"16*(320 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %379 = wave.extract %value_26[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %380 = wave.extract %value_26[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %381 = wave.extract %value_26[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %382 = wave.extract %value_26[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_28, %token_29 = wave.gather %181 mapping <bit_offset = <"16*(4544 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %334 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %383 = wave.extract %value_28[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %384 = wave.extract %value_28[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %385 = wave.extract %value_28[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %386 = wave.extract %value_28[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %387 = wave.pack %379, %380, %381, %382, %383, %384, %385, %386 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %388 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %389 = wave.binary subi %179, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %390 = wave.barrier %351, %388 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %391 = wave.binary divsi %68, %c256_i32 : !wave.simd<i32, 64>, i32 -> !wave.simd<i32, 64>
      %392 = wave.cmpi eq %391, %5 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %393 = wave.cmpi ne %391, %5 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      wave.where %393 {
        %1855 = wave.barrier : () -> !wave.mem.token
      } : !wave.mask<64>
      waveamd.set_priority 0
      %394 = wave.join %219, %271, %311, %351, %251, %291, %331, %388 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %395:24 = scf.for %arg12 = %c0_i32 to %389 step %c1_i32 iter_args(%arg13 = %value, %arg14 = %value_0, %arg15 = %value_2, %arg16 = %value_4, %arg17 = %value_6, %arg18 = %value_8, %arg19 = %value_10, %arg20 = %value_12, %arg21 = %360, %arg22 = %369, %arg23 = %378, %arg24 = %387, %arg25 = %43, %arg26 = %43, %arg27 = %43, %arg28 = %43, %arg29 = %43, %arg30 = %43, %arg31 = %43, %arg32 = %43, %arg33 = %332, %arg34 = %334, %arg35 = %390, %arg36 = %394) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %1855 = wave.binary remui %arg12, %c3_i32 : i32, i32 -> i32
        %1856 = wave.binary addi %arg12, %c1_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1857 = wave.binary remui %1856, %c3_i32 : i32, i32 -> i32
        %1858 = wave.binary addi %arg12, %c3_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1859 = wave.binary muli %1858, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1860 = waveamd.fragment_pack %arg13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1861 = waveamd.fragment_pack %arg14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1862 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1863 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1864 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1865 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1866 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1867 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1868 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1869 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1870 = waveamd.fragment_pack %arg23 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1871 = waveamd.fragment_pack %arg24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1872 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1873 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1874 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1875 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1876 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1877 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1878 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1879 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1880 = waveamd.mma "mfma.f32.16x16x32.f16" %1868, %1860, %1872 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1881 = waveamd.mma "mfma.f32.16x16x32.f16" %1869, %1861, %1880 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1882 = waveamd.fragment_unpack %1881 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1883 = waveamd.mma "mfma.f32.16x16x32.f16" %1870, %1860, %1873 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1884 = waveamd.mma "mfma.f32.16x16x32.f16" %1871, %1861, %1883 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1885 = waveamd.fragment_unpack %1884 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1886 = waveamd.mma "mfma.f32.16x16x32.f16" %1868, %1862, %1874 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1887 = waveamd.mma "mfma.f32.16x16x32.f16" %1869, %1863, %1886 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1888 = waveamd.fragment_unpack %1887 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1889 = waveamd.mma "mfma.f32.16x16x32.f16" %1870, %1862, %1875 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1890 = waveamd.mma "mfma.f32.16x16x32.f16" %1871, %1863, %1889 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1891 = waveamd.fragment_unpack %1890 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1892 = waveamd.mma "mfma.f32.16x16x32.f16" %1868, %1864, %1876 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1893 = waveamd.mma "mfma.f32.16x16x32.f16" %1869, %1865, %1892 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1894 = waveamd.fragment_unpack %1893 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1895 = waveamd.mma "mfma.f32.16x16x32.f16" %1870, %1864, %1877 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1896 = waveamd.mma "mfma.f32.16x16x32.f16" %1871, %1865, %1895 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1897 = waveamd.fragment_unpack %1896 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1898 = waveamd.mma "mfma.f32.16x16x32.f16" %1868, %1866, %1878 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1899 = waveamd.mma "mfma.f32.16x16x32.f16" %1869, %1867, %1898 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1900 = waveamd.fragment_unpack %1899 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1901 = waveamd.mma "mfma.f32.16x16x32.f16" %1870, %1866, %1879 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1902 = waveamd.mma "mfma.f32.16x16x32.f16" %1871, %1867, %1901 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1903 = waveamd.fragment_unpack %1902 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        waveamd.set_priority 1
        wave.sched_barrier
        %1904 = wave.barrier %arg35 : (!wave.mem.token) -> !wave.mem.token
        wave.sched_barrier
        %1905 = wave.binary subi %42, %1859 : i32, i32 -> i32
        %1906 = wave.splat %1905 : i32 -> !wave.simd<i32, 64>
        %1907 = wave.cmpi slt %191, %1906 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1908 = wave.binary muli %1855, %c4224_i32 overflow<nsw> : i32, i32 -> i32
        %1909 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0", "s1"](%68, %1859, %195) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1910 = wave.assume %1909 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1911 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1910) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1912 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0", "s1"](%68, %1859, %196) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1913 = wave.assume %1912 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1914 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1913) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1915 = wave.ptr_add %204, %1911 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1916 = wave.ptr_add %210, %1908 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1917 = wave.select %1907, %1915, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1918 = waveamd.dma_load_lds %1917 -> %1916 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1919 = wave.ptr_add %204, %1914 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1920 = wave.ptr_add %216, %1908 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1921 = wave.select %1907, %1919, %211 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1922 = waveamd.dma_load_lds %1921 -> %1920 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1923 = wave.join %1918, %1922 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1924 = wave.cmpi slt %226, %1906 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1925 = wave.cmpi slt %231, %1906 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1926 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1927 = wave.binary muli %1859, %1926 overflow<nsw> : i32, i32 -> i32
        %1928 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%68, %1926, %169, %1927) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %1929 = wave.assume %1928 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1930 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1929) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1931 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%68, %1926, %169, %1927) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %1932 = wave.assume %1931 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1933 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1932) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1934 = wave.ptr_add %241, %1930 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1935 = wave.ptr_add %243, %1908 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1936 = wave.select %1924, %1934, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1937 = waveamd.dma_load_lds %1936 -> %1935 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1938 = wave.ptr_add %241, %1933 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1939 = wave.ptr_add %248, %1908 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1940 = wave.select %1925, %1938, %244 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1941 = waveamd.dma_load_lds %1940 -> %1939 after %207 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1942 = wave.join %1937, %1941 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1943 = wave.join %1923, %1942 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1944 = wave.binary muli %1857, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1945 = wave.ptr_add %180, %1944 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1946 = wave.barrier %1904 : (!wave.mem.token) -> !wave.mem.token
        %1947 = wave.join %arg33, %arg34 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1948 = wave.ptr_add %1945, %335 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_98, %token_99 = wave.load %1948 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1949 = wave.ptr_add %1945, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_100, %token_101 = wave.load %1949 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1950 = wave.ptr_add %1945, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_102, %token_103 = wave.load %1950 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1951 = wave.ptr_add %1945, %341 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_104, %token_105 = wave.load %1951 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1952 = wave.ptr_add %1945, %343 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_106, %token_107 = wave.load %1952 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1953 = wave.ptr_add %1945, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_108, %token_109 = wave.load %1953 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1954 = wave.ptr_add %1945, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_110, %token_111 = wave.load %1954 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1955 = wave.ptr_add %1945, %349 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_112, %token_113 = wave.load %1955 after %1947 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1956 = wave.join %token_99, %token_101, %token_103, %token_105, %token_107, %token_109, %token_111, %token_113 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1957 = wave.ptr_add %181, %1944 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %value_114, %token_115 = wave.gather %1957 mapping <bit_offset = <"16*(128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1958 = wave.extract %value_114[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1959 = wave.extract %value_114[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1960 = wave.extract %value_114[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1961 = wave.extract %value_114[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_116, %token_117 = wave.gather %1957 mapping <bit_offset = <"16*(4224 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1962 = wave.extract %value_116[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1963 = wave.extract %value_116[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1964 = wave.extract %value_116[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1965 = wave.extract %value_116[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1966 = wave.pack %1958, %1959, %1960, %1961, %1962, %1963, %1964, %1965 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_118, %token_119 = wave.gather %1957 mapping <bit_offset = <"16*(256 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1967 = wave.extract %value_118[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1968 = wave.extract %value_118[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1969 = wave.extract %value_118[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1970 = wave.extract %value_118[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_120, %token_121 = wave.gather %1957 mapping <bit_offset = <"16*(4480 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1971 = wave.extract %value_120[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1972 = wave.extract %value_120[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1973 = wave.extract %value_120[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1974 = wave.extract %value_120[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1975 = wave.pack %1967, %1968, %1969, %1970, %1971, %1972, %1973, %1974 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_122, %token_123 = wave.gather %1957 mapping <bit_offset = <"16*(64 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1976 = wave.extract %value_122[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1977 = wave.extract %value_122[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1978 = wave.extract %value_122[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1979 = wave.extract %value_122[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_124, %token_125 = wave.gather %1957 mapping <bit_offset = <"16*(4288 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1980 = wave.extract %value_124[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1981 = wave.extract %value_124[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1982 = wave.extract %value_124[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1983 = wave.extract %value_124[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1984 = wave.pack %1976, %1977, %1978, %1979, %1980, %1981, %1982, %1983 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_126, %token_127 = wave.gather %1957 mapping <bit_offset = <"16*(320 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1985 = wave.extract %value_126[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1986 = wave.extract %value_126[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1987 = wave.extract %value_126[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1988 = wave.extract %value_126[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_128, %token_129 = wave.gather %1957 mapping <bit_offset = <"16*(4544 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1947 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1989 = wave.extract %value_128[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1990 = wave.extract %value_128[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1991 = wave.extract %value_128[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1992 = wave.extract %value_128[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1993 = wave.pack %1985, %1986, %1987, %1988, %1989, %1990, %1991, %1992 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1994 = wave.join %token_115, %token_117, %token_119, %token_121, %token_123, %token_125, %token_127, %token_129 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        waveamd.set_priority 0
        wave.sched_barrier
        %1995 = wave.issue_token %1943 : !wave.mem.token -> !wave.mem.token
        %1996 = wave.barrier %arg33, %1995, %1946, %1956, %1994 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        wave.sched_barrier
        %1997 = wave.join %arg36, %1923, %1956, %1942, %1994 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        scf.yield %value_98, %value_100, %value_102, %value_104, %value_106, %value_108, %value_110, %value_112, %1966, %1975, %1984, %1993, %1882, %1885, %1888, %1891, %1894, %1897, %1900, %1903, %1943, %1996, %207, %1997 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      waveamd.set_priority 0
      wave.where %392 {
        %1855 = wave.barrier : () -> !wave.mem.token
      } : !wave.mask<64>
      %396 = wave.alloc() {align = 16 : i64, bytesize = 33792 : i64} : !wave.ptr<#wave.shared, f16>
      %397 = wave.splat %46 : i32 -> !wave.simd<i32, 64>
      %398 = wave.binary muli %152, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %399 = wave.binary muli %153, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %400 = wave.binary muli %154, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %401 = wave.binary muli %155, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %402 = wave.binary muli %156, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %403 = wave.binary muli %157, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %404 = wave.binary muli %158, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %405 = wave.binary muli %159, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %406 = wave.binary muli %160, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %407 = wave.binary muli %161, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %408 = wave.binary muli %162, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %409 = wave.binary muli %163, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %410 = wave.binary muli %164, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %411 = wave.binary muli %165, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %412 = wave.binary muli %166, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %413 = wave.binary muli %167, %397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %414 = wave.ptr_cast %396 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %415 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%398, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %416 = wave.assume %415 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %417 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%416) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %418 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%399, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %419 = wave.assume %418 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %420 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%419) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %421 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%400, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %422 = wave.assume %421 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %423 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%422) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %424 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%401, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %425 = wave.assume %424 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %426 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%425) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %427 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%402, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %428 = wave.assume %427 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %429 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%428) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %430 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%403, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %431 = wave.assume %430 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %432 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%431) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %433 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%404, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %434 = wave.assume %433 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %435 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%434) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %436 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%405, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %437 = wave.assume %436 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %438 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%437) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %439 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%406, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %440 = wave.assume %439 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %441 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%440) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %442 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%407, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %443 = wave.assume %442 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %444 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%443) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %445 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%408, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %446 = wave.assume %445 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %447 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%446) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %448 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%409, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %449 = wave.assume %448 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %450 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%449) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %451 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%410, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %452 = wave.assume %451 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %453 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%452) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %454 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%411, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %455 = wave.assume %454 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %456 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%455) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %457 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%412, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %458 = wave.assume %457 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %459 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%458) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %460 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741822 + s0 + s1 <= 0">] ["s0", "s1"](%413, %170) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %461 = wave.assume %460 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] : !wave.simd<index, 64>
      %462 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741822 + x <= 0">] ["x"](%461) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %463 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %464 = wave.ptr_add %463, %417 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %465 = wave.index_expr <"66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %466 = wave.ptr_add %414, %465 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %467 = waveamd.dma_load_lds %464 -> %466 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %468 = wave.ptr_add %463, %420 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %469 = wave.index_expr <"528 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %470 = wave.ptr_add %414, %469 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %471 = waveamd.dma_load_lds %468 -> %470 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %472 = wave.ptr_add %463, %423 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %473 = wave.index_expr <"1056 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %474 = wave.ptr_add %414, %473 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %475 = waveamd.dma_load_lds %472 -> %474 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %476 = wave.ptr_add %463, %426 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %477 = wave.index_expr <"1584 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %478 = wave.ptr_add %414, %477 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %479 = waveamd.dma_load_lds %476 -> %478 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %480 = wave.ptr_add %463, %429 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %481 = wave.index_expr <"2112 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %482 = wave.ptr_add %414, %481 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %483 = waveamd.dma_load_lds %480 -> %482 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %484 = wave.ptr_add %463, %432 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %485 = wave.index_expr <"2640 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %486 = wave.ptr_add %414, %485 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %487 = waveamd.dma_load_lds %484 -> %486 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %488 = wave.ptr_add %463, %435 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %489 = wave.index_expr <"3168 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %490 = wave.ptr_add %414, %489 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %491 = waveamd.dma_load_lds %488 -> %490 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %492 = wave.ptr_add %463, %438 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %493 = wave.index_expr <"3696 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %494 = wave.ptr_add %414, %493 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %495 = waveamd.dma_load_lds %492 -> %494 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %496 = wave.ptr_add %463, %441 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %497 = wave.index_expr <"4224 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %498 = wave.ptr_add %414, %497 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %499 = waveamd.dma_load_lds %496 -> %498 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %500 = wave.ptr_add %463, %444 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %501 = wave.index_expr <"4752 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %502 = wave.ptr_add %414, %501 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %503 = waveamd.dma_load_lds %500 -> %502 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %504 = wave.ptr_add %463, %447 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %505 = wave.index_expr <"5280 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %506 = wave.ptr_add %414, %505 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %507 = waveamd.dma_load_lds %504 -> %506 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %508 = wave.ptr_add %463, %450 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %509 = wave.index_expr <"5808 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %510 = wave.ptr_add %414, %509 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %511 = waveamd.dma_load_lds %508 -> %510 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %512 = wave.ptr_add %463, %453 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %513 = wave.index_expr <"6336 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %514 = wave.ptr_add %414, %513 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %515 = waveamd.dma_load_lds %512 -> %514 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %516 = wave.ptr_add %463, %456 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %517 = wave.index_expr <"6864 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %518 = wave.ptr_add %414, %517 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %519 = waveamd.dma_load_lds %516 -> %518 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %520 = wave.ptr_add %463, %459 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %521 = wave.index_expr <"7392 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %522 = wave.ptr_add %414, %521 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %523 = waveamd.dma_load_lds %520 -> %522 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %524 = wave.ptr_add %463, %462 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %525 = wave.index_expr <"7920 + 66*floor(1/64*wi_first)"> ["wi_first"](%206) : (i32) -> index
      %526 = wave.ptr_add %414, %525 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %527 = waveamd.dma_load_lds %524 -> %526 after %207 {bytes = 4 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %528 = wave.join %467, %471, %475, %479, %483, %487, %491, %495, %499, %503, %507, %511, %515, %519, %523, %527 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %529 = waveamd.fragment_pack %395#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %530 = waveamd.fragment_pack %395#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %531 = waveamd.fragment_pack %395#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %532 = waveamd.fragment_pack %395#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %533 = waveamd.fragment_pack %395#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %534 = waveamd.fragment_pack %395#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %535 = waveamd.fragment_pack %395#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %536 = waveamd.fragment_pack %395#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %537 = waveamd.fragment_pack %395#8 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %538 = waveamd.fragment_pack %395#9 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %539 = waveamd.fragment_pack %395#10 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %540 = waveamd.fragment_pack %395#11 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %541 = waveamd.fragment_pack %395#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %542 = waveamd.fragment_pack %395#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %543 = waveamd.fragment_pack %395#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %544 = waveamd.fragment_pack %395#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %545 = waveamd.fragment_pack %395#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %546 = waveamd.fragment_pack %395#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %547 = waveamd.fragment_pack %395#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %548 = waveamd.fragment_pack %395#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %549 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %529, %541 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %550 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %530, %549 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %551 = waveamd.fragment_unpack %550 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %552 = waveamd.mma "mfma.f32.16x16x32.f16" %539, %529, %542 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %553 = waveamd.mma "mfma.f32.16x16x32.f16" %540, %530, %552 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %554 = waveamd.fragment_unpack %553 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %555 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %531, %543 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %556 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %532, %555 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %557 = waveamd.fragment_unpack %556 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %558 = waveamd.mma "mfma.f32.16x16x32.f16" %539, %531, %544 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %559 = waveamd.mma "mfma.f32.16x16x32.f16" %540, %532, %558 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %560 = waveamd.fragment_unpack %559 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %561 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %533, %545 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %562 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %534, %561 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %563 = waveamd.fragment_unpack %562 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %564 = waveamd.mma "mfma.f32.16x16x32.f16" %539, %533, %546 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %565 = waveamd.mma "mfma.f32.16x16x32.f16" %540, %534, %564 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %566 = waveamd.fragment_unpack %565 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %567 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %535, %547 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %568 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %536, %567 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %569 = waveamd.fragment_unpack %568 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %570 = waveamd.mma "mfma.f32.16x16x32.f16" %539, %535, %548 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %571 = waveamd.mma "mfma.f32.16x16x32.f16" %540, %536, %570 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %572 = waveamd.fragment_unpack %571 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %573 = wave.barrier %395#20, %528, %395#22 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %574 = wave.binary subi %179, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %575 = wave.binary remsi %574, %c3_i32 : i32, i32 -> i32
      %576 = wave.binary muli %575, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %577 = wave.ptr_add %180, %576 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %578 = wave.barrier %332, %292, %252 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %579 = wave.join %395#21, %395#20, %578, %573 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %580 = wave.ptr_add %577, %335 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_30, %token_31 = wave.load %580 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %581 = wave.ptr_add %577, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_32, %token_33 = wave.load %581 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %582 = wave.ptr_add %577, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_34, %token_35 = wave.load %582 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %583 = wave.ptr_add %577, %341 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_36, %token_37 = wave.load %583 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %584 = wave.ptr_add %577, %343 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_38, %token_39 = wave.load %584 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %585 = wave.ptr_add %577, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_40, %token_41 = wave.load %585 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %586 = wave.ptr_add %577, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_42, %token_43 = wave.load %586 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %587 = wave.ptr_add %577, %349 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_44, %token_45 = wave.load %587 after %579 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %588 = wave.join %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %589 = wave.ptr_add %181, %576 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %590 = wave.barrier %332, %292, %252 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %591 = wave.join %395#21, %395#20, %590, %573 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_46, %token_47 = wave.gather %589 mapping <bit_offset = <"16*(128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %592 = wave.extract %value_46[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %593 = wave.extract %value_46[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %594 = wave.extract %value_46[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %595 = wave.extract %value_46[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_48, %token_49 = wave.gather %589 mapping <bit_offset = <"16*(4224 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %596 = wave.extract %value_48[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %597 = wave.extract %value_48[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %598 = wave.extract %value_48[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %599 = wave.extract %value_48[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %600 = wave.pack %592, %593, %594, %595, %596, %597, %598, %599 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_50, %token_51 = wave.gather %589 mapping <bit_offset = <"16*(256 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %601 = wave.extract %value_50[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %602 = wave.extract %value_50[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %603 = wave.extract %value_50[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %604 = wave.extract %value_50[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_52, %token_53 = wave.gather %589 mapping <bit_offset = <"16*(4480 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %605 = wave.extract %value_52[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %606 = wave.extract %value_52[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %607 = wave.extract %value_52[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %608 = wave.extract %value_52[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %609 = wave.pack %601, %602, %603, %604, %605, %606, %607, %608 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_54, %token_55 = wave.gather %589 mapping <bit_offset = <"16*(64 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %610 = wave.extract %value_54[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %611 = wave.extract %value_54[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %612 = wave.extract %value_54[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %613 = wave.extract %value_54[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_56, %token_57 = wave.gather %589 mapping <bit_offset = <"16*(4288 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %614 = wave.extract %value_56[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %615 = wave.extract %value_56[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %616 = wave.extract %value_56[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %617 = wave.extract %value_56[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %618 = wave.pack %610, %611, %612, %613, %614, %615, %616, %617 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_58, %token_59 = wave.gather %589 mapping <bit_offset = <"16*(320 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %619 = wave.extract %value_58[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %620 = wave.extract %value_58[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %621 = wave.extract %value_58[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %622 = wave.extract %value_58[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_60, %token_61 = wave.gather %589 mapping <bit_offset = <"16*(4544 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %591 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %623 = wave.extract %value_60[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %624 = wave.extract %value_60[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %625 = wave.extract %value_60[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %626 = wave.extract %value_60[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %627 = wave.pack %619, %620, %621, %622, %623, %624, %625, %626 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %628 = wave.join %token_47, %token_49, %token_51, %token_53, %token_55, %token_57, %token_59, %token_61 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %629 = waveamd.fragment_pack %value_30 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %630 = waveamd.fragment_pack %value_32 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %631 = waveamd.fragment_pack %value_34 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %632 = waveamd.fragment_pack %value_36 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %633 = waveamd.fragment_pack %value_38 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %634 = waveamd.fragment_pack %value_40 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %635 = waveamd.fragment_pack %value_42 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %636 = waveamd.fragment_pack %value_44 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %637 = waveamd.fragment_pack %600 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %638 = waveamd.fragment_pack %609 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %639 = waveamd.fragment_pack %618 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %640 = waveamd.fragment_pack %627 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %641 = waveamd.fragment_pack %551 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.fragment_pack %554 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %643 = waveamd.fragment_pack %557 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.fragment_pack %560 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %645 = waveamd.fragment_pack %563 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %646 = waveamd.fragment_pack %566 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.fragment_pack %569 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %648 = waveamd.fragment_pack %572 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %649 = waveamd.mma "mfma.f32.16x16x32.f16" %637, %629, %641 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.mma "mfma.f32.16x16x32.f16" %638, %630, %649 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %651 = waveamd.fragment_unpack %650 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %652 = waveamd.mma "mfma.f32.16x16x32.f16" %639, %629, %642 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.mma "mfma.f32.16x16x32.f16" %640, %630, %652 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %654 = waveamd.fragment_unpack %653 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %655 = waveamd.mma "mfma.f32.16x16x32.f16" %637, %631, %643 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %656 = waveamd.mma "mfma.f32.16x16x32.f16" %638, %632, %655 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %657 = waveamd.fragment_unpack %656 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %658 = waveamd.mma "mfma.f32.16x16x32.f16" %639, %631, %644 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %659 = waveamd.mma "mfma.f32.16x16x32.f16" %640, %632, %658 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %660 = waveamd.fragment_unpack %659 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %661 = waveamd.mma "mfma.f32.16x16x32.f16" %637, %633, %645 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %662 = waveamd.mma "mfma.f32.16x16x32.f16" %638, %634, %661 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.fragment_unpack %662 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %664 = waveamd.mma "mfma.f32.16x16x32.f16" %639, %633, %646 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %665 = waveamd.mma "mfma.f32.16x16x32.f16" %640, %634, %664 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.fragment_unpack %665 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %667 = waveamd.mma "mfma.f32.16x16x32.f16" %637, %635, %647 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %668 = waveamd.mma "mfma.f32.16x16x32.f16" %638, %636, %667 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.fragment_unpack %668 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %670 = waveamd.mma "mfma.f32.16x16x32.f16" %639, %635, %648 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %671 = waveamd.mma "mfma.f32.16x16x32.f16" %640, %636, %670 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %672 = waveamd.fragment_unpack %671 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %673 = wave.binary addi %179, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %674 = wave.binary remsi %673, %c3_i32 : i32, i32 -> i32
      %675 = wave.binary muli %674, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %676 = wave.ptr_add %180, %675 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %677 = wave.join %395#21, %395#20, %578, %588, %573 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %678 = wave.ptr_add %676, %335 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_62, %token_63 = wave.load %678 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %679 = wave.ptr_add %676, %337 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_64, %token_65 = wave.load %679 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %680 = wave.ptr_add %676, %339 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_66, %token_67 = wave.load %680 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %681 = wave.ptr_add %676, %341 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_68, %token_69 = wave.load %681 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %682 = wave.ptr_add %676, %343 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_70, %token_71 = wave.load %682 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %683 = wave.ptr_add %676, %345 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_72, %token_73 = wave.load %683 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %684 = wave.ptr_add %676, %347 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_74, %token_75 = wave.load %684 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %685 = wave.ptr_add %676, %349 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_76, %token_77 = wave.load %685 after %677 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %686 = wave.join %token_63, %token_65, %token_67, %token_69, %token_71, %token_73, %token_75, %token_77 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %687 = wave.ptr_add %181, %675 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %688 = wave.join %395#21, %395#20, %590, %628, %573 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_78, %token_79 = wave.gather %687 mapping <bit_offset = <"16*(128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %689 = wave.extract %value_78[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %690 = wave.extract %value_78[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %691 = wave.extract %value_78[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %692 = wave.extract %value_78[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_80, %token_81 = wave.gather %687 mapping <bit_offset = <"16*(4224 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %693 = wave.extract %value_80[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %694 = wave.extract %value_80[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %695 = wave.extract %value_80[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %696 = wave.extract %value_80[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %697 = wave.pack %689, %690, %691, %692, %693, %694, %695, %696 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_82, %token_83 = wave.gather %687 mapping <bit_offset = <"16*(256 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %698 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %699 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %700 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %701 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_84, %token_85 = wave.gather %687 mapping <bit_offset = <"16*(4480 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %702 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %703 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %704 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %705 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %706 = wave.pack %698, %699, %700, %701, %702, %703, %704, %705 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_86, %token_87 = wave.gather %687 mapping <bit_offset = <"16*(64 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %707 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %708 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %709 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %710 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_88, %token_89 = wave.gather %687 mapping <bit_offset = <"16*(4288 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %711 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %712 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %713 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %714 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %715 = wave.pack %707, %708, %709, %710, %711, %712, %713, %714 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_90, %token_91 = wave.gather %687 mapping <bit_offset = <"16*(320 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %716 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %717 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %718 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %719 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_92, %token_93 = wave.gather %687 mapping <bit_offset = <"16*(4544 + 128*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %688 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %720 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %721 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %722 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %723 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %724 = wave.pack %716, %717, %718, %719, %720, %721, %722, %723 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %725 = wave.join %token_79, %token_81, %token_83, %token_85, %token_87, %token_89, %token_91, %token_93 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %726 = waveamd.fragment_pack %value_62 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %727 = waveamd.fragment_pack %value_64 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %728 = waveamd.fragment_pack %value_66 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %729 = waveamd.fragment_pack %value_68 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %730 = waveamd.fragment_pack %value_70 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %731 = waveamd.fragment_pack %value_72 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %732 = waveamd.fragment_pack %value_74 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %733 = waveamd.fragment_pack %value_76 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %734 = waveamd.fragment_pack %697 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %735 = waveamd.fragment_pack %706 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %736 = waveamd.fragment_pack %715 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %737 = waveamd.fragment_pack %724 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %738 = waveamd.fragment_pack %651 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %739 = waveamd.fragment_pack %654 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %740 = waveamd.fragment_pack %657 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %741 = waveamd.fragment_pack %660 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %742 = waveamd.fragment_pack %663 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %743 = waveamd.fragment_pack %666 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %744 = waveamd.fragment_pack %669 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %745 = waveamd.fragment_pack %672 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %746 = waveamd.mma "mfma.f32.16x16x32.f16" %734, %726, %738 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %747 = waveamd.mma "mfma.f32.16x16x32.f16" %735, %727, %746 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %748 = waveamd.fragment_unpack %747 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %749 = waveamd.mma "mfma.f32.16x16x32.f16" %736, %726, %739 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %750 = waveamd.mma "mfma.f32.16x16x32.f16" %737, %727, %749 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %751 = waveamd.fragment_unpack %750 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %752 = waveamd.mma "mfma.f32.16x16x32.f16" %734, %728, %740 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %753 = waveamd.mma "mfma.f32.16x16x32.f16" %735, %729, %752 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %754 = waveamd.fragment_unpack %753 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %755 = waveamd.mma "mfma.f32.16x16x32.f16" %736, %728, %741 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %756 = waveamd.mma "mfma.f32.16x16x32.f16" %737, %729, %755 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %757 = waveamd.fragment_unpack %756 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %758 = waveamd.mma "mfma.f32.16x16x32.f16" %734, %730, %742 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %759 = waveamd.mma "mfma.f32.16x16x32.f16" %735, %731, %758 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %760 = waveamd.fragment_unpack %759 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %761 = waveamd.mma "mfma.f32.16x16x32.f16" %736, %730, %743 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %762 = waveamd.mma "mfma.f32.16x16x32.f16" %737, %731, %761 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %763 = waveamd.fragment_unpack %762 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %764 = waveamd.mma "mfma.f32.16x16x32.f16" %734, %732, %744 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %765 = waveamd.mma "mfma.f32.16x16x32.f16" %735, %733, %764 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %766 = waveamd.fragment_unpack %765 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %767 = waveamd.mma "mfma.f32.16x16x32.f16" %736, %732, %745 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %768 = waveamd.mma "mfma.f32.16x16x32.f16" %737, %733, %767 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %769 = waveamd.fragment_unpack %768 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %770 = wave.barrier %588, %628, %686, %725 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %771 = wave.join %395#23, %588, %686, %395#21, %395#20, %578, %770 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %772 = wave.alloc_release %180 after %771 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> !wave.mem.token
      %773 = wave.join %395#23, %628, %725, %395#21, %395#20, %590, %770 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %774 = wave.alloc_release %181 after %773 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> !wave.mem.token
      %775 = wave.barrier %528, %772, %774 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %776 = wave.pack %748, %751, %754, %757, %760, %763, %766, %769 : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<32xf32>, 64>
      %777 = wave.redistribute %776, <blocks = 1, items = 512, source_block = "0", source_item = "64*xor(4*Mod(floor(1/256*item), 2), xor(2*Mod(floor(1/4*Mod(item, 64)), 2), Mod(floor(1/2*Mod(item, 64)), 2))) + xor(8*Mod(floor(1/128*item), 2), xor(4*Mod(floor(1/64*item), 2), xor(2*Mod(floor(1/32*Mod(item, 64)), 2), xor(Mod(floor(1/16*Mod(item, 64)), 2), xor(16*Mod(floor(1/4*slot), 2), 32*Mod(Mod(item, 64), 2))))))", source_slot = "xor(4*Mod(floor(1/8*Mod(item, 64)), 2), xor(16*Mod(floor(1/16*slot), 2), xor(8*Mod(floor(1/8*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))"> : !wave.simd<vector<32xf32>, 64> -> !wave.simd<vector<32xf32>, 64>
      %778 = wave.extract %777[0] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %779 = wave.extract %777[1] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %780 = wave.extract %777[2] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %781 = wave.extract %777[3] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %782 = wave.extract %777[4] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %783 = wave.extract %777[5] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %784 = wave.extract %777[6] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %785 = wave.extract %777[7] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %786 = wave.extract %777[8] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %787 = wave.extract %777[9] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %788 = wave.extract %777[10] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %789 = wave.extract %777[11] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %790 = wave.extract %777[12] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %791 = wave.extract %777[13] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %792 = wave.extract %777[14] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %793 = wave.extract %777[15] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %794 = wave.extract %777[16] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %795 = wave.extract %777[17] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %796 = wave.extract %777[18] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %797 = wave.extract %777[19] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %798 = wave.extract %777[20] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %799 = wave.extract %777[21] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %800 = wave.extract %777[22] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %801 = wave.extract %777[23] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %802 = wave.extract %777[24] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %803 = wave.extract %777[25] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %804 = wave.extract %777[26] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %805 = wave.extract %777[27] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %806 = wave.extract %777[28] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %807 = wave.extract %777[29] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %808 = wave.extract %777[30] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %809 = wave.extract %777[31] : !wave.simd<vector<32xf32>, 64> -> !wave.simd<f32, 64>
      %810 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%169) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %811 = wave.assume %810 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %812 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%811) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %813 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%171) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %814 = wave.assume %813 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %815 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%814) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %816 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%172) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %817 = wave.assume %816 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %818 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%817) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %819 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%173) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %820 = wave.assume %819 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %821 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%820) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %822 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%174) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %823 = wave.assume %822 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %824 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%823) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %825 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%175) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %826 = wave.assume %825 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %827 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%826) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %828 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%176) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %829 = wave.assume %828 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %830 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%829) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %831 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%177) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %832 = wave.assume %831 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %833 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%832) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %834 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %value_94, %token_95 = wave.gather %834 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%812, %815, %818, %821, %824, %827, %830, %833) : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %835 = wave.extract %value_94[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %836 = wave.extract %value_94[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %837 = wave.extract %value_94[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %838 = wave.extract %value_94[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %839 = wave.extract %value_94[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %840 = wave.extract %value_94[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %841 = wave.extract %value_94[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %842 = wave.extract %value_94[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %843 = wave.cast fpconvert %835 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %844 = wave.cast fpconvert %836 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %845 = wave.cast fpconvert %837 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %846 = wave.cast fpconvert %838 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %847 = wave.cast fpconvert %839 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %848 = wave.cast fpconvert %840 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %849 = wave.cast fpconvert %841 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %850 = wave.cast fpconvert %842 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %851 = wave.fadd %778, %843 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %852 = wave.fadd %779, %844 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %853 = wave.fadd %780, %845 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %854 = wave.fadd %781, %846 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %855 = wave.fadd %782, %847 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %856 = wave.fadd %783, %848 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %857 = wave.fadd %784, %849 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %858 = wave.fadd %785, %850 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %859 = wave.fadd %786, %843 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %860 = wave.fadd %787, %844 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %861 = wave.fadd %788, %845 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %862 = wave.fadd %789, %846 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %863 = wave.fadd %790, %847 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %864 = wave.fadd %791, %848 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %865 = wave.fadd %792, %849 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %866 = wave.fadd %793, %850 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %867 = wave.fadd %794, %843 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %868 = wave.fadd %795, %844 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %869 = wave.fadd %796, %845 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %870 = wave.fadd %797, %846 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %871 = wave.fadd %798, %847 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %872 = wave.fadd %799, %848 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %873 = wave.fadd %800, %849 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %874 = wave.fadd %801, %850 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %875 = wave.fadd %802, %843 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %876 = wave.fadd %803, %844 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %877 = wave.fadd %804, %845 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %878 = wave.fadd %805, %846 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %879 = wave.fadd %806, %847 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %880 = wave.fadd %807, %848 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %881 = wave.fadd %808, %849 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %882 = wave.fadd %809, %850 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %883 = wave.binary muli %77, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %884 = wave.binary xori %73, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %885 = wave.binary muli %81, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %886 = wave.binary xori %884, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %887 = wave.binary muli %84, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %888 = wave.binary xori %886, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %889 = wave.binary muli %88, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %890 = wave.binary xori %888, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %891 = wave.binary muli %70, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %892 = wave.binary xori %191, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %893 = wave.binary remui %892, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %894 = wave.binary divui %892, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %895 = wave.binary remui %894, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %896 = wave.binary muli %895, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %897 = wave.binary addi %893, %896 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %898 = wave.binary divui %892, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %899 = wave.binary remui %898, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %900 = wave.binary muli %899, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %901 = wave.binary addi %897, %900 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %902 = wave.binary divui %892, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %903 = wave.binary remui %902, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %904 = wave.binary muli %903, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %905 = wave.binary addi %901, %904 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %906 = wave.binary divui %892, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %907 = wave.binary remui %906, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %908 = wave.binary muli %907, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %909 = wave.binary addi %905, %908 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %910 = wave.binary divui %892, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %911 = wave.binary remui %910, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %912 = wave.binary muli %911, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %913 = wave.binary addi %909, %912 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %914 = wave.binary divui %892, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %915 = wave.binary remui %914, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %916 = wave.binary muli %915, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %917 = wave.binary addi %913, %916 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %918 = wave.binary remui %890, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %919 = wave.binary muli %918, %32 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %920 = wave.binary addi %917, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %921 = wave.binary divui %890, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %922 = wave.binary remui %921, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %923 = wave.binary muli %922, %31 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %924 = wave.binary addi %920, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %925 = wave.binary divui %890, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %926 = wave.binary remui %925, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %927 = wave.binary muli %926, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %928 = wave.binary addi %924, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %929 = wave.binary divui %890, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %930 = wave.binary remui %929, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %931 = wave.binary muli %930, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %932 = wave.binary addi %928, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %933 = wave.binary divui %890, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %934 = wave.binary remui %933, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary muli %934, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.binary addi %932, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %937 = wave.binary divui %890, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary remui %937, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary muli %938, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary addi %936, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary divui %890, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary remui %941, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary muli %942, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary addi %940, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary divui %944, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary muli %945, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.binary addi %944, %946 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %948 = wave.assume %947 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %949 = wave.binary xori %29, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.binary xori %949, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %951 = wave.binary xori %950, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary xori %951, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary remui %952, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary divui %952, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary remui %954, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary muli %955, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary addi %953, %956 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary divui %952, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary remui %958, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary muli %959, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.binary addi %957, %960 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %962 = wave.binary divui %952, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %963 = wave.binary remui %962, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %964 = wave.binary muli %963, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %965 = wave.binary addi %961, %964 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %966 = wave.binary divui %952, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %967 = wave.binary remui %966, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %968 = wave.binary muli %967, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %969 = wave.binary addi %965, %968 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %970 = wave.binary divui %952, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %971 = wave.binary remui %970, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %972 = wave.binary muli %971, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %973 = wave.binary addi %969, %972 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %974 = wave.binary divui %952, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %975 = wave.binary remui %974, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %976 = wave.binary muli %975, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %977 = wave.binary addi %973, %976 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %978 = wave.binary addi %977, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %979 = wave.binary addi %978, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %980 = wave.binary addi %979, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %981 = wave.binary addi %980, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %982 = wave.binary addi %981, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %983 = wave.binary addi %982, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %984 = wave.binary addi %983, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %985 = wave.binary divui %984, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %986 = wave.binary muli %985, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %987 = wave.binary addi %984, %986 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %988 = wave.assume %987 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %989 = wave.binary xori %36, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %990 = wave.binary xori %989, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %991 = wave.binary xori %990, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %992 = wave.binary xori %991, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %993 = wave.binary remui %992, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %994 = wave.binary divui %992, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %995 = wave.binary remui %994, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %996 = wave.binary muli %995, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %997 = wave.binary addi %993, %996 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %998 = wave.binary divui %992, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %999 = wave.binary remui %998, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1000 = wave.binary muli %999, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1001 = wave.binary addi %997, %1000 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1002 = wave.binary divui %992, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1003 = wave.binary remui %1002, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1004 = wave.binary muli %1003, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1005 = wave.binary addi %1001, %1004 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1006 = wave.binary divui %992, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1007 = wave.binary remui %1006, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1008 = wave.binary muli %1007, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1009 = wave.binary addi %1005, %1008 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1010 = wave.binary divui %992, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1011 = wave.binary remui %1010, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1012 = wave.binary muli %1011, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1013 = wave.binary addi %1009, %1012 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1014 = wave.binary divui %992, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1015 = wave.binary remui %1014, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1016 = wave.binary muli %1015, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1017 = wave.binary addi %1013, %1016 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1018 = wave.binary addi %1017, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1019 = wave.binary addi %1018, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1020 = wave.binary addi %1019, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1021 = wave.binary addi %1020, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1022 = wave.binary addi %1021, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1023 = wave.binary addi %1022, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1024 = wave.binary addi %1023, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1025 = wave.binary divui %1024, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1026 = wave.binary muli %1025, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1027 = wave.binary addi %1024, %1026 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1028 = wave.assume %1027 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1029 = wave.binary xori %28, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1030 = wave.binary xori %1029, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1031 = wave.binary xori %1030, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1032 = wave.binary xori %1031, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1033 = wave.binary remui %1032, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1034 = wave.binary divui %1032, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1035 = wave.binary remui %1034, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1036 = wave.binary muli %1035, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1037 = wave.binary addi %1033, %1036 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1038 = wave.binary divui %1032, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1039 = wave.binary remui %1038, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1040 = wave.binary muli %1039, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1041 = wave.binary addi %1037, %1040 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1042 = wave.binary divui %1032, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1043 = wave.binary remui %1042, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1044 = wave.binary muli %1043, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1045 = wave.binary addi %1041, %1044 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1046 = wave.binary divui %1032, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1047 = wave.binary remui %1046, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1048 = wave.binary muli %1047, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1049 = wave.binary addi %1045, %1048 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1050 = wave.binary divui %1032, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1051 = wave.binary remui %1050, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1052 = wave.binary muli %1051, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1053 = wave.binary addi %1049, %1052 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1054 = wave.binary divui %1032, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1055 = wave.binary remui %1054, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1056 = wave.binary muli %1055, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1057 = wave.binary addi %1053, %1056 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1058 = wave.binary addi %1057, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1059 = wave.binary addi %1058, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1060 = wave.binary addi %1059, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1061 = wave.binary addi %1060, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1062 = wave.binary addi %1061, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1063 = wave.binary addi %1062, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1064 = wave.binary addi %1063, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1065 = wave.binary divui %1064, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1066 = wave.binary muli %1065, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1067 = wave.binary addi %1064, %1066 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1068 = wave.assume %1067 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1069 = wave.binary xori %30, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1070 = wave.binary xori %1069, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1071 = wave.binary xori %1070, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1072 = wave.binary xori %1071, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1073 = wave.binary remui %1072, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1074 = wave.binary divui %1072, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1075 = wave.binary remui %1074, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1076 = wave.binary muli %1075, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1077 = wave.binary addi %1073, %1076 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1078 = wave.binary divui %1072, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1079 = wave.binary remui %1078, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1080 = wave.binary muli %1079, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1081 = wave.binary addi %1077, %1080 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1082 = wave.binary divui %1072, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1083 = wave.binary remui %1082, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1084 = wave.binary muli %1083, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1085 = wave.binary addi %1081, %1084 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1086 = wave.binary divui %1072, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1087 = wave.binary remui %1086, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1088 = wave.binary muli %1087, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1089 = wave.binary addi %1085, %1088 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1090 = wave.binary divui %1072, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1091 = wave.binary remui %1090, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1092 = wave.binary muli %1091, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1093 = wave.binary addi %1089, %1092 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1094 = wave.binary divui %1072, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1095 = wave.binary remui %1094, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1096 = wave.binary muli %1095, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1097 = wave.binary addi %1093, %1096 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1098 = wave.binary addi %1097, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1099 = wave.binary addi %1098, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1100 = wave.binary addi %1099, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1101 = wave.binary addi %1100, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1102 = wave.binary addi %1101, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1103 = wave.binary addi %1102, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1104 = wave.binary addi %1103, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1105 = wave.binary divui %1104, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1106 = wave.binary muli %1105, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1107 = wave.binary addi %1104, %1106 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1108 = wave.assume %1107 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1109 = wave.binary xori %27, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1110 = wave.binary xori %1109, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1111 = wave.binary xori %1110, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1112 = wave.binary xori %1111, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1113 = wave.binary remui %1112, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1114 = wave.binary divui %1112, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1115 = wave.binary remui %1114, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1116 = wave.binary muli %1115, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1117 = wave.binary addi %1113, %1116 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1118 = wave.binary divui %1112, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1119 = wave.binary remui %1118, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1120 = wave.binary muli %1119, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1121 = wave.binary addi %1117, %1120 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1122 = wave.binary divui %1112, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1123 = wave.binary remui %1122, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1124 = wave.binary muli %1123, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1125 = wave.binary addi %1121, %1124 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1126 = wave.binary divui %1112, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1127 = wave.binary remui %1126, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1128 = wave.binary muli %1127, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1129 = wave.binary addi %1125, %1128 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1130 = wave.binary divui %1112, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1131 = wave.binary remui %1130, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1132 = wave.binary muli %1131, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1133 = wave.binary addi %1129, %1132 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1134 = wave.binary divui %1112, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1135 = wave.binary remui %1134, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1136 = wave.binary muli %1135, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1137 = wave.binary addi %1133, %1136 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1138 = wave.binary addi %1137, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1139 = wave.binary addi %1138, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1140 = wave.binary addi %1139, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1141 = wave.binary addi %1140, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1142 = wave.binary addi %1141, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1143 = wave.binary addi %1142, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1144 = wave.binary addi %1143, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1145 = wave.binary divui %1144, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1146 = wave.binary muli %1145, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1147 = wave.binary addi %1144, %1146 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1148 = wave.assume %1147 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1149 = wave.binary xori %26, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1150 = wave.binary xori %1149, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1151 = wave.binary xori %1150, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1152 = wave.binary xori %1151, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1153 = wave.binary remui %1152, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1154 = wave.binary divui %1152, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1155 = wave.binary remui %1154, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1156 = wave.binary muli %1155, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1157 = wave.binary addi %1153, %1156 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1158 = wave.binary divui %1152, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1159 = wave.binary remui %1158, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1160 = wave.binary muli %1159, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1161 = wave.binary addi %1157, %1160 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1162 = wave.binary divui %1152, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1163 = wave.binary remui %1162, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1164 = wave.binary muli %1163, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1165 = wave.binary addi %1161, %1164 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1166 = wave.binary divui %1152, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1167 = wave.binary remui %1166, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1168 = wave.binary muli %1167, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1169 = wave.binary addi %1165, %1168 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1170 = wave.binary divui %1152, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1171 = wave.binary remui %1170, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1172 = wave.binary muli %1171, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1173 = wave.binary addi %1169, %1172 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1174 = wave.binary divui %1152, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1175 = wave.binary remui %1174, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1176 = wave.binary muli %1175, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1177 = wave.binary addi %1173, %1176 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1178 = wave.binary addi %1177, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1179 = wave.binary addi %1178, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1180 = wave.binary addi %1179, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1181 = wave.binary addi %1180, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1182 = wave.binary addi %1181, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1183 = wave.binary addi %1182, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1184 = wave.binary addi %1183, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1185 = wave.binary divui %1184, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1186 = wave.binary muli %1185, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1187 = wave.binary addi %1184, %1186 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1188 = wave.assume %1187 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1189 = wave.binary xori %25, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1190 = wave.binary xori %1189, %186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1191 = wave.binary xori %1190, %190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1192 = wave.binary xori %1191, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1193 = wave.binary remui %1192, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1194 = wave.binary divui %1192, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1195 = wave.binary remui %1194, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1196 = wave.binary muli %1195, %36 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1197 = wave.binary addi %1193, %1196 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1198 = wave.binary divui %1192, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1199 = wave.binary remui %1198, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1200 = wave.binary muli %1199, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1201 = wave.binary addi %1197, %1200 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1202 = wave.binary divui %1192, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1203 = wave.binary remui %1202, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1204 = wave.binary muli %1203, %37 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1205 = wave.binary addi %1201, %1204 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1206 = wave.binary divui %1192, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1207 = wave.binary remui %1206, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1208 = wave.binary muli %1207, %35 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1209 = wave.binary addi %1205, %1208 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1210 = wave.binary divui %1192, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1211 = wave.binary remui %1210, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1212 = wave.binary muli %1211, %34 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1213 = wave.binary addi %1209, %1212 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1214 = wave.binary divui %1192, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1215 = wave.binary remui %1214, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1216 = wave.binary muli %1215, %33 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1217 = wave.binary addi %1213, %1216 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1218 = wave.binary addi %1217, %919 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1219 = wave.binary addi %1218, %923 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1220 = wave.binary addi %1219, %927 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1221 = wave.binary addi %1220, %931 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1222 = wave.binary addi %1221, %935 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1223 = wave.binary addi %1222, %939 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1224 = wave.binary addi %1223, %943 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1225 = wave.binary divui %1224, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1226 = wave.binary muli %1225, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1227 = wave.binary addi %1224, %1226 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1228 = wave.assume %1227 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1229 = wave.binary xori %34, %73 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1230 = wave.binary xori %1229, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1231 = wave.binary xori %1230, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1232 = wave.binary xori %1231, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1233 = wave.binary xori %1232, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1234 = wave.binary remui %1233, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1235 = wave.binary muli %1234, %32 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1236 = wave.binary addi %917, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1237 = wave.binary divui %1233, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1238 = wave.binary remui %1237, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1239 = wave.binary muli %1238, %31 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1240 = wave.binary addi %1236, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1241 = wave.binary divui %1233, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1242 = wave.binary remui %1241, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1243 = wave.binary muli %1242, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1244 = wave.binary addi %1240, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1245 = wave.binary divui %1233, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1246 = wave.binary remui %1245, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1247 = wave.binary muli %1246, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1248 = wave.binary addi %1244, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1249 = wave.binary divui %1233, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1250 = wave.binary remui %1249, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1251 = wave.binary muli %1250, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1252 = wave.binary addi %1248, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1253 = wave.binary divui %1233, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1254 = wave.binary remui %1253, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1255 = wave.binary muli %1254, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1256 = wave.binary addi %1252, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1257 = wave.binary divui %1233, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1258 = wave.binary remui %1257, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1259 = wave.binary muli %1258, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1260 = wave.binary addi %1256, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1261 = wave.binary divui %1260, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1262 = wave.binary muli %1261, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1263 = wave.binary addi %1260, %1262 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1264 = wave.assume %1263 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1265 = wave.binary addi %977, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1266 = wave.binary addi %1265, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1267 = wave.binary addi %1266, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1268 = wave.binary addi %1267, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1269 = wave.binary addi %1268, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1270 = wave.binary addi %1269, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1271 = wave.binary addi %1270, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1272 = wave.binary divui %1271, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1273 = wave.binary muli %1272, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1274 = wave.binary addi %1271, %1273 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1275 = wave.assume %1274 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1276 = wave.binary addi %1017, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1277 = wave.binary addi %1276, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1278 = wave.binary addi %1277, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1279 = wave.binary addi %1278, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1280 = wave.binary addi %1279, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1281 = wave.binary addi %1280, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1282 = wave.binary addi %1281, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1283 = wave.binary divui %1282, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1284 = wave.binary muli %1283, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1285 = wave.binary addi %1282, %1284 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1286 = wave.assume %1285 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1287 = wave.binary addi %1057, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1288 = wave.binary addi %1287, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1289 = wave.binary addi %1288, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1290 = wave.binary addi %1289, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1291 = wave.binary addi %1290, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1292 = wave.binary addi %1291, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1293 = wave.binary addi %1292, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1294 = wave.binary divui %1293, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1295 = wave.binary muli %1294, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1296 = wave.binary addi %1293, %1295 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1297 = wave.assume %1296 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1298 = wave.binary addi %1097, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1299 = wave.binary addi %1298, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1300 = wave.binary addi %1299, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1301 = wave.binary addi %1300, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1302 = wave.binary addi %1301, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1303 = wave.binary addi %1302, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1304 = wave.binary addi %1303, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1305 = wave.binary divui %1304, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1306 = wave.binary muli %1305, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1307 = wave.binary addi %1304, %1306 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1308 = wave.assume %1307 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1309 = wave.binary addi %1137, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1310 = wave.binary addi %1309, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1311 = wave.binary addi %1310, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1312 = wave.binary addi %1311, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1313 = wave.binary addi %1312, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1314 = wave.binary addi %1313, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1315 = wave.binary addi %1314, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1316 = wave.binary divui %1315, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1317 = wave.binary muli %1316, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1318 = wave.binary addi %1315, %1317 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1319 = wave.assume %1318 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1320 = wave.binary addi %1177, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1321 = wave.binary addi %1320, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1322 = wave.binary addi %1321, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1323 = wave.binary addi %1322, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1324 = wave.binary addi %1323, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1325 = wave.binary addi %1324, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1326 = wave.binary addi %1325, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1327 = wave.binary divui %1326, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1328 = wave.binary muli %1327, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1329 = wave.binary addi %1326, %1328 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1330 = wave.assume %1329 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1331 = wave.binary addi %1217, %1235 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1332 = wave.binary addi %1331, %1239 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1333 = wave.binary addi %1332, %1243 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1334 = wave.binary addi %1333, %1247 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1335 = wave.binary addi %1334, %1251 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1336 = wave.binary addi %1335, %1255 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1337 = wave.binary addi %1336, %1259 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1338 = wave.binary divui %1337, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1339 = wave.binary muli %1338, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1340 = wave.binary addi %1337, %1339 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1341 = wave.assume %1340 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1342 = wave.binary xori %33, %73 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1343 = wave.binary xori %1342, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1344 = wave.binary xori %1343, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1345 = wave.binary xori %1344, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1346 = wave.binary xori %1345, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1347 = wave.binary remui %1346, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1348 = wave.binary muli %1347, %32 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1349 = wave.binary addi %917, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1350 = wave.binary divui %1346, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1351 = wave.binary remui %1350, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1352 = wave.binary muli %1351, %31 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1353 = wave.binary addi %1349, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1354 = wave.binary divui %1346, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1355 = wave.binary remui %1354, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1356 = wave.binary muli %1355, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1357 = wave.binary addi %1353, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1358 = wave.binary divui %1346, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1359 = wave.binary remui %1358, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1360 = wave.binary muli %1359, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1361 = wave.binary addi %1357, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1362 = wave.binary divui %1346, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1363 = wave.binary remui %1362, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1364 = wave.binary muli %1363, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1365 = wave.binary addi %1361, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1366 = wave.binary divui %1346, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1367 = wave.binary remui %1366, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1368 = wave.binary muli %1367, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1369 = wave.binary addi %1365, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1370 = wave.binary divui %1346, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1371 = wave.binary remui %1370, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1372 = wave.binary muli %1371, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1373 = wave.binary addi %1369, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1374 = wave.binary divui %1373, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1375 = wave.binary muli %1374, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1376 = wave.binary addi %1373, %1375 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1377 = wave.assume %1376 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1378 = wave.binary addi %977, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1379 = wave.binary addi %1378, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1380 = wave.binary addi %1379, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1381 = wave.binary addi %1380, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1382 = wave.binary addi %1381, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1383 = wave.binary addi %1382, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1384 = wave.binary addi %1383, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1385 = wave.binary divui %1384, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1386 = wave.binary muli %1385, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1387 = wave.binary addi %1384, %1386 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1388 = wave.assume %1387 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1389 = wave.binary addi %1017, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1390 = wave.binary addi %1389, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1391 = wave.binary addi %1390, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1392 = wave.binary addi %1391, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1393 = wave.binary addi %1392, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1394 = wave.binary addi %1393, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1395 = wave.binary addi %1394, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1396 = wave.binary divui %1395, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1397 = wave.binary muli %1396, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1398 = wave.binary addi %1395, %1397 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1399 = wave.assume %1398 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1400 = wave.binary addi %1057, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1401 = wave.binary addi %1400, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1402 = wave.binary addi %1401, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1403 = wave.binary addi %1402, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1404 = wave.binary addi %1403, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1405 = wave.binary addi %1404, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1406 = wave.binary addi %1405, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1407 = wave.binary divui %1406, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1408 = wave.binary muli %1407, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1409 = wave.binary addi %1406, %1408 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1410 = wave.assume %1409 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1411 = wave.binary addi %1097, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1412 = wave.binary addi %1411, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1413 = wave.binary addi %1412, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1414 = wave.binary addi %1413, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1415 = wave.binary addi %1414, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1416 = wave.binary addi %1415, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1417 = wave.binary addi %1416, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1418 = wave.binary divui %1417, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1419 = wave.binary muli %1418, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1420 = wave.binary addi %1417, %1419 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1421 = wave.assume %1420 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1422 = wave.binary addi %1137, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1423 = wave.binary addi %1422, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1424 = wave.binary addi %1423, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1425 = wave.binary addi %1424, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1426 = wave.binary addi %1425, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1427 = wave.binary addi %1426, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1428 = wave.binary addi %1427, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1429 = wave.binary divui %1428, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1430 = wave.binary muli %1429, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1431 = wave.binary addi %1428, %1430 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1432 = wave.assume %1431 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1433 = wave.binary addi %1177, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1434 = wave.binary addi %1433, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1435 = wave.binary addi %1434, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1436 = wave.binary addi %1435, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1437 = wave.binary addi %1436, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1438 = wave.binary addi %1437, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1439 = wave.binary addi %1438, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1440 = wave.binary divui %1439, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1441 = wave.binary muli %1440, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1442 = wave.binary addi %1439, %1441 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1443 = wave.assume %1442 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1444 = wave.binary addi %1217, %1348 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1445 = wave.binary addi %1444, %1352 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1446 = wave.binary addi %1445, %1356 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1447 = wave.binary addi %1446, %1360 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1448 = wave.binary addi %1447, %1364 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1449 = wave.binary addi %1448, %1368 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1450 = wave.binary addi %1449, %1372 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1451 = wave.binary divui %1450, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1452 = wave.binary muli %1451, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1453 = wave.binary addi %1450, %1452 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1454 = wave.assume %1453 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1455 = wave.binary xori %17, %73 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1456 = wave.binary xori %1455, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1457 = wave.binary xori %1456, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1458 = wave.binary xori %1457, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1459 = wave.binary xori %1458, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1460 = wave.binary remui %1459, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1461 = wave.binary muli %1460, %32 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1462 = wave.binary addi %917, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1463 = wave.binary divui %1459, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1464 = wave.binary remui %1463, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1465 = wave.binary muli %1464, %31 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1466 = wave.binary addi %1462, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1467 = wave.binary divui %1459, %30 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1468 = wave.binary remui %1467, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1469 = wave.binary muli %1468, %4 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1470 = wave.binary addi %1466, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1471 = wave.binary divui %1459, %37 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1472 = wave.binary remui %1471, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1473 = wave.binary muli %1472, %3 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1474 = wave.binary addi %1470, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1475 = wave.binary divui %1459, %35 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1476 = wave.binary remui %1475, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1477 = wave.binary muli %1476, %2 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1478 = wave.binary addi %1474, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1479 = wave.binary divui %1459, %34 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1480 = wave.binary remui %1479, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1481 = wave.binary muli %1480, %1 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1482 = wave.binary addi %1478, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1483 = wave.binary divui %1459, %33 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1484 = wave.binary remui %1483, %36 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1485 = wave.binary muli %1484, %0 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1486 = wave.binary addi %1482, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1487 = wave.binary divui %1486, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1488 = wave.binary muli %1487, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1489 = wave.binary addi %1486, %1488 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1490 = wave.assume %1489 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1491 = wave.binary addi %977, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1492 = wave.binary addi %1491, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1493 = wave.binary addi %1492, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1494 = wave.binary addi %1493, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1495 = wave.binary addi %1494, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1496 = wave.binary addi %1495, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1497 = wave.binary addi %1496, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1498 = wave.binary divui %1497, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1499 = wave.binary muli %1498, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1500 = wave.binary addi %1497, %1499 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1501 = wave.assume %1500 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1502 = wave.binary addi %1017, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1503 = wave.binary addi %1502, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1504 = wave.binary addi %1503, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1505 = wave.binary addi %1504, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1506 = wave.binary addi %1505, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1507 = wave.binary addi %1506, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1508 = wave.binary addi %1507, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1509 = wave.binary divui %1508, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1510 = wave.binary muli %1509, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1511 = wave.binary addi %1508, %1510 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1512 = wave.assume %1511 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1513 = wave.binary addi %1057, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1514 = wave.binary addi %1513, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1515 = wave.binary addi %1514, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1516 = wave.binary addi %1515, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1517 = wave.binary addi %1516, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1518 = wave.binary addi %1517, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1519 = wave.binary addi %1518, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1520 = wave.binary divui %1519, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1521 = wave.binary muli %1520, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1522 = wave.binary addi %1519, %1521 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1523 = wave.assume %1522 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1524 = wave.binary addi %1097, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1525 = wave.binary addi %1524, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1526 = wave.binary addi %1525, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1527 = wave.binary addi %1526, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1528 = wave.binary addi %1527, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1529 = wave.binary addi %1528, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1530 = wave.binary addi %1529, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1531 = wave.binary divui %1530, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1532 = wave.binary muli %1531, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1533 = wave.binary addi %1530, %1532 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1534 = wave.assume %1533 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1535 = wave.binary addi %1137, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1536 = wave.binary addi %1535, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1537 = wave.binary addi %1536, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1538 = wave.binary addi %1537, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1539 = wave.binary addi %1538, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1540 = wave.binary addi %1539, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1541 = wave.binary addi %1540, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1542 = wave.binary divui %1541, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1543 = wave.binary muli %1542, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1544 = wave.binary addi %1541, %1543 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1545 = wave.assume %1544 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1546 = wave.binary addi %1177, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1547 = wave.binary addi %1546, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1548 = wave.binary addi %1547, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1549 = wave.binary addi %1548, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1550 = wave.binary addi %1549, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1551 = wave.binary addi %1550, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1552 = wave.binary addi %1551, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1553 = wave.binary divui %1552, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1554 = wave.binary muli %1553, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1555 = wave.binary addi %1552, %1554 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1556 = wave.assume %1555 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1557 = wave.binary addi %1217, %1461 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1558 = wave.binary addi %1557, %1465 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1559 = wave.binary addi %1558, %1469 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1560 = wave.binary addi %1559, %1473 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1561 = wave.binary addi %1560, %1477 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1562 = wave.binary addi %1561, %1481 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1563 = wave.binary addi %1562, %1485 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1564 = wave.binary divui %1563, %32 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1565 = wave.binary muli %1564, %30 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1566 = wave.binary addi %1563, %1565 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1567 = wave.assume %1566 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-16891 + x <= 0">] : !wave.simd<i32, 64>
      %1568 = wave.join %775, %573 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1569 = wave.pack %948, %988, %1028, %1068, %1108, %1148, %1188, %1228, %1264, %1275, %1286, %1297, %1308, %1319, %1330, %1341, %1377, %1388, %1399, %1410, %1421, %1432, %1443, %1454, %1490, %1501, %1512, %1523, %1534, %1545, %1556, %1567 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<32xi32>, 64>
      %value_96, %token_97 = wave.gather %396 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset"](%1569) after %1568 : (!wave.ptr<#wave.shared, f16>, !wave.simd<vector<32xi32>, 64>, !wave.mem.token) -> (!wave.simd<vector<32xf16>, 64>, !wave.mem.token)
      %1570 = wave.extract %value_96[0] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1571 = wave.extract %value_96[1] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1572 = wave.extract %value_96[2] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1573 = wave.extract %value_96[3] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1574 = wave.extract %value_96[4] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1575 = wave.extract %value_96[5] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1576 = wave.extract %value_96[6] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1577 = wave.extract %value_96[7] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1578 = wave.extract %value_96[8] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1579 = wave.extract %value_96[9] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1580 = wave.extract %value_96[10] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1581 = wave.extract %value_96[11] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1582 = wave.extract %value_96[12] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1583 = wave.extract %value_96[13] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1584 = wave.extract %value_96[14] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1585 = wave.extract %value_96[15] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1586 = wave.extract %value_96[16] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1587 = wave.extract %value_96[17] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1588 = wave.extract %value_96[18] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1589 = wave.extract %value_96[19] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1590 = wave.extract %value_96[20] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1591 = wave.extract %value_96[21] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1592 = wave.extract %value_96[22] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1593 = wave.extract %value_96[23] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1594 = wave.extract %value_96[24] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1595 = wave.extract %value_96[25] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1596 = wave.extract %value_96[26] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1597 = wave.extract %value_96[27] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1598 = wave.extract %value_96[28] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1599 = wave.extract %value_96[29] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1600 = wave.extract %value_96[30] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1601 = wave.extract %value_96[31] : !wave.simd<vector<32xf16>, 64> -> !wave.simd<f16, 64>
      %1602 = wave.cast fpconvert %1570 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1603 = wave.cast fpconvert %1571 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1604 = wave.cast fpconvert %1572 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1605 = wave.cast fpconvert %1573 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1606 = wave.cast fpconvert %1574 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1607 = wave.cast fpconvert %1575 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1608 = wave.cast fpconvert %1576 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1609 = wave.cast fpconvert %1577 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1610 = wave.cast fpconvert %1578 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1611 = wave.cast fpconvert %1579 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1612 = wave.cast fpconvert %1580 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1613 = wave.cast fpconvert %1581 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1614 = wave.cast fpconvert %1582 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1615 = wave.cast fpconvert %1583 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1616 = wave.cast fpconvert %1584 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1617 = wave.cast fpconvert %1585 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1618 = wave.cast fpconvert %1586 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1619 = wave.cast fpconvert %1587 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1620 = wave.cast fpconvert %1588 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1621 = wave.cast fpconvert %1589 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1622 = wave.cast fpconvert %1590 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1623 = wave.cast fpconvert %1591 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1624 = wave.cast fpconvert %1592 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1625 = wave.cast fpconvert %1593 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1626 = wave.cast fpconvert %1594 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1627 = wave.cast fpconvert %1595 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1628 = wave.cast fpconvert %1596 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1629 = wave.cast fpconvert %1597 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1630 = wave.cast fpconvert %1598 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1631 = wave.cast fpconvert %1599 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1632 = wave.cast fpconvert %1600 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1633 = wave.cast fpconvert %1601 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1634 = wave.fma %851, %1602, %851 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1635 = wave.fma %852, %1603, %852 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1636 = wave.fma %853, %1604, %853 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1637 = wave.fma %854, %1605, %854 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1638 = wave.fma %855, %1606, %855 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1639 = wave.fma %856, %1607, %856 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1640 = wave.fma %857, %1608, %857 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1641 = wave.fma %858, %1609, %858 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1642 = wave.fma %859, %1610, %859 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1643 = wave.fma %860, %1611, %860 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1644 = wave.fma %861, %1612, %861 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1645 = wave.fma %862, %1613, %862 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1646 = wave.fma %863, %1614, %863 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1647 = wave.fma %864, %1615, %864 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1648 = wave.fma %865, %1616, %865 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1649 = wave.fma %866, %1617, %866 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1650 = wave.fma %867, %1618, %867 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1651 = wave.fma %868, %1619, %868 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1652 = wave.fma %869, %1620, %869 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1653 = wave.fma %870, %1621, %870 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1654 = wave.fma %871, %1622, %871 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1655 = wave.fma %872, %1623, %872 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1656 = wave.fma %873, %1624, %873 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1657 = wave.fma %874, %1625, %874 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1658 = wave.fma %875, %1626, %875 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1659 = wave.fma %876, %1627, %876 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1660 = wave.fma %877, %1628, %877 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1661 = wave.fma %878, %1629, %878 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1662 = wave.fma %879, %1630, %879 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1663 = wave.fma %880, %1631, %880 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1664 = wave.fma %881, %1632, %881 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1665 = wave.fma %882, %1633, %882 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1666 = wave.binary addi %890, %119 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1667 = wave.binary addi %1233, %119 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1668 = wave.binary addi %1346, %119 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1669 = wave.binary addi %1459, %119 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1670 = wave.cmpi slt %1666, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1671 = wave.cmpi slt %1667, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1672 = wave.cmpi slt %1668, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1673 = wave.cmpi slt %1669, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1674 = wave.binary addi %892, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1675 = wave.binary addi %952, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1676 = wave.binary addi %992, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1677 = wave.binary addi %1032, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1678 = wave.binary addi %1072, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1679 = wave.binary addi %1112, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1680 = wave.binary addi %1152, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1681 = wave.binary addi %1192, %139 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1682 = wave.cmpi slt %1674, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1683 = wave.cmpi slt %1675, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1684 = wave.cmpi slt %1676, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1685 = wave.cmpi slt %1677, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1686 = wave.cmpi slt %1678, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1687 = wave.cmpi slt %1679, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1688 = wave.cmpi slt %1680, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1689 = wave.cmpi slt %1681, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1690 = wave.select %1670, %1682, %38 : !wave.mask<64>, !wave.mask<64>
      %1691 = wave.select %1670, %1683, %38 : !wave.mask<64>, !wave.mask<64>
      %1692 = wave.select %1670, %1684, %38 : !wave.mask<64>, !wave.mask<64>
      %1693 = wave.select %1670, %1685, %38 : !wave.mask<64>, !wave.mask<64>
      %1694 = wave.select %1670, %1686, %38 : !wave.mask<64>, !wave.mask<64>
      %1695 = wave.select %1670, %1687, %38 : !wave.mask<64>, !wave.mask<64>
      %1696 = wave.select %1670, %1688, %38 : !wave.mask<64>, !wave.mask<64>
      %1697 = wave.select %1670, %1689, %38 : !wave.mask<64>, !wave.mask<64>
      %1698 = wave.select %1671, %1682, %38 : !wave.mask<64>, !wave.mask<64>
      %1699 = wave.select %1671, %1683, %38 : !wave.mask<64>, !wave.mask<64>
      %1700 = wave.select %1671, %1684, %38 : !wave.mask<64>, !wave.mask<64>
      %1701 = wave.select %1671, %1685, %38 : !wave.mask<64>, !wave.mask<64>
      %1702 = wave.select %1671, %1686, %38 : !wave.mask<64>, !wave.mask<64>
      %1703 = wave.select %1671, %1687, %38 : !wave.mask<64>, !wave.mask<64>
      %1704 = wave.select %1671, %1688, %38 : !wave.mask<64>, !wave.mask<64>
      %1705 = wave.select %1671, %1689, %38 : !wave.mask<64>, !wave.mask<64>
      %1706 = wave.select %1672, %1682, %38 : !wave.mask<64>, !wave.mask<64>
      %1707 = wave.select %1672, %1683, %38 : !wave.mask<64>, !wave.mask<64>
      %1708 = wave.select %1672, %1684, %38 : !wave.mask<64>, !wave.mask<64>
      %1709 = wave.select %1672, %1685, %38 : !wave.mask<64>, !wave.mask<64>
      %1710 = wave.select %1672, %1686, %38 : !wave.mask<64>, !wave.mask<64>
      %1711 = wave.select %1672, %1687, %38 : !wave.mask<64>, !wave.mask<64>
      %1712 = wave.select %1672, %1688, %38 : !wave.mask<64>, !wave.mask<64>
      %1713 = wave.select %1672, %1689, %38 : !wave.mask<64>, !wave.mask<64>
      %1714 = wave.select %1673, %1682, %38 : !wave.mask<64>, !wave.mask<64>
      %1715 = wave.select %1673, %1683, %38 : !wave.mask<64>, !wave.mask<64>
      %1716 = wave.select %1673, %1684, %38 : !wave.mask<64>, !wave.mask<64>
      %1717 = wave.select %1673, %1685, %38 : !wave.mask<64>, !wave.mask<64>
      %1718 = wave.select %1673, %1686, %38 : !wave.mask<64>, !wave.mask<64>
      %1719 = wave.select %1673, %1687, %38 : !wave.mask<64>, !wave.mask<64>
      %1720 = wave.select %1673, %1688, %38 : !wave.mask<64>, !wave.mask<64>
      %1721 = wave.select %1673, %1689, %38 : !wave.mask<64>, !wave.mask<64>
      %1722 = wave.assume %arg11 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %1723 = wave.binary muli %67, %1722 overflow<nsw> : i32, i32 -> i32
      %1724 = wave.binary addi %1723, %138 overflow<nsw> : i32, i32 -> i32
      %1725 = wave.cast fpconvert %1634 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1726 = wave.cast fpconvert %1635 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1727 = wave.cast fpconvert %1636 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1728 = wave.cast fpconvert %1637 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1729 = wave.cast fpconvert %1638 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1730 = wave.cast fpconvert %1639 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1731 = wave.cast fpconvert %1640 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1732 = wave.cast fpconvert %1641 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1733 = wave.cast fpconvert %1642 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1734 = wave.cast fpconvert %1643 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1735 = wave.cast fpconvert %1644 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1736 = wave.cast fpconvert %1645 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1737 = wave.cast fpconvert %1646 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1738 = wave.cast fpconvert %1647 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1739 = wave.cast fpconvert %1648 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1740 = wave.cast fpconvert %1649 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1741 = wave.cast fpconvert %1650 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1742 = wave.cast fpconvert %1651 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1743 = wave.cast fpconvert %1652 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1744 = wave.cast fpconvert %1653 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1745 = wave.cast fpconvert %1654 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1746 = wave.cast fpconvert %1655 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1747 = wave.cast fpconvert %1656 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1748 = wave.cast fpconvert %1657 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1749 = wave.cast fpconvert %1658 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1750 = wave.cast fpconvert %1659 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1751 = wave.cast fpconvert %1660 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1752 = wave.cast fpconvert %1661 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1753 = wave.cast fpconvert %1662 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1754 = wave.cast fpconvert %1663 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1755 = wave.cast fpconvert %1664 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1756 = wave.cast fpconvert %1665 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1757 = wave.index_expr <"s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1758 = wave.assume %1757 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1759 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1758) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1760 = wave.index_expr <"1 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1761 = wave.assume %1760 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1762 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1761) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1763 = wave.index_expr <"2 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1764 = wave.assume %1763 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1765 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1764) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1766 = wave.index_expr <"3 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1767 = wave.assume %1766 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1768 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1767) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1769 = wave.index_expr <"4 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1770 = wave.assume %1769 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1771 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1770) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1772 = wave.index_expr <"5 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1773 = wave.assume %1772 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1774 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1773) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1775 = wave.index_expr <"6 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1776 = wave.assume %1775 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1777 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1776) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1778 = wave.index_expr <"7 + s1 + 16*s0*Mod(floor(1/256*wi), 2) + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1779 = wave.assume %1778 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1780 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1779) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1781 = wave.index_expr <"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1782 = wave.assume %1781 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1783 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1782) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1784 = wave.index_expr <"1 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1785 = wave.assume %1784 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1786 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1785) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1787 = wave.index_expr <"2 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1788 = wave.assume %1787 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1789 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1788) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1790 = wave.index_expr <"3 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1791 = wave.assume %1790 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1792 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1791) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1793 = wave.index_expr <"4 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1794 = wave.assume %1793 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1795 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1794) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1796 = wave.index_expr <"5 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1797 = wave.assume %1796 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1798 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1797) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1799 = wave.index_expr <"6 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1800 = wave.assume %1799 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1801 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1800) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1802 = wave.index_expr <"7 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1803 = wave.assume %1802 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1804 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1803) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1805 = wave.index_expr <"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1806 = wave.assume %1805 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1807 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1806) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1808 = wave.index_expr <"1 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1809 = wave.assume %1808 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1810 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1809) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1811 = wave.index_expr <"2 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1812 = wave.assume %1811 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1813 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1812) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1814 = wave.index_expr <"3 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1815 = wave.assume %1814 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1816 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1815) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1817 = wave.index_expr <"4 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1818 = wave.assume %1817 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1819 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1818) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1820 = wave.index_expr <"5 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1821 = wave.assume %1820 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1822 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1821) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1823 = wave.index_expr <"6 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1824 = wave.assume %1823 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1825 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1824) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1826 = wave.index_expr <"7 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1827 = wave.assume %1826 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1828 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1827) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1829 = wave.index_expr <"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1830 = wave.assume %1829 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1831 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1830) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1832 = wave.index_expr <"1 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1833 = wave.assume %1832 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1834 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1833) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1835 = wave.index_expr <"2 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1836 = wave.assume %1835 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1837 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1836) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1838 = wave.index_expr <"3 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1839 = wave.assume %1838 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1840 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1839) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1841 = wave.index_expr <"4 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1842 = wave.assume %1841 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1843 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1842) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1844 = wave.index_expr <"5 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1845 = wave.assume %1844 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1846 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1845) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1847 = wave.index_expr <"6 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1848 = wave.assume %1847 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1849 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1848) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1850 = wave.index_expr <"7 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(16*Mod(floor(1/256*wi), 2), xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%68, %1722, %1724) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %1851 = wave.assume %1850 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1852 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1851) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1853 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %1854 = wave.pack %1725, %1726, %1727, %1728, %1729, %1730, %1731, %1732, %1733, %1734, %1735, %1736, %1737, %1738, %1739, %1740, %1741, %1742, %1743, %1744, %1745, %1746, %1747, %1748, %1749, %1750, %1751, %1752, %1753, %1754, %1755, %1756 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<32xf16>, 64>
      wave.where %1690, %1691, %1692, %1693, %1694, %1695, %1696, %1697, %1698, %1699, %1700, %1701, %1702, %1703, %1704, %1705, %1706, %1707, %1708, %1709, %1710, %1711, %1712, %1713, %1714, %1715, %1716, %1717, %1718, %1719, %1720, %1721 {
        %1855 = wave.scatter %1854 to %1853 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%1759, %1762, %1765, %1768, %1771, %1774, %1777, %1780, %1783, %1786, %1789, %1792, %1795, %1798, %1801, %1804, %1807, %1810, %1813, %1816, %1819, %1822, %1825, %1828, %1831, %1834, %1837, %1840, %1843, %1846, %1849, %1852) {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<32xf16>, 64>, !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> !wave.mem.token
      } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
      return
    }
  }
}
