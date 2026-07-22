module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 8 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @tlx_addmm_glu_kernel_persistent(%arg0: !wave.ptr<#wave.global, f16>, %arg1: !wave.ptr<#wave.global, f16>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, f16>, %arg4: !wave.ptr<#wave.global, f16>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 8 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 8 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
      %0 = wave.constant 0 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 3168 : index -> !wave.simd<index, 64>
      %2 = wave.constant 2112 : index -> !wave.simd<index, 64>
      %3 = wave.constant 1056 : index -> !wave.simd<index, 64>
      %4 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %5 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 6 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 5 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 3 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %14 = wave.constant 256 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %16 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %17 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %18 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %19 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %20 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %21 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %22 = wave.constant false -> !wave.mask<64>
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %c8448_i32 = arith.constant 8448 : i32
      %c2112_i32 = arith.constant 2112 : i32
      %c4224_i32 = arith.constant 4224 : i32
      %c32_i32 = arith.constant 32 : i32
      %c1_i32 = arith.constant 1 : i32
      %c128_i32 = arith.constant 128 : i32
      %c256_i32 = arith.constant 256 : i32
      %c4_i32 = arith.constant 4 : i32
      %c0_i32 = arith.constant 0 : i32
      %c64_i32 = arith.constant 64 : i32
      %c2_i32 = arith.constant 2 : i32
      %c3_i32 = arith.constant 3 : i32
      %c-1_i32 = arith.constant -1 : i32
      %c127_i32 = arith.constant 127 : i32
      %c255_i32 = arith.constant 255 : i32
      %c31_i32 = arith.constant 31 : i32
      %23 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %c8_i32 = arith.constant 8 : i32
      %24 = wave.assume %arg5 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %25 = wave.assume %arg6 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %26 = wave.assume %arg7 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %27 = wave.pack %23, %23, %23, %23 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %28 = wave.assume %arg8 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %29 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %30 = wave.assume %arg10 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %31 = wave.workgroup_id 0
      %32 = wave.binary addi %24, %c127_i32 overflow<nsw> : i32, i32 -> i32
      %33 = wave.binary divsi %32, %c128_i32 : i32, i32 -> i32
      %34 = wave.binary addi %25, %c255_i32 overflow<nsw> : i32, i32 -> i32
      %35 = wave.binary divsi %34, %c256_i32 : i32, i32 -> i32
      %36 = wave.binary muli %33, %35 overflow<nsw> : i32, i32 -> i32
      %37 = wave.binary muli %35, %c4_i32 overflow<nsw> : i32, i32 -> i32
      %38 = wave.alloc() {align = 16 : i64, bytesize = 25312 : i64} : !wave.ptr<#wave.shared, f16>
      %39 = wave.alloc() {align = 16 : i64, bytesize = 50656 : i64} : !wave.ptr<#wave.shared, f16>
      %40 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %41 = wave.binary divui %40, %21 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %42 = wave.binary remui %41, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %43 = wave.binary muli %42, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %44 = wave.binary divui %40, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %45 = wave.binary remui %44, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %46 = wave.binary muli %45, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %47 = wave.binary addi %43, %46 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %48 = wave.binary divui %40, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %49 = wave.binary remui %48, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %50 = wave.binary muli %49, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %51 = wave.binary addi %47, %50 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %52 = wave.binary divui %40, %17 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %53 = wave.binary remui %52, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %54 = wave.binary muli %53, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %55 = wave.binary addi %51, %54 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %56 = wave.binary divui %40, %16 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %57 = wave.binary remui %56, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %58 = wave.binary addi %55, %57 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %59 = wave.binary divui %40, %15 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %60 = wave.binary remui %59, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %61 = wave.binary muli %60, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %62 = wave.binary addi %58, %61 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %63 = wave.binary divui %40, %14 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %64 = wave.binary remui %63, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %65 = wave.binary muli %64, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %66 = wave.binary addi %62, %65 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %67 = wave.binary remui %52, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %68 = wave.binary addi %67, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %69 = wave.binary addi %67, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %70 = wave.binary addi %67, %13 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %71 = wave.binary addi %67, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %72 = wave.binary addi %67, %12 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %73 = wave.binary addi %67, %11 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %74 = wave.binary addi %67, %10 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %75 = wave.splat %24 : i32 -> !wave.simd<i32, 64>
      %76 = wave.binary remui %40, %17 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %77 = wave.binary muli %76, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %78 = wave.binary addi %77, %9 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %79 = wave.binary addi %77, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %80 = wave.binary addi %77, %8 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %81 = wave.binary addi %77, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %82 = wave.binary addi %77, %7 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %83 = wave.binary addi %77, %6 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %84 = wave.binary addi %77, %5 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %85 = wave.splat %25 : i32 -> !wave.simd<i32, 64>
      %86 = wave.binary addi %26, %c31_i32 overflow<nsw> : i32, i32 -> i32
      %87 = wave.binary divsi %86, %c32_i32 : i32, i32 -> i32
      %88 = wave.binary remui %40, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %89 = wave.binary muli %88, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %90 = wave.binary divui %40, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %91 = wave.binary remui %90, %20 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %92 = wave.binary muli %91, %18 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %93 = wave.binary xori %89, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %94 = wave.splat %26 : i32 -> !wave.simd<i32, 64>
      %95 = wave.cmpi slt %93, %94 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %96 = wave.ptr_cast %38 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %97 = wave.binary xori %54, %57 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %98 = wave.binary muli %60, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %99 = wave.binary xori %97, %98 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %100 = wave.binary muli %64, %19 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %101 = wave.binary xori %99, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %102 = wave.binary xori %21, %54 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %103 = wave.binary xori %102, %57 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %104 = wave.binary xori %103, %98 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %105 = wave.binary xori %104, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %106 = wave.cmpi slt %101, %94 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %107 = wave.cmpi slt %105, %94 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %108 = wave.ptr_cast %39 : !wave.ptr<#wave.shared, f16> -> !wave.ptr<#wave.shared, i32>
      %109 = wave.binary subi %26, %c32_i32 : i32, i32 -> i32
      %110 = wave.splat %109 : i32 -> !wave.simd<i32, 64>
      %111 = wave.cmpi slt %93, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %112 = wave.ptr_add %96, %c2112_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %113 = wave.cmpi slt %101, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %114 = wave.cmpi slt %105, %110 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %115 = wave.ptr_add %108, %c4224_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %116 = wave.binary subi %26, %c64_i32 : i32, i32 -> i32
      %117 = wave.splat %116 : i32 -> !wave.simd<i32, 64>
      %118 = wave.cmpi slt %93, %117 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %119 = wave.ptr_add %96, %c4224_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %120 = wave.cmpi slt %101, %117 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %121 = wave.cmpi slt %105, %117 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %122 = wave.ptr_add %108, %c8448_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
      %123 = wave.binary subi %87, %c3_i32 overflow<nsw> : i32, i32 -> i32
      %124 = wave.binary subi %87, %c2_i32 overflow<nsw> : i32, i32 -> i32
      %125 = wave.binary remsi %124, %c3_i32 : i32, i32 -> i32
      %126 = wave.binary muli %125, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %127 = wave.ptr_add %38, %126 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %128 = wave.binary muli %125, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %129 = wave.ptr_add %39, %128 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %130 = wave.binary addi %87, %c-1_i32 overflow<nsw> : i32, i32 -> i32
      %131 = wave.binary remsi %130, %c3_i32 : i32, i32 -> i32
      %132 = wave.binary muli %131, %c4224_i32 overflow<nsw> : i32, i32 -> i32
      %133 = wave.ptr_add %38, %132 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %134 = wave.binary muli %131, %c8448_i32 overflow<nsw> : i32, i32 -> i32
      %135 = wave.ptr_add %39, %134 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
      %136 = wave.token : !wave.mem.token
      %137 = scf.for %arg12 = %31 to %36 step %c256_i32 iter_args(%arg13 = %136) -> (!wave.mem.token)  : i32 {
        %138 = wave.binary divsi %36, %c32_i32 : i32, i32 -> i32
        %139 = wave.binary muli %138, %c32_i32 : i32, i32 -> i32
        %140 = arith.cmpi sge, %arg12, %139 : i32
        %141 = scf.if %140 -> (i32) {
          scf.yield %arg12 : i32
        } else {
          %1585 = wave.binary remui %arg12, %c8_i32 : i32, i32 -> i32
          %1586 = wave.binary divui %arg12, %c8_i32 : i32, i32 -> i32
          %1587 = wave.binary divui %1586, %c4_i32 : i32, i32 -> i32
          %1588 = wave.binary muli %1587, %c32_i32 overflow<nsw, nuw> : i32, i32 -> i32
          %1589 = wave.binary muli %1585, %c4_i32 overflow<nsw, nuw> : i32, i32 -> i32
          %1590 = wave.binary addi %1588, %1589 overflow<nsw, nuw> : i32, i32 -> i32
          %1591 = wave.binary remui %1586, %c4_i32 : i32, i32 -> i32
          %1592 = wave.binary addi %1590, %1591 overflow<nsw, nuw> : i32, i32 -> i32
          scf.yield %1592 : i32
        }
        %142 = wave.binary divsi %141, %37 : i32, i32 -> i32
        %143 = wave.binary muli %142, %c4_i32 overflow<nsw> : i32, i32 -> i32
        %144 = wave.binary subi %33, %143 overflow<nsw> : i32, i32 -> i32
        %145 = arith.cmpi slt, %144, %c4_i32 : i32
        %146 = wave.select %145, %144, %c4_i32 : i32
        %147 = wave.binary remsi %141, %37 : i32, i32 -> i32
        %148 = wave.binary remsi %147, %146 : i32, i32 -> i32
        %149 = wave.binary addi %143, %148 overflow<nsw> : i32, i32 -> i32
        %150 = wave.binary divsi %147, %146 : i32, i32 -> i32
        %151 = wave.binary muli %149, %c128_i32 overflow<nsw> : i32, i32 -> i32
        %152 = wave.splat %151 : i32 -> !wave.simd<i32, 64>
        %153 = wave.binary addi %152, %66 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %154 = wave.binary addi %152, %67 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %155 = wave.binary addi %152, %68 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %156 = wave.binary addi %152, %69 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %157 = wave.binary addi %152, %70 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %158 = wave.binary addi %152, %71 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %159 = wave.binary addi %152, %72 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %160 = wave.binary addi %152, %73 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %161 = wave.binary addi %152, %74 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %162 = wave.binary remsi %153, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %163 = wave.binary remsi %154, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %164 = wave.binary remsi %155, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %165 = wave.binary remsi %156, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %166 = wave.binary remsi %157, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %167 = wave.binary remsi %158, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %168 = wave.binary remsi %159, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %169 = wave.binary remsi %160, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %170 = wave.binary remsi %161, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %171 = wave.binary muli %150, %c256_i32 overflow<nsw> : i32, i32 -> i32
        %172 = wave.splat %171 : i32 -> !wave.simd<i32, 64>
        %173 = wave.binary addi %172, %77 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %174 = wave.binary addi %172, %78 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %175 = wave.binary addi %172, %79 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %176 = wave.binary addi %172, %80 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %177 = wave.binary addi %172, %81 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %178 = wave.binary addi %172, %82 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %179 = wave.binary addi %172, %83 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %180 = wave.binary addi %172, %84 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %181 = wave.binary remsi %173, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %182 = wave.binary remsi %174, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %183 = wave.binary remsi %175, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %184 = wave.binary remsi %176, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %185 = wave.binary remsi %177, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %186 = wave.binary remsi %178, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %187 = wave.binary remsi %179, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %188 = wave.binary remsi %180, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %189 = wave.splat %28 : i32 -> !wave.simd<i32, 64>
        %190 = wave.binary muli %162, %189 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %191 = wave.index_expr <"s0 + 8*Mod(wi, 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s0 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) <= 0">] ["wi", "s0"](%40, %190) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %192 = wave.assume %191 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %193 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%192) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %194 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
        %195 = wave.read_first %40 : !wave.simd<i32, 64> -> i32
        %196 = wave.assume %195 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : i32
        %197 = wave.ptr_add %194, %193 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %198 = wave.index_expr <"264*floor(1/64*wi_first)"> ["wi_first"](%196) : (i32) -> index
        %199 = wave.ptr_add %96, %198 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %200 = wave.ptr_add %194, %4 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %201 = wave.select %95, %197, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %202 = waveamd.dma_load_lds %201 -> %199 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %203 = wave.index_expr <"s1 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %29, %181) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %204 = wave.assume %203 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %205 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%204) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %206 = wave.index_expr <"s1 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %29, %181) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %207 = wave.assume %206 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %208 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%207) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %209 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
        %210 = wave.ptr_add %209, %205 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %211 = wave.ptr_add %108, %198 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %212 = wave.ptr_add %209, %4 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %213 = wave.select %106, %210, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %214 = waveamd.dma_load_lds %213 -> %211 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %215 = wave.ptr_add %209, %208 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %216 = wave.index_expr <"2112 + 264*floor(1/64*wi_first)"> ["wi_first"](%196) : (i32) -> index
        %217 = wave.ptr_add %108, %216 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %218 = wave.select %107, %215, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %219 = waveamd.dma_load_lds %218 -> %217 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %220 = wave.join %214, %219 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %221 = wave.join %202, %220 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %222 = wave.barrier : () -> !wave.mem.token
        %223 = wave.index_expr <"32 + s0 + 8*Mod(wi, 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"32 + s0 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) >= 0">, #wave.pred<"-1073741784 + s0 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) <= 0">] ["wi", "s0"](%40, %190) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %224 = wave.assume %223 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %225 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%224) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %226 = wave.ptr_add %194, %225 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %227 = wave.ptr_add %112, %198 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %228 = wave.select %111, %226, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %229 = waveamd.dma_load_lds %228 -> %227 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %230 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %231 = wave.binary muli %230, %c32_i32 overflow<nsw> : i32, i32 -> i32
        %232 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%40, %230, %181, %231) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %233 = wave.assume %232 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %234 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%233) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %235 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%40, %230, %181, %231) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %236 = wave.assume %235 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %237 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%236) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %238 = wave.ptr_add %209, %234 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %239 = wave.ptr_add %115, %198 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %240 = wave.select %113, %238, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %241 = waveamd.dma_load_lds %240 -> %239 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %242 = wave.ptr_add %209, %237 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %243 = wave.ptr_add %115, %216 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %244 = wave.select %114, %242, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %245 = waveamd.dma_load_lds %244 -> %243 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %246 = wave.join %241, %245 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %247 = wave.join %229, %246 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %248 = wave.index_expr <"64 + s0 + 8*Mod(wi, 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"64 + s0 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) >= 0">, #wave.pred<"-1073741752 + s0 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) <= 0">] ["wi", "s0"](%40, %190) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %249 = wave.assume %248 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %250 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%249) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %251 = wave.ptr_add %194, %250 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %252 = wave.ptr_add %119, %198 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %253 = wave.select %118, %251, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %254 = waveamd.dma_load_lds %253 -> %252 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %255 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %256 = wave.binary muli %255, %c64_i32 overflow<nsw> : i32, i32 -> i32
        %257 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%40, %255, %181, %256) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %258 = wave.assume %257 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %259 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%258) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %260 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%40, %255, %181, %256) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
        %261 = wave.assume %260 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %262 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%261) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %263 = wave.ptr_add %209, %259 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %264 = wave.ptr_add %122, %198 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %265 = wave.select %120, %263, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %266 = waveamd.dma_load_lds %265 -> %264 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %267 = wave.ptr_add %209, %262 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %268 = wave.ptr_add %122, %216 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
        %269 = wave.select %121, %267, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
        %270 = waveamd.dma_load_lds %269 -> %268 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %271 = wave.join %266, %270 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %272 = wave.join %254, %271 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %273 = wave.issue_token %272 : !wave.mem.token -> !wave.mem.token
        %274 = wave.barrier %221, %247, %273 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %275 = wave.barrier %arg13 : (!wave.mem.token) -> !wave.mem.token
        %276 = wave.join %275, %274 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %277 = wave.index_expr <"8*floor(1/16*Mod(wi, 64)) + 32*floor(1/2*Mod(Mod(wi, 64), 16)) + 2112*Mod(floor(1/1024*wi), 2) + 1056*Mod(floor(1/512*wi), 2) + 256*Mod(floor(1/256*wi), 2) + 528*Mod(Mod(Mod(wi, 64), 16), 2)"> ["wi"](%40) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %278 = wave.ptr_add %38, %277 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value, %token = wave.load %278 after %276 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %279 = wave.binary addi %277, %3 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %280 = wave.ptr_add %38, %279 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_0, %token_1 = wave.load %280 after %276 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %281 = wave.binary addi %277, %2 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %282 = wave.ptr_add %38, %281 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_2, %token_3 = wave.load %282 after %276 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %283 = wave.binary addi %277, %1 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %284 = wave.ptr_add %38, %283 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_4, %token_5 = wave.load %284 after %276 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %285 = wave.join %token, %token_1, %token_3, %token_5 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %286 = wave.barrier %arg13 : (!wave.mem.token) -> !wave.mem.token
        %287 = wave.join %286, %274 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_6, %token_7 = wave.gather %39 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %288 = wave.extract %value_6[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %289 = wave.extract %value_6[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %290 = wave.extract %value_6[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %291 = wave.extract %value_6[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_8, %token_9 = wave.gather %39 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %292 = wave.extract %value_8[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %293 = wave.extract %value_8[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %294 = wave.extract %value_8[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %295 = wave.extract %value_8[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %296 = wave.pack %288, %289, %290, %291, %292, %293, %294, %295 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_10, %token_11 = wave.gather %39 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %297 = wave.extract %value_10[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %298 = wave.extract %value_10[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %299 = wave.extract %value_10[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %300 = wave.extract %value_10[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_12, %token_13 = wave.gather %39 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %301 = wave.extract %value_12[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %302 = wave.extract %value_12[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %303 = wave.extract %value_12[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %304 = wave.extract %value_12[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %305 = wave.pack %297, %298, %299, %300, %301, %302, %303, %304 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_14, %token_15 = wave.gather %39 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %306 = wave.extract %value_14[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %307 = wave.extract %value_14[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %308 = wave.extract %value_14[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %309 = wave.extract %value_14[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_16, %token_17 = wave.gather %39 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %310 = wave.extract %value_16[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %311 = wave.extract %value_16[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %312 = wave.extract %value_16[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %313 = wave.extract %value_16[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %314 = wave.pack %306, %307, %308, %309, %310, %311, %312, %313 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_18, %token_19 = wave.gather %39 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %315 = wave.extract %value_18[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %316 = wave.extract %value_18[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %317 = wave.extract %value_18[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %318 = wave.extract %value_18[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_20, %token_21 = wave.gather %39 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %287 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %319 = wave.extract %value_20[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %320 = wave.extract %value_20[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %321 = wave.extract %value_20[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %322 = wave.extract %value_20[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %323 = wave.pack %315, %316, %317, %318, %319, %320, %321, %322 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %324 = wave.join %token_7, %token_9, %token_11, %token_13, %token_15, %token_17, %token_19, %token_21 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %325 = wave.barrier %285, %324 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %326 = wave.binary divsi %40, %c256_i32 : !wave.simd<i32, 64>, i32 -> !wave.simd<i32, 64>
        %327 = wave.cmpi eq %326, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %328 = wave.cmpi ne %326, %0 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        wave.where %328 {
          %1585 = wave.barrier : () -> !wave.mem.token
        } : !wave.mask<64>
        waveamd.set_priority 0
        %329:27 = scf.for %arg14 = %c0_i32 to %123 step %c1_i32 iter_args(%arg15 = %value, %arg16 = %value_0, %arg17 = %value_2, %arg18 = %value_4, %arg19 = %296, %arg20 = %305, %arg21 = %314, %arg22 = %323, %arg23 = %27, %arg24 = %27, %arg25 = %27, %arg26 = %27, %arg27 = %27, %arg28 = %27, %arg29 = %27, %arg30 = %27, %arg31 = %27, %arg32 = %27, %arg33 = %27, %arg34 = %27, %arg35 = %27, %arg36 = %27, %arg37 = %27, %arg38 = %27, %arg39 = %272, %arg40 = %274, %arg41 = %325) -> (!wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
          %1585 = wave.binary remui %arg14, %c3_i32 : i32, i32 -> i32
          %1586 = wave.binary addi %arg14, %c1_i32 overflow<nsw, nuw> : i32, i32 -> i32
          %1587 = wave.binary remui %1586, %c3_i32 : i32, i32 -> i32
          %1588 = wave.binary addi %arg14, %c3_i32 overflow<nsw, nuw> : i32, i32 -> i32
          %1589 = wave.binary muli %1588, %c32_i32 overflow<nsw> : i32, i32 -> i32
          %1590 = waveamd.fragment_pack %arg15 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
          %1591 = waveamd.fragment_pack %arg16 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
          %1592 = waveamd.fragment_pack %arg17 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
          %1593 = waveamd.fragment_pack %arg18 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
          %1594 = waveamd.fragment_pack %arg19 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
          %1595 = waveamd.fragment_pack %arg20 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
          %1596 = waveamd.fragment_pack %arg21 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
          %1597 = waveamd.fragment_pack %arg22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
          %1598 = waveamd.fragment_pack %arg23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1599 = waveamd.fragment_pack %arg24 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1600 = waveamd.fragment_pack %arg25 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1601 = waveamd.fragment_pack %arg26 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1602 = waveamd.fragment_pack %arg27 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1603 = waveamd.fragment_pack %arg28 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1604 = waveamd.fragment_pack %arg29 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1605 = waveamd.fragment_pack %arg30 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1606 = waveamd.fragment_pack %arg31 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1607 = waveamd.fragment_pack %arg32 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1608 = waveamd.fragment_pack %arg33 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1609 = waveamd.fragment_pack %arg34 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1610 = waveamd.fragment_pack %arg35 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1611 = waveamd.fragment_pack %arg36 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1612 = waveamd.fragment_pack %arg37 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1613 = waveamd.fragment_pack %arg38 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1614 = waveamd.mma "mfma.f32.16x16x32.f16" %1594, %1590, %1598 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1615 = waveamd.fragment_unpack %1614 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1616 = waveamd.mma "mfma.f32.16x16x32.f16" %1595, %1590, %1599 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1617 = waveamd.fragment_unpack %1616 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1618 = waveamd.mma "mfma.f32.16x16x32.f16" %1596, %1590, %1600 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1619 = waveamd.fragment_unpack %1618 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1620 = waveamd.mma "mfma.f32.16x16x32.f16" %1597, %1590, %1601 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1621 = waveamd.fragment_unpack %1620 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1622 = waveamd.mma "mfma.f32.16x16x32.f16" %1594, %1591, %1602 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1623 = waveamd.fragment_unpack %1622 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1624 = waveamd.mma "mfma.f32.16x16x32.f16" %1595, %1591, %1603 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1625 = waveamd.fragment_unpack %1624 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1626 = waveamd.mma "mfma.f32.16x16x32.f16" %1596, %1591, %1604 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1627 = waveamd.fragment_unpack %1626 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1628 = waveamd.mma "mfma.f32.16x16x32.f16" %1597, %1591, %1605 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1629 = waveamd.fragment_unpack %1628 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1630 = waveamd.mma "mfma.f32.16x16x32.f16" %1594, %1592, %1606 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1631 = waveamd.fragment_unpack %1630 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1632 = waveamd.mma "mfma.f32.16x16x32.f16" %1595, %1592, %1607 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1633 = waveamd.fragment_unpack %1632 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1634 = waveamd.mma "mfma.f32.16x16x32.f16" %1596, %1592, %1608 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1635 = waveamd.fragment_unpack %1634 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1636 = waveamd.mma "mfma.f32.16x16x32.f16" %1597, %1592, %1609 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1637 = waveamd.fragment_unpack %1636 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1638 = waveamd.mma "mfma.f32.16x16x32.f16" %1594, %1593, %1610 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1639 = waveamd.fragment_unpack %1638 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1640 = waveamd.mma "mfma.f32.16x16x32.f16" %1595, %1593, %1611 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1641 = waveamd.fragment_unpack %1640 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1642 = waveamd.mma "mfma.f32.16x16x32.f16" %1596, %1593, %1612 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1643 = waveamd.fragment_unpack %1642 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          %1644 = waveamd.mma "mfma.f32.16x16x32.f16" %1597, %1593, %1613 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
          %1645 = waveamd.fragment_unpack %1644 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
          waveamd.set_priority 1
          wave.sched_barrier
          %1646 = wave.barrier %arg41 : (!wave.mem.token) -> !wave.mem.token
          wave.sched_barrier
          %1647 = wave.binary subi %26, %1589 : i32, i32 -> i32
          %1648 = wave.splat %1647 : i32 -> !wave.simd<i32, 64>
          %1649 = wave.cmpi slt %93, %1648 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
          %1650 = wave.binary muli %1585, %c2112_i32 overflow<nsw> : i32, i32 -> i32
          %1651 = wave.index_expr <"s0 + s1 + 8*Mod(wi, 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s0 + s1 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) >= 0">, #wave.pred<"-1073741816 + s0 + s1 + xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)) <= 0">] ["wi", "s0", "s1"](%40, %190, %1589) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
          %1652 = wave.assume %1651 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
          %1653 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1652) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
          %1654 = wave.ptr_add %194, %1653 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
          %1655 = wave.ptr_add %199, %1650 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
          %1656 = wave.select %1649, %1654, %200 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
          %1657 = waveamd.dma_load_lds %1656 -> %1655 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          %1658 = wave.cmpi slt %101, %1648 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
          %1659 = wave.cmpi slt %105, %1648 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
          %1660 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
          %1661 = wave.binary muli %1589, %1660 overflow<nsw> : i32, i32 -> i32
          %1662 = wave.binary muli %1585, %c4224_i32 overflow<nsw> : i32, i32 -> i32
          %1663 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%40, %1660, %181, %1661) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
          %1664 = wave.assume %1663 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
          %1665 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1664) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
          %1666 = wave.index_expr <"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(Mod(floor(1/64*wi), 2) + 16*Mod(floor(1/32*wi), 2), 2*Mod(floor(1/128*wi), 2))))"> assuming [#wave.pred<"s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(4*Mod(1 + floor(1/512*wi), 2), xor(8*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(16*Mod(floor(1/32*wi), 2), Mod(floor(1/64*wi), 2))))) <= 0">] ["wi", "s0", "s1", "s2"](%40, %1660, %181, %1661) : (!wave.simd<i32, 64>, i32, !wave.simd<i32, 64>, i32) -> !wave.simd<index, 64>
          %1667 = wave.assume %1666 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
          %1668 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%1667) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
          %1669 = wave.ptr_add %209, %1665 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
          %1670 = wave.ptr_add %211, %1662 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
          %1671 = wave.select %1658, %1669, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
          %1672 = waveamd.dma_load_lds %1671 -> %1670 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          %1673 = wave.ptr_add %209, %1668 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
          %1674 = wave.ptr_add %217, %1662 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
          %1675 = wave.select %1659, %1673, %212 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
          %1676 = waveamd.dma_load_lds %1675 -> %1674 after %136 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
          %1677 = wave.join %1672, %1676 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
          %1678 = wave.join %1657, %1677 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
          %1679 = wave.binary muli %1587, %c4224_i32 overflow<nsw> : i32, i32 -> i32
          %1680 = wave.ptr_add %38, %1679 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
          %1681 = wave.barrier %1646 : (!wave.mem.token) -> !wave.mem.token
          %1682 = wave.join %275, %arg39, %arg40 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
          %1683 = wave.ptr_add %1680, %277 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
          %value_74, %token_75 = wave.load %1683 after %1682 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
          %1684 = wave.ptr_add %1680, %279 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
          %value_76, %token_77 = wave.load %1684 after %1682 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
          %1685 = wave.ptr_add %1680, %281 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
          %value_78, %token_79 = wave.load %1685 after %1682 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
          %1686 = wave.ptr_add %1680, %283 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
          %value_80, %token_81 = wave.load %1686 after %1682 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
          %1687 = wave.join %token_75, %token_77, %token_79, %token_81 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
          %1688 = wave.binary muli %1587, %c8448_i32 overflow<nsw> : i32, i32 -> i32
          %1689 = wave.ptr_add %39, %1688 : !wave.ptr<#wave.shared, f16>, i32 -> !wave.ptr<#wave.shared, f16>
          %1690 = wave.join %286, %arg39, %arg40 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
          %value_82, %token_83 = wave.gather %1689 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1691 = wave.extract %value_82[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1692 = wave.extract %value_82[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1693 = wave.extract %value_82[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1694 = wave.extract %value_82[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %value_84, %token_85 = wave.gather %1689 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1695 = wave.extract %value_84[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1696 = wave.extract %value_84[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1697 = wave.extract %value_84[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1698 = wave.extract %value_84[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1699 = wave.pack %1691, %1692, %1693, %1694, %1695, %1696, %1697, %1698 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
          %value_86, %token_87 = wave.gather %1689 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1700 = wave.extract %value_86[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1701 = wave.extract %value_86[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1702 = wave.extract %value_86[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1703 = wave.extract %value_86[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %value_88, %token_89 = wave.gather %1689 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1704 = wave.extract %value_88[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1705 = wave.extract %value_88[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1706 = wave.extract %value_88[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1707 = wave.extract %value_88[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1708 = wave.pack %1700, %1701, %1702, %1703, %1704, %1705, %1706, %1707 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
          %value_90, %token_91 = wave.gather %1689 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1709 = wave.extract %value_90[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1710 = wave.extract %value_90[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1711 = wave.extract %value_90[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1712 = wave.extract %value_90[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %value_92, %token_93 = wave.gather %1689 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1713 = wave.extract %value_92[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1714 = wave.extract %value_92[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1715 = wave.extract %value_92[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1716 = wave.extract %value_92[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1717 = wave.pack %1709, %1710, %1711, %1712, %1713, %1714, %1715, %1716 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
          %value_94, %token_95 = wave.gather %1689 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1718 = wave.extract %value_94[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1719 = wave.extract %value_94[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1720 = wave.extract %value_94[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1721 = wave.extract %value_94[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %value_96, %token_97 = wave.gather %1689 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %1690 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
          %1722 = wave.extract %value_96[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1723 = wave.extract %value_96[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1724 = wave.extract %value_96[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1725 = wave.extract %value_96[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
          %1726 = wave.pack %1718, %1719, %1720, %1721, %1722, %1723, %1724, %1725 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
          %1727 = wave.join %token_83, %token_85, %token_87, %token_89, %token_91, %token_93, %token_95, %token_97 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
          waveamd.set_priority 0
          wave.sched_barrier
          %1728 = wave.issue_token %1678 : !wave.mem.token -> !wave.mem.token
          %1729 = wave.barrier %arg39, %1728, %1681, %1687, %1727 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
          wave.sched_barrier
          scf.yield %value_74, %value_76, %value_78, %value_80, %1699, %1708, %1717, %1726, %1615, %1617, %1619, %1621, %1623, %1625, %1627, %1629, %1631, %1633, %1635, %1637, %1639, %1641, %1643, %1645, %1678, %1729, %136 : !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<8xf16>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token
        }
        waveamd.set_priority 0
        wave.where %327 {
          %1585 = wave.barrier : () -> !wave.mem.token
        } : !wave.mask<64>
        %330 = waveamd.fragment_pack %329#0 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %331 = waveamd.fragment_pack %329#1 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %332 = waveamd.fragment_pack %329#2 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %333 = waveamd.fragment_pack %329#3 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %334 = waveamd.fragment_pack %329#4 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %335 = waveamd.fragment_pack %329#5 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %336 = waveamd.fragment_pack %329#6 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %337 = waveamd.fragment_pack %329#7 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %338 = waveamd.fragment_pack %329#8 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %339 = waveamd.fragment_pack %329#9 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %340 = waveamd.fragment_pack %329#10 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %341 = waveamd.fragment_pack %329#11 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %342 = waveamd.fragment_pack %329#12 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %343 = waveamd.fragment_pack %329#13 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %344 = waveamd.fragment_pack %329#14 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %345 = waveamd.fragment_pack %329#15 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %346 = waveamd.fragment_pack %329#16 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %347 = waveamd.fragment_pack %329#17 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %348 = waveamd.fragment_pack %329#18 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %349 = waveamd.fragment_pack %329#19 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %350 = waveamd.fragment_pack %329#20 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %351 = waveamd.fragment_pack %329#21 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %352 = waveamd.fragment_pack %329#22 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %353 = waveamd.fragment_pack %329#23 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %354 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %330, %338 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %355 = waveamd.fragment_unpack %354 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %356 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %330, %339 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %357 = waveamd.fragment_unpack %356 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %358 = waveamd.mma "mfma.f32.16x16x32.f16" %336, %330, %340 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %359 = waveamd.fragment_unpack %358 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %360 = waveamd.mma "mfma.f32.16x16x32.f16" %337, %330, %341 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %361 = waveamd.fragment_unpack %360 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %362 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %331, %342 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %363 = waveamd.fragment_unpack %362 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %364 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %331, %343 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %365 = waveamd.fragment_unpack %364 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %366 = waveamd.mma "mfma.f32.16x16x32.f16" %336, %331, %344 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %367 = waveamd.fragment_unpack %366 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %368 = waveamd.mma "mfma.f32.16x16x32.f16" %337, %331, %345 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %369 = waveamd.fragment_unpack %368 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %370 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %332, %346 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %371 = waveamd.fragment_unpack %370 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %372 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %332, %347 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %373 = waveamd.fragment_unpack %372 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %374 = waveamd.mma "mfma.f32.16x16x32.f16" %336, %332, %348 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %375 = waveamd.fragment_unpack %374 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %376 = waveamd.mma "mfma.f32.16x16x32.f16" %337, %332, %349 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %377 = waveamd.fragment_unpack %376 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %378 = waveamd.mma "mfma.f32.16x16x32.f16" %334, %333, %350 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %379 = waveamd.fragment_unpack %378 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %380 = waveamd.mma "mfma.f32.16x16x32.f16" %335, %333, %351 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %381 = waveamd.fragment_unpack %380 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %382 = waveamd.mma "mfma.f32.16x16x32.f16" %336, %333, %352 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %383 = waveamd.fragment_unpack %382 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %384 = waveamd.mma "mfma.f32.16x16x32.f16" %337, %333, %353 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %385 = waveamd.fragment_unpack %384 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %386 = wave.barrier %329#24, %329#26 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %387 = wave.barrier %272, %247, %221 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %388 = wave.join %329#25, %275, %329#24, %387, %386 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %389 = wave.ptr_add %127, %277 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_22, %token_23 = wave.load %389 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %390 = wave.ptr_add %127, %279 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_24, %token_25 = wave.load %390 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %391 = wave.ptr_add %127, %281 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_26, %token_27 = wave.load %391 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %392 = wave.ptr_add %127, %283 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_28, %token_29 = wave.load %392 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %393 = wave.join %token_23, %token_25, %token_27, %token_29 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %394 = wave.barrier %272, %247, %221 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %395 = wave.join %329#25, %286, %329#24, %394, %386 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_30, %token_31 = wave.gather %129 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %396 = wave.extract %value_30[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %397 = wave.extract %value_30[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %398 = wave.extract %value_30[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %399 = wave.extract %value_30[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_32, %token_33 = wave.gather %129 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %400 = wave.extract %value_32[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %401 = wave.extract %value_32[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %402 = wave.extract %value_32[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %403 = wave.extract %value_32[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %404 = wave.pack %396, %397, %398, %399, %400, %401, %402, %403 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_34, %token_35 = wave.gather %129 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %405 = wave.extract %value_34[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %406 = wave.extract %value_34[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %407 = wave.extract %value_34[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %408 = wave.extract %value_34[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_36, %token_37 = wave.gather %129 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %409 = wave.extract %value_36[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %410 = wave.extract %value_36[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %411 = wave.extract %value_36[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %412 = wave.extract %value_36[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %413 = wave.pack %405, %406, %407, %408, %409, %410, %411, %412 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_38, %token_39 = wave.gather %129 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %414 = wave.extract %value_38[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %415 = wave.extract %value_38[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %416 = wave.extract %value_38[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %417 = wave.extract %value_38[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_40, %token_41 = wave.gather %129 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %418 = wave.extract %value_40[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %419 = wave.extract %value_40[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %420 = wave.extract %value_40[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %421 = wave.extract %value_40[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %422 = wave.pack %414, %415, %416, %417, %418, %419, %420, %421 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_42, %token_43 = wave.gather %129 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %423 = wave.extract %value_42[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %424 = wave.extract %value_42[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %425 = wave.extract %value_42[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %426 = wave.extract %value_42[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_44, %token_45 = wave.gather %129 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %427 = wave.extract %value_44[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %428 = wave.extract %value_44[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %429 = wave.extract %value_44[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %430 = wave.extract %value_44[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %431 = wave.pack %423, %424, %425, %426, %427, %428, %429, %430 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %432 = wave.join %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %433 = waveamd.fragment_pack %value_22 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %434 = waveamd.fragment_pack %value_24 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %435 = waveamd.fragment_pack %value_26 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %436 = waveamd.fragment_pack %value_28 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %437 = waveamd.fragment_pack %404 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %438 = waveamd.fragment_pack %413 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %439 = waveamd.fragment_pack %422 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %440 = waveamd.fragment_pack %431 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %441 = waveamd.fragment_pack %355 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %442 = waveamd.fragment_pack %357 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %443 = waveamd.fragment_pack %359 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %444 = waveamd.fragment_pack %361 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %445 = waveamd.fragment_pack %363 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %446 = waveamd.fragment_pack %365 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %447 = waveamd.fragment_pack %367 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %448 = waveamd.fragment_pack %369 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %449 = waveamd.fragment_pack %371 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %450 = waveamd.fragment_pack %373 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %451 = waveamd.fragment_pack %375 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %452 = waveamd.fragment_pack %377 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %453 = waveamd.fragment_pack %379 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %454 = waveamd.fragment_pack %381 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %455 = waveamd.fragment_pack %383 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %456 = waveamd.fragment_pack %385 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %457 = waveamd.mma "mfma.f32.16x16x32.f16" %437, %433, %441 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %458 = waveamd.fragment_unpack %457 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %459 = waveamd.mma "mfma.f32.16x16x32.f16" %438, %433, %442 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %460 = waveamd.fragment_unpack %459 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %461 = waveamd.mma "mfma.f32.16x16x32.f16" %439, %433, %443 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %462 = waveamd.fragment_unpack %461 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %463 = waveamd.mma "mfma.f32.16x16x32.f16" %440, %433, %444 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %464 = waveamd.fragment_unpack %463 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %465 = waveamd.mma "mfma.f32.16x16x32.f16" %437, %434, %445 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %466 = waveamd.fragment_unpack %465 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %467 = waveamd.mma "mfma.f32.16x16x32.f16" %438, %434, %446 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %468 = waveamd.fragment_unpack %467 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %469 = waveamd.mma "mfma.f32.16x16x32.f16" %439, %434, %447 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %470 = waveamd.fragment_unpack %469 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %471 = waveamd.mma "mfma.f32.16x16x32.f16" %440, %434, %448 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %472 = waveamd.fragment_unpack %471 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %473 = waveamd.mma "mfma.f32.16x16x32.f16" %437, %435, %449 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %474 = waveamd.fragment_unpack %473 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %475 = waveamd.mma "mfma.f32.16x16x32.f16" %438, %435, %450 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %476 = waveamd.fragment_unpack %475 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %477 = waveamd.mma "mfma.f32.16x16x32.f16" %439, %435, %451 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %478 = waveamd.fragment_unpack %477 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %479 = waveamd.mma "mfma.f32.16x16x32.f16" %440, %435, %452 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %480 = waveamd.fragment_unpack %479 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %481 = waveamd.mma "mfma.f32.16x16x32.f16" %437, %436, %453 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %482 = waveamd.fragment_unpack %481 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %483 = waveamd.mma "mfma.f32.16x16x32.f16" %438, %436, %454 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %484 = waveamd.fragment_unpack %483 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %485 = waveamd.mma "mfma.f32.16x16x32.f16" %439, %436, %455 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %486 = waveamd.fragment_unpack %485 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %487 = waveamd.mma "mfma.f32.16x16x32.f16" %440, %436, %456 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %488 = waveamd.fragment_unpack %487 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %489 = wave.ptr_add %133, %277 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_46, %token_47 = wave.load %489 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %490 = wave.ptr_add %133, %279 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_48, %token_49 = wave.load %490 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %491 = wave.ptr_add %133, %281 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_50, %token_51 = wave.load %491 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %492 = wave.ptr_add %133, %283 : !wave.ptr<#wave.shared, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, f16>, 64>
        %value_52, %token_53 = wave.load %492 after %388 : (!wave.simd<!wave.ptr<#wave.shared, f16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %493 = wave.join %token_47, %token_49, %token_51, %token_53 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_54, %token_55 = wave.gather %135 mapping <bit_offset = <"16*(256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %494 = wave.extract %value_54[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %495 = wave.extract %value_54[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %496 = wave.extract %value_54[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %497 = wave.extract %value_54[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_56, %token_57 = wave.gather %135 mapping <bit_offset = <"16*(4224 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %498 = wave.extract %value_56[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %499 = wave.extract %value_56[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %500 = wave.extract %value_56[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %501 = wave.extract %value_56[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %502 = wave.pack %494, %495, %496, %497, %498, %499, %500, %501 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_58, %token_59 = wave.gather %135 mapping <bit_offset = <"16*(64 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %503 = wave.extract %value_58[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %504 = wave.extract %value_58[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %505 = wave.extract %value_58[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %506 = wave.extract %value_58[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_60, %token_61 = wave.gather %135 mapping <bit_offset = <"16*(4288 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %507 = wave.extract %value_60[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %508 = wave.extract %value_60[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %509 = wave.extract %value_60[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %510 = wave.extract %value_60[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %511 = wave.pack %503, %504, %505, %506, %507, %508, %509, %510 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_62, %token_63 = wave.gather %135 mapping <bit_offset = <"16*(128 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %512 = wave.extract %value_62[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %513 = wave.extract %value_62[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %514 = wave.extract %value_62[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %515 = wave.extract %value_62[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_64, %token_65 = wave.gather %135 mapping <bit_offset = <"16*(4352 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %516 = wave.extract %value_64[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %517 = wave.extract %value_64[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %518 = wave.extract %value_64[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %519 = wave.extract %value_64[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %520 = wave.pack %512, %513, %514, %515, %516, %517, %518, %519 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %value_66, %token_67 = wave.gather %135 mapping <bit_offset = <"16*(192 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %521 = wave.extract %value_66[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %522 = wave.extract %value_66[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %523 = wave.extract %value_66[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %524 = wave.extract %value_66[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %value_68, %token_69 = wave.gather %135 mapping <bit_offset = <"16*(4416 + 256*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 528*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + 16*Mod(floor(1/64*item + 1/16*slot + 1/64*floor(1/4*Mod(Mod(item, 64), 16)) - 1/64*Mod(Mod(item, 64), 16)), 4) + 2112*Mod(floor(1/16*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)), 2) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %395 : (!wave.ptr<#wave.shared, f16>, !wave.mem.token) -> (!wave.simd<vector<4xf16>, 64>, !wave.mem.token)
        %525 = wave.extract %value_68[0] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %526 = wave.extract %value_68[1] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %527 = wave.extract %value_68[2] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %528 = wave.extract %value_68[3] : !wave.simd<vector<4xf16>, 64> -> !wave.simd<f16, 64>
        %529 = wave.pack %521, %522, %523, %524, %525, %526, %527, %528 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<8xf16>, 64>
        %530 = wave.join %token_55, %token_57, %token_59, %token_61, %token_63, %token_65, %token_67, %token_69 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %531 = waveamd.fragment_pack %value_46 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %532 = waveamd.fragment_pack %value_48 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %533 = waveamd.fragment_pack %value_50 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %534 = waveamd.fragment_pack %value_52 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<1, f16, 16, 16, 64, 4>
        %535 = waveamd.fragment_pack %502 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %536 = waveamd.fragment_pack %511 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %537 = waveamd.fragment_pack %520 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %538 = waveamd.fragment_pack %529 : !wave.simd<vector<8xf16>, 64> -> !waveamd.fragment<0, f16, 16, 16, 64, 4>
        %539 = waveamd.fragment_pack %458 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %540 = waveamd.fragment_pack %460 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %541 = waveamd.fragment_pack %462 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %542 = waveamd.fragment_pack %464 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %543 = waveamd.fragment_pack %466 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %544 = waveamd.fragment_pack %468 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %545 = waveamd.fragment_pack %470 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %546 = waveamd.fragment_pack %472 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %547 = waveamd.fragment_pack %474 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %548 = waveamd.fragment_pack %476 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %549 = waveamd.fragment_pack %478 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %550 = waveamd.fragment_pack %480 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %551 = waveamd.fragment_pack %482 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %552 = waveamd.fragment_pack %484 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %553 = waveamd.fragment_pack %486 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %554 = waveamd.fragment_pack %488 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %555 = waveamd.mma "mfma.f32.16x16x32.f16" %535, %531, %539 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %556 = waveamd.fragment_unpack %555 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %557 = waveamd.mma "mfma.f32.16x16x32.f16" %536, %531, %540 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %558 = waveamd.fragment_unpack %557 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %559 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %531, %541 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %560 = waveamd.fragment_unpack %559 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %561 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %531, %542 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %562 = waveamd.fragment_unpack %561 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %563 = waveamd.mma "mfma.f32.16x16x32.f16" %535, %532, %543 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %564 = waveamd.fragment_unpack %563 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %565 = waveamd.mma "mfma.f32.16x16x32.f16" %536, %532, %544 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %566 = waveamd.fragment_unpack %565 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %567 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %532, %545 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %568 = waveamd.fragment_unpack %567 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %569 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %532, %546 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %570 = waveamd.fragment_unpack %569 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %571 = waveamd.mma "mfma.f32.16x16x32.f16" %535, %533, %547 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %572 = waveamd.fragment_unpack %571 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %573 = waveamd.mma "mfma.f32.16x16x32.f16" %536, %533, %548 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %574 = waveamd.fragment_unpack %573 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %575 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %533, %549 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %576 = waveamd.fragment_unpack %575 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %577 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %533, %550 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %578 = waveamd.fragment_unpack %577 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %579 = waveamd.mma "mfma.f32.16x16x32.f16" %535, %534, %551 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %580 = waveamd.fragment_unpack %579 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %581 = waveamd.mma "mfma.f32.16x16x32.f16" %536, %534, %552 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %582 = waveamd.fragment_unpack %581 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %583 = waveamd.mma "mfma.f32.16x16x32.f16" %537, %534, %553 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %584 = waveamd.fragment_unpack %583 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %585 = waveamd.mma "mfma.f32.16x16x32.f16" %538, %534, %554 : !waveamd.fragment<0, f16, 16, 16, 64, 4>, !waveamd.fragment<1, f16, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %586 = waveamd.fragment_unpack %585 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %587 = wave.barrier %393, %493, %432, %530 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %588 = wave.pack %556, %558, %560, %562, %564, %566, %568, %570, %572, %574, %576, %578, %580, %582, %584, %586 : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<64xf32>, 64>
        %589 = wave.redistribute %588, <blocks = 1, items = 512, source_block = "0", source_item = "64*xor(2*Mod(floor(1/4*Mod(item, 64)), 2), xor(4*Mod(floor(1/8*slot), 2), Mod(floor(1/2*Mod(item, 64)), 2))) + xor(8*Mod(floor(1/256*item), 2), xor(4*Mod(floor(1/128*item), 2), xor(2*Mod(floor(1/64*item), 2), xor(Mod(floor(1/32*Mod(item, 64)), 2), xor(16*Mod(floor(1/4*slot), 2), 32*Mod(Mod(item, 64), 2))))))", source_slot = "xor(8*Mod(floor(1/16*Mod(item, 64)), 2), xor(4*Mod(floor(1/8*Mod(item, 64)), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2))))))"> : !wave.simd<vector<64xf32>, 64> -> !wave.simd<vector<64xf32>, 64>
        %590 = wave.extract %589[0] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %591 = wave.extract %589[1] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %592 = wave.extract %589[2] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %593 = wave.extract %589[3] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %594 = wave.extract %589[4] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %595 = wave.extract %589[5] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %596 = wave.extract %589[6] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %597 = wave.extract %589[7] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %598 = wave.extract %589[8] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %599 = wave.extract %589[9] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %600 = wave.extract %589[10] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %601 = wave.extract %589[11] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %602 = wave.extract %589[12] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %603 = wave.extract %589[13] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %604 = wave.extract %589[14] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %605 = wave.extract %589[15] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %606 = wave.extract %589[16] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %607 = wave.extract %589[17] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %608 = wave.extract %589[18] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %609 = wave.extract %589[19] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %610 = wave.extract %589[20] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %611 = wave.extract %589[21] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %612 = wave.extract %589[22] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %613 = wave.extract %589[23] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %614 = wave.extract %589[24] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %615 = wave.extract %589[25] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %616 = wave.extract %589[26] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %617 = wave.extract %589[27] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %618 = wave.extract %589[28] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %619 = wave.extract %589[29] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %620 = wave.extract %589[30] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %621 = wave.extract %589[31] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %622 = wave.extract %589[32] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %623 = wave.extract %589[33] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %624 = wave.extract %589[34] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %625 = wave.extract %589[35] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %626 = wave.extract %589[36] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %627 = wave.extract %589[37] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %628 = wave.extract %589[38] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %629 = wave.extract %589[39] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %630 = wave.extract %589[40] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %631 = wave.extract %589[41] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %632 = wave.extract %589[42] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %633 = wave.extract %589[43] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %634 = wave.extract %589[44] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %635 = wave.extract %589[45] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %636 = wave.extract %589[46] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %637 = wave.extract %589[47] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %638 = wave.extract %589[48] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %639 = wave.extract %589[49] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %640 = wave.extract %589[50] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %641 = wave.extract %589[51] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %642 = wave.extract %589[52] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %643 = wave.extract %589[53] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %644 = wave.extract %589[54] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %645 = wave.extract %589[55] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %646 = wave.extract %589[56] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %647 = wave.extract %589[57] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %648 = wave.extract %589[58] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %649 = wave.extract %589[59] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %650 = wave.extract %589[60] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %651 = wave.extract %589[61] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %652 = wave.extract %589[62] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %653 = wave.extract %589[63] : !wave.simd<vector<64xf32>, 64> -> !wave.simd<f32, 64>
        %654 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%181) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %655 = wave.assume %654 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %656 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%655) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %657 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%182) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %658 = wave.assume %657 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %659 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%658) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %660 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%183) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %661 = wave.assume %660 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %662 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%661) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %663 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%184) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %664 = wave.assume %663 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %665 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%664) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %666 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%185) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %667 = wave.assume %666 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %668 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%667) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %669 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%186) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %670 = wave.assume %669 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %671 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%670) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %672 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%187) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %673 = wave.assume %672 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %674 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%673) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %675 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%188) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %676 = wave.assume %675 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %677 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%676) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %678 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
        %value_70, %token_71 = wave.gather %678 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%656, %659, %662, %665, %668, %671, %674, %677) : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<8xf16>, 64>, !wave.mem.token)
        %679 = wave.extract %value_70[0] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %680 = wave.extract %value_70[1] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %681 = wave.extract %value_70[2] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %682 = wave.extract %value_70[3] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %683 = wave.extract %value_70[4] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %684 = wave.extract %value_70[5] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %685 = wave.extract %value_70[6] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %686 = wave.extract %value_70[7] : !wave.simd<vector<8xf16>, 64> -> !wave.simd<f16, 64>
        %687 = wave.cast fpconvert %679 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %688 = wave.cast fpconvert %680 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %689 = wave.cast fpconvert %681 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %690 = wave.cast fpconvert %682 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %691 = wave.cast fpconvert %683 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %692 = wave.cast fpconvert %684 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %693 = wave.cast fpconvert %685 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %694 = wave.cast fpconvert %686 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %695 = wave.splat %30 : i32 -> !wave.simd<i32, 64>
        %696 = wave.binary muli %163, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %697 = wave.binary muli %164, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %698 = wave.binary muli %165, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %699 = wave.binary muli %166, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %700 = wave.binary muli %167, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %701 = wave.binary muli %168, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %702 = wave.binary muli %169, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %703 = wave.binary muli %170, %695 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %704 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %705 = wave.assume %704 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %706 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%705) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %707 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %708 = wave.assume %707 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %709 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%708) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %710 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %711 = wave.assume %710 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %712 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%711) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %713 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %714 = wave.assume %713 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %715 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%714) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %716 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %717 = wave.assume %716 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %718 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%717) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %719 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %720 = wave.assume %719 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %721 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%720) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %722 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %723 = wave.assume %722 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %724 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%723) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %725 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %696) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %726 = wave.assume %725 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %727 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%726) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %728 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %729 = wave.assume %728 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %730 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%729) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %731 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %732 = wave.assume %731 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %733 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%732) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %734 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %735 = wave.assume %734 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %736 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%735) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %737 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %738 = wave.assume %737 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %739 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%738) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %740 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %741 = wave.assume %740 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %742 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%741) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %743 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %744 = wave.assume %743 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %745 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%744) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %746 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %747 = wave.assume %746 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %748 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%747) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %749 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %697) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %750 = wave.assume %749 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %751 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%750) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %752 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %753 = wave.assume %752 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %754 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%753) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %755 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %756 = wave.assume %755 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %757 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%756) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %758 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %759 = wave.assume %758 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %760 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%759) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %761 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %762 = wave.assume %761 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %763 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%762) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %764 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %765 = wave.assume %764 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %766 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%765) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %767 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %768 = wave.assume %767 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %769 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%768) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %770 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %771 = wave.assume %770 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %772 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%771) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %773 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %698) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %774 = wave.assume %773 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %775 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%774) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %776 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %777 = wave.assume %776 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %778 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%777) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %779 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %780 = wave.assume %779 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %781 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%780) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %782 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %783 = wave.assume %782 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %784 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%783) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %785 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %786 = wave.assume %785 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %787 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%786) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %788 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %789 = wave.assume %788 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %790 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%789) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %791 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %792 = wave.assume %791 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %793 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%792) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %794 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %795 = wave.assume %794 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %796 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%795) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %797 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %699) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %798 = wave.assume %797 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %799 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%798) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %800 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %801 = wave.assume %800 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %802 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%801) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %803 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %804 = wave.assume %803 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %805 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%804) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %806 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %807 = wave.assume %806 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %808 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%807) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %809 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %810 = wave.assume %809 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %811 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%810) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %812 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %813 = wave.assume %812 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %814 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%813) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %815 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %816 = wave.assume %815 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %817 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%816) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %818 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %819 = wave.assume %818 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %820 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%819) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %821 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %700) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %822 = wave.assume %821 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %823 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%822) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %824 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %825 = wave.assume %824 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %826 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%825) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %827 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %828 = wave.assume %827 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %829 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%828) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %830 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %831 = wave.assume %830 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %832 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%831) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %833 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %834 = wave.assume %833 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %835 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%834) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %836 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %837 = wave.assume %836 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %838 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%837) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %839 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %840 = wave.assume %839 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %841 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%840) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %842 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %843 = wave.assume %842 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %844 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%843) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %845 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %701) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %846 = wave.assume %845 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %847 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%846) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %848 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %849 = wave.assume %848 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %850 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%849) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %851 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %852 = wave.assume %851 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %853 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%852) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %854 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %855 = wave.assume %854 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %856 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%855) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %857 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %858 = wave.assume %857 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %859 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%858) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %860 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %861 = wave.assume %860 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %862 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%861) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %863 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %864 = wave.assume %863 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %865 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%864) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %866 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %867 = wave.assume %866 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %868 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%867) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %869 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %702) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %870 = wave.assume %869 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %871 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%870) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %872 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%181, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %873 = wave.assume %872 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %874 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%873) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %875 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%182, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %876 = wave.assume %875 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %877 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%876) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %878 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%183, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %879 = wave.assume %878 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %880 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%879) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %881 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%184, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %882 = wave.assume %881 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %883 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%882) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %884 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%185, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %885 = wave.assume %884 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %886 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%885) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %887 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%186, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %888 = wave.assume %887 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %889 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%888) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %890 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%187, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %891 = wave.assume %890 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %892 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%891) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %893 = wave.index_expr <"s0 + s1"> assuming [#wave.pred<"s0 + s1 >= 0">, #wave.pred<"-1073741823 + s0 + s1 <= 0">] ["s0", "s1"](%188, %703) : (!wave.simd<i32, 64>, !wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %894 = wave.assume %893 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %895 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%894) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %896 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
        %value_72, %token_73 = wave.gather %896 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%706, %709, %712, %715, %718, %721, %724, %727, %730, %733, %736, %739, %742, %745, %748, %751, %754, %757, %760, %763, %766, %769, %772, %775, %778, %781, %784, %787, %790, %793, %796, %799, %802, %805, %808, %811, %814, %817, %820, %823, %826, %829, %832, %835, %838, %841, %844, %847, %850, %853, %856, %859, %862, %865, %868, %871, %874, %877, %880, %883, %886, %889, %892, %895) {cache = #waveamd.load_cache<cs>} : (!wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<64xf16>, 64>, !wave.mem.token)
        %897 = wave.extract %value_72[0] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %898 = wave.extract %value_72[1] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %899 = wave.extract %value_72[2] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %900 = wave.extract %value_72[3] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %901 = wave.extract %value_72[4] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %902 = wave.extract %value_72[5] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %903 = wave.extract %value_72[6] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %904 = wave.extract %value_72[7] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %905 = wave.extract %value_72[8] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %906 = wave.extract %value_72[9] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %907 = wave.extract %value_72[10] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %908 = wave.extract %value_72[11] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %909 = wave.extract %value_72[12] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %910 = wave.extract %value_72[13] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %911 = wave.extract %value_72[14] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %912 = wave.extract %value_72[15] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %913 = wave.extract %value_72[16] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %914 = wave.extract %value_72[17] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %915 = wave.extract %value_72[18] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %916 = wave.extract %value_72[19] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %917 = wave.extract %value_72[20] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %918 = wave.extract %value_72[21] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %919 = wave.extract %value_72[22] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %920 = wave.extract %value_72[23] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %921 = wave.extract %value_72[24] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %922 = wave.extract %value_72[25] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %923 = wave.extract %value_72[26] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %924 = wave.extract %value_72[27] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %925 = wave.extract %value_72[28] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %926 = wave.extract %value_72[29] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %927 = wave.extract %value_72[30] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %928 = wave.extract %value_72[31] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %929 = wave.extract %value_72[32] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %930 = wave.extract %value_72[33] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %931 = wave.extract %value_72[34] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %932 = wave.extract %value_72[35] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %933 = wave.extract %value_72[36] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %934 = wave.extract %value_72[37] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %935 = wave.extract %value_72[38] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %936 = wave.extract %value_72[39] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %937 = wave.extract %value_72[40] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %938 = wave.extract %value_72[41] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %939 = wave.extract %value_72[42] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %940 = wave.extract %value_72[43] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %941 = wave.extract %value_72[44] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %942 = wave.extract %value_72[45] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %943 = wave.extract %value_72[46] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %944 = wave.extract %value_72[47] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %945 = wave.extract %value_72[48] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %946 = wave.extract %value_72[49] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %947 = wave.extract %value_72[50] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %948 = wave.extract %value_72[51] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %949 = wave.extract %value_72[52] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %950 = wave.extract %value_72[53] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %951 = wave.extract %value_72[54] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %952 = wave.extract %value_72[55] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %953 = wave.extract %value_72[56] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %954 = wave.extract %value_72[57] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %955 = wave.extract %value_72[58] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %956 = wave.extract %value_72[59] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %957 = wave.extract %value_72[60] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %958 = wave.extract %value_72[61] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %959 = wave.extract %value_72[62] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %960 = wave.extract %value_72[63] : !wave.simd<vector<64xf16>, 64> -> !wave.simd<f16, 64>
        %961 = wave.cast fpconvert %897 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %962 = wave.cast fpconvert %898 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %963 = wave.cast fpconvert %899 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %964 = wave.cast fpconvert %900 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %965 = wave.cast fpconvert %901 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %966 = wave.cast fpconvert %902 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %967 = wave.cast fpconvert %903 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %968 = wave.cast fpconvert %904 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %969 = wave.cast fpconvert %905 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %970 = wave.cast fpconvert %906 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %971 = wave.cast fpconvert %907 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %972 = wave.cast fpconvert %908 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %973 = wave.cast fpconvert %909 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %974 = wave.cast fpconvert %910 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %975 = wave.cast fpconvert %911 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %976 = wave.cast fpconvert %912 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %977 = wave.cast fpconvert %913 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %978 = wave.cast fpconvert %914 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %979 = wave.cast fpconvert %915 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %980 = wave.cast fpconvert %916 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %981 = wave.cast fpconvert %917 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %982 = wave.cast fpconvert %918 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %983 = wave.cast fpconvert %919 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %984 = wave.cast fpconvert %920 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %985 = wave.cast fpconvert %921 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %986 = wave.cast fpconvert %922 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %987 = wave.cast fpconvert %923 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %988 = wave.cast fpconvert %924 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %989 = wave.cast fpconvert %925 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %990 = wave.cast fpconvert %926 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %991 = wave.cast fpconvert %927 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %992 = wave.cast fpconvert %928 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %993 = wave.cast fpconvert %929 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %994 = wave.cast fpconvert %930 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %995 = wave.cast fpconvert %931 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %996 = wave.cast fpconvert %932 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %997 = wave.cast fpconvert %933 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %998 = wave.cast fpconvert %934 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %999 = wave.cast fpconvert %935 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1000 = wave.cast fpconvert %936 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1001 = wave.cast fpconvert %937 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1002 = wave.cast fpconvert %938 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1003 = wave.cast fpconvert %939 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1004 = wave.cast fpconvert %940 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1005 = wave.cast fpconvert %941 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1006 = wave.cast fpconvert %942 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1007 = wave.cast fpconvert %943 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1008 = wave.cast fpconvert %944 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1009 = wave.cast fpconvert %945 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1010 = wave.cast fpconvert %946 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1011 = wave.cast fpconvert %947 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1012 = wave.cast fpconvert %948 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1013 = wave.cast fpconvert %949 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1014 = wave.cast fpconvert %950 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1015 = wave.cast fpconvert %951 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1016 = wave.cast fpconvert %952 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1017 = wave.cast fpconvert %953 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1018 = wave.cast fpconvert %954 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1019 = wave.cast fpconvert %955 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1020 = wave.cast fpconvert %956 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1021 = wave.cast fpconvert %957 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1022 = wave.cast fpconvert %958 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1023 = wave.cast fpconvert %959 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1024 = wave.cast fpconvert %960 : !wave.simd<f16, 64> -> !wave.simd<f32, 64>
        %1025 = wave.fadd %590, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1026 = wave.fadd %591, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1027 = wave.fadd %592, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1028 = wave.fadd %593, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1029 = wave.fadd %594, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1030 = wave.fadd %595, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1031 = wave.fadd %596, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1032 = wave.fadd %597, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1033 = wave.fadd %598, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1034 = wave.fadd %599, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1035 = wave.fadd %600, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1036 = wave.fadd %601, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1037 = wave.fadd %602, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1038 = wave.fadd %603, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1039 = wave.fadd %604, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1040 = wave.fadd %605, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1041 = wave.fadd %606, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1042 = wave.fadd %607, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1043 = wave.fadd %608, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1044 = wave.fadd %609, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1045 = wave.fadd %610, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1046 = wave.fadd %611, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1047 = wave.fadd %612, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1048 = wave.fadd %613, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1049 = wave.fadd %614, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1050 = wave.fadd %615, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1051 = wave.fadd %616, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1052 = wave.fadd %617, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1053 = wave.fadd %618, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1054 = wave.fadd %619, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1055 = wave.fadd %620, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1056 = wave.fadd %621, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1057 = wave.fadd %622, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1058 = wave.fadd %623, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1059 = wave.fadd %624, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1060 = wave.fadd %625, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1061 = wave.fadd %626, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1062 = wave.fadd %627, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1063 = wave.fadd %628, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1064 = wave.fadd %629, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1065 = wave.fadd %630, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1066 = wave.fadd %631, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1067 = wave.fadd %632, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1068 = wave.fadd %633, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1069 = wave.fadd %634, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1070 = wave.fadd %635, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1071 = wave.fadd %636, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1072 = wave.fadd %637, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1073 = wave.fadd %638, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1074 = wave.fadd %639, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1075 = wave.fadd %640, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1076 = wave.fadd %641, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1077 = wave.fadd %642, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1078 = wave.fadd %643, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1079 = wave.fadd %644, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1080 = wave.fadd %645, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1081 = wave.fadd %646, %687 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1082 = wave.fadd %647, %688 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1083 = wave.fadd %648, %689 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1084 = wave.fadd %649, %690 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1085 = wave.fadd %650, %691 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1086 = wave.fadd %651, %692 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1087 = wave.fadd %652, %693 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1088 = wave.fadd %653, %694 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1089 = wave.fma %1025, %961, %1025 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1090 = wave.fma %1026, %962, %1026 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1091 = wave.fma %1027, %963, %1027 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1092 = wave.fma %1028, %964, %1028 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1093 = wave.fma %1029, %965, %1029 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1094 = wave.fma %1030, %966, %1030 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1095 = wave.fma %1031, %967, %1031 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1096 = wave.fma %1032, %968, %1032 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1097 = wave.fma %1033, %969, %1033 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1098 = wave.fma %1034, %970, %1034 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1099 = wave.fma %1035, %971, %1035 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1100 = wave.fma %1036, %972, %1036 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1101 = wave.fma %1037, %973, %1037 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1102 = wave.fma %1038, %974, %1038 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1103 = wave.fma %1039, %975, %1039 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1104 = wave.fma %1040, %976, %1040 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1105 = wave.fma %1041, %977, %1041 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1106 = wave.fma %1042, %978, %1042 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1107 = wave.fma %1043, %979, %1043 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1108 = wave.fma %1044, %980, %1044 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1109 = wave.fma %1045, %981, %1045 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1110 = wave.fma %1046, %982, %1046 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1111 = wave.fma %1047, %983, %1047 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1112 = wave.fma %1048, %984, %1048 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1113 = wave.fma %1049, %985, %1049 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1114 = wave.fma %1050, %986, %1050 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1115 = wave.fma %1051, %987, %1051 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1116 = wave.fma %1052, %988, %1052 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1117 = wave.fma %1053, %989, %1053 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1118 = wave.fma %1054, %990, %1054 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1119 = wave.fma %1055, %991, %1055 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1120 = wave.fma %1056, %992, %1056 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1121 = wave.fma %1057, %993, %1057 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1122 = wave.fma %1058, %994, %1058 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1123 = wave.fma %1059, %995, %1059 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1124 = wave.fma %1060, %996, %1060 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1125 = wave.fma %1061, %997, %1061 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1126 = wave.fma %1062, %998, %1062 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1127 = wave.fma %1063, %999, %1063 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1128 = wave.fma %1064, %1000, %1064 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1129 = wave.fma %1065, %1001, %1065 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1130 = wave.fma %1066, %1002, %1066 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1131 = wave.fma %1067, %1003, %1067 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1132 = wave.fma %1068, %1004, %1068 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1133 = wave.fma %1069, %1005, %1069 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1134 = wave.fma %1070, %1006, %1070 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1135 = wave.fma %1071, %1007, %1071 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1136 = wave.fma %1072, %1008, %1072 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1137 = wave.fma %1073, %1009, %1073 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1138 = wave.fma %1074, %1010, %1074 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1139 = wave.fma %1075, %1011, %1075 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1140 = wave.fma %1076, %1012, %1076 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1141 = wave.fma %1077, %1013, %1077 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1142 = wave.fma %1078, %1014, %1078 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1143 = wave.fma %1079, %1015, %1079 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1144 = wave.fma %1080, %1016, %1080 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1145 = wave.fma %1081, %1017, %1081 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1146 = wave.fma %1082, %1018, %1082 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1147 = wave.fma %1083, %1019, %1083 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1148 = wave.fma %1084, %1020, %1084 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1149 = wave.fma %1085, %1021, %1085 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1150 = wave.fma %1086, %1022, %1086 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1151 = wave.fma %1087, %1023, %1087 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1152 = wave.fma %1088, %1024, %1088 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %1153 = wave.binary muli %57, %20 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1154 = wave.binary xori %53, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1155 = wave.binary muli %60, %21 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1156 = wave.binary xori %1154, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1157 = wave.binary xori %1156, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1158 = wave.binary addi %1157, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1159 = wave.binary xori %18, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1160 = wave.binary xori %1159, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1161 = wave.binary xori %1160, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1162 = wave.binary xori %1161, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1163 = wave.binary addi %1162, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1164 = wave.binary xori %17, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1165 = wave.binary xori %1164, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1166 = wave.binary xori %1165, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1167 = wave.binary xori %1166, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1168 = wave.binary addi %1167, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1169 = wave.binary xori %13, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1170 = wave.binary xori %1169, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1171 = wave.binary xori %1170, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1172 = wave.binary xori %1171, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1173 = wave.binary addi %1172, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1174 = wave.binary xori %16, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1175 = wave.binary xori %1174, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1176 = wave.binary xori %1175, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1177 = wave.binary xori %1176, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1178 = wave.binary addi %1177, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1179 = wave.binary xori %12, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1180 = wave.binary xori %1179, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1181 = wave.binary xori %1180, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1182 = wave.binary xori %1181, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1183 = wave.binary addi %1182, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1184 = wave.binary xori %11, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1185 = wave.binary xori %1184, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1186 = wave.binary xori %1185, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1187 = wave.binary xori %1186, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1188 = wave.binary addi %1187, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1189 = wave.binary xori %10, %53 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1190 = wave.binary xori %1189, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1191 = wave.binary xori %1190, %1155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1192 = wave.binary xori %1191, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1193 = wave.binary addi %1192, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1194 = wave.cmpi slt %1158, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1195 = wave.cmpi slt %1163, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1196 = wave.cmpi slt %1168, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1197 = wave.cmpi slt %1173, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1198 = wave.cmpi slt %1178, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1199 = wave.cmpi slt %1183, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1200 = wave.cmpi slt %1188, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1201 = wave.cmpi slt %1193, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1202 = wave.binary muli %42, %17 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1203 = wave.binary xori %93, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1204 = wave.binary muli %45, %16 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1205 = wave.binary xori %1203, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1206 = wave.binary muli %49, %15 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1207 = wave.binary xori %1205, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1208 = wave.binary addi %1207, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1209 = wave.binary xori %9, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1210 = wave.binary xori %1209, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1211 = wave.binary xori %1210, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1212 = wave.binary xori %1211, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1213 = wave.binary xori %1212, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1214 = wave.binary addi %1213, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1215 = wave.binary xori %20, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1216 = wave.binary xori %1215, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1217 = wave.binary xori %1216, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1218 = wave.binary xori %1217, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1219 = wave.binary xori %1218, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1220 = wave.binary addi %1219, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1221 = wave.binary xori %8, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1222 = wave.binary xori %1221, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1223 = wave.binary xori %1222, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1224 = wave.binary xori %1223, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1225 = wave.binary xori %1224, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1226 = wave.binary addi %1225, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1227 = wave.binary xori %21, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1228 = wave.binary xori %1227, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1229 = wave.binary xori %1228, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1230 = wave.binary xori %1229, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1231 = wave.binary xori %1230, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1232 = wave.binary addi %1231, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1233 = wave.binary xori %7, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1234 = wave.binary xori %1233, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1235 = wave.binary xori %1234, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1236 = wave.binary xori %1235, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1237 = wave.binary xori %1236, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1238 = wave.binary addi %1237, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1239 = wave.binary xori %6, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1240 = wave.binary xori %1239, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1241 = wave.binary xori %1240, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1242 = wave.binary xori %1241, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1243 = wave.binary xori %1242, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1244 = wave.binary addi %1243, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1245 = wave.binary xori %5, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1246 = wave.binary xori %1245, %92 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1247 = wave.binary xori %1246, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1248 = wave.binary xori %1247, %1204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1249 = wave.binary xori %1248, %1206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1250 = wave.binary addi %1249, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %1251 = wave.cmpi slt %1208, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1252 = wave.cmpi slt %1214, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1253 = wave.cmpi slt %1220, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1254 = wave.cmpi slt %1226, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1255 = wave.cmpi slt %1232, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1256 = wave.cmpi slt %1238, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1257 = wave.cmpi slt %1244, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1258 = wave.cmpi slt %1250, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %1259 = wave.select %1194, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1260 = wave.select %1194, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1261 = wave.select %1194, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1262 = wave.select %1194, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1263 = wave.select %1194, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1264 = wave.select %1194, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1265 = wave.select %1194, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1266 = wave.select %1194, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1267 = wave.select %1195, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1268 = wave.select %1195, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1269 = wave.select %1195, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1270 = wave.select %1195, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1271 = wave.select %1195, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1272 = wave.select %1195, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1273 = wave.select %1195, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1274 = wave.select %1195, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1275 = wave.select %1196, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1276 = wave.select %1196, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1277 = wave.select %1196, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1278 = wave.select %1196, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1279 = wave.select %1196, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1280 = wave.select %1196, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1281 = wave.select %1196, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1282 = wave.select %1196, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1283 = wave.select %1197, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1284 = wave.select %1197, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1285 = wave.select %1197, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1286 = wave.select %1197, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1287 = wave.select %1197, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1288 = wave.select %1197, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1289 = wave.select %1197, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1290 = wave.select %1197, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1291 = wave.select %1198, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1292 = wave.select %1198, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1293 = wave.select %1198, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1294 = wave.select %1198, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1295 = wave.select %1198, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1296 = wave.select %1198, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1297 = wave.select %1198, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1298 = wave.select %1198, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1299 = wave.select %1199, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1300 = wave.select %1199, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1301 = wave.select %1199, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1302 = wave.select %1199, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1303 = wave.select %1199, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1304 = wave.select %1199, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1305 = wave.select %1199, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1306 = wave.select %1199, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1307 = wave.select %1200, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1308 = wave.select %1200, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1309 = wave.select %1200, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1310 = wave.select %1200, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1311 = wave.select %1200, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1312 = wave.select %1200, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1313 = wave.select %1200, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1314 = wave.select %1200, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1315 = wave.select %1201, %1251, %22 : !wave.mask<64>, !wave.mask<64>
        %1316 = wave.select %1201, %1252, %22 : !wave.mask<64>, !wave.mask<64>
        %1317 = wave.select %1201, %1253, %22 : !wave.mask<64>, !wave.mask<64>
        %1318 = wave.select %1201, %1254, %22 : !wave.mask<64>, !wave.mask<64>
        %1319 = wave.select %1201, %1255, %22 : !wave.mask<64>, !wave.mask<64>
        %1320 = wave.select %1201, %1256, %22 : !wave.mask<64>, !wave.mask<64>
        %1321 = wave.select %1201, %1257, %22 : !wave.mask<64>, !wave.mask<64>
        %1322 = wave.select %1201, %1258, %22 : !wave.mask<64>, !wave.mask<64>
        %1323 = wave.assume %arg11 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %1324 = wave.binary muli %151, %1323 overflow<nsw> : i32, i32 -> i32
        %1325 = wave.binary addi %1324, %171 overflow<nsw> : i32, i32 -> i32
        %1326 = wave.cast fpconvert %1089 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1327 = wave.cast fpconvert %1090 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1328 = wave.cast fpconvert %1091 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1329 = wave.cast fpconvert %1092 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1330 = wave.cast fpconvert %1093 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1331 = wave.cast fpconvert %1094 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1332 = wave.cast fpconvert %1095 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1333 = wave.cast fpconvert %1096 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1334 = wave.cast fpconvert %1097 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1335 = wave.cast fpconvert %1098 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1336 = wave.cast fpconvert %1099 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1337 = wave.cast fpconvert %1100 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1338 = wave.cast fpconvert %1101 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1339 = wave.cast fpconvert %1102 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1340 = wave.cast fpconvert %1103 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1341 = wave.cast fpconvert %1104 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1342 = wave.cast fpconvert %1105 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1343 = wave.cast fpconvert %1106 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1344 = wave.cast fpconvert %1107 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1345 = wave.cast fpconvert %1108 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1346 = wave.cast fpconvert %1109 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1347 = wave.cast fpconvert %1110 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1348 = wave.cast fpconvert %1111 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1349 = wave.cast fpconvert %1112 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1350 = wave.cast fpconvert %1113 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1351 = wave.cast fpconvert %1114 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1352 = wave.cast fpconvert %1115 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1353 = wave.cast fpconvert %1116 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1354 = wave.cast fpconvert %1117 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1355 = wave.cast fpconvert %1118 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1356 = wave.cast fpconvert %1119 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1357 = wave.cast fpconvert %1120 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1358 = wave.cast fpconvert %1121 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1359 = wave.cast fpconvert %1122 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1360 = wave.cast fpconvert %1123 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1361 = wave.cast fpconvert %1124 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1362 = wave.cast fpconvert %1125 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1363 = wave.cast fpconvert %1126 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1364 = wave.cast fpconvert %1127 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1365 = wave.cast fpconvert %1128 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1366 = wave.cast fpconvert %1129 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1367 = wave.cast fpconvert %1130 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1368 = wave.cast fpconvert %1131 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1369 = wave.cast fpconvert %1132 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1370 = wave.cast fpconvert %1133 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1371 = wave.cast fpconvert %1134 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1372 = wave.cast fpconvert %1135 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1373 = wave.cast fpconvert %1136 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1374 = wave.cast fpconvert %1137 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1375 = wave.cast fpconvert %1138 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1376 = wave.cast fpconvert %1139 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1377 = wave.cast fpconvert %1140 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1378 = wave.cast fpconvert %1141 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1379 = wave.cast fpconvert %1142 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1380 = wave.cast fpconvert %1143 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1381 = wave.cast fpconvert %1144 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1382 = wave.cast fpconvert %1145 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1383 = wave.cast fpconvert %1146 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1384 = wave.cast fpconvert %1147 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1385 = wave.cast fpconvert %1148 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1386 = wave.cast fpconvert %1149 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1387 = wave.cast fpconvert %1150 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1388 = wave.cast fpconvert %1151 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1389 = wave.cast fpconvert %1152 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
        %1390 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1391 = wave.assume %1390 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1392 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1391) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1393 = wave.index_expr <"1 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1394 = wave.assume %1393 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1395 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1394) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1396 = wave.index_expr <"2 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1397 = wave.assume %1396 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1398 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1397) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1399 = wave.index_expr <"3 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1400 = wave.assume %1399 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1401 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1400) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1402 = wave.index_expr <"4 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1403 = wave.assume %1402 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1404 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1403) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1405 = wave.index_expr <"5 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1406 = wave.assume %1405 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1407 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1406) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1408 = wave.index_expr <"6 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1409 = wave.assume %1408 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1410 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1409) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1411 = wave.index_expr <"7 + s1 + 8*s0*Mod(floor(1/256*wi), 2) + 4*s0*Mod(floor(1/128*wi), 2) + 2*s0*Mod(floor(1/64*wi), 2) + s0*Mod(floor(1/32*wi), 2) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), Mod(floor(1/32*wi), 2)))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1412 = wave.assume %1411 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1413 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1412) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1414 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1415 = wave.assume %1414 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1416 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1415) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1417 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1418 = wave.assume %1417 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1419 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1418) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1420 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1421 = wave.assume %1420 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1422 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1421) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1423 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1424 = wave.assume %1423 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1425 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1424) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1426 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1427 = wave.assume %1426 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1428 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1427) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1429 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1430 = wave.assume %1429 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1431 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1430) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1432 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1433 = wave.assume %1432 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1434 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1433) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1435 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(16 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(16, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1436 = wave.assume %1435 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1437 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1436) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1438 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1439 = wave.assume %1438 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1440 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1439) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1441 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1442 = wave.assume %1441 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1443 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1442) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1444 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1445 = wave.assume %1444 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1446 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1445) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1447 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1448 = wave.assume %1447 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1449 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1448) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1450 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1451 = wave.assume %1450 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1452 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1451) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1453 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1454 = wave.assume %1453 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1455 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1454) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1456 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1457 = wave.assume %1456 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1458 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1457) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1459 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(32 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(32, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1460 = wave.assume %1459 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1461 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1460) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1462 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1463 = wave.assume %1462 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1464 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1463) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1465 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1466 = wave.assume %1465 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1467 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1466) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1468 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1469 = wave.assume %1468 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1470 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1469) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1471 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1472 = wave.assume %1471 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1473 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1472) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1474 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1475 = wave.assume %1474 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1476 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1475) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1477 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1478 = wave.assume %1477 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1479 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1478) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1480 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1481 = wave.assume %1480 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1482 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1481) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1483 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(48 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(48, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1484 = wave.assume %1483 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1485 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1484) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1486 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1487 = wave.assume %1486 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1488 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1487) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1489 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1490 = wave.assume %1489 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1491 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1490) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1492 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1493 = wave.assume %1492 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1494 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1493) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1495 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1496 = wave.assume %1495 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1497 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1496) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1498 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1499 = wave.assume %1498 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1500 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1499) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1501 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1502 = wave.assume %1501 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1503 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1502) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1504 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1505 = wave.assume %1504 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1506 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1505) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1507 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(64 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(64, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1508 = wave.assume %1507 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1509 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1508) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1510 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1511 = wave.assume %1510 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1512 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1511) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1513 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1514 = wave.assume %1513 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1515 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1514) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1516 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1517 = wave.assume %1516 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1518 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1517) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1519 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1520 = wave.assume %1519 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1521 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1520) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1522 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1523 = wave.assume %1522 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1524 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1523) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1525 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1526 = wave.assume %1525 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1527 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1526) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1528 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1529 = wave.assume %1528 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1530 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1529) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1531 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(80 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(80, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1532 = wave.assume %1531 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1533 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1532) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1534 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1535 = wave.assume %1534 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1536 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1535) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1537 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1538 = wave.assume %1537 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1539 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1538) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1540 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1541 = wave.assume %1540 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1542 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1541) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1543 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1544 = wave.assume %1543 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1545 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1544) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1546 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1547 = wave.assume %1546 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1548 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1547) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1549 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1550 = wave.assume %1549 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1551 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1550) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1552 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1553 = wave.assume %1552 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1554 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1553) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1555 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(96 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(96, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1556 = wave.assume %1555 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1557 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1556) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1558 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1559 = wave.assume %1558 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1560 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1559) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1561 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1562 = wave.assume %1561 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1563 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1562) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1564 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1565 = wave.assume %1564 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1566 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1565) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1567 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1568 = wave.assume %1567 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1569 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1568) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1570 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1571 = wave.assume %1570 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1572 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1571) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1573 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1574 = wave.assume %1573 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1575 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1574) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1576 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1577 = wave.assume %1576 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1578 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1577) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1579 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(112 + Mod(floor(1/32*wi), 2), 2*Mod(floor(1/64*wi), 2)))) + 8*Mod(wi, 2) + 128*Mod(floor(1/16*wi), 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/256*wi), 2), xor(4*Mod(floor(1/128*wi), 2), xor(2*Mod(floor(1/64*wi), 2), xor(112, Mod(floor(1/32*wi), 2))))) + xor(128*Mod(floor(1/16*wi), 2), xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2)))))) <= 0">] ["wi", "s0", "s1"](%40, %1323, %1325) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
        %1580 = wave.assume %1579 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
        %1581 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%1580) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %1582 = waveamd.make_buffer %arg4, %c2147483647_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
        %1583 = wave.pack %1326, %1327, %1328, %1329, %1330, %1331, %1332, %1333, %1334, %1335, %1336, %1337, %1338, %1339, %1340, %1341, %1342, %1343, %1344, %1345, %1346, %1347, %1348, %1349, %1350, %1351, %1352, %1353, %1354, %1355, %1356, %1357, %1358, %1359, %1360, %1361, %1362, %1363, %1364, %1365, %1366, %1367, %1368, %1369, %1370, %1371, %1372, %1373, %1374, %1375, %1376, %1377, %1378, %1379, %1380, %1381, %1382, %1383, %1384, %1385, %1386, %1387, %1388, %1389 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<64xf16>, 64>
        wave.where %1259, %1260, %1261, %1262, %1263, %1264, %1265, %1266, %1267, %1268, %1269, %1270, %1271, %1272, %1273, %1274, %1275, %1276, %1277, %1278, %1279, %1280, %1281, %1282, %1283, %1284, %1285, %1286, %1287, %1288, %1289, %1290, %1291, %1292, %1293, %1294, %1295, %1296, %1297, %1298, %1299, %1300, %1301, %1302, %1303, %1304, %1305, %1306, %1307, %1308, %1309, %1310, %1311, %1312, %1313, %1314, %1315, %1316, %1317, %1318, %1319, %1320, %1321, %1322 {
          %1585 = wave.scatter %1583 to %1582 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%1392, %1395, %1398, %1401, %1404, %1407, %1410, %1413, %1416, %1419, %1422, %1425, %1428, %1431, %1434, %1437, %1440, %1443, %1446, %1449, %1452, %1455, %1458, %1461, %1464, %1467, %1470, %1473, %1476, %1479, %1482, %1485, %1488, %1491, %1494, %1497, %1500, %1503, %1506, %1509, %1512, %1515, %1518, %1521, %1524, %1527, %1530, %1533, %1536, %1539, %1542, %1545, %1548, %1551, %1554, %1557, %1560, %1563, %1566, %1569, %1572, %1575, %1578, %1581) {cache = #waveamd.store_cache<cs>} : (!wave.simd<vector<64xf16>, 64>, !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> !wave.mem.token
        } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
        %1584 = wave.join %286, %275, %329#24, %394, %387, %587 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        scf.yield %1584 : !wave.mem.token
      }
      return
    }
  }
}
