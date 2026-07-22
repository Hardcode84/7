module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_optimized(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 416 : index -> !wave.simd<index, 64>
      %2 = wave.constant 384 : index -> !wave.simd<index, 64>
      %3 = wave.constant 288 : index -> !wave.simd<index, 64>
      %4 = wave.constant 256 : index -> !wave.simd<index, 64>
      %5 = wave.constant 160 : index -> !wave.simd<index, 64>
      %6 = wave.constant 128 : index -> !wave.simd<index, 64>
      %7 = wave.constant 32 : index -> !wave.simd<index, 64>
      %8 = wave.constant 36 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %10 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 6 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 5 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 3 : i32 -> !wave.simd<i32, 64>
      %14 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %16 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %17 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %18 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %19 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %20 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %21 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %22 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %23 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %24 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %25 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %26 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %c16896_i32 = arith.constant 16896 : i32
      %c4224_i32 = arith.constant 4224 : i32
      %c8448_i32 = arith.constant 8448 : i32
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
      %27 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %c0_i32 = arith.constant 0 : i32
      %28 = wave.assume %arg5 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %29 = wave.assume %arg6 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %30 = wave.assume %arg7 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %31 = wave.pack %27, %27, %27, %27 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %32 = wave.assume %arg8 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %33 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %34 = wave.assume %arg10 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %35 = wave.assume %arg11 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %36 = wave.workgroup_id 0
      %37 = wave.binary addi %28, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %38 = wave.binary divsi %37, %c128_i32 : i32, i32 -> i32
      %39 = wave.binary addi %29, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %40 = wave.binary divsi %39, %c256_i32 : i32, i32 -> i32
      %41 = wave.binary muli %38, %40 : i32, i32 -> i32
      %42 = wave.binary divsi %41, %c32_i32 : i32, i32 -> i32
      %43 = wave.binary muli %42, %c32_i32 : i32, i32 -> i32
      %44 = arith.cmpi sge, %36, %43 : i32
      %45 = scf.if %44 -> (i32) {
        scf.yield %36 : i32
      } else {
        %1710 = wave.binary remui %36, %c8_i32 : i32, i32 -> i32
        %1711 = wave.binary divui %36, %c8_i32 : i32, i32 -> i32
        %1712 = wave.binary divui %1711, %c4_i32 : i32, i32 -> i32
        %1713 = wave.binary muli %1712, %c32_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1714 = wave.binary muli %1710, %c4_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1715 = wave.binary addi %1713, %1714 overflow<nsw, nuw> : i32, i32 -> i32
        %1716 = wave.binary remui %1711, %c4_i32 : i32, i32 -> i32
        %1717 = wave.binary addi %1715, %1716 overflow<nsw, nuw> : i32, i32 -> i32
        scf.yield %1717 : i32
      }
      %46 = wave.binary muli %40, %c8_i32 overflow<nsw> : i32, i32 -> i32
      %47 = wave.binary divsi %45, %46 : i32, i32 -> i32
      %48 = wave.binary muli %47, %c8_i32 overflow<nsw> : i32, i32 -> i32
      %49 = wave.binary subi %38, %48 overflow<nsw> : i32, i32 -> i32
      %50 = arith.cmpi slt, %49, %c8_i32 : i32
      %51 = wave.select %50, %49, %c8_i32 : i32
      %52 = wave.binary remsi %45, %46 : i32, i32 -> i32
      %53 = wave.binary remsi %52, %51 : i32, i32 -> i32
      %54 = wave.binary addi %48, %53 overflow<nsw> : i32, i32 -> i32
      %55 = wave.binary divsi %52, %51 : i32, i32 -> i32
      %56 = wave.binary muli %54, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %57 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %58 = wave.binary divui %57, %26 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary remui %58, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary muli %59, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary divui %57, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary remui %61, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary muli %62, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary addi %60, %63 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary divui %57, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary remui %65, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary muli %66, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary addi %64, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.binary divui %57, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.binary remui %69, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary addi %68, %70 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary divui %57, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary remui %72, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary muli %73, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.binary addi %71, %74 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %76 = wave.binary divui %57, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary remui %76, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary muli %77, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary addi %75, %78 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary addi %79, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary remui %65, %24 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary addi %81, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary addi %81, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.binary addi %81, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.binary addi %81, %22 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %86 = wave.binary addi %81, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %87 = wave.binary addi %81, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %88 = wave.binary addi %81, %15 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %89 = wave.splat %56 : i32 -> !wave.simd<i32, 64>
      %90 = wave.binary addi %89, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary addi %89, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %92 = wave.binary addi %89, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %93 = wave.binary addi %89, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %94 = wave.binary addi %89, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %95 = wave.binary addi %89, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %96 = wave.binary addi %89, %85 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %97 = wave.binary addi %89, %86 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %98 = wave.binary addi %89, %87 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %99 = wave.binary addi %89, %88 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %100 = wave.splat %28 : i32 -> !wave.simd<i32, 64>
      %101 = wave.binary remsi %90, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %102 = wave.binary remsi %91, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %103 = wave.binary remsi %92, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %104 = wave.binary remsi %93, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %105 = wave.binary remsi %94, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %106 = wave.binary remsi %95, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %107 = wave.binary remsi %96, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %108 = wave.binary remsi %97, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %109 = wave.binary remsi %98, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %110 = wave.binary remsi %99, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %111 = wave.binary muli %55, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %112 = wave.binary remui %57, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %113 = wave.binary muli %112, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %114 = wave.binary addi %113, %14 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %115 = wave.binary addi %113, %25 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %116 = wave.binary addi %113, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %117 = wave.binary addi %113, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %118 = wave.binary addi %113, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %119 = wave.binary addi %113, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %120 = wave.binary addi %113, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %121 = wave.splat %111 : i32 -> !wave.simd<i32, 64>
      %122 = wave.binary addi %121, %113 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %123 = wave.binary addi %121, %114 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %124 = wave.binary addi %121, %115 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %125 = wave.binary addi %121, %116 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %126 = wave.binary addi %121, %117 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %127 = wave.binary addi %121, %118 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %128 = wave.binary addi %121, %119 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %129 = wave.binary addi %121, %120 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %130 = wave.splat %29 : i32 -> !wave.simd<i32, 64>
      %131 = wave.binary remsi %122, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %132 = wave.binary remsi %123, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %133 = wave.binary remsi %124, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %134 = wave.binary remsi %125, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %135 = wave.binary remsi %126, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %136 = wave.binary remsi %127, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %137 = wave.binary remsi %128, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %138 = wave.binary remsi %129, %130 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %139 = wave.binary addi %30, %c63_i32 overflow<nsw> : i32, i32 -> i32
      %140 = wave.binary divsi %139, %c64_i32 : i32, i32 -> i32
      %141 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %142 = wave.alloc() {align = 16 : i64, bytesize = 101344 : i64} : !wave.ptr<#wave.shared, f16>
      %143 = wave.binary remui %57, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %144 = wave.binary muli %143, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %145 = wave.binary divui %57, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %146 = wave.binary remui %145, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %147 = wave.binary muli %146, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %148 = wave.binary xori %144, %147 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %149 = wave.binary divui %57, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %150 = wave.binary remui %149, %25 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %151 = wave.binary muli %150, %23 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %152 = wave.binary xori %148, %151 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %153 = wave.splat %30 : i32 -> !wave.simd<i32, 64>
      %154 = wave.cmpi slt %152, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %155 = wave.splat %32 : i32 -> !wave.simd<i32, 64>
      %156 = wave.binary muli %101, %155 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %157 = wave.binary muli %102, %155 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %158 = wave.ptr_cast %141 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %159 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%57, %156) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %160 = wave.assume %159 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %161 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%160) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %162 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%57, %157) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %163 = wave.assume %162 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %164 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%163) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %165 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %166 = wave.read_first %57 : !wave.simd<i32, 64> -> i32
      %167 = wave.assume %166 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
      %168 = wave.token : !wave.mem.token
      %169 = wave.ptr_add %165, %161 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %170 = wave.index_expr <"264*floor(1/64*wi_first)"> ["wi_first"](%167) : (i32) -> index
      %171 = wave.ptr_add %158, %170 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %172 = wave.ptr_add %165, %9 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %173 = wave.select %154, %169, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %174 = waveamd.dma_load_lds %173 -> %171 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %175 = wave.ptr_add %165, %164 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %176 = wave.index_expr <"2112 + 264*floor(1/64*wi_first)"> ["wi_first"](%167) : (i32) -> index
      %177 = wave.ptr_add %158, %176 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %178 = wave.select %154, %175, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %179 = waveamd.dma_load_lds %178 -> %177 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %180 = wave.join %174, %179 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %181 = wave.binary muli %66, %24 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %182 = wave.binary xori %181, %70 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %183 = wave.binary xori %182, %74 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %184 = wave.binary muli %77, %26 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %185 = wave.binary xori %183, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %186 = wave.binary xori %19, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %187 = wave.binary xori %186, %70 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %188 = wave.binary xori %187, %74 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %189 = wave.binary xori %188, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %190 = wave.binary xori %23, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %191 = wave.binary xori %190, %70 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %192 = wave.binary xori %191, %74 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %193 = wave.binary xori %192, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %194 = wave.binary xori %8, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %195 = wave.binary xori %194, %70 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %196 = wave.binary xori %195, %74 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %197 = wave.binary xori %196, %184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %198 = wave.cmpi slt %185, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %199 = wave.cmpi slt %189, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %200 = wave.cmpi slt %193, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %201 = wave.cmpi slt %197, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %202 = wave.ptr_cast %142 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %203 = wave.index_expr <"s1 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1"](%57, %33, %131) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %204 = wave.assume %203 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %205 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%204) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %206 = wave.index_expr <"s1 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1"](%57, %33, %131) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %207 = wave.assume %206 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %208 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%207) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %209 = wave.index_expr <"s1 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1"](%57, %33, %131) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %210 = wave.assume %209 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %211 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%210) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %212 = wave.index_expr <"s1 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1"](%57, %33, %131) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %213 = wave.assume %212 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %214 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%213) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %215 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %216 = wave.ptr_add %215, %205 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %217 = wave.ptr_add %202, %170 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %218 = wave.ptr_add %215, %9 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %219 = wave.select %198, %216, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %220 = waveamd.dma_load_lds %219 -> %217 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %221 = wave.ptr_add %215, %208 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %222 = wave.ptr_add %202, %176 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %223 = wave.select %199, %221, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %224 = waveamd.dma_load_lds %223 -> %222 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %225 = wave.ptr_add %215, %211 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %226 = wave.index_expr <"4224 + 264*floor(1/64*wi_first)"> ["wi_first"](%167) : (i32) -> index
      %227 = wave.ptr_add %202, %226 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %228 = wave.select %200, %225, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %229 = waveamd.dma_load_lds %228 -> %227 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %230 = wave.ptr_add %215, %214 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %231 = wave.index_expr <"6336 + 264*floor(1/64*wi_first)"> ["wi_first"](%167) : (i32) -> index
      %232 = wave.ptr_add %202, %231 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %233 = wave.select %201, %230, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %234 = waveamd.dma_load_lds %233 -> %232 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %235 = wave.join %220, %224, %229, %234 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %236 = wave.join %180, %235 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %237 = wave.binary subi %30, %c64_i32 : i32, i32 -> i32
      %238 = wave.splat %237 : i32 -> !wave.simd<i32, 64>
      %239 = wave.cmpi slt %152, %238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %240 = wave.ptr_add %158, %c4224_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %241 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741752 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%57, %156) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %242 = wave.assume %241 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %243 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%242) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %244 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741752 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%57, %157) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %245 = wave.assume %244 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %246 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%245) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %247 = wave.ptr_add %165, %243 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %248 = wave.ptr_add %240, %170 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %249 = wave.select %239, %247, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %250 = waveamd.dma_load_lds %249 -> %248 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %251 = wave.ptr_add %165, %246 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %252 = wave.ptr_add %240, %176 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %253 = wave.select %239, %251, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %254 = waveamd.dma_load_lds %253 -> %252 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %255 = wave.join %250, %254 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %256 = wave.cmpi slt %185, %238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %257 = wave.cmpi slt %189, %238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %258 = wave.cmpi slt %193, %238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %259 = wave.cmpi slt %197, %238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %260 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %261 = wave.binary muli %260, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %262 = wave.ptr_add %202, %c8448_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %263 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %260, %261, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %264 = wave.assume %263 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %265 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%264) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %266 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %260, %261, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %267 = wave.assume %266 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %268 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%267) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %269 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %260, %261, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %270 = wave.assume %269 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %271 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%270) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %272 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %260, %261, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %273 = wave.assume %272 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %274 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%273) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %275 = wave.ptr_add %215, %265 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %276 = wave.ptr_add %262, %170 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %277 = wave.select %256, %275, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %278 = waveamd.dma_load_lds %277 -> %276 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %279 = wave.ptr_add %215, %268 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %280 = wave.ptr_add %262, %176 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %281 = wave.select %257, %279, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %282 = waveamd.dma_load_lds %281 -> %280 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %283 = wave.ptr_add %215, %271 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %284 = wave.ptr_add %262, %226 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %285 = wave.select %258, %283, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %286 = waveamd.dma_load_lds %285 -> %284 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %287 = wave.ptr_add %215, %274 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %288 = wave.ptr_add %262, %231 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %289 = wave.select %259, %287, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %290 = waveamd.dma_load_lds %289 -> %288 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %291 = wave.join %278, %282, %286, %290 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %292 = wave.join %255, %291 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %293 = wave.binary subi %30, %c128_i32 : i32, i32 -> i32
      %294 = wave.splat %293 : i32 -> !wave.simd<i32, 64>
      %295 = wave.cmpi slt %152, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %296 = wave.ptr_add %158, %c8448_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %297 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741688 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%57, %156) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %298 = wave.assume %297 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %299 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%298) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %300 = wave.index_expr <"128 + s0 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"128 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741688 + s0 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0"](%57, %157) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %301 = wave.assume %300 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %302 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%301) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %303 = wave.ptr_add %165, %299 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %304 = wave.ptr_add %296, %170 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %305 = wave.select %295, %303, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %306 = waveamd.dma_load_lds %305 -> %304 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %307 = wave.ptr_add %165, %302 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %308 = wave.ptr_add %296, %176 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %309 = wave.select %295, %307, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %310 = waveamd.dma_load_lds %309 -> %308 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %311 = wave.join %306, %310 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %312 = wave.cmpi slt %185, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %313 = wave.cmpi slt %189, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %314 = wave.cmpi slt %193, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %315 = wave.cmpi slt %197, %294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %316 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %317 = wave.binary muli %316, %c128_i32 overflow<nsw> : i32, i32 -> i32
      %318 = wave.ptr_add %202, %c16896_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %319 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %316, %317, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %320 = wave.assume %319 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %321 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%320) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %322 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %316, %317, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %323 = wave.assume %322 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %324 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%323) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %325 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %316, %317, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %326 = wave.assume %325 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %327 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%326) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %328 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %316, %317, %131) : (!wave.simd<i32, 64>, i32, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %329 = wave.assume %328 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %330 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%329) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %331 = wave.ptr_add %215, %321 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %332 = wave.ptr_add %318, %170 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %333 = wave.select %312, %331, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %334 = waveamd.dma_load_lds %333 -> %332 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %335 = wave.ptr_add %215, %324 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %336 = wave.ptr_add %318, %176 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %337 = wave.select %313, %335, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %338 = waveamd.dma_load_lds %337 -> %336 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %339 = wave.ptr_add %215, %327 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %340 = wave.ptr_add %318, %226 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %341 = wave.select %314, %339, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %342 = waveamd.dma_load_lds %341 -> %340 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %343 = wave.ptr_add %215, %330 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %344 = wave.ptr_add %318, %231 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %345 = wave.select %315, %343, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
      %346 = waveamd.dma_load_lds %345 -> %344 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %347 = wave.join %334, %338, %342, %346 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %348 = wave.join %311, %347 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %349 = wave.issue_token %348 : !wave.mem.token -> !wave.mem.token
      %350 = wave.barrier %236, %292, %349 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %351 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 256*Mod(floor(1/1024*wi), 2) + 128*Mod(floor(1/512*wi), 2) + 64*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(wi, 64), 16)"> ["wi"](%57) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %352 = wave.ptr_add %141, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value, %token = wave.load %352 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %353 = wave.binary addi %351, %7 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %354 = wave.ptr_add %141, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_0, %token_1 = wave.load %354 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %355 = wave.binary addi %351, %6 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %356 = wave.ptr_add %141, %355 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_2, %token_3 = wave.load %356 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %357 = wave.binary addi %351, %5 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %358 = wave.ptr_add %141, %357 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_4, %token_5 = wave.load %358 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %359 = wave.binary addi %351, %4 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %360 = wave.ptr_add %141, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_6, %token_7 = wave.load %360 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %361 = wave.binary addi %351, %3 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %362 = wave.ptr_add %141, %361 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_8, %token_9 = wave.load %362 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %363 = wave.binary addi %351, %2 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %364 = wave.ptr_add %141, %363 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_10, %token_11 = wave.load %364 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %365 = wave.binary addi %351, %1 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %366 = wave.ptr_add %141, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_12, %token_13 = wave.load %366 after %350 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %367 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_14, %token_15 = wave.gather %142 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %368 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %369 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %370 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %371 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_16, %token_17 = wave.gather %142 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %372 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %373 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %374 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %375 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %376 = wave.pack %368, %369, %370, %371, %372, %373, %374, %375 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_18, %token_19 = wave.gather %142 mapping <bit_offset = <"16*(8448 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %377 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %378 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %379 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %380 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_20, %token_21 = wave.gather %142 mapping <bit_offset = <"16*(12672 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %381 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %382 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %383 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %384 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %385 = wave.pack %377, %378, %379, %380, %381, %382, %383, %384 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_22, %token_23 = wave.gather %142 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %386 = wave.extract %value_22[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %387 = wave.extract %value_22[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %388 = wave.extract %value_22[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %389 = wave.extract %value_22[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_24, %token_25 = wave.gather %142 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %390 = wave.extract %value_24[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %391 = wave.extract %value_24[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %392 = wave.extract %value_24[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %393 = wave.extract %value_24[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %394 = wave.pack %386, %387, %388, %389, %390, %391, %392, %393 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_26, %token_27 = wave.gather %142 mapping <bit_offset = <"16*(8512 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %395 = wave.extract %value_26[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %396 = wave.extract %value_26[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %397 = wave.extract %value_26[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %398 = wave.extract %value_26[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_28, %token_29 = wave.gather %142 mapping <bit_offset = <"16*(12736 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %399 = wave.extract %value_28[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %400 = wave.extract %value_28[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %401 = wave.extract %value_28[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %402 = wave.extract %value_28[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %403 = wave.pack %395, %396, %397, %398, %399, %400, %401, %402 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_30, %token_31 = wave.gather %142 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %404 = wave.extract %value_30[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %405 = wave.extract %value_30[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %406 = wave.extract %value_30[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %407 = wave.extract %value_30[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_32, %token_33 = wave.gather %142 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %408 = wave.extract %value_32[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %409 = wave.extract %value_32[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %410 = wave.extract %value_32[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %411 = wave.extract %value_32[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %412 = wave.pack %404, %405, %406, %407, %408, %409, %410, %411 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_34, %token_35 = wave.gather %142 mapping <bit_offset = <"16*(8576 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %413 = wave.extract %value_34[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %414 = wave.extract %value_34[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %415 = wave.extract %value_34[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %416 = wave.extract %value_34[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_36, %token_37 = wave.gather %142 mapping <bit_offset = <"16*(12800 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %417 = wave.extract %value_36[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %418 = wave.extract %value_36[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %419 = wave.extract %value_36[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %420 = wave.extract %value_36[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %421 = wave.pack %413, %414, %415, %416, %417, %418, %419, %420 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_38, %token_39 = wave.gather %142 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %422 = wave.extract %value_38[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %423 = wave.extract %value_38[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %424 = wave.extract %value_38[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %425 = wave.extract %value_38[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_40, %token_41 = wave.gather %142 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %426 = wave.extract %value_40[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %427 = wave.extract %value_40[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %428 = wave.extract %value_40[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %429 = wave.extract %value_40[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %430 = wave.pack %422, %423, %424, %425, %426, %427, %428, %429 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_42, %token_43 = wave.gather %142 mapping <bit_offset = <"16*(8640 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %431 = wave.extract %value_42[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %432 = wave.extract %value_42[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %433 = wave.extract %value_42[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %434 = wave.extract %value_42[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_44, %token_45 = wave.gather %142 mapping <bit_offset = <"16*(12864 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %350 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %435 = wave.extract %value_44[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %436 = wave.extract %value_44[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %437 = wave.extract %value_44[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %438 = wave.extract %value_44[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %439 = wave.pack %431, %432, %433, %434, %435, %436, %437, %438 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %440 = wave.join %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29, %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %441 = wave.binary subi %140, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %442 = wave.barrier %367, %440 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %443 = wave.binary divsi %57, %c256_i32 : !wave.simd<i32, 64>, i32 -> !wave.simd<i32, 64>
      %444 = wave.cmpi eq %443, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %445 = wave.cmpi ne %443, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      wave.where %445 {
        %1710 = wave.barrier : () -> !wave.mem.token
      } : !wave.mask<64>
      waveamd.set_priority 0
      %446 = wave.join %180, %255, %311, %367, %235, %291, %347, %440 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %447:36 = scf.for %arg12 = %c0_i32 to %441 step %c1_i32 iter_args(%arg13 = %value, %arg14 = %value_0, %arg15 = %value_2, %arg16 = %value_4, %arg17 = %value_6, %arg18 = %value_8, %arg19 = %value_10, %arg20 = %value_12, %arg21 = %376, %arg22 = %385, %arg23 = %394, %arg24 = %403, %arg25 = %412, %arg26 = %421, %arg27 = %430, %arg28 = %439, %arg29 = %31, %arg30 = %31, %arg31 = %31, %arg32 = %31, %arg33 = %31, %arg34 = %31, %arg35 = %31, %arg36 = %31, %arg37 = %31, %arg38 = %31, %arg39 = %31, %arg40 = %31, %arg41 = %31, %arg42 = %31, %arg43 = %31, %arg44 = %31, %arg45 = %348, %arg46 = %350, %arg47 = %442, %arg48 = %446) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %1710 = wave.binary remui %arg12, %c3_i32 : i32, i32 -> i32
        %1711 = wave.binary addi %arg12, %c1_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1712 = wave.binary remui %1711, %c3_i32 : i32, i32 -> i32
        %1713 = wave.binary addi %arg12, %c3_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %1714 = wave.binary muli %1713, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %1715 = waveamd.fragment_pack %arg13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1716 = waveamd.fragment_pack %arg14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1717 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1718 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1719 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1720 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1721 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1722 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %1723 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1724 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1725 = waveamd.fragment_pack %arg23 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1726 = waveamd.fragment_pack %arg24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1727 = waveamd.fragment_pack %arg25 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1728 = waveamd.fragment_pack %arg26 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1729 = waveamd.fragment_pack %arg27 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1730 = waveamd.fragment_pack %arg28 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %1731 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1732 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1733 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1734 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1735 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1736 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1737 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1738 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1739 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1740 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1741 = waveamd.fragment_pack %arg39 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1742 = waveamd.fragment_pack %arg40 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1743 = waveamd.fragment_pack %arg41 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1744 = waveamd.fragment_pack %arg42 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1745 = waveamd.fragment_pack %arg43 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1746 = waveamd.fragment_pack %arg44 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1747 = waveamd.mma "mfma.f32.16x16x32.f16" %1723, %1715, %1731 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1748 = waveamd.mma "mfma.f32.16x16x32.f16" %1724, %1716, %1747 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1749 = waveamd.fragment_unpack %1748 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1750 = waveamd.mma "mfma.f32.16x16x32.f16" %1725, %1715, %1732 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1751 = waveamd.mma "mfma.f32.16x16x32.f16" %1726, %1716, %1750 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1752 = waveamd.fragment_unpack %1751 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1753 = waveamd.mma "mfma.f32.16x16x32.f16" %1727, %1715, %1733 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1754 = waveamd.mma "mfma.f32.16x16x32.f16" %1728, %1716, %1753 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1755 = waveamd.fragment_unpack %1754 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1756 = waveamd.mma "mfma.f32.16x16x32.f16" %1729, %1715, %1734 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1757 = waveamd.mma "mfma.f32.16x16x32.f16" %1730, %1716, %1756 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1758 = waveamd.fragment_unpack %1757 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1759 = waveamd.mma "mfma.f32.16x16x32.f16" %1723, %1717, %1735 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1760 = waveamd.mma "mfma.f32.16x16x32.f16" %1724, %1718, %1759 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1761 = waveamd.fragment_unpack %1760 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1762 = waveamd.mma "mfma.f32.16x16x32.f16" %1725, %1717, %1736 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1763 = waveamd.mma "mfma.f32.16x16x32.f16" %1726, %1718, %1762 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1764 = waveamd.fragment_unpack %1763 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1765 = waveamd.mma "mfma.f32.16x16x32.f16" %1727, %1717, %1737 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1766 = waveamd.mma "mfma.f32.16x16x32.f16" %1728, %1718, %1765 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1767 = waveamd.fragment_unpack %1766 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1768 = waveamd.mma "mfma.f32.16x16x32.f16" %1729, %1717, %1738 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1769 = waveamd.mma "mfma.f32.16x16x32.f16" %1730, %1718, %1768 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1770 = waveamd.fragment_unpack %1769 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1771 = waveamd.mma "mfma.f32.16x16x32.f16" %1723, %1719, %1739 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1772 = waveamd.mma "mfma.f32.16x16x32.f16" %1724, %1720, %1771 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1773 = waveamd.fragment_unpack %1772 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1774 = waveamd.mma "mfma.f32.16x16x32.f16" %1725, %1719, %1740 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1775 = waveamd.mma "mfma.f32.16x16x32.f16" %1726, %1720, %1774 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1776 = waveamd.fragment_unpack %1775 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1777 = waveamd.mma "mfma.f32.16x16x32.f16" %1727, %1719, %1741 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1778 = waveamd.mma "mfma.f32.16x16x32.f16" %1728, %1720, %1777 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1779 = waveamd.fragment_unpack %1778 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1780 = waveamd.mma "mfma.f32.16x16x32.f16" %1729, %1719, %1742 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1781 = waveamd.mma "mfma.f32.16x16x32.f16" %1730, %1720, %1780 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1782 = waveamd.fragment_unpack %1781 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1783 = waveamd.mma "mfma.f32.16x16x32.f16" %1723, %1721, %1743 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1784 = waveamd.mma "mfma.f32.16x16x32.f16" %1724, %1722, %1783 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1785 = waveamd.fragment_unpack %1784 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1786 = waveamd.mma "mfma.f32.16x16x32.f16" %1725, %1721, %1744 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1787 = waveamd.mma "mfma.f32.16x16x32.f16" %1726, %1722, %1786 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1788 = waveamd.fragment_unpack %1787 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1789 = waveamd.mma "mfma.f32.16x16x32.f16" %1727, %1721, %1745 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1790 = waveamd.mma "mfma.f32.16x16x32.f16" %1728, %1722, %1789 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1791 = waveamd.fragment_unpack %1790 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %1792 = waveamd.mma "mfma.f32.16x16x32.f16" %1729, %1721, %1746 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1793 = waveamd.mma "mfma.f32.16x16x32.f16" %1730, %1722, %1792 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %1794 = waveamd.fragment_unpack %1793 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        waveamd.set_priority 1
        wave.sched_barrier
        %1795 = wave.barrier %arg47 : (!wave.mem.token) -> !wave.mem.token
        wave.sched_barrier
        %1796 = wave.binary subi %30, %1714 : i32, i32 -> i32
        %1797 = wave.splat %1796 : i32 -> !wave.simd<i32, 64>
        %1798 = wave.cmpi slt %152, %1797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1799 = wave.binary muli %1710, %c4224_i32 overflow<nsw> : i32, i32 -> i32
        %1800 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0", "s1"](%57, %1714, %156) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1801 = wave.assume %1800 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1802 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1801) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1803 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))) <= 0">] ["wi", "s0", "s1"](%57, %1714, %157) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %1804 = wave.assume %1803 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1805 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1804) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1806 = wave.ptr_add %165, %1802 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1807 = wave.ptr_add %171, %1799 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1808 = wave.select %1798, %1806, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1809 = waveamd.dma_load_lds %1808 -> %1807 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1810 = wave.ptr_add %165, %1805 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1811 = wave.ptr_add %177, %1799 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1812 = wave.select %1798, %1810, %172 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1813 = waveamd.dma_load_lds %1812 -> %1811 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1814 = wave.join %1809, %1813 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1815 = wave.cmpi slt %185, %1797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1816 = wave.cmpi slt %189, %1797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1817 = wave.cmpi slt %193, %1797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1818 = wave.cmpi slt %197, %1797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1819 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1820 = wave.binary muli %1714, %1819 overflow<nsw> : i32, i32 -> i32
        %1821 = wave.binary muli %1710, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1822 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %1819, %131, %1820) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %1823 = wave.assume %1822 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1824 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1823) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1825 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %1819, %131, %1820) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %1826 = wave.assume %1825 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1827 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1826) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1828 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(1 + floor(1/1024*wi), 2), xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %1819, %131, %1820) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %1829 = wave.assume %1828 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1830 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1829) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1831 = wave.index_expr <"s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2)))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(32*Mod(1 + floor(1/2 + 1/1024*wi), 2), xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2)))))) <= 0">] ["wi", "s0", "s1", "s2"](%57, %1819, %131, %1820) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %1832 = wave.assume %1831 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %1833 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1832) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1834 = wave.ptr_add %215, %1824 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1835 = wave.ptr_add %217, %1821 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1836 = wave.select %1815, %1834, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1837 = waveamd.dma_load_lds %1836 -> %1835 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1838 = wave.ptr_add %215, %1827 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1839 = wave.ptr_add %222, %1821 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1840 = wave.select %1816, %1838, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1841 = waveamd.dma_load_lds %1840 -> %1839 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1842 = wave.ptr_add %215, %1830 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1843 = wave.ptr_add %227, %1821 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1844 = wave.select %1817, %1842, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1845 = waveamd.dma_load_lds %1844 -> %1843 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1846 = wave.ptr_add %215, %1833 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1847 = wave.ptr_add %232, %1821 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %1848 = wave.select %1818, %1846, %218 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %1849 = waveamd.dma_load_lds %1848 -> %1847 after %168 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %1850 = wave.join %1837, %1841, %1845, %1849 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1851 = wave.join %1814, %1850 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1852 = wave.binary muli %1712, %c8448_i32 overflow<nsw> : i32, i32 -> i32
        %1853 = wave.ptr_add %141, %1852 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %1854 = wave.barrier %1795 : (!wave.mem.token) -> !wave.mem.token
        %1855 = wave.join %arg45, %arg46 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1856 = wave.ptr_add %1853, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_146, %token_147 = wave.load %1856 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1857 = wave.ptr_add %1853, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_148, %token_149 = wave.load %1857 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1858 = wave.ptr_add %1853, %355 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_150, %token_151 = wave.load %1858 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1859 = wave.ptr_add %1853, %357 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_152, %token_153 = wave.load %1859 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1860 = wave.ptr_add %1853, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_154, %token_155 = wave.load %1860 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1861 = wave.ptr_add %1853, %361 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_156, %token_157 = wave.load %1861 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1862 = wave.ptr_add %1853, %363 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_158, %token_159 = wave.load %1862 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1863 = wave.ptr_add %1853, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_160, %token_161 = wave.load %1863 after %1855 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %1864 = wave.join %token_147, %token_149, %token_151, %token_153, %token_155, %token_157, %token_159, %token_161 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %1865 = wave.binary muli %1712, %c16896_i32 overflow<nsw> : i32, i32 -> i32
        %1866 = wave.ptr_add %142, %1865 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
        %value_162, %token_163 = wave.gather %1866 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1867 = wave.extract %value_162[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1868 = wave.extract %value_162[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1869 = wave.extract %value_162[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1870 = wave.extract %value_162[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_164, %token_165 = wave.gather %1866 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1871 = wave.extract %value_164[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1872 = wave.extract %value_164[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1873 = wave.extract %value_164[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1874 = wave.extract %value_164[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1875 = wave.pack %1867, %1868, %1869, %1870, %1871, %1872, %1873, %1874 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_166, %token_167 = wave.gather %1866 mapping <bit_offset = <"16*(8448 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1876 = wave.extract %value_166[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1877 = wave.extract %value_166[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1878 = wave.extract %value_166[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1879 = wave.extract %value_166[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_168, %token_169 = wave.gather %1866 mapping <bit_offset = <"16*(12672 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1880 = wave.extract %value_168[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1881 = wave.extract %value_168[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1882 = wave.extract %value_168[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1883 = wave.extract %value_168[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1884 = wave.pack %1876, %1877, %1878, %1879, %1880, %1881, %1882, %1883 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_170, %token_171 = wave.gather %1866 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1885 = wave.extract %value_170[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1886 = wave.extract %value_170[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1887 = wave.extract %value_170[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1888 = wave.extract %value_170[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_172, %token_173 = wave.gather %1866 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1889 = wave.extract %value_172[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1890 = wave.extract %value_172[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1891 = wave.extract %value_172[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1892 = wave.extract %value_172[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1893 = wave.pack %1885, %1886, %1887, %1888, %1889, %1890, %1891, %1892 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_174, %token_175 = wave.gather %1866 mapping <bit_offset = <"16*(8512 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1894 = wave.extract %value_174[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1895 = wave.extract %value_174[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1896 = wave.extract %value_174[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1897 = wave.extract %value_174[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_176, %token_177 = wave.gather %1866 mapping <bit_offset = <"16*(12736 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1898 = wave.extract %value_176[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1899 = wave.extract %value_176[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1900 = wave.extract %value_176[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1901 = wave.extract %value_176[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1902 = wave.pack %1894, %1895, %1896, %1897, %1898, %1899, %1900, %1901 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_178, %token_179 = wave.gather %1866 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1903 = wave.extract %value_178[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1904 = wave.extract %value_178[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1905 = wave.extract %value_178[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1906 = wave.extract %value_178[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_180, %token_181 = wave.gather %1866 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1907 = wave.extract %value_180[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1908 = wave.extract %value_180[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1909 = wave.extract %value_180[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1910 = wave.extract %value_180[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1911 = wave.pack %1903, %1904, %1905, %1906, %1907, %1908, %1909, %1910 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_182, %token_183 = wave.gather %1866 mapping <bit_offset = <"16*(8576 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1912 = wave.extract %value_182[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1913 = wave.extract %value_182[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1914 = wave.extract %value_182[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1915 = wave.extract %value_182[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_184, %token_185 = wave.gather %1866 mapping <bit_offset = <"16*(12800 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1916 = wave.extract %value_184[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1917 = wave.extract %value_184[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1918 = wave.extract %value_184[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1919 = wave.extract %value_184[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1920 = wave.pack %1912, %1913, %1914, %1915, %1916, %1917, %1918, %1919 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_186, %token_187 = wave.gather %1866 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1921 = wave.extract %value_186[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1922 = wave.extract %value_186[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1923 = wave.extract %value_186[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1924 = wave.extract %value_186[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_188, %token_189 = wave.gather %1866 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1925 = wave.extract %value_188[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1926 = wave.extract %value_188[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1927 = wave.extract %value_188[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1928 = wave.extract %value_188[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1929 = wave.pack %1921, %1922, %1923, %1924, %1925, %1926, %1927, %1928 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_190, %token_191 = wave.gather %1866 mapping <bit_offset = <"16*(8640 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1930 = wave.extract %value_190[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1931 = wave.extract %value_190[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1932 = wave.extract %value_190[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1933 = wave.extract %value_190[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_192, %token_193 = wave.gather %1866 mapping <bit_offset = <"16*(12864 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1855 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %1934 = wave.extract %value_192[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1935 = wave.extract %value_192[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1936 = wave.extract %value_192[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1937 = wave.extract %value_192[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %1938 = wave.pack %1930, %1931, %1932, %1933, %1934, %1935, %1936, %1937 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %1939 = wave.join %token_163, %token_165, %token_167, %token_169, %token_171, %token_173, %token_175, %token_177, %token_179, %token_181, %token_183, %token_185, %token_187, %token_189, %token_191, %token_193 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        waveamd.set_priority 0
        wave.sched_barrier
        %1940 = wave.issue_token %1851 : !wave.mem.token -> !wave.mem.token
        %1941 = wave.barrier %arg45, %1940, %1854, %1864, %1939 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        wave.sched_barrier
        %1942 = wave.join %arg48, %1814, %1864, %1850, %1939 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        scf.yield %value_146, %value_148, %value_150, %value_152, %value_154, %value_156, %value_158, %value_160, %1875, %1884, %1893, %1902, %1911, %1920, %1929, %1938, %1749, %1752, %1755, %1758, %1761, %1764, %1767, %1770, %1773, %1776, %1779, %1782, %1785, %1788, %1791, %1794, %1851, %1941, %168, %1942 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      waveamd.set_priority 0
      wave.where %444 {
        %1710 = wave.barrier : () -> !wave.mem.token
      } : !wave.mask<64>
      %448 = waveamd.fragment_pack %447#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %449 = waveamd.fragment_pack %447#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %450 = waveamd.fragment_pack %447#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %451 = waveamd.fragment_pack %447#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %452 = waveamd.fragment_pack %447#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %453 = waveamd.fragment_pack %447#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %454 = waveamd.fragment_pack %447#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %455 = waveamd.fragment_pack %447#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %456 = waveamd.fragment_pack %447#8 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %457 = waveamd.fragment_pack %447#9 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %458 = waveamd.fragment_pack %447#10 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %459 = waveamd.fragment_pack %447#11 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %460 = waveamd.fragment_pack %447#12 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %461 = waveamd.fragment_pack %447#13 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %462 = waveamd.fragment_pack %447#14 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %463 = waveamd.fragment_pack %447#15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %464 = waveamd.fragment_pack %447#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %465 = waveamd.fragment_pack %447#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %466 = waveamd.fragment_pack %447#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %467 = waveamd.fragment_pack %447#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %468 = waveamd.fragment_pack %447#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %469 = waveamd.fragment_pack %447#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %470 = waveamd.fragment_pack %447#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %471 = waveamd.fragment_pack %447#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %472 = waveamd.fragment_pack %447#24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %473 = waveamd.fragment_pack %447#25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %474 = waveamd.fragment_pack %447#26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %475 = waveamd.fragment_pack %447#27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %476 = waveamd.fragment_pack %447#28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %477 = waveamd.fragment_pack %447#29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %478 = waveamd.fragment_pack %447#30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %479 = waveamd.fragment_pack %447#31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %480 = waveamd.mma "mfma.f32.16x16x32.f16" %456, %448, %464 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %481 = waveamd.mma "mfma.f32.16x16x32.f16" %457, %449, %480 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %482 = waveamd.fragment_unpack %481 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %483 = waveamd.mma "mfma.f32.16x16x32.f16" %458, %448, %465 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %484 = waveamd.mma "mfma.f32.16x16x32.f16" %459, %449, %483 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %485 = waveamd.fragment_unpack %484 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %486 = waveamd.mma "mfma.f32.16x16x32.f16" %460, %448, %466 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %487 = waveamd.mma "mfma.f32.16x16x32.f16" %461, %449, %486 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %488 = waveamd.fragment_unpack %487 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %489 = waveamd.mma "mfma.f32.16x16x32.f16" %462, %448, %467 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %490 = waveamd.mma "mfma.f32.16x16x32.f16" %463, %449, %489 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %491 = waveamd.fragment_unpack %490 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %492 = waveamd.mma "mfma.f32.16x16x32.f16" %456, %450, %468 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %493 = waveamd.mma "mfma.f32.16x16x32.f16" %457, %451, %492 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %494 = waveamd.fragment_unpack %493 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %495 = waveamd.mma "mfma.f32.16x16x32.f16" %458, %450, %469 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %496 = waveamd.mma "mfma.f32.16x16x32.f16" %459, %451, %495 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %497 = waveamd.fragment_unpack %496 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %498 = waveamd.mma "mfma.f32.16x16x32.f16" %460, %450, %470 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %499 = waveamd.mma "mfma.f32.16x16x32.f16" %461, %451, %498 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %500 = waveamd.fragment_unpack %499 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %501 = waveamd.mma "mfma.f32.16x16x32.f16" %462, %450, %471 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %502 = waveamd.mma "mfma.f32.16x16x32.f16" %463, %451, %501 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %503 = waveamd.fragment_unpack %502 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %504 = waveamd.mma "mfma.f32.16x16x32.f16" %456, %452, %472 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %505 = waveamd.mma "mfma.f32.16x16x32.f16" %457, %453, %504 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %506 = waveamd.fragment_unpack %505 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %507 = waveamd.mma "mfma.f32.16x16x32.f16" %458, %452, %473 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %508 = waveamd.mma "mfma.f32.16x16x32.f16" %459, %453, %507 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %509 = waveamd.fragment_unpack %508 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %510 = waveamd.mma "mfma.f32.16x16x32.f16" %460, %452, %474 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %511 = waveamd.mma "mfma.f32.16x16x32.f16" %461, %453, %510 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %512 = waveamd.fragment_unpack %511 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %513 = waveamd.mma "mfma.f32.16x16x32.f16" %462, %452, %475 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %514 = waveamd.mma "mfma.f32.16x16x32.f16" %463, %453, %513 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %515 = waveamd.fragment_unpack %514 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %516 = waveamd.mma "mfma.f32.16x16x32.f16" %456, %454, %476 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %517 = waveamd.mma "mfma.f32.16x16x32.f16" %457, %455, %516 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %518 = waveamd.fragment_unpack %517 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %519 = waveamd.mma "mfma.f32.16x16x32.f16" %458, %454, %477 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %520 = waveamd.mma "mfma.f32.16x16x32.f16" %459, %455, %519 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %521 = waveamd.fragment_unpack %520 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %522 = waveamd.mma "mfma.f32.16x16x32.f16" %460, %454, %478 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %523 = waveamd.mma "mfma.f32.16x16x32.f16" %461, %455, %522 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %524 = waveamd.fragment_unpack %523 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %525 = waveamd.mma "mfma.f32.16x16x32.f16" %462, %454, %479 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %526 = waveamd.mma "mfma.f32.16x16x32.f16" %463, %455, %525 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %527 = waveamd.fragment_unpack %526 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %528 = wave.barrier %447#32, %447#34 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %529 = wave.binary subi %140, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %530 = wave.binary remsi %529, %c3_i32 : i32, i32 -> i32
      %531 = wave.binary muli %530, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %532 = wave.ptr_add %141, %531 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %533 = wave.barrier %348, %292, %236 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %534 = wave.join %447#33, %447#32, %533, %528 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %535 = wave.ptr_add %532, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_46, %token_47 = wave.load %535 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %536 = wave.ptr_add %532, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_48, %token_49 = wave.load %536 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %537 = wave.ptr_add %532, %355 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_50, %token_51 = wave.load %537 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %538 = wave.ptr_add %532, %357 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_52, %token_53 = wave.load %538 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %539 = wave.ptr_add %532, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_54, %token_55 = wave.load %539 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %540 = wave.ptr_add %532, %361 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_56, %token_57 = wave.load %540 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %541 = wave.ptr_add %532, %363 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_58, %token_59 = wave.load %541 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %542 = wave.ptr_add %532, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_60, %token_61 = wave.load %542 after %534 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %543 = wave.join %token_47, %token_49, %token_51, %token_53, %token_55, %token_57, %token_59, %token_61 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %544 = wave.binary muli %530, %c16896_i32 overflow<nsw> : i32, i32 -> i32
      %545 = wave.ptr_add %142, %544 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %546 = wave.barrier %348, %292, %236 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %547 = wave.join %447#33, %447#32, %546, %528 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_62, %token_63 = wave.gather %545 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %548 = wave.extract %value_62[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %549 = wave.extract %value_62[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %550 = wave.extract %value_62[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %551 = wave.extract %value_62[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_64, %token_65 = wave.gather %545 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %552 = wave.extract %value_64[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %553 = wave.extract %value_64[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %554 = wave.extract %value_64[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %555 = wave.extract %value_64[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %556 = wave.pack %548, %549, %550, %551, %552, %553, %554, %555 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_66, %token_67 = wave.gather %545 mapping <bit_offset = <"16*(8448 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %557 = wave.extract %value_66[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %558 = wave.extract %value_66[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %559 = wave.extract %value_66[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %560 = wave.extract %value_66[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_68, %token_69 = wave.gather %545 mapping <bit_offset = <"16*(12672 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %561 = wave.extract %value_68[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %562 = wave.extract %value_68[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %563 = wave.extract %value_68[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %564 = wave.extract %value_68[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %565 = wave.pack %557, %558, %559, %560, %561, %562, %563, %564 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_70, %token_71 = wave.gather %545 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %566 = wave.extract %value_70[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %567 = wave.extract %value_70[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %568 = wave.extract %value_70[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %569 = wave.extract %value_70[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_72, %token_73 = wave.gather %545 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %570 = wave.extract %value_72[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %571 = wave.extract %value_72[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %572 = wave.extract %value_72[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %573 = wave.extract %value_72[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %574 = wave.pack %566, %567, %568, %569, %570, %571, %572, %573 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_74, %token_75 = wave.gather %545 mapping <bit_offset = <"16*(8512 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %575 = wave.extract %value_74[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %576 = wave.extract %value_74[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %577 = wave.extract %value_74[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %578 = wave.extract %value_74[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_76, %token_77 = wave.gather %545 mapping <bit_offset = <"16*(12736 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %579 = wave.extract %value_76[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %580 = wave.extract %value_76[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %581 = wave.extract %value_76[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %582 = wave.extract %value_76[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %583 = wave.pack %575, %576, %577, %578, %579, %580, %581, %582 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_78, %token_79 = wave.gather %545 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %584 = wave.extract %value_78[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %585 = wave.extract %value_78[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %586 = wave.extract %value_78[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %587 = wave.extract %value_78[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_80, %token_81 = wave.gather %545 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %588 = wave.extract %value_80[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %589 = wave.extract %value_80[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %590 = wave.extract %value_80[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %591 = wave.extract %value_80[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %592 = wave.pack %584, %585, %586, %587, %588, %589, %590, %591 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_82, %token_83 = wave.gather %545 mapping <bit_offset = <"16*(8576 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %593 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %594 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %595 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %596 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_84, %token_85 = wave.gather %545 mapping <bit_offset = <"16*(12800 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %597 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %598 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %599 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %600 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %601 = wave.pack %593, %594, %595, %596, %597, %598, %599, %600 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_86, %token_87 = wave.gather %545 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %602 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %603 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %604 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %605 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_88, %token_89 = wave.gather %545 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %606 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %607 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %608 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %609 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %610 = wave.pack %602, %603, %604, %605, %606, %607, %608, %609 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_90, %token_91 = wave.gather %545 mapping <bit_offset = <"16*(8640 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %611 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %612 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %613 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %614 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_92, %token_93 = wave.gather %545 mapping <bit_offset = <"16*(12864 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %547 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %615 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %616 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %617 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %618 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %619 = wave.pack %611, %612, %613, %614, %615, %616, %617, %618 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %620 = wave.join %token_63, %token_65, %token_67, %token_69, %token_71, %token_73, %token_75, %token_77, %token_79, %token_81, %token_83, %token_85, %token_87, %token_89, %token_91, %token_93 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %621 = waveamd.fragment_pack %value_46 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %622 = waveamd.fragment_pack %value_48 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %623 = waveamd.fragment_pack %value_50 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %624 = waveamd.fragment_pack %value_52 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %625 = waveamd.fragment_pack %value_54 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %626 = waveamd.fragment_pack %value_56 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %627 = waveamd.fragment_pack %value_58 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %628 = waveamd.fragment_pack %value_60 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %629 = waveamd.fragment_pack %556 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %630 = waveamd.fragment_pack %565 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %631 = waveamd.fragment_pack %574 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %632 = waveamd.fragment_pack %583 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %633 = waveamd.fragment_pack %592 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %634 = waveamd.fragment_pack %601 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %635 = waveamd.fragment_pack %610 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %636 = waveamd.fragment_pack %619 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %637 = waveamd.fragment_pack %482 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %638 = waveamd.fragment_pack %485 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %639 = waveamd.fragment_pack %488 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %640 = waveamd.fragment_pack %491 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %641 = waveamd.fragment_pack %494 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %642 = waveamd.fragment_pack %497 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %643 = waveamd.fragment_pack %500 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %644 = waveamd.fragment_pack %503 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %645 = waveamd.fragment_pack %506 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %646 = waveamd.fragment_pack %509 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %647 = waveamd.fragment_pack %512 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %648 = waveamd.fragment_pack %515 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %649 = waveamd.fragment_pack %518 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %650 = waveamd.fragment_pack %521 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %651 = waveamd.fragment_pack %524 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %652 = waveamd.fragment_pack %527 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %653 = waveamd.mma "mfma.f32.16x16x32.f16" %629, %621, %637 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %654 = waveamd.mma "mfma.f32.16x16x32.f16" %630, %622, %653 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %655 = waveamd.fragment_unpack %654 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %656 = waveamd.mma "mfma.f32.16x16x32.f16" %631, %621, %638 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %657 = waveamd.mma "mfma.f32.16x16x32.f16" %632, %622, %656 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %658 = waveamd.fragment_unpack %657 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %659 = waveamd.mma "mfma.f32.16x16x32.f16" %633, %621, %639 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %660 = waveamd.mma "mfma.f32.16x16x32.f16" %634, %622, %659 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %661 = waveamd.fragment_unpack %660 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %662 = waveamd.mma "mfma.f32.16x16x32.f16" %635, %621, %640 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %663 = waveamd.mma "mfma.f32.16x16x32.f16" %636, %622, %662 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %664 = waveamd.fragment_unpack %663 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %665 = waveamd.mma "mfma.f32.16x16x32.f16" %629, %623, %641 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %666 = waveamd.mma "mfma.f32.16x16x32.f16" %630, %624, %665 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %667 = waveamd.fragment_unpack %666 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %668 = waveamd.mma "mfma.f32.16x16x32.f16" %631, %623, %642 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %669 = waveamd.mma "mfma.f32.16x16x32.f16" %632, %624, %668 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %670 = waveamd.fragment_unpack %669 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %671 = waveamd.mma "mfma.f32.16x16x32.f16" %633, %623, %643 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %672 = waveamd.mma "mfma.f32.16x16x32.f16" %634, %624, %671 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %673 = waveamd.fragment_unpack %672 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %674 = waveamd.mma "mfma.f32.16x16x32.f16" %635, %623, %644 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %675 = waveamd.mma "mfma.f32.16x16x32.f16" %636, %624, %674 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %676 = waveamd.fragment_unpack %675 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %677 = waveamd.mma "mfma.f32.16x16x32.f16" %629, %625, %645 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %678 = waveamd.mma "mfma.f32.16x16x32.f16" %630, %626, %677 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %679 = waveamd.fragment_unpack %678 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %680 = waveamd.mma "mfma.f32.16x16x32.f16" %631, %625, %646 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %681 = waveamd.mma "mfma.f32.16x16x32.f16" %632, %626, %680 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %682 = waveamd.fragment_unpack %681 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %683 = waveamd.mma "mfma.f32.16x16x32.f16" %633, %625, %647 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %684 = waveamd.mma "mfma.f32.16x16x32.f16" %634, %626, %683 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %685 = waveamd.fragment_unpack %684 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %686 = waveamd.mma "mfma.f32.16x16x32.f16" %635, %625, %648 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %687 = waveamd.mma "mfma.f32.16x16x32.f16" %636, %626, %686 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %688 = waveamd.fragment_unpack %687 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %689 = waveamd.mma "mfma.f32.16x16x32.f16" %629, %627, %649 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %690 = waveamd.mma "mfma.f32.16x16x32.f16" %630, %628, %689 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %691 = waveamd.fragment_unpack %690 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %692 = waveamd.mma "mfma.f32.16x16x32.f16" %631, %627, %650 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %693 = waveamd.mma "mfma.f32.16x16x32.f16" %632, %628, %692 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %694 = waveamd.fragment_unpack %693 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %695 = waveamd.mma "mfma.f32.16x16x32.f16" %633, %627, %651 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %696 = waveamd.mma "mfma.f32.16x16x32.f16" %634, %628, %695 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %697 = waveamd.fragment_unpack %696 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %698 = waveamd.mma "mfma.f32.16x16x32.f16" %635, %627, %652 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %699 = waveamd.mma "mfma.f32.16x16x32.f16" %636, %628, %698 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %700 = waveamd.fragment_unpack %699 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %701 = wave.binary addi %140, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %702 = wave.binary remsi %701, %c3_i32 : i32, i32 -> i32
      %703 = wave.binary muli %702, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %704 = wave.ptr_add %141, %703 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %705 = wave.join %447#33, %447#32, %533, %543, %528 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %706 = wave.ptr_add %704, %351 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_94, %token_95 = wave.load %706 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %707 = wave.ptr_add %704, %353 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_96, %token_97 = wave.load %707 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %708 = wave.ptr_add %704, %355 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_98, %token_99 = wave.load %708 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %709 = wave.ptr_add %704, %357 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_100, %token_101 = wave.load %709 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %710 = wave.ptr_add %704, %359 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_102, %token_103 = wave.load %710 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %711 = wave.ptr_add %704, %361 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_104, %token_105 = wave.load %711 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %712 = wave.ptr_add %704, %363 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_106, %token_107 = wave.load %712 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %713 = wave.ptr_add %704, %365 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
      %value_108, %token_109 = wave.load %713 after %705 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %714 = wave.join %token_95, %token_97, %token_99, %token_101, %token_103, %token_105, %token_107, %token_109 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %715 = wave.binary muli %702, %c16896_i32 overflow<nsw> : i32, i32 -> i32
      %716 = wave.ptr_add %142, %715 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %717 = wave.join %447#33, %447#32, %546, %620, %528 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_110, %token_111 = wave.gather %716 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %718 = wave.extract %value_110[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %719 = wave.extract %value_110[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %720 = wave.extract %value_110[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %721 = wave.extract %value_110[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_112, %token_113 = wave.gather %716 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %722 = wave.extract %value_112[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %723 = wave.extract %value_112[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %724 = wave.extract %value_112[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %725 = wave.extract %value_112[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %726 = wave.pack %718, %719, %720, %721, %722, %723, %724, %725 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_114, %token_115 = wave.gather %716 mapping <bit_offset = <"16*(8448 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %727 = wave.extract %value_114[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %728 = wave.extract %value_114[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %729 = wave.extract %value_114[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %730 = wave.extract %value_114[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_116, %token_117 = wave.gather %716 mapping <bit_offset = <"16*(12672 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %731 = wave.extract %value_116[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %732 = wave.extract %value_116[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %733 = wave.extract %value_116[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %734 = wave.extract %value_116[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %735 = wave.pack %727, %728, %729, %730, %731, %732, %733, %734 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_118, %token_119 = wave.gather %716 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %736 = wave.extract %value_118[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %737 = wave.extract %value_118[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %738 = wave.extract %value_118[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %739 = wave.extract %value_118[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_120, %token_121 = wave.gather %716 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %740 = wave.extract %value_120[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %741 = wave.extract %value_120[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %742 = wave.extract %value_120[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %743 = wave.extract %value_120[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %744 = wave.pack %736, %737, %738, %739, %740, %741, %742, %743 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_122, %token_123 = wave.gather %716 mapping <bit_offset = <"16*(8512 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %745 = wave.extract %value_122[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %746 = wave.extract %value_122[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %747 = wave.extract %value_122[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %748 = wave.extract %value_122[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_124, %token_125 = wave.gather %716 mapping <bit_offset = <"16*(12736 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %749 = wave.extract %value_124[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %750 = wave.extract %value_124[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %751 = wave.extract %value_124[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %752 = wave.extract %value_124[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %753 = wave.pack %745, %746, %747, %748, %749, %750, %751, %752 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_126, %token_127 = wave.gather %716 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %754 = wave.extract %value_126[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %755 = wave.extract %value_126[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %756 = wave.extract %value_126[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %757 = wave.extract %value_126[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_128, %token_129 = wave.gather %716 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %758 = wave.extract %value_128[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %759 = wave.extract %value_128[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %760 = wave.extract %value_128[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %761 = wave.extract %value_128[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %762 = wave.pack %754, %755, %756, %757, %758, %759, %760, %761 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_130, %token_131 = wave.gather %716 mapping <bit_offset = <"16*(8576 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %763 = wave.extract %value_130[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %764 = wave.extract %value_130[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %765 = wave.extract %value_130[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %766 = wave.extract %value_130[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_132, %token_133 = wave.gather %716 mapping <bit_offset = <"16*(12800 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %767 = wave.extract %value_132[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %768 = wave.extract %value_132[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %769 = wave.extract %value_132[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %770 = wave.extract %value_132[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %771 = wave.pack %763, %764, %765, %766, %767, %768, %769, %770 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_134, %token_135 = wave.gather %716 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %772 = wave.extract %value_134[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %773 = wave.extract %value_134[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %774 = wave.extract %value_134[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %775 = wave.extract %value_134[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_136, %token_137 = wave.gather %716 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %776 = wave.extract %value_136[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %777 = wave.extract %value_136[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %778 = wave.extract %value_136[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %779 = wave.extract %value_136[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %780 = wave.pack %772, %773, %774, %775, %776, %777, %778, %779 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %value_138, %token_139 = wave.gather %716 mapping <bit_offset = <"16*(8640 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %781 = wave.extract %value_138[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %782 = wave.extract %value_138[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %783 = wave.extract %value_138[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %784 = wave.extract %value_138[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %value_140, %token_141 = wave.gather %716 mapping <bit_offset = <"16*(12864 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %717 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
      %785 = wave.extract %value_140[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %786 = wave.extract %value_140[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %787 = wave.extract %value_140[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %788 = wave.extract %value_140[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
      %789 = wave.pack %781, %782, %783, %784, %785, %786, %787, %788 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
      %790 = wave.join %token_111, %token_113, %token_115, %token_117, %token_119, %token_121, %token_123, %token_125, %token_127, %token_129, %token_131, %token_133, %token_135, %token_137, %token_139, %token_141 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %791 = waveamd.fragment_pack %value_94 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %792 = waveamd.fragment_pack %value_96 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %793 = waveamd.fragment_pack %value_98 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %794 = waveamd.fragment_pack %value_100 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %795 = waveamd.fragment_pack %value_102 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %796 = waveamd.fragment_pack %value_104 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %797 = waveamd.fragment_pack %value_106 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %798 = waveamd.fragment_pack %value_108 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
      %799 = waveamd.fragment_pack %726 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %800 = waveamd.fragment_pack %735 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %801 = waveamd.fragment_pack %744 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %802 = waveamd.fragment_pack %753 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %803 = waveamd.fragment_pack %762 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %804 = waveamd.fragment_pack %771 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %805 = waveamd.fragment_pack %780 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %806 = waveamd.fragment_pack %789 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
      %807 = waveamd.fragment_pack %655 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %808 = waveamd.fragment_pack %658 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %809 = waveamd.fragment_pack %661 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %810 = waveamd.fragment_pack %664 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %811 = waveamd.fragment_pack %667 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %812 = waveamd.fragment_pack %670 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %813 = waveamd.fragment_pack %673 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %814 = waveamd.fragment_pack %676 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %815 = waveamd.fragment_pack %679 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %816 = waveamd.fragment_pack %682 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %817 = waveamd.fragment_pack %685 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %818 = waveamd.fragment_pack %688 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %819 = waveamd.fragment_pack %691 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %820 = waveamd.fragment_pack %694 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %821 = waveamd.fragment_pack %697 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %822 = waveamd.fragment_pack %700 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %823 = waveamd.mma "mfma.f32.16x16x32.f16" %799, %791, %807 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %824 = waveamd.mma "mfma.f32.16x16x32.f16" %800, %792, %823 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %825 = waveamd.fragment_unpack %824 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %826 = waveamd.mma "mfma.f32.16x16x32.f16" %801, %791, %808 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %827 = waveamd.mma "mfma.f32.16x16x32.f16" %802, %792, %826 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %828 = waveamd.fragment_unpack %827 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %829 = waveamd.mma "mfma.f32.16x16x32.f16" %803, %791, %809 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %830 = waveamd.mma "mfma.f32.16x16x32.f16" %804, %792, %829 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %831 = waveamd.fragment_unpack %830 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %832 = waveamd.mma "mfma.f32.16x16x32.f16" %805, %791, %810 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %833 = waveamd.mma "mfma.f32.16x16x32.f16" %806, %792, %832 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %834 = waveamd.fragment_unpack %833 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %835 = waveamd.mma "mfma.f32.16x16x32.f16" %799, %793, %811 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %836 = waveamd.mma "mfma.f32.16x16x32.f16" %800, %794, %835 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %837 = waveamd.fragment_unpack %836 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %838 = waveamd.mma "mfma.f32.16x16x32.f16" %801, %793, %812 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %839 = waveamd.mma "mfma.f32.16x16x32.f16" %802, %794, %838 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %840 = waveamd.fragment_unpack %839 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %841 = waveamd.mma "mfma.f32.16x16x32.f16" %803, %793, %813 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %842 = waveamd.mma "mfma.f32.16x16x32.f16" %804, %794, %841 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %843 = waveamd.fragment_unpack %842 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %844 = waveamd.mma "mfma.f32.16x16x32.f16" %805, %793, %814 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %845 = waveamd.mma "mfma.f32.16x16x32.f16" %806, %794, %844 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %846 = waveamd.fragment_unpack %845 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %847 = waveamd.mma "mfma.f32.16x16x32.f16" %799, %795, %815 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %848 = waveamd.mma "mfma.f32.16x16x32.f16" %800, %796, %847 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %849 = waveamd.fragment_unpack %848 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %850 = waveamd.mma "mfma.f32.16x16x32.f16" %801, %795, %816 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %851 = waveamd.mma "mfma.f32.16x16x32.f16" %802, %796, %850 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %852 = waveamd.fragment_unpack %851 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %853 = waveamd.mma "mfma.f32.16x16x32.f16" %803, %795, %817 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %854 = waveamd.mma "mfma.f32.16x16x32.f16" %804, %796, %853 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %855 = waveamd.fragment_unpack %854 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %856 = waveamd.mma "mfma.f32.16x16x32.f16" %805, %795, %818 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %857 = waveamd.mma "mfma.f32.16x16x32.f16" %806, %796, %856 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %858 = waveamd.fragment_unpack %857 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %859 = waveamd.mma "mfma.f32.16x16x32.f16" %799, %797, %819 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %860 = waveamd.mma "mfma.f32.16x16x32.f16" %800, %798, %859 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %861 = waveamd.fragment_unpack %860 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %862 = waveamd.mma "mfma.f32.16x16x32.f16" %801, %797, %820 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %863 = waveamd.mma "mfma.f32.16x16x32.f16" %802, %798, %862 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %864 = waveamd.fragment_unpack %863 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %865 = waveamd.mma "mfma.f32.16x16x32.f16" %803, %797, %821 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %866 = waveamd.mma "mfma.f32.16x16x32.f16" %804, %798, %865 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %867 = waveamd.fragment_unpack %866 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %868 = waveamd.mma "mfma.f32.16x16x32.f16" %805, %797, %822 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %869 = waveamd.mma "mfma.f32.16x16x32.f16" %806, %798, %868 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %870 = waveamd.fragment_unpack %869 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %871 = wave.barrier %543, %620, %714, %790 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %872 = wave.join %447#35, %543, %714, %447#33, %447#32, %533, %871 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %873 = wave.alloc_release %141 after %872 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> !wave.mem.token
      %874 = wave.join %447#35, %620, %790, %447#33, %447#32, %546, %871 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %875 = wave.alloc_release %142 after %874 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> !wave.mem.token
      %876 = wave.barrier %873, %875 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %877 = wave.pack %825, %828, %831, %834, %837, %840, %843, %846, %849, %852, %855, %858, %861, %864, %867, %870 : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<64xf32>, 64>
      %878 = wave.redistribute %877, <blocks = 1, items = 512, source_block = "0", source_item = "64*xor(2*Mod(floor(1/4*Mod(item, 64)), 2), xor(4*Mod(floor(1/8*slot), 2), Mod(floor(1/2*Mod(item, 64)), 2))) + xor(8*Mod(floor(1/256*item), 2), xor(4*Mod(floor(1/128*item), 2), xor(2*Mod(floor(1/64*item), 2), xor(Mod(floor(1/32*Mod(item, 64)), 2), xor(16*Mod(floor(1/4*slot), 2), 32*Mod(Mod(item, 64), 2))))))", source_slot = "xor(8*Mod(floor(1/16*Mod(item, 64)), 2), xor(4*Mod(floor(1/8*Mod(item, 64)), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2))))))"> : !wave.simd<vector<64xf32>, 64> -> !wave.simd<vector<64xf32>, 64>
      %879 = wave.extract %878[0] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %880 = wave.extract %878[1] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %881 = wave.extract %878[2] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %882 = wave.extract %878[3] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %883 = wave.extract %878[4] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %884 = wave.extract %878[5] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %885 = wave.extract %878[6] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %886 = wave.extract %878[7] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %887 = wave.extract %878[8] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %888 = wave.extract %878[9] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %889 = wave.extract %878[10] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %890 = wave.extract %878[11] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %891 = wave.extract %878[12] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %892 = wave.extract %878[13] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %893 = wave.extract %878[14] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %894 = wave.extract %878[15] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %895 = wave.extract %878[16] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %896 = wave.extract %878[17] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %897 = wave.extract %878[18] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %898 = wave.extract %878[19] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %899 = wave.extract %878[20] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %900 = wave.extract %878[21] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %901 = wave.extract %878[22] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %902 = wave.extract %878[23] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %903 = wave.extract %878[24] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %904 = wave.extract %878[25] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %905 = wave.extract %878[26] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %906 = wave.extract %878[27] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %907 = wave.extract %878[28] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %908 = wave.extract %878[29] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %909 = wave.extract %878[30] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %910 = wave.extract %878[31] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %911 = wave.extract %878[32] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %912 = wave.extract %878[33] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %913 = wave.extract %878[34] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %914 = wave.extract %878[35] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %915 = wave.extract %878[36] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %916 = wave.extract %878[37] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %917 = wave.extract %878[38] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %918 = wave.extract %878[39] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %919 = wave.extract %878[40] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %920 = wave.extract %878[41] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %921 = wave.extract %878[42] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %922 = wave.extract %878[43] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %923 = wave.extract %878[44] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %924 = wave.extract %878[45] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %925 = wave.extract %878[46] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %926 = wave.extract %878[47] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %927 = wave.extract %878[48] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %928 = wave.extract %878[49] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %929 = wave.extract %878[50] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %930 = wave.extract %878[51] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %931 = wave.extract %878[52] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %932 = wave.extract %878[53] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %933 = wave.extract %878[54] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %934 = wave.extract %878[55] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %935 = wave.extract %878[56] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %936 = wave.extract %878[57] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %937 = wave.extract %878[58] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %938 = wave.extract %878[59] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %939 = wave.extract %878[60] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %940 = wave.extract %878[61] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %941 = wave.extract %878[62] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %942 = wave.extract %878[63] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
      %943 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%131) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %944 = wave.assume %943 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %945 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%944) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %946 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%132) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %947 = wave.assume %946 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %948 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%947) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %949 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%133) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %950 = wave.assume %949 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %951 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%950) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %952 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%134) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %953 = wave.assume %952 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %954 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%953) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %955 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%135) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %956 = wave.assume %955 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %957 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%956) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %958 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%136) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %959 = wave.assume %958 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %960 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%959) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %961 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%137) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %962 = wave.assume %961 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %963 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%962) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %964 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%138) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %965 = wave.assume %964 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %966 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%965) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %967 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %value_142, %token_143 = wave.gather %967 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%945, %948, %951, %954, %957, %960, %963, %966) : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
      %968 = wave.extract %value_142[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %969 = wave.extract %value_142[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %970 = wave.extract %value_142[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %971 = wave.extract %value_142[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %972 = wave.extract %value_142[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %973 = wave.extract %value_142[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %974 = wave.extract %value_142[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %975 = wave.extract %value_142[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
      %976 = wave.cast fpconvert %968 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %977 = wave.cast fpconvert %969 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %978 = wave.cast fpconvert %970 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %979 = wave.cast fpconvert %971 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %980 = wave.cast fpconvert %972 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %981 = wave.cast fpconvert %973 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %982 = wave.cast fpconvert %974 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %983 = wave.cast fpconvert %975 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %984 = wave.splat %34 : i32 -> !wave.simd<i32, 64>
      %985 = wave.binary muli %103, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %986 = wave.binary muli %104, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %987 = wave.binary muli %105, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %988 = wave.binary muli %106, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %989 = wave.binary muli %107, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %990 = wave.binary muli %108, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %991 = wave.binary muli %109, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %992 = wave.binary muli %110, %984 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %993 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %994 = wave.assume %993 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %995 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%994) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %996 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %997 = wave.assume %996 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %998 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%997) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %999 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1000 = wave.assume %999 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1001 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1000) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1002 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1003 = wave.assume %1002 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1004 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1003) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1005 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1006 = wave.assume %1005 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1007 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1006) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1008 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1009 = wave.assume %1008 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1010 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1009) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1011 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1012 = wave.assume %1011 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1013 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1012) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1014 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%985, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1015 = wave.assume %1014 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1016 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1015) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1017 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1018 = wave.assume %1017 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1019 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1018) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1020 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1021 = wave.assume %1020 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1022 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1021) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1023 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1024 = wave.assume %1023 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1025 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1024) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1026 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1027 = wave.assume %1026 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1028 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1027) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1029 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1030 = wave.assume %1029 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1031 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1030) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1032 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1033 = wave.assume %1032 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1034 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1033) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1035 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1036 = wave.assume %1035 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1037 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1036) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1038 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%986, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1039 = wave.assume %1038 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1040 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1039) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1041 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1042 = wave.assume %1041 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1043 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1042) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1044 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1045 = wave.assume %1044 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1046 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1045) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1047 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1048 = wave.assume %1047 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1049 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1048) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1050 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1051 = wave.assume %1050 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1052 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1051) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1053 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1054 = wave.assume %1053 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1055 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1054) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1056 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1057 = wave.assume %1056 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1058 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1057) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1059 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1060 = wave.assume %1059 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1061 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1060) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1062 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%987, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1063 = wave.assume %1062 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1064 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1063) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1065 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1066 = wave.assume %1065 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1067 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1066) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1068 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1069 = wave.assume %1068 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1070 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1069) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1071 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1072 = wave.assume %1071 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1073 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1072) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1074 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1075 = wave.assume %1074 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1076 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1075) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1077 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1078 = wave.assume %1077 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1079 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1078) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1080 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1081 = wave.assume %1080 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1082 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1081) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1083 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1084 = wave.assume %1083 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1085 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1084) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1086 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%988, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1087 = wave.assume %1086 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1088 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1087) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1089 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1090 = wave.assume %1089 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1091 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1090) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1092 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1093 = wave.assume %1092 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1094 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1093) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1095 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1096 = wave.assume %1095 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1097 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1096) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1098 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1099 = wave.assume %1098 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1100 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1099) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1101 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1102 = wave.assume %1101 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1103 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1102) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1104 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1105 = wave.assume %1104 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1106 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1105) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1107 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1108 = wave.assume %1107 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1109 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1108) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1110 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%989, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1111 = wave.assume %1110 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1112 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1111) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1113 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1114 = wave.assume %1113 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1115 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1114) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1116 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1117 = wave.assume %1116 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1118 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1117) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1119 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1120 = wave.assume %1119 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1121 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1120) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1122 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1123 = wave.assume %1122 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1124 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1123) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1125 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1126 = wave.assume %1125 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1127 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1126) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1128 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1129 = wave.assume %1128 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1130 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1129) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1131 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1132 = wave.assume %1131 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1133 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1132) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1134 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%990, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1135 = wave.assume %1134 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1136 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1135) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1137 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1138 = wave.assume %1137 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1139 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1138) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1140 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1141 = wave.assume %1140 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1142 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1141) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1143 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1144 = wave.assume %1143 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1145 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1144) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1146 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1147 = wave.assume %1146 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1148 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1147) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1149 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1150 = wave.assume %1149 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1151 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1150) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1152 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1153 = wave.assume %1152 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1154 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1153) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1155 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1156 = wave.assume %1155 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1157 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1156) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1158 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%991, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1159 = wave.assume %1158 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1160 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1159) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1161 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1162 = wave.assume %1161 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1163 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1162) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1164 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1165 = wave.assume %1164 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1166 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1165) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1167 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1168 = wave.assume %1167 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1169 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1168) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1170 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1171 = wave.assume %1170 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1172 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1171) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1173 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1174 = wave.assume %1173 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1175 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1174) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1176 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1177 = wave.assume %1176 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1178 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1177) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1179 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1180 = wave.assume %1179 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1181 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1180) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1182 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%992, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1183 = wave.assume %1182 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1184 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1183) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1185 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %value_144, %token_145 = wave.gather %1185 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%995, %998, %1001, %1004, %1007, %1010, %1013, %1016, %1019, %1022, %1025, %1028, %1031, %1034, %1037, %1040, %1043, %1046, %1049, %1052, %1055, %1058, %1061, %1064, %1067, %1070, %1073, %1076, %1079, %1082, %1085, %1088, %1091, %1094, %1097, %1100, %1103, %1106, %1109, %1112, %1115, %1118, %1121, %1124, %1127, %1130, %1133, %1136, %1139, %1142, %1145, %1148, %1151, %1154, %1157, %1160, %1163, %1166, %1169, %1172, %1175, %1178, %1181, %1184) {cache = #waveamd.load_cache<cs>} : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<64xf16>, 64>, !wave.mem.token)
      %1186 = wave.extract %value_144[0] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1187 = wave.extract %value_144[1] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1188 = wave.extract %value_144[2] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1189 = wave.extract %value_144[3] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1190 = wave.extract %value_144[4] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1191 = wave.extract %value_144[5] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1192 = wave.extract %value_144[6] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1193 = wave.extract %value_144[7] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1194 = wave.extract %value_144[8] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1195 = wave.extract %value_144[9] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1196 = wave.extract %value_144[10] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1197 = wave.extract %value_144[11] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1198 = wave.extract %value_144[12] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1199 = wave.extract %value_144[13] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1200 = wave.extract %value_144[14] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1201 = wave.extract %value_144[15] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1202 = wave.extract %value_144[16] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1203 = wave.extract %value_144[17] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1204 = wave.extract %value_144[18] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1205 = wave.extract %value_144[19] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1206 = wave.extract %value_144[20] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1207 = wave.extract %value_144[21] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1208 = wave.extract %value_144[22] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1209 = wave.extract %value_144[23] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1210 = wave.extract %value_144[24] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1211 = wave.extract %value_144[25] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1212 = wave.extract %value_144[26] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1213 = wave.extract %value_144[27] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1214 = wave.extract %value_144[28] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1215 = wave.extract %value_144[29] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1216 = wave.extract %value_144[30] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1217 = wave.extract %value_144[31] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1218 = wave.extract %value_144[32] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1219 = wave.extract %value_144[33] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1220 = wave.extract %value_144[34] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1221 = wave.extract %value_144[35] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1222 = wave.extract %value_144[36] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1223 = wave.extract %value_144[37] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1224 = wave.extract %value_144[38] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1225 = wave.extract %value_144[39] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1226 = wave.extract %value_144[40] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1227 = wave.extract %value_144[41] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1228 = wave.extract %value_144[42] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1229 = wave.extract %value_144[43] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1230 = wave.extract %value_144[44] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1231 = wave.extract %value_144[45] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1232 = wave.extract %value_144[46] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1233 = wave.extract %value_144[47] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1234 = wave.extract %value_144[48] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1235 = wave.extract %value_144[49] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1236 = wave.extract %value_144[50] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1237 = wave.extract %value_144[51] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1238 = wave.extract %value_144[52] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1239 = wave.extract %value_144[53] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1240 = wave.extract %value_144[54] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1241 = wave.extract %value_144[55] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1242 = wave.extract %value_144[56] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1243 = wave.extract %value_144[57] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1244 = wave.extract %value_144[58] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1245 = wave.extract %value_144[59] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1246 = wave.extract %value_144[60] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1247 = wave.extract %value_144[61] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1248 = wave.extract %value_144[62] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1249 = wave.extract %value_144[63] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
      %1250 = wave.cast fpconvert %1186 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1251 = wave.cast fpconvert %1187 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1252 = wave.cast fpconvert %1188 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1253 = wave.cast fpconvert %1189 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1254 = wave.cast fpconvert %1190 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1255 = wave.cast fpconvert %1191 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1256 = wave.cast fpconvert %1192 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1257 = wave.cast fpconvert %1193 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1258 = wave.cast fpconvert %1194 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1259 = wave.cast fpconvert %1195 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1260 = wave.cast fpconvert %1196 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1261 = wave.cast fpconvert %1197 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1262 = wave.cast fpconvert %1198 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1263 = wave.cast fpconvert %1199 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1264 = wave.cast fpconvert %1200 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1265 = wave.cast fpconvert %1201 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1266 = wave.cast fpconvert %1202 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1267 = wave.cast fpconvert %1203 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1268 = wave.cast fpconvert %1204 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1269 = wave.cast fpconvert %1205 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1270 = wave.cast fpconvert %1206 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1271 = wave.cast fpconvert %1207 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1272 = wave.cast fpconvert %1208 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1273 = wave.cast fpconvert %1209 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1274 = wave.cast fpconvert %1210 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1275 = wave.cast fpconvert %1211 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1276 = wave.cast fpconvert %1212 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1277 = wave.cast fpconvert %1213 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1278 = wave.cast fpconvert %1214 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1279 = wave.cast fpconvert %1215 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1280 = wave.cast fpconvert %1216 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1281 = wave.cast fpconvert %1217 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1282 = wave.cast fpconvert %1218 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1283 = wave.cast fpconvert %1219 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1284 = wave.cast fpconvert %1220 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1285 = wave.cast fpconvert %1221 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1286 = wave.cast fpconvert %1222 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1287 = wave.cast fpconvert %1223 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1288 = wave.cast fpconvert %1224 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1289 = wave.cast fpconvert %1225 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1290 = wave.cast fpconvert %1226 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1291 = wave.cast fpconvert %1227 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1292 = wave.cast fpconvert %1228 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1293 = wave.cast fpconvert %1229 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1294 = wave.cast fpconvert %1230 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1295 = wave.cast fpconvert %1231 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1296 = wave.cast fpconvert %1232 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1297 = wave.cast fpconvert %1233 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1298 = wave.cast fpconvert %1234 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1299 = wave.cast fpconvert %1235 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1300 = wave.cast fpconvert %1236 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1301 = wave.cast fpconvert %1237 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1302 = wave.cast fpconvert %1238 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1303 = wave.cast fpconvert %1239 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1304 = wave.cast fpconvert %1240 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1305 = wave.cast fpconvert %1241 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1306 = wave.cast fpconvert %1242 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1307 = wave.cast fpconvert %1243 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1308 = wave.cast fpconvert %1244 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1309 = wave.cast fpconvert %1245 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1310 = wave.cast fpconvert %1246 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1311 = wave.cast fpconvert %1247 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1312 = wave.cast fpconvert %1248 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1313 = wave.cast fpconvert %1249 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
      %1314 = wave.fadd %879, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1315 = wave.fadd %880, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1316 = wave.fadd %881, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1317 = wave.fadd %882, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1318 = wave.fadd %883, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1319 = wave.fadd %884, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1320 = wave.fadd %885, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1321 = wave.fadd %886, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1322 = wave.fadd %887, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1323 = wave.fadd %888, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1324 = wave.fadd %889, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1325 = wave.fadd %890, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1326 = wave.fadd %891, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1327 = wave.fadd %892, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1328 = wave.fadd %893, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1329 = wave.fadd %894, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1330 = wave.fadd %895, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1331 = wave.fadd %896, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1332 = wave.fadd %897, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1333 = wave.fadd %898, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1334 = wave.fadd %899, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1335 = wave.fadd %900, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1336 = wave.fadd %901, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1337 = wave.fadd %902, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1338 = wave.fadd %903, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1339 = wave.fadd %904, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1340 = wave.fadd %905, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1341 = wave.fadd %906, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1342 = wave.fadd %907, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1343 = wave.fadd %908, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1344 = wave.fadd %909, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1345 = wave.fadd %910, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1346 = wave.fadd %911, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1347 = wave.fadd %912, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1348 = wave.fadd %913, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1349 = wave.fadd %914, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1350 = wave.fadd %915, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1351 = wave.fadd %916, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1352 = wave.fadd %917, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1353 = wave.fadd %918, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1354 = wave.fadd %919, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1355 = wave.fadd %920, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1356 = wave.fadd %921, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1357 = wave.fadd %922, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1358 = wave.fadd %923, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1359 = wave.fadd %924, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1360 = wave.fadd %925, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1361 = wave.fadd %926, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1362 = wave.fadd %927, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1363 = wave.fadd %928, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1364 = wave.fadd %929, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1365 = wave.fadd %930, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1366 = wave.fadd %931, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1367 = wave.fadd %932, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1368 = wave.fadd %933, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1369 = wave.fadd %934, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1370 = wave.fadd %935, %976 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1371 = wave.fadd %936, %977 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1372 = wave.fadd %937, %978 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1373 = wave.fadd %938, %979 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1374 = wave.fadd %939, %980 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1375 = wave.fadd %940, %981 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1376 = wave.fadd %941, %982 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1377 = wave.fadd %942, %983 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1378 = wave.fma %1314, %1250, %1314 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1379 = wave.fma %1315, %1251, %1315 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1380 = wave.fma %1316, %1252, %1316 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1381 = wave.fma %1317, %1253, %1317 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1382 = wave.fma %1318, %1254, %1318 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1383 = wave.fma %1319, %1255, %1319 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1384 = wave.fma %1320, %1256, %1320 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1385 = wave.fma %1321, %1257, %1321 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1386 = wave.fma %1322, %1258, %1322 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1387 = wave.fma %1323, %1259, %1323 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1388 = wave.fma %1324, %1260, %1324 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1389 = wave.fma %1325, %1261, %1325 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1390 = wave.fma %1326, %1262, %1326 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1391 = wave.fma %1327, %1263, %1327 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1392 = wave.fma %1328, %1264, %1328 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1393 = wave.fma %1329, %1265, %1329 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1394 = wave.fma %1330, %1266, %1330 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1395 = wave.fma %1331, %1267, %1331 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1396 = wave.fma %1332, %1268, %1332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1397 = wave.fma %1333, %1269, %1333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1398 = wave.fma %1334, %1270, %1334 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1399 = wave.fma %1335, %1271, %1335 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1400 = wave.fma %1336, %1272, %1336 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1401 = wave.fma %1337, %1273, %1337 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1402 = wave.fma %1338, %1274, %1338 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1403 = wave.fma %1339, %1275, %1339 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1404 = wave.fma %1340, %1276, %1340 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1405 = wave.fma %1341, %1277, %1341 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1406 = wave.fma %1342, %1278, %1342 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1407 = wave.fma %1343, %1279, %1343 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1408 = wave.fma %1344, %1280, %1344 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1409 = wave.fma %1345, %1281, %1345 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1410 = wave.fma %1346, %1282, %1346 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1411 = wave.fma %1347, %1283, %1347 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1412 = wave.fma %1348, %1284, %1348 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1413 = wave.fma %1349, %1285, %1349 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1414 = wave.fma %1350, %1286, %1350 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1415 = wave.fma %1351, %1287, %1351 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1416 = wave.fma %1352, %1288, %1352 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1417 = wave.fma %1353, %1289, %1353 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1418 = wave.fma %1354, %1290, %1354 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1419 = wave.fma %1355, %1291, %1355 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1420 = wave.fma %1356, %1292, %1356 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1421 = wave.fma %1357, %1293, %1357 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1422 = wave.fma %1358, %1294, %1358 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1423 = wave.fma %1359, %1295, %1359 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1424 = wave.fma %1360, %1296, %1360 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1425 = wave.fma %1361, %1297, %1361 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1426 = wave.fma %1362, %1298, %1362 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1427 = wave.fma %1363, %1299, %1363 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1428 = wave.fma %1364, %1300, %1364 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1429 = wave.fma %1365, %1301, %1365 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1430 = wave.fma %1366, %1302, %1366 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1431 = wave.fma %1367, %1303, %1367 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1432 = wave.fma %1368, %1304, %1368 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1433 = wave.fma %1369, %1305, %1369 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1434 = wave.fma %1370, %1306, %1370 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1435 = wave.fma %1371, %1307, %1371 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1436 = wave.fma %1372, %1308, %1372 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1437 = wave.fma %1373, %1309, %1373 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1438 = wave.fma %1374, %1310, %1374 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1439 = wave.fma %1375, %1311, %1375 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1440 = wave.fma %1376, %1312, %1376 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1441 = wave.fma %1377, %1313, %1377 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1442 = wave.splat %35 : i32 -> !wave.simd<i32, 64>
      %1443 = wave.binary muli %103, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1444 = wave.binary muli %104, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1445 = wave.binary muli %105, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1446 = wave.binary muli %106, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1447 = wave.binary muli %107, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1448 = wave.binary muli %108, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1449 = wave.binary muli %109, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1450 = wave.binary muli %110, %1442 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1451 = wave.cast fpconvert %1378 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1452 = wave.cast fpconvert %1379 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1453 = wave.cast fpconvert %1380 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1454 = wave.cast fpconvert %1381 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1455 = wave.cast fpconvert %1382 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1456 = wave.cast fpconvert %1383 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1457 = wave.cast fpconvert %1384 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1458 = wave.cast fpconvert %1385 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1459 = wave.cast fpconvert %1386 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1460 = wave.cast fpconvert %1387 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1461 = wave.cast fpconvert %1388 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1462 = wave.cast fpconvert %1389 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1463 = wave.cast fpconvert %1390 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1464 = wave.cast fpconvert %1391 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1465 = wave.cast fpconvert %1392 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1466 = wave.cast fpconvert %1393 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1467 = wave.cast fpconvert %1394 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1468 = wave.cast fpconvert %1395 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1469 = wave.cast fpconvert %1396 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1470 = wave.cast fpconvert %1397 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1471 = wave.cast fpconvert %1398 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1472 = wave.cast fpconvert %1399 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1473 = wave.cast fpconvert %1400 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1474 = wave.cast fpconvert %1401 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1475 = wave.cast fpconvert %1402 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1476 = wave.cast fpconvert %1403 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1477 = wave.cast fpconvert %1404 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1478 = wave.cast fpconvert %1405 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1479 = wave.cast fpconvert %1406 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1480 = wave.cast fpconvert %1407 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1481 = wave.cast fpconvert %1408 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1482 = wave.cast fpconvert %1409 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1483 = wave.cast fpconvert %1410 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1484 = wave.cast fpconvert %1411 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1485 = wave.cast fpconvert %1412 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1486 = wave.cast fpconvert %1413 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1487 = wave.cast fpconvert %1414 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1488 = wave.cast fpconvert %1415 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1489 = wave.cast fpconvert %1416 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1490 = wave.cast fpconvert %1417 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1491 = wave.cast fpconvert %1418 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1492 = wave.cast fpconvert %1419 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1493 = wave.cast fpconvert %1420 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1494 = wave.cast fpconvert %1421 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1495 = wave.cast fpconvert %1422 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1496 = wave.cast fpconvert %1423 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1497 = wave.cast fpconvert %1424 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1498 = wave.cast fpconvert %1425 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1499 = wave.cast fpconvert %1426 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1500 = wave.cast fpconvert %1427 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1501 = wave.cast fpconvert %1428 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1502 = wave.cast fpconvert %1429 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1503 = wave.cast fpconvert %1430 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1504 = wave.cast fpconvert %1431 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1505 = wave.cast fpconvert %1432 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1506 = wave.cast fpconvert %1433 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1507 = wave.cast fpconvert %1434 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1508 = wave.cast fpconvert %1435 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1509 = wave.cast fpconvert %1436 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1510 = wave.cast fpconvert %1437 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1511 = wave.cast fpconvert %1438 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1512 = wave.cast fpconvert %1439 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1513 = wave.cast fpconvert %1440 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1514 = wave.cast fpconvert %1441 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
      %1515 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1516 = wave.assume %1515 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1517 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1516) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1518 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1519 = wave.assume %1518 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1520 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1519) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1521 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1522 = wave.assume %1521 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1523 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1522) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1524 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1525 = wave.assume %1524 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1526 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1525) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1527 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1528 = wave.assume %1527 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1529 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1528) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1530 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1531 = wave.assume %1530 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1532 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1531) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1533 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1534 = wave.assume %1533 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1535 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1534) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1536 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1443, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1537 = wave.assume %1536 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1538 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1537) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1539 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1540 = wave.assume %1539 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1541 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1540) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1542 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1543 = wave.assume %1542 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1544 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1543) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1545 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1546 = wave.assume %1545 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1547 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1546) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1548 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1549 = wave.assume %1548 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1550 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1549) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1551 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1552 = wave.assume %1551 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1553 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1552) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1554 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1555 = wave.assume %1554 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1556 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1555) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1557 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1558 = wave.assume %1557 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1559 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1558) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1560 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1444, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1561 = wave.assume %1560 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1562 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1561) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1563 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1564 = wave.assume %1563 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1565 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1564) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1566 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1567 = wave.assume %1566 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1568 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1567) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1569 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1570 = wave.assume %1569 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1571 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1570) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1572 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1573 = wave.assume %1572 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1574 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1573) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1575 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1576 = wave.assume %1575 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1577 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1576) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1578 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1579 = wave.assume %1578 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1580 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1579) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1581 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1582 = wave.assume %1581 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1583 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1582) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1584 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1445, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1585 = wave.assume %1584 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1586 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1585) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1587 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1588 = wave.assume %1587 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1589 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1588) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1590 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1591 = wave.assume %1590 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1592 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1591) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1593 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1594 = wave.assume %1593 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1595 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1594) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1596 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1597 = wave.assume %1596 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1598 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1597) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1599 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1600 = wave.assume %1599 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1601 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1600) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1602 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1603 = wave.assume %1602 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1604 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1603) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1605 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1606 = wave.assume %1605 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1607 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1606) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1608 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1446, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1609 = wave.assume %1608 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1610 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1609) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1611 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1612 = wave.assume %1611 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1613 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1612) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1614 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1615 = wave.assume %1614 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1616 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1615) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1617 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1618 = wave.assume %1617 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1619 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1618) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1620 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1621 = wave.assume %1620 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1622 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1621) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1623 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1624 = wave.assume %1623 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1625 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1624) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1626 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1627 = wave.assume %1626 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1628 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1627) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1629 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1630 = wave.assume %1629 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1631 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1630) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1632 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1447, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1633 = wave.assume %1632 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1634 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1633) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1635 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1636 = wave.assume %1635 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1637 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1636) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1638 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1639 = wave.assume %1638 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1640 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1639) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1641 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1642 = wave.assume %1641 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1643 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1642) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1644 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1645 = wave.assume %1644 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1646 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1645) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1647 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1648 = wave.assume %1647 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1649 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1648) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1650 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1651 = wave.assume %1650 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1652 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1651) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1653 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1654 = wave.assume %1653 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1655 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1654) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1656 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1448, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1657 = wave.assume %1656 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1658 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1657) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1659 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1660 = wave.assume %1659 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1661 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1660) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1662 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1663 = wave.assume %1662 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1664 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1663) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1665 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1666 = wave.assume %1665 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1667 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1666) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1668 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1669 = wave.assume %1668 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1670 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1669) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1671 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1672 = wave.assume %1671 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1673 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1672) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1674 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1675 = wave.assume %1674 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1676 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1675) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1677 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1678 = wave.assume %1677 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1679 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1678) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1680 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1449, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1681 = wave.assume %1680 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1682 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1681) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1683 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %131) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1684 = wave.assume %1683 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1685 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1684) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1686 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %132) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1687 = wave.assume %1686 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1688 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1687) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1689 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %133) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1690 = wave.assume %1689 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1691 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1690) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1692 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %134) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1693 = wave.assume %1692 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1694 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1693) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1695 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %135) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1696 = wave.assume %1695 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1697 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1696) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1698 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %136) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1699 = wave.assume %1698 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1700 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1699) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1701 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %137) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1702 = wave.assume %1701 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1703 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1702) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1704 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%1450, %138) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1705 = wave.assume %1704 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %1706 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1705) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %1707 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
      %1708 = wave.pack %1451, %1452, %1453, %1454, %1455, %1456, %1457, %1458, %1459, %1460, %1461, %1462, %1463, %1464, %1465, %1466, %1467, %1468, %1469, %1470, %1471, %1472, %1473, %1474, %1475, %1476, %1477, %1478, %1479, %1480, %1481, %1482, %1483, %1484, %1485, %1486, %1487, %1488, %1489, %1490, %1491, %1492, %1493, %1494, %1495, %1496, %1497, %1498, %1499, %1500, %1501, %1502, %1503, %1504, %1505, %1506, %1507, %1508, %1509, %1510, %1511, %1512, %1513, %1514 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<64xf16>, 64>
      %1709 = wave.scatter %1708 to %1707 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%1517, %1520, %1523, %1526, %1529, %1532, %1535, %1538, %1541, %1544, %1547, %1550, %1553, %1556, %1559, %1562, %1565, %1568, %1571, %1574, %1577, %1580, %1583, %1586, %1589, %1592, %1595, %1598, %1601, %1604, %1607, %1610, %1613, %1616, %1619, %1622, %1625, %1628, %1631, %1634, %1637, %1640, %1643, %1646, %1649, %1652, %1655, %1658, %1661, %1664, %1667, %1670, %1673, %1676, %1679, %1682, %1685, %1688, %1691, %1694, %1697, %1700, %1703, %1706) {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<64xf16>, 64>, !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> !wave.mem.token
      return
    }
  }
}
