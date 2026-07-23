module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 4 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @_attn_fwd_async_prefetch(%arg0: !wave.ptr<#wave.global, bf16>, %arg1: !wave.ptr<#wave.global, bf16>, %arg2: !wave.ptr<#wave.global, bf16>, %arg3: !wave.ptr<#wave.global, bf16>, %arg4: i32, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32, %arg13: i32, %arg14: i32, %arg15: i32, %arg16: i32, %arg17: i32, %arg18: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 256, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 4 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 4 : i64, wave.workgroup_size = array<i32: 256, 1, 1>, waveamdmachine.target_waves = 1 : i64} {
      %0 = wave.constant 119 : i32 -> !wave.simd<i32, 64>
      %1 = wave.constant 118 : i32 -> !wave.simd<i32, 64>
      %2 = wave.constant 117 : i32 -> !wave.simd<i32, 64>
      %3 = wave.constant 116 : i32 -> !wave.simd<i32, 64>
      %4 = wave.constant 115 : i32 -> !wave.simd<i32, 64>
      %5 = wave.constant 114 : i32 -> !wave.simd<i32, 64>
      %6 = wave.constant 113 : i32 -> !wave.simd<i32, 64>
      %7 = wave.constant 103 : i32 -> !wave.simd<i32, 64>
      %8 = wave.constant 102 : i32 -> !wave.simd<i32, 64>
      %9 = wave.constant 101 : i32 -> !wave.simd<i32, 64>
      %10 = wave.constant 100 : i32 -> !wave.simd<i32, 64>
      %11 = wave.constant 99 : i32 -> !wave.simd<i32, 64>
      %12 = wave.constant 98 : i32 -> !wave.simd<i32, 64>
      %13 = wave.constant 97 : i32 -> !wave.simd<i32, 64>
      %14 = wave.constant 87 : i32 -> !wave.simd<i32, 64>
      %15 = wave.constant 86 : i32 -> !wave.simd<i32, 64>
      %16 = wave.constant 85 : i32 -> !wave.simd<i32, 64>
      %17 = wave.constant 84 : i32 -> !wave.simd<i32, 64>
      %18 = wave.constant 83 : i32 -> !wave.simd<i32, 64>
      %19 = wave.constant 82 : i32 -> !wave.simd<i32, 64>
      %20 = wave.constant 81 : i32 -> !wave.simd<i32, 64>
      %21 = wave.constant 71 : i32 -> !wave.simd<i32, 64>
      %22 = wave.constant 70 : i32 -> !wave.simd<i32, 64>
      %23 = wave.constant 69 : i32 -> !wave.simd<i32, 64>
      %24 = wave.constant 68 : i32 -> !wave.simd<i32, 64>
      %25 = wave.constant 67 : i32 -> !wave.simd<i32, 64>
      %26 = wave.constant 66 : i32 -> !wave.simd<i32, 64>
      %27 = wave.constant 65 : i32 -> !wave.simd<i32, 64>
      %28 = wave.constant 55 : i32 -> !wave.simd<i32, 64>
      %29 = wave.constant 54 : i32 -> !wave.simd<i32, 64>
      %30 = wave.constant 53 : i32 -> !wave.simd<i32, 64>
      %31 = wave.constant 52 : i32 -> !wave.simd<i32, 64>
      %32 = wave.constant 39 : i32 -> !wave.simd<i32, 64>
      %33 = wave.constant 38 : i32 -> !wave.simd<i32, 64>
      %34 = wave.constant 37 : i32 -> !wave.simd<i32, 64>
      %35 = wave.constant 36 : i32 -> !wave.simd<i32, 64>
      %36 = wave.constant 23 : i32 -> !wave.simd<i32, 64>
      %37 = wave.constant 22 : i32 -> !wave.simd<i32, 64>
      %38 = wave.constant 21 : i32 -> !wave.simd<i32, 64>
      %39 = wave.constant 20 : i32 -> !wave.simd<i32, 64>
      %40 = wave.constant 7 : i32 -> !wave.simd<i32, 64>
      %41 = wave.constant 6 : i32 -> !wave.simd<i32, 64>
      %42 = wave.constant 5 : i32 -> !wave.simd<i32, 64>
      %43 = wave.constant 59 : i32 -> !wave.simd<i32, 64>
      %44 = wave.constant 58 : i32 -> !wave.simd<i32, 64>
      %45 = wave.constant 57 : i32 -> !wave.simd<i32, 64>
      %46 = wave.constant 56 : i32 -> !wave.simd<i32, 64>
      %47 = wave.constant 51 : i32 -> !wave.simd<i32, 64>
      %48 = wave.constant 50 : i32 -> !wave.simd<i32, 64>
      %49 = wave.constant 49 : i32 -> !wave.simd<i32, 64>
      %50 = wave.constant 43 : i32 -> !wave.simd<i32, 64>
      %51 = wave.constant 42 : i32 -> !wave.simd<i32, 64>
      %52 = wave.constant 41 : i32 -> !wave.simd<i32, 64>
      %53 = wave.constant 40 : i32 -> !wave.simd<i32, 64>
      %54 = wave.constant 35 : i32 -> !wave.simd<i32, 64>
      %55 = wave.constant 34 : i32 -> !wave.simd<i32, 64>
      %56 = wave.constant 33 : i32 -> !wave.simd<i32, 64>
      %57 = wave.constant 27 : i32 -> !wave.simd<i32, 64>
      %58 = wave.constant 26 : i32 -> !wave.simd<i32, 64>
      %59 = wave.constant 25 : i32 -> !wave.simd<i32, 64>
      %60 = wave.constant 24 : i32 -> !wave.simd<i32, 64>
      %61 = wave.constant 19 : i32 -> !wave.simd<i32, 64>
      %62 = wave.constant 18 : i32 -> !wave.simd<i32, 64>
      %63 = wave.constant 17 : i32 -> !wave.simd<i32, 64>
      %64 = wave.constant 11 : i32 -> !wave.simd<i32, 64>
      %65 = wave.constant 10 : i32 -> !wave.simd<i32, 64>
      %66 = wave.constant 9 : i32 -> !wave.simd<i32, 64>
      %67 = wave.constant 3 : i32 -> !wave.simd<i32, 64>
      %68 = wave.constant 1 : i32 -> !wave.simd<i32, 64>
      %69 = wave.constant 368 : index -> !wave.simd<index, 64>
      %70 = wave.constant 352 : index -> !wave.simd<index, 64>
      %71 = wave.constant 336 : index -> !wave.simd<index, 64>
      %72 = wave.constant 320 : index -> !wave.simd<index, 64>
      %73 = wave.constant 304 : index -> !wave.simd<index, 64>
      %74 = wave.constant 288 : index -> !wave.simd<index, 64>
      %75 = wave.constant 272 : index -> !wave.simd<index, 64>
      %76 = wave.constant 256 : index -> !wave.simd<index, 64>
      %77 = wave.constant 112 : index -> !wave.simd<index, 64>
      %78 = wave.constant 96 : index -> !wave.simd<index, 64>
      %79 = wave.constant 80 : index -> !wave.simd<index, 64>
      %80 = wave.constant 64 : index -> !wave.simd<index, 64>
      %81 = wave.constant 48 : index -> !wave.simd<index, 64>
      %82 = wave.constant 32 : index -> !wave.simd<index, 64>
      %83 = wave.constant 16 : index -> !wave.simd<index, 64>
      %84 = wave.constant 1073741824 : index -> !wave.simd<index, 64>
      %85 = wave.constant 12 : i32 -> !wave.simd<i32, 64>
      %86 = wave.constant 240 : i32 -> !wave.simd<i32, 64>
      %87 = wave.constant 224 : i32 -> !wave.simd<i32, 64>
      %88 = wave.constant 208 : i32 -> !wave.simd<i32, 64>
      %89 = wave.constant 192 : i32 -> !wave.simd<i32, 64>
      %90 = wave.constant 176 : i32 -> !wave.simd<i32, 64>
      %91 = wave.constant 160 : i32 -> !wave.simd<i32, 64>
      %92 = wave.constant 144 : i32 -> !wave.simd<i32, 64>
      %93 = wave.constant 112 : i32 -> !wave.simd<i32, 64>
      %94 = wave.constant 96 : i32 -> !wave.simd<i32, 64>
      %95 = wave.constant 80 : i32 -> !wave.simd<i32, 64>
      %96 = wave.constant 48 : i32 -> !wave.simd<i32, 64>
      %97 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %98 = wave.constant 32 : i32 -> !wave.simd<i32, 64>
      %99 = wave.constant 64 : i32 -> !wave.simd<i32, 64>
      %100 = wave.constant 16 : i32 -> !wave.simd<i32, 64>
      %101 = wave.constant 8 : i32 -> !wave.simd<i32, 64>
      %102 = wave.constant 4 : i32 -> !wave.simd<i32, 64>
      %103 = wave.constant 2 : i32 -> !wave.simd<i32, 64>
      %104 = wave.constant false -> !wave.mask<64>
      %c4352_i32 = arith.constant 4352 : i32
      %c8704_i32 = arith.constant 8704 : i32
      %c4160_i32 = arith.constant 4160 : i32
      %c8320_i32 = arith.constant 8320 : i32
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %105 = wave.constant 0.000000e+00 : bf16 -> !wave.simd<bf16, 64>
      %c2_i32 = arith.constant 2 : i32
      %c0_i32 = arith.constant 0 : i32
      %c64_i32 = arith.constant 64 : i32
      %c1_i32 = arith.constant 1 : i32
      %c256_i32 = arith.constant 256 : i32
      %c63_i32 = arith.constant 63 : i32
      %106 = wave.constant 1.000000e+00 : f32 -> !wave.simd<f32, 64>
      %107 = wave.constant 0.127517432 : f32 -> !wave.simd<f32, 64>
      %108 = wave.constant 0xFF800000 : f32 -> !wave.simd<f32, 64>
      %109 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %110 = wave.assume %arg17 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %111 = wave.assume %arg18 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">] : i32
      %112 = wave.pack %109, %109, %109, %109, %109, %109, %109, %109, %109, %109, %109, %109, %109, %109, %109, %109 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %113 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %114 = wave.assume %arg12 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %115 = wave.workgroup_id 0
      %116 = wave.workgroup_id 1
      %117 = wave.binary divsi %116, %110 : i32, i32 -> i32
      %118 = wave.binary remsi %116, %110 : i32, i32 -> i32
      %119 = wave.assume %arg4 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %120 = wave.binary muli %117, %119 overflow<nsw> : i32, i32 -> i32
      %121 = wave.assume %arg5 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %122 = wave.binary muli %118, %121 overflow<nsw> : i32, i32 -> i32
      %123 = wave.binary addi %120, %122 overflow<nsw> : i32, i32 -> i32
      %124 = wave.assume %arg7 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %125 = wave.binary muli %117, %124 overflow<nsw> : i32, i32 -> i32
      %126 = wave.assume %arg8 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %127 = wave.binary muli %118, %126 overflow<nsw> : i32, i32 -> i32
      %128 = wave.binary addi %125, %127 overflow<nsw> : i32, i32 -> i32
      %129 = wave.assume %arg10 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %130 = wave.binary muli %117, %129 overflow<nsw> : i32, i32 -> i32
      %131 = wave.assume %arg11 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %132 = wave.binary muli %118, %131 overflow<nsw> : i32, i32 -> i32
      %133 = wave.binary addi %130, %132 overflow<nsw> : i32, i32 -> i32
      %134 = wave.assume %arg13 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %135 = wave.binary muli %117, %134 overflow<nsw> : i32, i32 -> i32
      %136 = wave.assume %arg14 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">, #wave.pred<"x >= 0">] : i32
      %137 = wave.binary muli %118, %136 overflow<nsw> : i32, i32 -> i32
      %138 = wave.binary addi %135, %137 overflow<nsw> : i32, i32 -> i32
      %139 = wave.binary muli %115, %c256_i32 overflow<nsw> : i32, i32 -> i32
      %140 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %141 = wave.binary remui %140, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %142 = wave.binary divui %140, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %143 = wave.binary remui %142, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %144 = wave.binary muli %143, %103 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %145 = wave.binary xori %141, %144 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %146 = wave.binary divui %140, %102 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %147 = wave.binary remui %146, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %148 = wave.binary muli %147, %102 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %149 = wave.binary xori %145, %148 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %150 = wave.binary divui %140, %101 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %151 = wave.binary remui %150, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %152 = wave.binary muli %151, %101 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %153 = wave.binary xori %149, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %154 = wave.binary divui %140, %100 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %155 = wave.binary remui %154, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %156 = wave.binary muli %155, %100 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %157 = wave.binary xori %153, %156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %158 = wave.binary divui %140, %99 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %159 = wave.binary remui %158, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %160 = wave.binary muli %159, %98 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %161 = wave.binary xori %157, %160 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %162 = wave.binary divui %140, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %163 = wave.binary remui %162, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %164 = wave.binary muli %163, %99 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %165 = wave.binary xori %161, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %166 = wave.splat %139 : i32 -> !wave.simd<i32, 64>
      %167 = wave.binary addi %165, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %168 = wave.binary xori %97, %141 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %169 = wave.binary xori %168, %144 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %170 = wave.binary xori %169, %148 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %171 = wave.binary xori %170, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %172 = wave.binary xori %171, %156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %173 = wave.binary xori %172, %160 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %174 = wave.binary xori %173, %164 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %175 = wave.binary addi %174, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %176 = wave.splat %111 : i32 -> !wave.simd<i32, 64>
      %177 = wave.cmpi slt %167, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %178 = wave.cmpi slt %175, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %179 = wave.binary divui %140, %98 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %180 = wave.binary remui %179, %103 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %181 = wave.binary muli %180, %103 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %182 = wave.binary xori %155, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %183 = wave.binary muli %159, %102 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %184 = wave.binary xori %182, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %185 = wave.binary muli %163, %101 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %186 = wave.binary xori %184, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %187 = wave.binary addi %186, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %188 = wave.binary xori %100, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %189 = wave.binary xori %188, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %190 = wave.binary xori %189, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %191 = wave.binary xori %190, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %192 = wave.binary addi %191, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %193 = wave.binary xori %98, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %194 = wave.binary xori %193, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %195 = wave.binary xori %194, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %196 = wave.binary xori %195, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %197 = wave.binary addi %196, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %198 = wave.binary xori %96, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %199 = wave.binary xori %198, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %200 = wave.binary xori %199, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %201 = wave.binary xori %200, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %202 = wave.binary addi %201, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %203 = wave.binary xori %99, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %204 = wave.binary xori %203, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %205 = wave.binary xori %204, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %206 = wave.binary xori %205, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %207 = wave.binary addi %206, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %208 = wave.binary xori %95, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %209 = wave.binary xori %208, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %210 = wave.binary xori %209, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %211 = wave.binary xori %210, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %212 = wave.binary addi %211, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %213 = wave.binary xori %94, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %214 = wave.binary xori %213, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %215 = wave.binary xori %214, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %216 = wave.binary xori %215, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %217 = wave.binary addi %216, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %218 = wave.binary xori %93, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %219 = wave.binary xori %218, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %220 = wave.binary xori %219, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %221 = wave.binary xori %220, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %222 = wave.binary addi %221, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %223 = wave.binary xori %97, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %224 = wave.binary xori %223, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %225 = wave.binary xori %224, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %226 = wave.binary xori %225, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %227 = wave.binary addi %226, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %228 = wave.binary xori %92, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %229 = wave.binary xori %228, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %230 = wave.binary xori %229, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %231 = wave.binary xori %230, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %232 = wave.binary addi %231, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %233 = wave.binary xori %91, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %234 = wave.binary xori %233, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %235 = wave.binary xori %234, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %236 = wave.binary xori %235, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %237 = wave.binary addi %236, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %238 = wave.binary xori %90, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %239 = wave.binary xori %238, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %240 = wave.binary xori %239, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %241 = wave.binary xori %240, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %242 = wave.binary addi %241, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %243 = wave.binary xori %89, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %244 = wave.binary xori %243, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %245 = wave.binary xori %244, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %246 = wave.binary xori %245, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %247 = wave.binary addi %246, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %248 = wave.binary xori %88, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %249 = wave.binary xori %248, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %250 = wave.binary xori %249, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %251 = wave.binary xori %250, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %252 = wave.binary addi %251, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %253 = wave.binary xori %87, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %254 = wave.binary xori %253, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %255 = wave.binary xori %254, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %256 = wave.binary xori %255, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %257 = wave.binary addi %256, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %258 = wave.binary xori %86, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %259 = wave.binary xori %258, %181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %260 = wave.binary xori %259, %183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %261 = wave.binary xori %260, %185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %262 = wave.binary addi %261, %166 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %263 = wave.cmpi slt %187, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %264 = wave.cmpi slt %192, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %265 = wave.cmpi slt %197, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %266 = wave.cmpi slt %202, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %267 = wave.cmpi slt %207, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %268 = wave.cmpi slt %212, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %269 = wave.cmpi slt %217, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %270 = wave.cmpi slt %222, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %271 = wave.cmpi slt %227, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %272 = wave.cmpi slt %232, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %273 = wave.cmpi slt %237, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %274 = wave.cmpi slt %242, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %275 = wave.cmpi slt %247, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %276 = wave.cmpi slt %252, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %277 = wave.cmpi slt %257, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %278 = wave.cmpi slt %262, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %279 = wave.assume %arg6 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %280 = wave.binary muli %139, %279 overflow<nsw> : i32, i32 -> i32
      %281 = wave.binary addi %280, %123 overflow<nsw> : i32, i32 -> i32
      %282 = wave.index_expr <"s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %283 = wave.assume %282 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %284 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%283) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %285 = wave.index_expr <"1 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %286 = wave.assume %285 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %287 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%286) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %288 = wave.index_expr <"2 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %289 = wave.assume %288 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %290 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%289) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %291 = wave.index_expr <"3 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %292 = wave.assume %291 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %293 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%292) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %294 = wave.index_expr <"4 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %295 = wave.assume %294 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %296 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%295) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %297 = wave.index_expr <"5 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %298 = wave.assume %297 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %299 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%298) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %300 = wave.index_expr <"6 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %301 = wave.assume %300 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %302 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%301) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %303 = wave.index_expr <"7 + s1 + 8*s0*Mod(floor(1/128*wi), 2) + 4*s0*Mod(floor(1/64*wi), 2) + 2*s0*Mod(floor(1/32*wi), 2) + s0*Mod(floor(1/16*wi), 2) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), Mod(floor(1/16*wi), 2)))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %304 = wave.assume %303 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %305 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%304) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %306 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %307 = wave.assume %306 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %308 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%307) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %309 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %310 = wave.assume %309 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %311 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%310) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %312 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %313 = wave.assume %312 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %314 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%313) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %315 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %316 = wave.assume %315 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %317 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%316) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %318 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %319 = wave.assume %318 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %320 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%319) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %321 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %322 = wave.assume %321 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %323 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%322) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %324 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %325 = wave.assume %324 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %326 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%325) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %327 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(16 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(16, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %328 = wave.assume %327 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %329 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%328) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %330 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %331 = wave.assume %330 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %332 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%331) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %333 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %334 = wave.assume %333 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %335 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%334) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %336 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %337 = wave.assume %336 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %338 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%337) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %339 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %340 = wave.assume %339 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %341 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%340) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %342 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %343 = wave.assume %342 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %344 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%343) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %345 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %346 = wave.assume %345 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %347 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%346) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %348 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %349 = wave.assume %348 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %350 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%349) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %351 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(32 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(32, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %352 = wave.assume %351 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %353 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%352) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %354 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %355 = wave.assume %354 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %356 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%355) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %357 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %358 = wave.assume %357 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %359 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%358) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %360 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %361 = wave.assume %360 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %362 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%361) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %363 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %364 = wave.assume %363 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %365 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%364) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %366 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %367 = wave.assume %366 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %368 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%367) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %369 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %370 = wave.assume %369 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %371 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%370) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %372 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %373 = wave.assume %372 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %374 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%373) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %375 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(48 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(48, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %376 = wave.assume %375 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %377 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%376) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %378 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %379 = wave.assume %378 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %380 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%379) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %381 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %382 = wave.assume %381 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %383 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%382) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %384 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %385 = wave.assume %384 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %386 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%385) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %387 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %388 = wave.assume %387 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %389 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%388) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %390 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %391 = wave.assume %390 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %392 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%391) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %393 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %394 = wave.assume %393 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %395 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%394) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %396 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %397 = wave.assume %396 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %398 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%397) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %399 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(64 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(64, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %400 = wave.assume %399 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %401 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%400) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %402 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %403 = wave.assume %402 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %404 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%403) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %405 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %406 = wave.assume %405 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %407 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%406) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %408 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %409 = wave.assume %408 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %410 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%409) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %411 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %412 = wave.assume %411 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %413 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%412) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %414 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %415 = wave.assume %414 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %416 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%415) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %417 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %418 = wave.assume %417 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %419 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%418) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %420 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %421 = wave.assume %420 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %422 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%421) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %423 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(80 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(80, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %424 = wave.assume %423 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %425 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%424) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %426 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %427 = wave.assume %426 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %428 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%427) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %429 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %430 = wave.assume %429 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %431 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%430) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %432 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %433 = wave.assume %432 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %434 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%433) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %435 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %436 = wave.assume %435 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %437 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%436) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %438 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %439 = wave.assume %438 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %440 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%439) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %441 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %442 = wave.assume %441 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %443 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%442) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %444 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %445 = wave.assume %444 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %446 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%445) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %447 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(96 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(96, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %448 = wave.assume %447 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %449 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%448) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %450 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %451 = wave.assume %450 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %452 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%451) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %453 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %454 = wave.assume %453 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %455 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%454) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %456 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %457 = wave.assume %456 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %458 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%457) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %459 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %460 = wave.assume %459 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %461 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%460) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %462 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %463 = wave.assume %462 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %464 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%463) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %465 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %466 = wave.assume %465 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %467 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%466) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %468 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %469 = wave.assume %468 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %470 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%469) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %471 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(112 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(112, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %472 = wave.assume %471 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %473 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%472) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %474 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %475 = wave.assume %474 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %476 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%475) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %477 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %478 = wave.assume %477 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %479 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%478) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %480 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %481 = wave.assume %480 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %482 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%481) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %483 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %484 = wave.assume %483 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %485 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%484) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %486 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %487 = wave.assume %486 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %488 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%487) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %489 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %490 = wave.assume %489 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %491 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%490) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %492 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %493 = wave.assume %492 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %494 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%493) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %495 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(128 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(128, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %496 = wave.assume %495 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %497 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%496) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %498 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %499 = wave.assume %498 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %500 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%499) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %501 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %502 = wave.assume %501 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %503 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%502) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %504 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %505 = wave.assume %504 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %506 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%505) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %507 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %508 = wave.assume %507 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %509 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%508) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %510 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %511 = wave.assume %510 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %512 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%511) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %513 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %514 = wave.assume %513 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %515 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%514) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %516 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %517 = wave.assume %516 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %518 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%517) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %519 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(144 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(144, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %520 = wave.assume %519 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %521 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%520) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %522 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %523 = wave.assume %522 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %524 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%523) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %525 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %526 = wave.assume %525 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %527 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%526) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %528 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %529 = wave.assume %528 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %530 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%529) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %531 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %532 = wave.assume %531 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %533 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%532) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %534 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %535 = wave.assume %534 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %536 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%535) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %537 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %538 = wave.assume %537 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %539 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%538) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %540 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %541 = wave.assume %540 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %542 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%541) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %543 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(160 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(160, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %544 = wave.assume %543 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %545 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%544) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %546 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %547 = wave.assume %546 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %548 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%547) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %549 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %550 = wave.assume %549 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %551 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%550) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %552 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %553 = wave.assume %552 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %554 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%553) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %555 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %556 = wave.assume %555 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %557 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%556) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %558 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %559 = wave.assume %558 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %560 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%559) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %561 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %562 = wave.assume %561 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %563 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%562) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %564 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %565 = wave.assume %564 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %566 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%565) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %567 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(176 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(176, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %568 = wave.assume %567 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %569 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%568) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %570 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %571 = wave.assume %570 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %572 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%571) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %573 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %574 = wave.assume %573 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %575 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%574) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %576 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %577 = wave.assume %576 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %578 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%577) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %579 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %580 = wave.assume %579 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %581 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%580) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %582 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %583 = wave.assume %582 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %584 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%583) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %585 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %586 = wave.assume %585 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %587 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%586) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %588 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %589 = wave.assume %588 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %590 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%589) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %591 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(192 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(192, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %592 = wave.assume %591 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %593 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%592) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %594 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %595 = wave.assume %594 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %596 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%595) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %597 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %598 = wave.assume %597 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %599 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%598) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %600 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %601 = wave.assume %600 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %602 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%601) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %603 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %604 = wave.assume %603 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %605 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%604) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %606 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %607 = wave.assume %606 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %608 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%607) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %609 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %610 = wave.assume %609 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %611 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%610) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %612 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %613 = wave.assume %612 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %614 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%613) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %615 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(208 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(208, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %616 = wave.assume %615 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %617 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%616) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %618 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %619 = wave.assume %618 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %620 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%619) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %621 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %622 = wave.assume %621 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %623 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%622) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %624 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %625 = wave.assume %624 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %626 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%625) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %627 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %628 = wave.assume %627 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %629 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%628) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %630 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %631 = wave.assume %630 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %632 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%631) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %633 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %634 = wave.assume %633 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %635 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%634) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %636 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %637 = wave.assume %636 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %638 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%637) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %639 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(224 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(224, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %640 = wave.assume %639 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %641 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%640) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %642 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %643 = wave.assume %642 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %644 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%643) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %645 = wave.index_expr <"1 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(1, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %646 = wave.assume %645 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %647 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%646) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %648 = wave.index_expr <"2 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(2, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %649 = wave.assume %648 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %650 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%649) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %651 = wave.index_expr <"3 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(3, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %652 = wave.assume %651 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %653 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%652) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %654 = wave.index_expr <"4 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(4, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %655 = wave.assume %654 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %656 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%655) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %657 = wave.index_expr <"5 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(5, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %658 = wave.assume %657 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %659 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%658) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %660 = wave.index_expr <"6 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(6, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %661 = wave.assume %660 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %662 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%661) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %663 = wave.index_expr <"7 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(240 + Mod(floor(1/16*wi), 2), 2*Mod(floor(1/32*wi), 2)))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(8*Mod(floor(1/128*wi), 2), xor(4*Mod(floor(1/64*wi), 2), xor(2*Mod(floor(1/32*wi), 2), xor(240, Mod(floor(1/16*wi), 2))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(16*Mod(floor(1/2*wi), 2), xor(7, 8*Mod(wi, 2))))) <= 0">] ["wi", "s0", "s1"](%140, %279, %281) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %664 = wave.assume %663 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %665 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%664) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %666 = waveamd.make_buffer %arg0, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %667 = wave.pack %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105, %105 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<128xbf16>, 64>
      %668 = wave.token : !wave.mem.token
      %669:2 = wave.where %263, %263, %263, %263, %263, %263, %263, %263, %264, %264, %264, %264, %264, %264, %264, %264, %265, %265, %265, %265, %265, %265, %265, %265, %266, %266, %266, %266, %266, %266, %266, %266, %267, %267, %267, %267, %267, %267, %267, %267, %268, %268, %268, %268, %268, %268, %268, %268, %269, %269, %269, %269, %269, %269, %269, %269, %270, %270, %270, %270, %270, %270, %270, %270, %271, %271, %271, %271, %271, %271, %271, %271, %272, %272, %272, %272, %272, %272, %272, %272, %273, %273, %273, %273, %273, %273, %273, %273, %274, %274, %274, %274, %274, %274, %274, %274, %275, %275, %275, %275, %275, %275, %275, %275, %276, %276, %276, %276, %276, %276, %276, %276, %277, %277, %277, %277, %277, %277, %277, %277, %278, %278, %278, %278, %278, %278, %278, %278 {
        %value_62, %token_63 = wave.gather %666 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%284, %287, %290, %293, %296, %299, %302, %305, %308, %311, %314, %317, %320, %323, %326, %329, %332, %335, %338, %341, %344, %347, %350, %353, %356, %359, %362, %365, %368, %371, %374, %377, %380, %383, %386, %389, %392, %395, %398, %401, %404, %407, %410, %413, %416, %419, %422, %425, %428, %431, %434, %437, %440, %443, %446, %449, %452, %455, %458, %461, %464, %467, %470, %473, %476, %479, %482, %485, %488, %491, %494, %497, %500, %503, %506, %509, %512, %515, %518, %521, %524, %527, %530, %533, %536, %539, %542, %545, %548, %551, %554, %557, %560, %563, %566, %569, %572, %575, %578, %581, %584, %587, %590, %593, %596, %599, %602, %605, %608, %611, %614, %617, %620, %623, %626, %629, %632, %635, %638, %641, %644, %647, %650, %653, %656, %659, %662, %665) : (!wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<128xbf16>, 64>, !wave.mem.token)
        wave.yield %value_62, %token_63 : !wave.simd<vector<128xbf16>, 64>, !wave.mem.token
      } otherwise {
        wave.yield %667, %668 : !wave.simd<vector<128xbf16>, 64>, !wave.mem.token
      } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64> -> !wave.simd<vector<128xbf16>, 64>, !wave.mem.token
      %670 = wave.redistribute %669#0, <blocks = 1, items = 256, source_block = "0", source_item = "64*xor(2*Mod(floor(1/8*Mod(item, 64)), 2), Mod(floor(1/4*Mod(item, 64)), 2)) + xor(Mod(floor(1/32*Mod(item, 64)), 2), xor(32*Mod(floor(1/2*Mod(item, 64)), 2), xor(16*Mod(Mod(item, 64), 2), xor(8*Mod(floor(1/32*slot), 2), xor(2*Mod(floor(1/8*slot), 2), 4*Mod(floor(1/16*slot), 2))))))", source_slot = "xor(32*Mod(floor(1/128*item), 2), xor(16*Mod(floor(1/64*item), 2), xor(8*Mod(floor(1/16*Mod(item, 64)), 2), xor(64*Mod(floor(1/64*slot), 2), xor(4*Mod(floor(1/4*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))))"> : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %671 = wave.extract %670[0] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %672 = wave.extract %670[8] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %673 = wave.extract %670[16] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %674 = wave.extract %670[24] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %675 = wave.extract %670[32] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %676 = wave.extract %670[40] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %677 = wave.extract %670[48] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %678 = wave.extract %670[56] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %679 = wave.extract %670[64] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %680 = wave.extract %670[72] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %681 = wave.extract %670[80] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %682 = wave.extract %670[88] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %683 = wave.extract %670[96] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %684 = wave.extract %670[104] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %685 = wave.extract %670[112] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %686 = wave.extract %670[120] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %687 = wave.alloc() {align = 16 : i64, bytesize = 33264 : i64} : !wave.ptr<#wave.shared, bf16>
      %688 = wave.alloc() {align = 16 : i64, bytesize = 34752 : i64} : !wave.ptr<#wave.shared, bf16>
      %689 = wave.binary addi %111, %c63_i32 overflow<nsw> : i32, i32 -> i32
      %690 = wave.binary divsi %689, %c64_i32 : i32, i32 -> i32
      %691 = wave.binary subi %690, %c1_i32 overflow<nsw> : i32, i32 -> i32
      %692 = arith.cmpi sgt, %691, %c0_i32 : i32
      %693 = wave.select %692, %691, %c0_i32 : i32
      %694 = wave.binary muli %180, %98 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %695 = wave.binary xori %156, %694 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %696 = wave.binary xori %695, %159 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %697 = wave.binary muli %163, %103 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %698 = wave.binary xori %696, %697 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %699 = wave.binary xori %102, %156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %700 = wave.binary xori %699, %694 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %701 = wave.binary xori %700, %159 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %702 = wave.binary xori %701, %697 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %703 = wave.binary xori %101, %156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %704 = wave.binary xori %703, %694 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %705 = wave.binary xori %704, %159 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %706 = wave.binary xori %705, %697 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %707 = wave.binary xori %85, %156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %708 = wave.binary xori %707, %694 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %709 = wave.binary xori %708, %159 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %710 = wave.binary xori %709, %697 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %711 = wave.cmpi slt %698, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %712 = wave.cmpi slt %702, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %713 = wave.cmpi slt %706, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %714 = wave.cmpi slt %710, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %715 = wave.ptr_cast %687 : !wave.ptr<#wave.shared, bf16> -> !wave.ptr<#wave.shared, i32>
      %716 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %113, %128) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %717 = wave.assume %716 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %718 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%717) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %719 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %113, %128) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %720 = wave.assume %719 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %721 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%720) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %722 = wave.index_expr <"s1 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %113, %128) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %723 = wave.assume %722 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %724 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%723) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %725 = wave.index_expr <"s1 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %113, %128) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %726 = wave.assume %725 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %727 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%726) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %728 = waveamd.make_buffer %arg1, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %729 = wave.read_first %140 : !wave.simd<i32, 64> -> i32
      %730 = wave.assume %729 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
      %731 = wave.ptr_add %728, %718 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %732 = wave.index_expr <"260*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %733 = wave.ptr_add %715, %732 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %734 = wave.ptr_add %728, %84 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %735 = wave.select %711, %731, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %736 = waveamd.dma_load_lds %735 -> %733 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %737 = wave.ptr_add %728, %721 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %738 = wave.index_expr <"1040 + 260*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %739 = wave.ptr_add %715, %738 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %740 = wave.select %712, %737, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %741 = waveamd.dma_load_lds %740 -> %739 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %742 = wave.ptr_add %728, %724 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %743 = wave.index_expr <"2080 + 260*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %744 = wave.ptr_add %715, %743 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %745 = wave.select %713, %742, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %746 = waveamd.dma_load_lds %745 -> %744 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %747 = wave.ptr_add %728, %727 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %748 = wave.index_expr <"3120 + 260*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %749 = wave.ptr_add %715, %748 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %750 = wave.select %714, %747, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %751 = waveamd.dma_load_lds %750 -> %749 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %752 = wave.join %736, %741, %746, %751 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %753 = wave.ptr_cast %688 : !wave.ptr<#wave.shared, bf16> -> !wave.ptr<#wave.shared, i32>
      %754 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %114, %133) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %755 = wave.assume %754 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %756 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%755) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %757 = wave.index_expr <"s1 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %114, %133) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %758 = wave.assume %757 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %759 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%758) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %760 = wave.index_expr <"s1 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %114, %133) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %761 = wave.assume %760 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %762 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%761) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %763 = wave.index_expr <"s1 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1"](%140, %114, %133) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %764 = wave.assume %763 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
      %765 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%764) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %766 = waveamd.make_buffer %arg2, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %767 = wave.ptr_add %766, %756 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %768 = wave.index_expr <"272*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %769 = wave.ptr_add %753, %768 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %770 = wave.ptr_add %766, %84 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %771 = wave.select %711, %767, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %772 = waveamd.dma_load_lds %771 -> %769 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %773 = wave.ptr_add %766, %759 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %774 = wave.index_expr <"1088 + 272*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %775 = wave.ptr_add %753, %774 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %776 = wave.select %712, %773, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %777 = waveamd.dma_load_lds %776 -> %775 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %778 = wave.ptr_add %766, %762 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %779 = wave.index_expr <"2176 + 272*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %780 = wave.ptr_add %753, %779 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %781 = wave.select %713, %778, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %782 = waveamd.dma_load_lds %781 -> %780 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %783 = wave.ptr_add %766, %765 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %784 = wave.index_expr <"3264 + 272*floor(1/64*wi_first)"> ["wi_first"](%730) : (i32) -> index
      %785 = wave.ptr_add %753, %784 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %786 = wave.select %714, %783, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
      %787 = waveamd.dma_load_lds %786 -> %785 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %788 = wave.join %772, %777, %782, %787 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %789 = wave.join %752, %788 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %790 = wave.binary muli %693, %c64_i32 overflow<nsw> : i32, i32 -> i32
      %791:13 = scf.for %arg19 = %c0_i32 to %790 step %c64_i32 iter_args(%arg20 = %108, %arg21 = %108, %arg22 = %106, %arg23 = %106, %arg24 = %112, %arg25 = %112, %arg26 = %112, %arg27 = %112, %arg28 = %112, %arg29 = %112, %arg30 = %112, %arg31 = %112, %arg32 = %789) -> (!wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.mem.token)  : i32 {
        %2738 = wave.binary addi %arg19, %c64_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %2739 = wave.splat %2738 : i32 -> !wave.simd<i32, 64>
        %2740 = wave.binary addi %698, %2739 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2741 = wave.binary addi %702, %2739 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2742 = wave.binary addi %706, %2739 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2743 = wave.binary addi %710, %2739 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2744 = wave.barrier %arg32 : (!wave.mem.token) -> !wave.mem.token
        %2745 = wave.cmpi slt %2740, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2746 = wave.cmpi slt %2741, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2747 = wave.cmpi slt %2742, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2748 = wave.cmpi slt %2743, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2749 = wave.binary divui %arg19, %c64_i32 : i32, i32 -> i32
        %2750 = wave.binary remui %2749, %c2_i32 : i32, i32 -> i32
        %2751 = wave.binary addi %2749, %c1_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %2752 = wave.binary remui %2751, %c2_i32 : i32, i32 -> i32
        %2753 = wave.binary muli %2750, %c8320_i32 overflow<nsw> : i32, i32 -> i32
        %2754 = wave.ptr_add %687, %2753 : !wave.ptr<#wave.shared, bf16>, i32 -> !wave.ptr<#wave.shared, bf16>
        %2755 = wave.join %arg32, %2744 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2756 = wave.index_expr <"8*floor(1/32*Mod(wi, 64)) + 128*floor(1/16*Mod(Mod(wi, 64), 32)) + 4160*Mod(floor(1/8*Mod(Mod(wi, 64), 32)), 2) + 2080*Mod(floor(1/4*Mod(Mod(wi, 64), 32)), 2) + 1040*Mod(floor(1/2*Mod(Mod(wi, 64), 32)), 2) + 520*Mod(Mod(Mod(wi, 64), 32), 2)"> ["wi"](%140) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %2757 = wave.ptr_add %2754, %2756 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_62, %token_63 = wave.load %2757 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2758 = wave.binary addi %2756, %83 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2759 = wave.ptr_add %2754, %2758 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_64, %token_65 = wave.load %2759 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2760 = wave.binary addi %2756, %82 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2761 = wave.ptr_add %2754, %2760 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_66, %token_67 = wave.load %2761 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2762 = wave.binary addi %2756, %81 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2763 = wave.ptr_add %2754, %2762 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_68, %token_69 = wave.load %2763 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2764 = wave.binary addi %2756, %80 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2765 = wave.ptr_add %2754, %2764 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_70, %token_71 = wave.load %2765 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2766 = wave.binary addi %2756, %79 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2767 = wave.ptr_add %2754, %2766 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_72, %token_73 = wave.load %2767 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2768 = wave.binary addi %2756, %78 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2769 = wave.ptr_add %2754, %2768 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_74, %token_75 = wave.load %2769 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2770 = wave.binary addi %2756, %77 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2771 = wave.ptr_add %2754, %2770 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_76, %token_77 = wave.load %2771 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2772 = wave.binary addi %2756, %76 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2773 = wave.ptr_add %2754, %2772 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_78, %token_79 = wave.load %2773 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2774 = wave.binary addi %2756, %75 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2775 = wave.ptr_add %2754, %2774 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_80, %token_81 = wave.load %2775 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2776 = wave.binary addi %2756, %74 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2777 = wave.ptr_add %2754, %2776 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_82, %token_83 = wave.load %2777 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2778 = wave.binary addi %2756, %73 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2779 = wave.ptr_add %2754, %2778 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_84, %token_85 = wave.load %2779 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2780 = wave.binary addi %2756, %72 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2781 = wave.ptr_add %2754, %2780 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_86, %token_87 = wave.load %2781 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2782 = wave.binary addi %2756, %71 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2783 = wave.ptr_add %2754, %2782 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_88, %token_89 = wave.load %2783 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2784 = wave.binary addi %2756, %70 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2785 = wave.ptr_add %2754, %2784 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_90, %token_91 = wave.load %2785 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2786 = wave.binary addi %2756, %69 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2787 = wave.ptr_add %2754, %2786 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_92, %token_93 = wave.load %2787 after %2755 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2788 = wave.join %token_63, %token_65, %token_67, %token_69, %token_71, %token_73, %token_75, %token_77, %token_79, %token_81, %token_83, %token_85, %token_87, %token_89, %token_91, %token_93 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2789 = wave.binary muli %2750, %c8704_i32 overflow<nsw> : i32, i32 -> i32
        %2790 = wave.ptr_add %688, %2789 : !wave.ptr<#wave.shared, bf16>, i32 -> !wave.ptr<#wave.shared, bf16>
        %value_94, %token_95 = wave.gather %2790 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 544*Mod(xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_96, %token_97 = wave.gather %2790 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 544*Mod(xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_98, %token_99 = wave.gather %2790 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 544*Mod(xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_100, %token_101 = wave.gather %2790 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 544*Mod(xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_102, %token_103 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_104, %token_105 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_106, %token_107 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_108, %token_109 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_110, %token_111 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_112, %token_113 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_114, %token_115 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_116, %token_117 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_118, %token_119 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_120, %token_121 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_122, %token_123 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %value_124, %token_125 = wave.gather %2790 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %2755 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2791 = wave.join %token_95, %token_97, %token_99, %token_101, %token_103, %token_105, %token_107, %token_109, %token_111, %token_113, %token_115, %token_117, %token_119, %token_121, %token_123, %token_125 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2792 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %2793 = wave.binary muli %2738, %2792 overflow<nsw> : i32, i32 -> i32
        %2794 = wave.binary muli %2752, %c4160_i32 overflow<nsw> : i32, i32 -> i32
        %2795 = wave.barrier %2788, %2791 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %2796 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2792, %128, %2793) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2797 = wave.assume %2796 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2798 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2797) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2799 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2792, %128, %2793) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2800 = wave.assume %2799 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2801 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2800) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2802 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2792, %128, %2793) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2803 = wave.assume %2802 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2804 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2803) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2805 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2792, %128, %2793) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2806 = wave.assume %2805 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2807 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2806) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2808 = wave.ptr_add %728, %2798 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2809 = wave.ptr_add %733, %2794 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2810 = wave.select %2745, %2808, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2811 = waveamd.dma_load_lds %2810 -> %2809 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2812 = wave.ptr_add %728, %2801 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2813 = wave.ptr_add %739, %2794 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2814 = wave.select %2746, %2812, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2815 = waveamd.dma_load_lds %2814 -> %2813 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2816 = wave.ptr_add %728, %2804 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2817 = wave.ptr_add %744, %2794 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2818 = wave.select %2747, %2816, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2819 = waveamd.dma_load_lds %2818 -> %2817 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2820 = wave.ptr_add %728, %2807 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2821 = wave.ptr_add %749, %2794 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2822 = wave.select %2748, %2820, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2823 = waveamd.dma_load_lds %2822 -> %2821 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2824 = wave.join %2811, %2815, %2819, %2823 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2825 = wave.assume %arg12 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %2826 = wave.binary muli %2738, %2825 overflow<nsw> : i32, i32 -> i32
        %2827 = wave.binary muli %2752, %c4352_i32 overflow<nsw> : i32, i32 -> i32
        %2828 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2825, %133, %2826) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2829 = wave.assume %2828 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2830 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2829) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2831 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2825, %133, %2826) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2832 = wave.assume %2831 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2833 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2832) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2834 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2825, %133, %2826) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2835 = wave.assume %2834 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2836 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2835) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2837 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %2825, %133, %2826) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %2838 = wave.assume %2837 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %2839 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%2838) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %2840 = wave.ptr_add %766, %2830 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2841 = wave.ptr_add %769, %2827 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2842 = wave.select %2745, %2840, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2843 = waveamd.dma_load_lds %2842 -> %2841 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2844 = wave.ptr_add %766, %2833 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2845 = wave.ptr_add %775, %2827 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2846 = wave.select %2746, %2844, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2847 = waveamd.dma_load_lds %2846 -> %2845 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2848 = wave.ptr_add %766, %2836 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2849 = wave.ptr_add %780, %2827 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2850 = wave.select %2747, %2848, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2851 = waveamd.dma_load_lds %2850 -> %2849 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2852 = wave.ptr_add %766, %2839 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2853 = wave.ptr_add %785, %2827 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %2854 = wave.select %2748, %2852, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %2855 = waveamd.dma_load_lds %2854 -> %2853 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %2856 = wave.join %2843, %2847, %2851, %2855 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2857 = wave.join %2824, %2856 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2858 = waveamd.fragment_pack %671 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2859 = waveamd.fragment_pack %672 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2860 = waveamd.fragment_pack %673 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2861 = waveamd.fragment_pack %674 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2862 = waveamd.fragment_pack %675 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2863 = waveamd.fragment_pack %676 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2864 = waveamd.fragment_pack %677 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2865 = waveamd.fragment_pack %678 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2866 = waveamd.fragment_pack %679 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2867 = waveamd.fragment_pack %680 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2868 = waveamd.fragment_pack %681 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2869 = waveamd.fragment_pack %682 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2870 = waveamd.fragment_pack %683 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2871 = waveamd.fragment_pack %684 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2872 = waveamd.fragment_pack %685 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2873 = waveamd.fragment_pack %686 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %2874 = waveamd.fragment_pack %value_62 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2875 = waveamd.fragment_pack %value_64 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2876 = waveamd.fragment_pack %value_66 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2877 = waveamd.fragment_pack %value_68 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2878 = waveamd.fragment_pack %value_70 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2879 = waveamd.fragment_pack %value_72 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2880 = waveamd.fragment_pack %value_74 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2881 = waveamd.fragment_pack %value_76 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2882 = waveamd.fragment_pack %value_78 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2883 = waveamd.fragment_pack %value_80 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2884 = waveamd.fragment_pack %value_82 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2885 = waveamd.fragment_pack %value_84 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2886 = waveamd.fragment_pack %value_86 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2887 = waveamd.fragment_pack %value_88 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2888 = waveamd.fragment_pack %value_90 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2889 = waveamd.fragment_pack %value_92 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %2890 = waveamd.fragment_pack %112 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2891 = waveamd.mma "mfma.f32.32x32x16.bf16" %2874, %2858, %2890 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2892 = waveamd.mma "mfma.f32.32x32x16.bf16" %2875, %2859, %2891 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2893 = waveamd.mma "mfma.f32.32x32x16.bf16" %2876, %2860, %2892 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2894 = waveamd.mma "mfma.f32.32x32x16.bf16" %2877, %2861, %2893 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2895 = waveamd.mma "mfma.f32.32x32x16.bf16" %2878, %2862, %2894 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2896 = waveamd.mma "mfma.f32.32x32x16.bf16" %2879, %2863, %2895 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2897 = waveamd.mma "mfma.f32.32x32x16.bf16" %2880, %2864, %2896 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2898 = waveamd.mma "mfma.f32.32x32x16.bf16" %2881, %2865, %2897 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2899 = waveamd.fragment_unpack %2898 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %2900 = waveamd.mma "mfma.f32.32x32x16.bf16" %2882, %2858, %2890 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2901 = waveamd.mma "mfma.f32.32x32x16.bf16" %2883, %2859, %2900 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2902 = waveamd.mma "mfma.f32.32x32x16.bf16" %2884, %2860, %2901 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2903 = waveamd.mma "mfma.f32.32x32x16.bf16" %2885, %2861, %2902 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2904 = waveamd.mma "mfma.f32.32x32x16.bf16" %2886, %2862, %2903 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2905 = waveamd.mma "mfma.f32.32x32x16.bf16" %2887, %2863, %2904 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2906 = waveamd.mma "mfma.f32.32x32x16.bf16" %2888, %2864, %2905 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2907 = waveamd.mma "mfma.f32.32x32x16.bf16" %2889, %2865, %2906 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2908 = waveamd.fragment_unpack %2907 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %2909 = waveamd.mma "mfma.f32.32x32x16.bf16" %2874, %2866, %2890 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2910 = waveamd.mma "mfma.f32.32x32x16.bf16" %2875, %2867, %2909 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2911 = waveamd.mma "mfma.f32.32x32x16.bf16" %2876, %2868, %2910 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2912 = waveamd.mma "mfma.f32.32x32x16.bf16" %2877, %2869, %2911 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2913 = waveamd.mma "mfma.f32.32x32x16.bf16" %2878, %2870, %2912 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2914 = waveamd.mma "mfma.f32.32x32x16.bf16" %2879, %2871, %2913 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2915 = waveamd.mma "mfma.f32.32x32x16.bf16" %2880, %2872, %2914 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2916 = waveamd.mma "mfma.f32.32x32x16.bf16" %2881, %2873, %2915 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2917 = waveamd.fragment_unpack %2916 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %2918 = waveamd.mma "mfma.f32.32x32x16.bf16" %2882, %2866, %2890 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2919 = waveamd.mma "mfma.f32.32x32x16.bf16" %2883, %2867, %2918 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2920 = waveamd.mma "mfma.f32.32x32x16.bf16" %2884, %2868, %2919 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2921 = waveamd.mma "mfma.f32.32x32x16.bf16" %2885, %2869, %2920 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2922 = waveamd.mma "mfma.f32.32x32x16.bf16" %2886, %2870, %2921 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2923 = waveamd.mma "mfma.f32.32x32x16.bf16" %2887, %2871, %2922 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2924 = waveamd.mma "mfma.f32.32x32x16.bf16" %2888, %2872, %2923 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2925 = waveamd.mma "mfma.f32.32x32x16.bf16" %2889, %2873, %2924 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %2926 = waveamd.fragment_unpack %2925 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %2927 = wave.lane_id : !wave.simd<i32, 64>
        %2928 = wave.extract %2899[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2929 = wave.extract %2899[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2930 = wave.extract %2899[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2931 = wave.extract %2899[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2932 = wave.extract %2899[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2933 = wave.extract %2899[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2934 = wave.extract %2899[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2935 = wave.extract %2899[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2936 = wave.extract %2899[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2937 = wave.extract %2899[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2938 = wave.extract %2899[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2939 = wave.extract %2899[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2940 = wave.extract %2899[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2941 = wave.extract %2899[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2942 = wave.extract %2899[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2943 = wave.extract %2899[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2944 = wave.extract %2908[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2945 = wave.extract %2908[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2946 = wave.extract %2908[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2947 = wave.extract %2908[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2948 = wave.extract %2908[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2949 = wave.extract %2908[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2950 = wave.extract %2908[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2951 = wave.extract %2908[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2952 = wave.extract %2908[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2953 = wave.extract %2908[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2954 = wave.extract %2908[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2955 = wave.extract %2908[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2956 = wave.extract %2908[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2957 = wave.extract %2908[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2958 = wave.extract %2908[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2959 = wave.extract %2908[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2960 = wave.fmax %2928, %2929 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2961 = wave.fmax %2930, %2931 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2962 = wave.fmax %2932, %2933 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2963 = wave.fmax %2934, %2935 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2964 = wave.fmax %2936, %2937 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2965 = wave.fmax %2938, %2939 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2966 = wave.fmax %2940, %2941 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2967 = wave.fmax %2942, %2943 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2968 = wave.fmax %2944, %2945 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2969 = wave.fmax %2946, %2947 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2970 = wave.fmax %2948, %2949 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2971 = wave.fmax %2950, %2951 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2972 = wave.fmax %2952, %2953 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2973 = wave.fmax %2954, %2955 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2974 = wave.fmax %2956, %2957 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2975 = wave.fmax %2958, %2959 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2976 = wave.fmax %2960, %2961 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2977 = wave.fmax %2962, %2963 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2978 = wave.fmax %2964, %2965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2979 = wave.fmax %2966, %2967 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2980 = wave.fmax %2968, %2969 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2981 = wave.fmax %2970, %2971 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2982 = wave.fmax %2972, %2973 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2983 = wave.fmax %2974, %2975 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2984 = wave.fmax %2976, %2977 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2985 = wave.fmax %2978, %2979 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2986 = wave.fmax %2980, %2981 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2987 = wave.fmax %2982, %2983 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2988 = wave.fmax %2984, %2985 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2989 = wave.fmax %2986, %2987 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2990 = wave.fmax %2988, %2989 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2991 = wave.index_expr <"Mod(wi, 2) + 16*Mod(floor(1/16*wi), 2) + 8*Mod(floor(1/8*wi), 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> ["wi"](%2927) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %2992 = wave.shuffle %2990 from %2991 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %2993 = wave.index_expr <"xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(32 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2)))))"> ["wi"](%2927) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %2994 = wave.shuffle %2990 from %2993 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %2995 = wave.fmax %2992, %2994 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %2996 = wave.extract %2917[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2997 = wave.extract %2917[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2998 = wave.extract %2917[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %2999 = wave.extract %2917[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3000 = wave.extract %2917[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3001 = wave.extract %2917[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3002 = wave.extract %2917[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3003 = wave.extract %2917[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3004 = wave.extract %2917[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3005 = wave.extract %2917[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3006 = wave.extract %2917[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3007 = wave.extract %2917[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3008 = wave.extract %2917[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3009 = wave.extract %2917[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3010 = wave.extract %2917[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3011 = wave.extract %2917[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3012 = wave.extract %2926[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3013 = wave.extract %2926[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3014 = wave.extract %2926[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3015 = wave.extract %2926[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3016 = wave.extract %2926[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3017 = wave.extract %2926[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3018 = wave.extract %2926[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3019 = wave.extract %2926[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3020 = wave.extract %2926[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3021 = wave.extract %2926[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3022 = wave.extract %2926[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3023 = wave.extract %2926[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3024 = wave.extract %2926[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3025 = wave.extract %2926[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3026 = wave.extract %2926[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3027 = wave.extract %2926[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3028 = wave.fmax %2996, %2997 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3029 = wave.fmax %2998, %2999 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3030 = wave.fmax %3000, %3001 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3031 = wave.fmax %3002, %3003 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3032 = wave.fmax %3004, %3005 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3033 = wave.fmax %3006, %3007 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3034 = wave.fmax %3008, %3009 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3035 = wave.fmax %3010, %3011 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3036 = wave.fmax %3012, %3013 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3037 = wave.fmax %3014, %3015 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3038 = wave.fmax %3016, %3017 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3039 = wave.fmax %3018, %3019 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3040 = wave.fmax %3020, %3021 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3041 = wave.fmax %3022, %3023 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3042 = wave.fmax %3024, %3025 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3043 = wave.fmax %3026, %3027 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3044 = wave.fmax %3028, %3029 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3045 = wave.fmax %3030, %3031 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3046 = wave.fmax %3032, %3033 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3047 = wave.fmax %3034, %3035 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3048 = wave.fmax %3036, %3037 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3049 = wave.fmax %3038, %3039 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3050 = wave.fmax %3040, %3041 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3051 = wave.fmax %3042, %3043 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3052 = wave.fmax %3044, %3045 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3053 = wave.fmax %3046, %3047 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3054 = wave.fmax %3048, %3049 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3055 = wave.fmax %3050, %3051 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3056 = wave.fmax %3052, %3053 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3057 = wave.fmax %3054, %3055 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3058 = wave.fmax %3056, %3057 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3059 = wave.shuffle %3058 from %2991 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3060 = wave.shuffle %3058 from %2993 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3061 = wave.fmax %3059, %3060 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3062 = wave.fmul %2995, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3063 = wave.fmul %3061, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3064 = wave.fmax %arg20, %3062 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3065 = wave.fmax %arg21, %3063 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3066 = wave.fmul %2928, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3067 = wave.fmul %2929, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3068 = wave.fmul %2930, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3069 = wave.fmul %2931, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3070 = wave.fmul %2932, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3071 = wave.fmul %2933, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3072 = wave.fmul %2934, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3073 = wave.fmul %2935, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3074 = wave.fmul %2936, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3075 = wave.fmul %2937, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3076 = wave.fmul %2938, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3077 = wave.fmul %2939, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3078 = wave.fmul %2940, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3079 = wave.fmul %2941, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3080 = wave.fmul %2942, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3081 = wave.fmul %2943, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3082 = wave.fmul %2944, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3083 = wave.fmul %2945, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3084 = wave.fmul %2946, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3085 = wave.fmul %2947, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3086 = wave.fmul %2948, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3087 = wave.fmul %2949, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3088 = wave.fmul %2950, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3089 = wave.fmul %2951, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3090 = wave.fmul %2952, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3091 = wave.fmul %2953, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3092 = wave.fmul %2954, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3093 = wave.fmul %2955, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3094 = wave.fmul %2956, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3095 = wave.fmul %2957, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3096 = wave.fmul %2958, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3097 = wave.fmul %2959, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3098 = wave.fmul %2996, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3099 = wave.fmul %2997, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3100 = wave.fmul %2998, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3101 = wave.fmul %2999, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3102 = wave.fmul %3000, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3103 = wave.fmul %3001, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3104 = wave.fmul %3002, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3105 = wave.fmul %3003, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3106 = wave.fmul %3004, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3107 = wave.fmul %3005, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3108 = wave.fmul %3006, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3109 = wave.fmul %3007, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3110 = wave.fmul %3008, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3111 = wave.fmul %3009, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3112 = wave.fmul %3010, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3113 = wave.fmul %3011, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3114 = wave.fmul %3012, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3115 = wave.fmul %3013, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3116 = wave.fmul %3014, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3117 = wave.fmul %3015, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3118 = wave.fmul %3016, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3119 = wave.fmul %3017, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3120 = wave.fmul %3018, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3121 = wave.fmul %3019, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3122 = wave.fmul %3020, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3123 = wave.fmul %3021, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3124 = wave.fmul %3022, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3125 = wave.fmul %3023, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3126 = wave.fmul %3024, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3127 = wave.fmul %3025, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3128 = wave.fmul %3026, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3129 = wave.fmul %3027, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3130 = wave.fsub %3066, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3131 = wave.fsub %3067, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3132 = wave.fsub %3068, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3133 = wave.fsub %3069, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3134 = wave.fsub %3070, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3135 = wave.fsub %3071, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3136 = wave.fsub %3072, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3137 = wave.fsub %3073, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3138 = wave.fsub %3074, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3139 = wave.fsub %3075, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3140 = wave.fsub %3076, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3141 = wave.fsub %3077, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3142 = wave.fsub %3078, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3143 = wave.fsub %3079, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3144 = wave.fsub %3080, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3145 = wave.fsub %3081, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3146 = wave.fsub %3082, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3147 = wave.fsub %3083, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3148 = wave.fsub %3084, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3149 = wave.fsub %3085, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3150 = wave.fsub %3086, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3151 = wave.fsub %3087, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3152 = wave.fsub %3088, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3153 = wave.fsub %3089, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3154 = wave.fsub %3090, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3155 = wave.fsub %3091, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3156 = wave.fsub %3092, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3157 = wave.fsub %3093, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3158 = wave.fsub %3094, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3159 = wave.fsub %3095, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3160 = wave.fsub %3096, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3161 = wave.fsub %3097, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3162 = wave.fsub %3098, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3163 = wave.fsub %3099, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3164 = wave.fsub %3100, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3165 = wave.fsub %3101, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3166 = wave.fsub %3102, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3167 = wave.fsub %3103, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3168 = wave.fsub %3104, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3169 = wave.fsub %3105, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3170 = wave.fsub %3106, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3171 = wave.fsub %3107, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3172 = wave.fsub %3108, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3173 = wave.fsub %3109, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3174 = wave.fsub %3110, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3175 = wave.fsub %3111, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3176 = wave.fsub %3112, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3177 = wave.fsub %3113, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3178 = wave.fsub %3114, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3179 = wave.fsub %3115, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3180 = wave.fsub %3116, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3181 = wave.fsub %3117, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3182 = wave.fsub %3118, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3183 = wave.fsub %3119, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3184 = wave.fsub %3120, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3185 = wave.fsub %3121, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3186 = wave.fsub %3122, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3187 = wave.fsub %3123, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3188 = wave.fsub %3124, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3189 = wave.fsub %3125, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3190 = wave.fsub %3126, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3191 = wave.fsub %3127, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3192 = wave.fsub %3128, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3193 = wave.fsub %3129, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3194 = wave.fexp2 %3130 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3195 = wave.fexp2 %3131 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3196 = wave.fexp2 %3132 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3197 = wave.fexp2 %3133 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3198 = wave.fexp2 %3134 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3199 = wave.fexp2 %3135 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3200 = wave.fexp2 %3136 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3201 = wave.fexp2 %3137 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3202 = wave.fexp2 %3138 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3203 = wave.fexp2 %3139 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3204 = wave.fexp2 %3140 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3205 = wave.fexp2 %3141 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3206 = wave.fexp2 %3142 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3207 = wave.fexp2 %3143 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3208 = wave.fexp2 %3144 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3209 = wave.fexp2 %3145 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3210 = wave.pack %3194, %3195, %3196, %3197, %3198, %3199, %3200, %3201, %3202, %3203, %3204, %3205, %3206, %3207, %3208, %3209 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3211 = wave.fexp2 %3146 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3212 = wave.fexp2 %3147 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3213 = wave.fexp2 %3148 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3214 = wave.fexp2 %3149 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3215 = wave.fexp2 %3150 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3216 = wave.fexp2 %3151 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3217 = wave.fexp2 %3152 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3218 = wave.fexp2 %3153 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3219 = wave.fexp2 %3154 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3220 = wave.fexp2 %3155 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3221 = wave.fexp2 %3156 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3222 = wave.fexp2 %3157 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3223 = wave.fexp2 %3158 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3224 = wave.fexp2 %3159 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3225 = wave.fexp2 %3160 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3226 = wave.fexp2 %3161 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3227 = wave.pack %3211, %3212, %3213, %3214, %3215, %3216, %3217, %3218, %3219, %3220, %3221, %3222, %3223, %3224, %3225, %3226 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3228 = wave.fexp2 %3162 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3229 = wave.fexp2 %3163 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3230 = wave.fexp2 %3164 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3231 = wave.fexp2 %3165 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3232 = wave.fexp2 %3166 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3233 = wave.fexp2 %3167 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3234 = wave.fexp2 %3168 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3235 = wave.fexp2 %3169 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3236 = wave.fexp2 %3170 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3237 = wave.fexp2 %3171 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3238 = wave.fexp2 %3172 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3239 = wave.fexp2 %3173 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3240 = wave.fexp2 %3174 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3241 = wave.fexp2 %3175 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3242 = wave.fexp2 %3176 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3243 = wave.fexp2 %3177 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3244 = wave.pack %3228, %3229, %3230, %3231, %3232, %3233, %3234, %3235, %3236, %3237, %3238, %3239, %3240, %3241, %3242, %3243 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3245 = wave.fexp2 %3178 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3246 = wave.fexp2 %3179 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3247 = wave.fexp2 %3180 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3248 = wave.fexp2 %3181 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3249 = wave.fexp2 %3182 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3250 = wave.fexp2 %3183 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3251 = wave.fexp2 %3184 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3252 = wave.fexp2 %3185 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3253 = wave.fexp2 %3186 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3254 = wave.fexp2 %3187 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3255 = wave.fexp2 %3188 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3256 = wave.fexp2 %3189 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3257 = wave.fexp2 %3190 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3258 = wave.fexp2 %3191 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3259 = wave.fexp2 %3192 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3260 = wave.fexp2 %3193 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3261 = wave.pack %3245, %3246, %3247, %3248, %3249, %3250, %3251, %3252, %3253, %3254, %3255, %3256, %3257, %3258, %3259, %3260 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3262 = wave.fadd %3194, %3195 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3263 = wave.fadd %3196, %3197 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3264 = wave.fadd %3198, %3199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3265 = wave.fadd %3200, %3201 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3266 = wave.fadd %3202, %3203 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3267 = wave.fadd %3204, %3205 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3268 = wave.fadd %3206, %3207 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3269 = wave.fadd %3208, %3209 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3270 = wave.fadd %3211, %3212 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3271 = wave.fadd %3213, %3214 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3272 = wave.fadd %3215, %3216 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3273 = wave.fadd %3217, %3218 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3274 = wave.fadd %3219, %3220 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3275 = wave.fadd %3221, %3222 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3276 = wave.fadd %3223, %3224 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3277 = wave.fadd %3225, %3226 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3278 = wave.fadd %3262, %3263 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3279 = wave.fadd %3264, %3265 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3280 = wave.fadd %3266, %3267 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3281 = wave.fadd %3268, %3269 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3282 = wave.fadd %3270, %3271 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3283 = wave.fadd %3272, %3273 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3284 = wave.fadd %3274, %3275 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3285 = wave.fadd %3276, %3277 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3286 = wave.fadd %3278, %3279 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3287 = wave.fadd %3280, %3281 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3288 = wave.fadd %3282, %3283 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3289 = wave.fadd %3284, %3285 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3290 = wave.fadd %3286, %3287 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3291 = wave.fadd %3288, %3289 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3292 = wave.fadd %3290, %3291 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3293 = wave.shuffle %3292 from %2991 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3294 = wave.shuffle %3292 from %2993 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3295 = wave.fadd %3293, %3294 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3296 = wave.fadd %3228, %3229 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3297 = wave.fadd %3230, %3231 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3298 = wave.fadd %3232, %3233 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3299 = wave.fadd %3234, %3235 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3300 = wave.fadd %3236, %3237 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3301 = wave.fadd %3238, %3239 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3302 = wave.fadd %3240, %3241 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3303 = wave.fadd %3242, %3243 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3304 = wave.fadd %3245, %3246 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3305 = wave.fadd %3247, %3248 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3306 = wave.fadd %3249, %3250 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3307 = wave.fadd %3251, %3252 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3308 = wave.fadd %3253, %3254 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3309 = wave.fadd %3255, %3256 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3310 = wave.fadd %3257, %3258 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3311 = wave.fadd %3259, %3260 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3312 = wave.fadd %3296, %3297 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3313 = wave.fadd %3298, %3299 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3314 = wave.fadd %3300, %3301 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3315 = wave.fadd %3302, %3303 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3316 = wave.fadd %3304, %3305 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3317 = wave.fadd %3306, %3307 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3318 = wave.fadd %3308, %3309 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3319 = wave.fadd %3310, %3311 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3320 = wave.fadd %3312, %3313 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3321 = wave.fadd %3314, %3315 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3322 = wave.fadd %3316, %3317 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3323 = wave.fadd %3318, %3319 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3324 = wave.fadd %3320, %3321 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3325 = wave.fadd %3322, %3323 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3326 = wave.fadd %3324, %3325 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3327 = wave.shuffle %3326 from %2991 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3328 = wave.shuffle %3326 from %2993 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3329 = wave.fadd %3327, %3328 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3330 = wave.fsub %arg20, %3064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3331 = wave.fsub %arg21, %3065 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3332 = wave.fexp2 %3330 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3333 = wave.fexp2 %3331 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3334 = wave.extract %arg24[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3335 = wave.fmul %3334, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3336 = wave.extract %arg24[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3337 = wave.fmul %3336, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3338 = wave.extract %arg24[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3339 = wave.fmul %3338, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3340 = wave.extract %arg24[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3341 = wave.fmul %3340, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3342 = wave.extract %arg24[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3343 = wave.fmul %3342, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3344 = wave.extract %arg24[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3345 = wave.fmul %3344, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3346 = wave.extract %arg24[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3347 = wave.fmul %3346, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3348 = wave.extract %arg24[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3349 = wave.fmul %3348, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3350 = wave.extract %arg24[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3351 = wave.fmul %3350, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3352 = wave.extract %arg24[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3353 = wave.fmul %3352, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3354 = wave.extract %arg24[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3355 = wave.fmul %3354, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3356 = wave.extract %arg24[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3357 = wave.fmul %3356, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3358 = wave.extract %arg24[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3359 = wave.fmul %3358, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3360 = wave.extract %arg24[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3361 = wave.fmul %3360, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3362 = wave.extract %arg24[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3363 = wave.fmul %3362, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3364 = wave.extract %arg24[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3365 = wave.fmul %3364, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3366 = wave.pack %3335, %3337, %3339, %3341, %3343, %3345, %3347, %3349, %3351, %3353, %3355, %3357, %3359, %3361, %3363, %3365 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3367 = wave.extract %arg25[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3368 = wave.fmul %3367, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3369 = wave.extract %arg25[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3370 = wave.fmul %3369, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3371 = wave.extract %arg25[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3372 = wave.fmul %3371, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3373 = wave.extract %arg25[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3374 = wave.fmul %3373, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3375 = wave.extract %arg25[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3376 = wave.fmul %3375, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3377 = wave.extract %arg25[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3378 = wave.fmul %3377, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3379 = wave.extract %arg25[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3380 = wave.fmul %3379, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3381 = wave.extract %arg25[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3382 = wave.fmul %3381, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3383 = wave.extract %arg25[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3384 = wave.fmul %3383, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3385 = wave.extract %arg25[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3386 = wave.fmul %3385, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3387 = wave.extract %arg25[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3388 = wave.fmul %3387, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3389 = wave.extract %arg25[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3390 = wave.fmul %3389, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3391 = wave.extract %arg25[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3392 = wave.fmul %3391, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3393 = wave.extract %arg25[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3394 = wave.fmul %3393, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3395 = wave.extract %arg25[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3396 = wave.fmul %3395, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3397 = wave.extract %arg25[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3398 = wave.fmul %3397, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3399 = wave.pack %3368, %3370, %3372, %3374, %3376, %3378, %3380, %3382, %3384, %3386, %3388, %3390, %3392, %3394, %3396, %3398 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3400 = wave.extract %arg26[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3401 = wave.fmul %3400, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3402 = wave.extract %arg26[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3403 = wave.fmul %3402, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3404 = wave.extract %arg26[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3405 = wave.fmul %3404, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3406 = wave.extract %arg26[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3407 = wave.fmul %3406, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3408 = wave.extract %arg26[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3409 = wave.fmul %3408, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3410 = wave.extract %arg26[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3411 = wave.fmul %3410, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3412 = wave.extract %arg26[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3413 = wave.fmul %3412, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3414 = wave.extract %arg26[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3415 = wave.fmul %3414, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3416 = wave.extract %arg26[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3417 = wave.fmul %3416, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3418 = wave.extract %arg26[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3419 = wave.fmul %3418, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3420 = wave.extract %arg26[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3421 = wave.fmul %3420, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3422 = wave.extract %arg26[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3423 = wave.fmul %3422, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3424 = wave.extract %arg26[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3425 = wave.fmul %3424, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3426 = wave.extract %arg26[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3427 = wave.fmul %3426, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3428 = wave.extract %arg26[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3429 = wave.fmul %3428, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3430 = wave.extract %arg26[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3431 = wave.fmul %3430, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3432 = wave.pack %3401, %3403, %3405, %3407, %3409, %3411, %3413, %3415, %3417, %3419, %3421, %3423, %3425, %3427, %3429, %3431 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3433 = wave.extract %arg27[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3434 = wave.fmul %3433, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3435 = wave.extract %arg27[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3436 = wave.fmul %3435, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3437 = wave.extract %arg27[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3438 = wave.fmul %3437, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3439 = wave.extract %arg27[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3440 = wave.fmul %3439, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3441 = wave.extract %arg27[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3442 = wave.fmul %3441, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3443 = wave.extract %arg27[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3444 = wave.fmul %3443, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3445 = wave.extract %arg27[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3446 = wave.fmul %3445, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3447 = wave.extract %arg27[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3448 = wave.fmul %3447, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3449 = wave.extract %arg27[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3450 = wave.fmul %3449, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3451 = wave.extract %arg27[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3452 = wave.fmul %3451, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3453 = wave.extract %arg27[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3454 = wave.fmul %3453, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3455 = wave.extract %arg27[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3456 = wave.fmul %3455, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3457 = wave.extract %arg27[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3458 = wave.fmul %3457, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3459 = wave.extract %arg27[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3460 = wave.fmul %3459, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3461 = wave.extract %arg27[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3462 = wave.fmul %3461, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3463 = wave.extract %arg27[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3464 = wave.fmul %3463, %3332 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3465 = wave.pack %3434, %3436, %3438, %3440, %3442, %3444, %3446, %3448, %3450, %3452, %3454, %3456, %3458, %3460, %3462, %3464 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3466 = wave.extract %arg28[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3467 = wave.fmul %3466, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3468 = wave.extract %arg28[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3469 = wave.fmul %3468, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3470 = wave.extract %arg28[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3471 = wave.fmul %3470, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3472 = wave.extract %arg28[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3473 = wave.fmul %3472, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3474 = wave.extract %arg28[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3475 = wave.fmul %3474, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3476 = wave.extract %arg28[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3477 = wave.fmul %3476, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3478 = wave.extract %arg28[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3479 = wave.fmul %3478, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3480 = wave.extract %arg28[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3481 = wave.fmul %3480, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3482 = wave.extract %arg28[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3483 = wave.fmul %3482, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3484 = wave.extract %arg28[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3485 = wave.fmul %3484, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3486 = wave.extract %arg28[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3487 = wave.fmul %3486, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3488 = wave.extract %arg28[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3489 = wave.fmul %3488, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3490 = wave.extract %arg28[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3491 = wave.fmul %3490, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3492 = wave.extract %arg28[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3493 = wave.fmul %3492, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3494 = wave.extract %arg28[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3495 = wave.fmul %3494, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3496 = wave.extract %arg28[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3497 = wave.fmul %3496, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3498 = wave.pack %3467, %3469, %3471, %3473, %3475, %3477, %3479, %3481, %3483, %3485, %3487, %3489, %3491, %3493, %3495, %3497 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3499 = wave.extract %arg29[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3500 = wave.fmul %3499, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3501 = wave.extract %arg29[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3502 = wave.fmul %3501, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3503 = wave.extract %arg29[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3504 = wave.fmul %3503, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3505 = wave.extract %arg29[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3506 = wave.fmul %3505, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3507 = wave.extract %arg29[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3508 = wave.fmul %3507, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3509 = wave.extract %arg29[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3510 = wave.fmul %3509, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3511 = wave.extract %arg29[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3512 = wave.fmul %3511, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3513 = wave.extract %arg29[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3514 = wave.fmul %3513, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3515 = wave.extract %arg29[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3516 = wave.fmul %3515, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3517 = wave.extract %arg29[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3518 = wave.fmul %3517, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3519 = wave.extract %arg29[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3520 = wave.fmul %3519, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3521 = wave.extract %arg29[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3522 = wave.fmul %3521, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3523 = wave.extract %arg29[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3524 = wave.fmul %3523, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3525 = wave.extract %arg29[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3526 = wave.fmul %3525, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3527 = wave.extract %arg29[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3528 = wave.fmul %3527, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3529 = wave.extract %arg29[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3530 = wave.fmul %3529, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3531 = wave.pack %3500, %3502, %3504, %3506, %3508, %3510, %3512, %3514, %3516, %3518, %3520, %3522, %3524, %3526, %3528, %3530 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3532 = wave.extract %arg30[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3533 = wave.fmul %3532, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3534 = wave.extract %arg30[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3535 = wave.fmul %3534, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3536 = wave.extract %arg30[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3537 = wave.fmul %3536, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3538 = wave.extract %arg30[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3539 = wave.fmul %3538, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3540 = wave.extract %arg30[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3541 = wave.fmul %3540, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3542 = wave.extract %arg30[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3543 = wave.fmul %3542, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3544 = wave.extract %arg30[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3545 = wave.fmul %3544, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3546 = wave.extract %arg30[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3547 = wave.fmul %3546, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3548 = wave.extract %arg30[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3549 = wave.fmul %3548, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3550 = wave.extract %arg30[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3551 = wave.fmul %3550, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3552 = wave.extract %arg30[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3553 = wave.fmul %3552, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3554 = wave.extract %arg30[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3555 = wave.fmul %3554, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3556 = wave.extract %arg30[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3557 = wave.fmul %3556, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3558 = wave.extract %arg30[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3559 = wave.fmul %3558, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3560 = wave.extract %arg30[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3561 = wave.fmul %3560, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3562 = wave.extract %arg30[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3563 = wave.fmul %3562, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3564 = wave.pack %3533, %3535, %3537, %3539, %3541, %3543, %3545, %3547, %3549, %3551, %3553, %3555, %3557, %3559, %3561, %3563 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3565 = wave.extract %arg31[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3566 = wave.fmul %3565, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3567 = wave.extract %arg31[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3568 = wave.fmul %3567, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3569 = wave.extract %arg31[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3570 = wave.fmul %3569, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3571 = wave.extract %arg31[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3572 = wave.fmul %3571, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3573 = wave.extract %arg31[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3574 = wave.fmul %3573, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3575 = wave.extract %arg31[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3576 = wave.fmul %3575, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3577 = wave.extract %arg31[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3578 = wave.fmul %3577, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3579 = wave.extract %arg31[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3580 = wave.fmul %3579, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3581 = wave.extract %arg31[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3582 = wave.fmul %3581, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3583 = wave.extract %arg31[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3584 = wave.fmul %3583, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3585 = wave.extract %arg31[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3586 = wave.fmul %3585, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3587 = wave.extract %arg31[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3588 = wave.fmul %3587, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3589 = wave.extract %arg31[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3590 = wave.fmul %3589, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3591 = wave.extract %arg31[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3592 = wave.fmul %3591, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3593 = wave.extract %arg31[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3594 = wave.fmul %3593, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3595 = wave.extract %arg31[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3596 = wave.fmul %3595, %3333 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3597 = wave.pack %3566, %3568, %3570, %3572, %3574, %3576, %3578, %3580, %3582, %3584, %3586, %3588, %3590, %3592, %3594, %3596 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3598 = wave.fma %arg22, %3332, %3295 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3599 = wave.fma %arg23, %3333, %3329 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3600 = wave.cast fpconvert %3210 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3601 = wave.cast fpconvert %3227 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3602 = wave.cast fpconvert %3244 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3603 = wave.cast fpconvert %3261 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3604 = wave.extract %3600[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3605 = wave.extract %3600[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3606 = wave.extract %3601[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3607 = wave.extract %3601[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3608 = wave.extract %3602[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3609 = wave.extract %3602[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3610 = wave.extract %3603[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3611 = wave.extract %3603[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3612 = waveamd.fragment_pack %3604 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3613 = waveamd.fragment_pack %3605 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3614 = waveamd.fragment_pack %3606 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3615 = waveamd.fragment_pack %3607 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3616 = waveamd.fragment_pack %3608 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3617 = waveamd.fragment_pack %3609 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3618 = waveamd.fragment_pack %3610 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3619 = waveamd.fragment_pack %3611 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3620 = waveamd.fragment_pack %value_94 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3621 = waveamd.fragment_pack %value_96 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3622 = waveamd.fragment_pack %value_98 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3623 = waveamd.fragment_pack %value_100 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3624 = waveamd.fragment_pack %value_102 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3625 = waveamd.fragment_pack %value_104 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3626 = waveamd.fragment_pack %value_106 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3627 = waveamd.fragment_pack %value_108 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3628 = waveamd.fragment_pack %value_110 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3629 = waveamd.fragment_pack %value_112 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3630 = waveamd.fragment_pack %value_114 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3631 = waveamd.fragment_pack %value_116 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3632 = waveamd.fragment_pack %value_118 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3633 = waveamd.fragment_pack %value_120 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3634 = waveamd.fragment_pack %value_122 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3635 = waveamd.fragment_pack %value_124 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3636 = waveamd.fragment_pack %3366 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3637 = waveamd.fragment_pack %3399 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3638 = waveamd.fragment_pack %3432 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3639 = waveamd.fragment_pack %3465 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3640 = waveamd.fragment_pack %3498 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3641 = waveamd.fragment_pack %3531 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3642 = waveamd.fragment_pack %3564 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3643 = waveamd.fragment_pack %3597 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3644 = waveamd.mma "mfma.f32.32x32x16.bf16" %3620, %3612, %3636 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3645 = waveamd.mma "mfma.f32.32x32x16.bf16" %3621, %3613, %3644 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3646 = waveamd.mma "mfma.f32.32x32x16.bf16" %3622, %3614, %3645 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3647 = waveamd.mma "mfma.f32.32x32x16.bf16" %3623, %3615, %3646 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3648 = waveamd.fragment_unpack %3647 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3649 = waveamd.mma "mfma.f32.32x32x16.bf16" %3624, %3612, %3637 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3650 = waveamd.mma "mfma.f32.32x32x16.bf16" %3625, %3613, %3649 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3651 = waveamd.mma "mfma.f32.32x32x16.bf16" %3626, %3614, %3650 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3652 = waveamd.mma "mfma.f32.32x32x16.bf16" %3627, %3615, %3651 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3653 = waveamd.fragment_unpack %3652 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3654 = waveamd.mma "mfma.f32.32x32x16.bf16" %3628, %3612, %3638 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3655 = waveamd.mma "mfma.f32.32x32x16.bf16" %3629, %3613, %3654 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3656 = waveamd.mma "mfma.f32.32x32x16.bf16" %3630, %3614, %3655 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3657 = waveamd.mma "mfma.f32.32x32x16.bf16" %3631, %3615, %3656 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3658 = waveamd.fragment_unpack %3657 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3659 = waveamd.mma "mfma.f32.32x32x16.bf16" %3632, %3612, %3639 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3660 = waveamd.mma "mfma.f32.32x32x16.bf16" %3633, %3613, %3659 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3661 = waveamd.mma "mfma.f32.32x32x16.bf16" %3634, %3614, %3660 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3662 = waveamd.mma "mfma.f32.32x32x16.bf16" %3635, %3615, %3661 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3663 = waveamd.fragment_unpack %3662 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3664 = waveamd.mma "mfma.f32.32x32x16.bf16" %3620, %3616, %3640 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3665 = waveamd.mma "mfma.f32.32x32x16.bf16" %3621, %3617, %3664 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3666 = waveamd.mma "mfma.f32.32x32x16.bf16" %3622, %3618, %3665 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3667 = waveamd.mma "mfma.f32.32x32x16.bf16" %3623, %3619, %3666 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3668 = waveamd.fragment_unpack %3667 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3669 = waveamd.mma "mfma.f32.32x32x16.bf16" %3624, %3616, %3641 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3670 = waveamd.mma "mfma.f32.32x32x16.bf16" %3625, %3617, %3669 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3671 = waveamd.mma "mfma.f32.32x32x16.bf16" %3626, %3618, %3670 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3672 = waveamd.mma "mfma.f32.32x32x16.bf16" %3627, %3619, %3671 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3673 = waveamd.fragment_unpack %3672 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3674 = waveamd.mma "mfma.f32.32x32x16.bf16" %3628, %3616, %3642 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3675 = waveamd.mma "mfma.f32.32x32x16.bf16" %3629, %3617, %3674 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3676 = waveamd.mma "mfma.f32.32x32x16.bf16" %3630, %3618, %3675 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3677 = waveamd.mma "mfma.f32.32x32x16.bf16" %3631, %3619, %3676 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3678 = waveamd.fragment_unpack %3677 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3679 = waveamd.mma "mfma.f32.32x32x16.bf16" %3632, %3616, %3643 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3680 = waveamd.mma "mfma.f32.32x32x16.bf16" %3633, %3617, %3679 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3681 = waveamd.mma "mfma.f32.32x32x16.bf16" %3634, %3618, %3680 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3682 = waveamd.mma "mfma.f32.32x32x16.bf16" %3635, %3619, %3681 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3683 = waveamd.fragment_unpack %3682 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        scf.yield %3064, %3065, %3598, %3599, %3648, %3653, %3658, %3663, %3668, %3673, %3678, %3683, %2857 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.mem.token
      }
      %792 = wave.barrier %791#12 : (!wave.mem.token) -> !wave.mem.token
      %793 = wave.binary remui %693, %c2_i32 : i32, i32 -> i32
      %794 = wave.binary muli %793, %c8320_i32 overflow<nsw> : i32, i32 -> i32
      %795 = wave.ptr_add %687, %794 : !wave.ptr<#wave.shared, bf16>, i32 -> !wave.ptr<#wave.shared, bf16>
      %796 = wave.join %791#12, %792 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %797 = wave.index_expr <"8*floor(1/32*Mod(wi, 64)) + 128*floor(1/16*Mod(Mod(wi, 64), 32)) + 4160*Mod(floor(1/8*Mod(Mod(wi, 64), 32)), 2) + 2080*Mod(floor(1/4*Mod(Mod(wi, 64), 32)), 2) + 1040*Mod(floor(1/2*Mod(Mod(wi, 64), 32)), 2) + 520*Mod(Mod(Mod(wi, 64), 32), 2)"> ["wi"](%140) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %798 = wave.ptr_add %795, %797 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value, %token = wave.load %798 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %799 = wave.binary addi %797, %83 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %800 = wave.ptr_add %795, %799 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_0, %token_1 = wave.load %800 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %801 = wave.binary addi %797, %82 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %802 = wave.ptr_add %795, %801 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_2, %token_3 = wave.load %802 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %803 = wave.binary addi %797, %81 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %804 = wave.ptr_add %795, %803 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_4, %token_5 = wave.load %804 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %805 = wave.binary addi %797, %80 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %806 = wave.ptr_add %795, %805 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_6, %token_7 = wave.load %806 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %807 = wave.binary addi %797, %79 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %808 = wave.ptr_add %795, %807 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_8, %token_9 = wave.load %808 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %809 = wave.binary addi %797, %78 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %810 = wave.ptr_add %795, %809 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_10, %token_11 = wave.load %810 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %811 = wave.binary addi %797, %77 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %812 = wave.ptr_add %795, %811 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_12, %token_13 = wave.load %812 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %813 = wave.binary addi %797, %76 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %814 = wave.ptr_add %795, %813 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_14, %token_15 = wave.load %814 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %815 = wave.binary addi %797, %75 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %816 = wave.ptr_add %795, %815 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_16, %token_17 = wave.load %816 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %817 = wave.binary addi %797, %74 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %818 = wave.ptr_add %795, %817 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_18, %token_19 = wave.load %818 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %819 = wave.binary addi %797, %73 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %820 = wave.ptr_add %795, %819 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_20, %token_21 = wave.load %820 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %821 = wave.binary addi %797, %72 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %822 = wave.ptr_add %795, %821 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_22, %token_23 = wave.load %822 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %823 = wave.binary addi %797, %71 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %824 = wave.ptr_add %795, %823 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_24, %token_25 = wave.load %824 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %825 = wave.binary addi %797, %70 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %826 = wave.ptr_add %795, %825 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_26, %token_27 = wave.load %826 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %827 = wave.binary addi %797, %69 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
      %828 = wave.ptr_add %795, %827 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
      %value_28, %token_29 = wave.load %828 after %796 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %829 = wave.binary muli %793, %c8704_i32 overflow<nsw> : i32, i32 -> i32
      %830 = wave.ptr_add %688, %829 : !wave.ptr<#wave.shared, bf16>, i32 -> !wave.ptr<#wave.shared, bf16>
      %value_30, %token_31 = wave.gather %830 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 544*Mod(xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_32, %token_33 = wave.gather %830 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 544*Mod(xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_34, %token_35 = wave.gather %830 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 544*Mod(xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_36, %token_37 = wave.gather %830 mapping <bit_offset = <"16*(Mod(item, 2) + 256*Mod(floor(1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 16*Mod(floor(1/16*item), 2) + 128*Mod(floor(1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 8*Mod(floor(1/8*item), 2) + 4352*Mod(floor(1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4*Mod(floor(1/4*item), 2) + 2176*Mod(floor(1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2*Mod(floor(1/2*item), 2) + 1088*Mod(floor(1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 544*Mod(xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_38, %token_39 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_40, %token_41 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_42, %token_43 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_44, %token_45 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(32 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_46, %token_47 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_48, %token_49 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_50, %token_51 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_52, %token_53 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(64 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_54, %token_55 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2)), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(Mod(slot, 2) + 8*Mod(floor(1/4*slot), 2) + 2*Mod(floor(1/2*slot), 2), 4*Mod(floor(1/32*item), 2))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_56, %token_57 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(16 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_58, %token_59 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(32 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %value_60, %token_61 = wave.gather %830 mapping <bit_offset = <"16*(544*Mod(floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2)))), 2) + 256*Mod(floor(1/32*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/32*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 128*Mod(floor(1/16*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/16*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 4352*Mod(floor(1/8*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/8*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 2176*Mod(floor(1/4*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/4*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + 1088*Mod(floor(1/2*floor(1/128*xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2)))))) + 1/2*xor(4*Mod(floor(1/32*item), 2), xor(8*Mod(floor(1/4*slot), 2), xor(48 + Mod(slot, 2), 2*Mod(floor(1/2*slot), 2))))), 2) + Mod(xor(16*Mod(floor(1/16*item), 2), xor(8*Mod(floor(1/8*item), 2), xor(4*Mod(floor(1/4*item), 2), xor(96 + Mod(item, 2), 2*Mod(floor(1/2*item), 2))))), 128))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
      %831 = waveamd.fragment_pack %671 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %832 = waveamd.fragment_pack %672 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %833 = waveamd.fragment_pack %673 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %834 = waveamd.fragment_pack %674 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %835 = waveamd.fragment_pack %675 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %836 = waveamd.fragment_pack %676 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %837 = waveamd.fragment_pack %677 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %838 = waveamd.fragment_pack %678 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %839 = waveamd.fragment_pack %679 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %840 = waveamd.fragment_pack %680 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %841 = waveamd.fragment_pack %681 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %842 = waveamd.fragment_pack %682 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %843 = waveamd.fragment_pack %683 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %844 = waveamd.fragment_pack %684 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %845 = waveamd.fragment_pack %685 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %846 = waveamd.fragment_pack %686 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %847 = waveamd.fragment_pack %value : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %848 = waveamd.fragment_pack %value_0 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %849 = waveamd.fragment_pack %value_2 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %850 = waveamd.fragment_pack %value_4 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %851 = waveamd.fragment_pack %value_6 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %852 = waveamd.fragment_pack %value_8 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %853 = waveamd.fragment_pack %value_10 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %854 = waveamd.fragment_pack %value_12 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %855 = waveamd.fragment_pack %value_14 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %856 = waveamd.fragment_pack %value_16 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %857 = waveamd.fragment_pack %value_18 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %858 = waveamd.fragment_pack %value_20 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %859 = waveamd.fragment_pack %value_22 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %860 = waveamd.fragment_pack %value_24 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %861 = waveamd.fragment_pack %value_26 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %862 = waveamd.fragment_pack %value_28 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %863 = waveamd.fragment_pack %112 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %864 = waveamd.mma "mfma.f32.32x32x16.bf16" %847, %831, %863 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %865 = waveamd.mma "mfma.f32.32x32x16.bf16" %848, %832, %864 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %866 = waveamd.mma "mfma.f32.32x32x16.bf16" %849, %833, %865 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %867 = waveamd.mma "mfma.f32.32x32x16.bf16" %850, %834, %866 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %868 = waveamd.mma "mfma.f32.32x32x16.bf16" %851, %835, %867 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %869 = waveamd.mma "mfma.f32.32x32x16.bf16" %852, %836, %868 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %870 = waveamd.mma "mfma.f32.32x32x16.bf16" %853, %837, %869 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %871 = waveamd.mma "mfma.f32.32x32x16.bf16" %854, %838, %870 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %872 = waveamd.fragment_unpack %871 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %873 = waveamd.mma "mfma.f32.32x32x16.bf16" %855, %831, %863 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %874 = waveamd.mma "mfma.f32.32x32x16.bf16" %856, %832, %873 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %875 = waveamd.mma "mfma.f32.32x32x16.bf16" %857, %833, %874 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %876 = waveamd.mma "mfma.f32.32x32x16.bf16" %858, %834, %875 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %877 = waveamd.mma "mfma.f32.32x32x16.bf16" %859, %835, %876 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %878 = waveamd.mma "mfma.f32.32x32x16.bf16" %860, %836, %877 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %879 = waveamd.mma "mfma.f32.32x32x16.bf16" %861, %837, %878 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %880 = waveamd.mma "mfma.f32.32x32x16.bf16" %862, %838, %879 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %881 = waveamd.fragment_unpack %880 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %882 = waveamd.mma "mfma.f32.32x32x16.bf16" %847, %839, %863 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %883 = waveamd.mma "mfma.f32.32x32x16.bf16" %848, %840, %882 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %884 = waveamd.mma "mfma.f32.32x32x16.bf16" %849, %841, %883 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %885 = waveamd.mma "mfma.f32.32x32x16.bf16" %850, %842, %884 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %886 = waveamd.mma "mfma.f32.32x32x16.bf16" %851, %843, %885 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %887 = waveamd.mma "mfma.f32.32x32x16.bf16" %852, %844, %886 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %888 = waveamd.mma "mfma.f32.32x32x16.bf16" %853, %845, %887 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %889 = waveamd.mma "mfma.f32.32x32x16.bf16" %854, %846, %888 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %890 = waveamd.fragment_unpack %889 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %891 = waveamd.mma "mfma.f32.32x32x16.bf16" %855, %839, %863 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %892 = waveamd.mma "mfma.f32.32x32x16.bf16" %856, %840, %891 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %893 = waveamd.mma "mfma.f32.32x32x16.bf16" %857, %841, %892 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %894 = waveamd.mma "mfma.f32.32x32x16.bf16" %858, %842, %893 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %895 = waveamd.mma "mfma.f32.32x32x16.bf16" %859, %843, %894 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %896 = waveamd.mma "mfma.f32.32x32x16.bf16" %860, %844, %895 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %897 = waveamd.mma "mfma.f32.32x32x16.bf16" %861, %845, %896 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %898 = waveamd.mma "mfma.f32.32x32x16.bf16" %862, %846, %897 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %899 = waveamd.fragment_unpack %898 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %900 = wave.binary muli %180, %102 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %901 = wave.splat %790 : i32 -> !wave.simd<i32, 64>
      %902 = wave.binary addi %900, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %903 = wave.binary xori %68, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %904 = wave.binary addi %903, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %905 = wave.binary xori %103, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %906 = wave.binary addi %905, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %907 = wave.binary xori %67, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %908 = wave.binary addi %907, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %909 = wave.binary xori %101, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %910 = wave.binary addi %909, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %911 = wave.binary xori %66, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %912 = wave.binary addi %911, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %913 = wave.binary xori %65, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %914 = wave.binary addi %913, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %915 = wave.binary xori %64, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %916 = wave.binary addi %915, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %917 = wave.binary xori %100, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %918 = wave.binary addi %917, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %919 = wave.binary xori %63, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %920 = wave.binary addi %919, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %921 = wave.binary xori %62, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %922 = wave.binary addi %921, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %923 = wave.binary xori %61, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %924 = wave.binary addi %923, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %925 = wave.binary xori %60, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %926 = wave.binary addi %925, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %927 = wave.binary xori %59, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %928 = wave.binary addi %927, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %929 = wave.binary xori %58, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %930 = wave.binary addi %929, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %931 = wave.binary xori %57, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %932 = wave.binary addi %931, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %933 = wave.binary xori %98, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %934 = wave.binary addi %933, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary xori %56, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.binary addi %935, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %937 = wave.binary xori %55, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary addi %937, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary xori %54, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary addi %939, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary xori %53, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary addi %941, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary xori %52, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary addi %943, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary xori %51, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary addi %945, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.binary xori %50, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %948 = wave.binary addi %947, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %949 = wave.binary xori %96, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.binary addi %949, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %951 = wave.binary xori %49, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary addi %951, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary xori %48, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary addi %953, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary xori %47, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary addi %955, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary xori %46, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary addi %957, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary xori %45, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary addi %959, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.binary xori %44, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %962 = wave.binary addi %961, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %963 = wave.binary xori %43, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %964 = wave.binary addi %963, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %965 = wave.cmpi slt %902, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %966 = wave.cmpi slt %904, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %967 = wave.cmpi slt %906, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %968 = wave.cmpi slt %908, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %969 = wave.cmpi slt %910, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %970 = wave.cmpi slt %912, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %971 = wave.cmpi slt %914, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %972 = wave.cmpi slt %916, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %973 = wave.cmpi slt %918, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %974 = wave.cmpi slt %920, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %975 = wave.cmpi slt %922, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %976 = wave.cmpi slt %924, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %977 = wave.cmpi slt %926, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %978 = wave.cmpi slt %928, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %979 = wave.cmpi slt %930, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %980 = wave.cmpi slt %932, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %981 = wave.cmpi slt %934, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %982 = wave.cmpi slt %936, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %983 = wave.cmpi slt %938, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %984 = wave.cmpi slt %940, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %985 = wave.cmpi slt %942, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %986 = wave.cmpi slt %944, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %987 = wave.cmpi slt %946, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %988 = wave.cmpi slt %948, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %989 = wave.cmpi slt %950, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %990 = wave.cmpi slt %952, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %991 = wave.cmpi slt %954, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %992 = wave.cmpi slt %956, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %993 = wave.cmpi slt %958, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %994 = wave.cmpi slt %960, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %995 = wave.cmpi slt %962, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %996 = wave.cmpi slt %964, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %997 = wave.extract %872[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %998 = wave.extract %872[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %999 = wave.extract %872[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1000 = wave.extract %872[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1001 = wave.extract %872[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1002 = wave.extract %872[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1003 = wave.extract %872[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1004 = wave.extract %872[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1005 = wave.extract %872[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1006 = wave.extract %872[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1007 = wave.extract %872[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1008 = wave.extract %872[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1009 = wave.extract %872[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1010 = wave.extract %872[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1011 = wave.extract %872[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1012 = wave.extract %872[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1013 = wave.extract %881[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1014 = wave.extract %881[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1015 = wave.extract %881[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1016 = wave.extract %881[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1017 = wave.extract %881[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1018 = wave.extract %881[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1019 = wave.extract %881[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1020 = wave.extract %881[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1021 = wave.extract %881[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1022 = wave.extract %881[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1023 = wave.extract %881[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1024 = wave.extract %881[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1025 = wave.extract %881[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1026 = wave.extract %881[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1027 = wave.extract %881[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1028 = wave.extract %881[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1029 = wave.extract %890[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1030 = wave.extract %890[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1031 = wave.extract %890[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1032 = wave.extract %890[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1033 = wave.extract %890[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1034 = wave.extract %890[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1035 = wave.extract %890[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1036 = wave.extract %890[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1037 = wave.extract %890[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1038 = wave.extract %890[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1039 = wave.extract %890[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1040 = wave.extract %890[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1041 = wave.extract %890[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1042 = wave.extract %890[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1043 = wave.extract %890[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1044 = wave.extract %890[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1045 = wave.extract %899[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1046 = wave.extract %899[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1047 = wave.extract %899[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1048 = wave.extract %899[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1049 = wave.extract %899[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1050 = wave.extract %899[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1051 = wave.extract %899[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1052 = wave.extract %899[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1053 = wave.extract %899[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1054 = wave.extract %899[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1055 = wave.extract %899[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1056 = wave.extract %899[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1057 = wave.extract %899[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1058 = wave.extract %899[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1059 = wave.extract %899[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1060 = wave.extract %899[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1061 = wave.select %965, %997, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1062 = wave.select %966, %998, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1063 = wave.select %967, %999, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1064 = wave.select %968, %1000, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1065 = wave.select %969, %1001, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1066 = wave.select %970, %1002, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1067 = wave.select %971, %1003, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1068 = wave.select %972, %1004, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1069 = wave.select %973, %1005, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1070 = wave.select %974, %1006, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1071 = wave.select %975, %1007, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1072 = wave.select %976, %1008, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1073 = wave.select %977, %1009, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1074 = wave.select %978, %1010, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1075 = wave.select %979, %1011, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1076 = wave.select %980, %1012, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1077 = wave.select %981, %1013, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1078 = wave.select %982, %1014, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1079 = wave.select %983, %1015, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1080 = wave.select %984, %1016, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1081 = wave.select %985, %1017, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1082 = wave.select %986, %1018, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1083 = wave.select %987, %1019, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1084 = wave.select %988, %1020, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1085 = wave.select %989, %1021, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1086 = wave.select %990, %1022, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1087 = wave.select %991, %1023, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1088 = wave.select %992, %1024, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1089 = wave.select %993, %1025, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1090 = wave.select %994, %1026, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1091 = wave.select %995, %1027, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1092 = wave.select %996, %1028, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1093 = wave.select %965, %1029, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1094 = wave.select %966, %1030, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1095 = wave.select %967, %1031, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1096 = wave.select %968, %1032, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1097 = wave.select %969, %1033, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1098 = wave.select %970, %1034, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1099 = wave.select %971, %1035, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1100 = wave.select %972, %1036, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1101 = wave.select %973, %1037, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1102 = wave.select %974, %1038, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1103 = wave.select %975, %1039, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1104 = wave.select %976, %1040, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1105 = wave.select %977, %1041, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1106 = wave.select %978, %1042, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1107 = wave.select %979, %1043, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1108 = wave.select %980, %1044, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1109 = wave.select %981, %1045, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1110 = wave.select %982, %1046, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1111 = wave.select %983, %1047, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1112 = wave.select %984, %1048, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1113 = wave.select %985, %1049, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1114 = wave.select %986, %1050, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1115 = wave.select %987, %1051, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1116 = wave.select %988, %1052, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1117 = wave.select %989, %1053, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1118 = wave.select %990, %1054, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1119 = wave.select %991, %1055, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1120 = wave.select %992, %1056, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1121 = wave.select %993, %1057, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1122 = wave.select %994, %1058, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1123 = wave.select %995, %1059, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1124 = wave.select %996, %1060, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1125 = wave.lane_id : !wave.simd<i32, 64>
      %1126 = wave.fmax %1061, %1062 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1127 = wave.fmax %1063, %1064 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1128 = wave.fmax %1065, %1066 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1129 = wave.fmax %1067, %1068 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1130 = wave.fmax %1069, %1070 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1131 = wave.fmax %1071, %1072 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1132 = wave.fmax %1073, %1074 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1133 = wave.fmax %1075, %1076 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1134 = wave.fmax %1077, %1078 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1135 = wave.fmax %1079, %1080 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1136 = wave.fmax %1081, %1082 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1137 = wave.fmax %1083, %1084 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1138 = wave.fmax %1085, %1086 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1139 = wave.fmax %1087, %1088 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1140 = wave.fmax %1089, %1090 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1141 = wave.fmax %1091, %1092 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1142 = wave.fmax %1126, %1127 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1143 = wave.fmax %1128, %1129 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1144 = wave.fmax %1130, %1131 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1145 = wave.fmax %1132, %1133 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1146 = wave.fmax %1134, %1135 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1147 = wave.fmax %1136, %1137 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1148 = wave.fmax %1138, %1139 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1149 = wave.fmax %1140, %1141 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1150 = wave.fmax %1142, %1143 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1151 = wave.fmax %1144, %1145 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1152 = wave.fmax %1146, %1147 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1153 = wave.fmax %1148, %1149 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1154 = wave.fmax %1150, %1151 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1155 = wave.fmax %1152, %1153 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1156 = wave.fmax %1154, %1155 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1157 = wave.index_expr <"Mod(wi, 2) + 16*Mod(floor(1/16*wi), 2) + 8*Mod(floor(1/8*wi), 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> ["wi"](%1125) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1158 = wave.shuffle %1156 from %1157 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1159 = wave.index_expr <"xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(32 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2)))))"> ["wi"](%1125) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1160 = wave.shuffle %1156 from %1159 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1161 = wave.fmax %1158, %1160 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1162 = wave.fmax %1093, %1094 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1163 = wave.fmax %1095, %1096 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1164 = wave.fmax %1097, %1098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1165 = wave.fmax %1099, %1100 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1166 = wave.fmax %1101, %1102 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1167 = wave.fmax %1103, %1104 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1168 = wave.fmax %1105, %1106 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1169 = wave.fmax %1107, %1108 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1170 = wave.fmax %1109, %1110 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1171 = wave.fmax %1111, %1112 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1172 = wave.fmax %1113, %1114 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1173 = wave.fmax %1115, %1116 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1174 = wave.fmax %1117, %1118 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1175 = wave.fmax %1119, %1120 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1176 = wave.fmax %1121, %1122 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1177 = wave.fmax %1123, %1124 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1178 = wave.fmax %1162, %1163 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1179 = wave.fmax %1164, %1165 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1180 = wave.fmax %1166, %1167 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1181 = wave.fmax %1168, %1169 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1182 = wave.fmax %1170, %1171 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1183 = wave.fmax %1172, %1173 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1184 = wave.fmax %1174, %1175 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1185 = wave.fmax %1176, %1177 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1186 = wave.fmax %1178, %1179 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1187 = wave.fmax %1180, %1181 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1188 = wave.fmax %1182, %1183 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1189 = wave.fmax %1184, %1185 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1190 = wave.fmax %1186, %1187 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1191 = wave.fmax %1188, %1189 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1192 = wave.fmax %1190, %1191 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1193 = wave.shuffle %1192 from %1157 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1194 = wave.shuffle %1192 from %1159 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1195 = wave.fmax %1193, %1194 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1196 = wave.fmul %1161, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1197 = wave.fmul %1195, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1198 = wave.fmax %791#0, %1196 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1199 = wave.fmax %791#1, %1197 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1200 = wave.fmul %1061, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1201 = wave.fmul %1062, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1202 = wave.fmul %1063, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1203 = wave.fmul %1064, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1204 = wave.fmul %1065, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1205 = wave.fmul %1066, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1206 = wave.fmul %1067, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1207 = wave.fmul %1068, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1208 = wave.fmul %1069, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1209 = wave.fmul %1070, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1210 = wave.fmul %1071, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1211 = wave.fmul %1072, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1212 = wave.fmul %1073, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1213 = wave.fmul %1074, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1214 = wave.fmul %1075, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1215 = wave.fmul %1076, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1216 = wave.fmul %1077, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1217 = wave.fmul %1078, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1218 = wave.fmul %1079, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1219 = wave.fmul %1080, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1220 = wave.fmul %1081, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1221 = wave.fmul %1082, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1222 = wave.fmul %1083, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1223 = wave.fmul %1084, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1224 = wave.fmul %1085, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1225 = wave.fmul %1086, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1226 = wave.fmul %1087, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1227 = wave.fmul %1088, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1228 = wave.fmul %1089, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1229 = wave.fmul %1090, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1230 = wave.fmul %1091, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1231 = wave.fmul %1092, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1232 = wave.fmul %1093, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1233 = wave.fmul %1094, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1234 = wave.fmul %1095, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1235 = wave.fmul %1096, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1236 = wave.fmul %1097, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1237 = wave.fmul %1098, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1238 = wave.fmul %1099, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1239 = wave.fmul %1100, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1240 = wave.fmul %1101, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1241 = wave.fmul %1102, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1242 = wave.fmul %1103, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1243 = wave.fmul %1104, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1244 = wave.fmul %1105, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1245 = wave.fmul %1106, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1246 = wave.fmul %1107, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1247 = wave.fmul %1108, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1248 = wave.fmul %1109, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1249 = wave.fmul %1110, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1250 = wave.fmul %1111, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1251 = wave.fmul %1112, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1252 = wave.fmul %1113, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1253 = wave.fmul %1114, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1254 = wave.fmul %1115, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1255 = wave.fmul %1116, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1256 = wave.fmul %1117, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1257 = wave.fmul %1118, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1258 = wave.fmul %1119, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1259 = wave.fmul %1120, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1260 = wave.fmul %1121, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1261 = wave.fmul %1122, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1262 = wave.fmul %1123, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1263 = wave.fmul %1124, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1264 = wave.fsub %1200, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1265 = wave.fsub %1201, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1266 = wave.fsub %1202, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1267 = wave.fsub %1203, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1268 = wave.fsub %1204, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1269 = wave.fsub %1205, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1270 = wave.fsub %1206, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1271 = wave.fsub %1207, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1272 = wave.fsub %1208, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1273 = wave.fsub %1209, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1274 = wave.fsub %1210, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1275 = wave.fsub %1211, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1276 = wave.fsub %1212, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1277 = wave.fsub %1213, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1278 = wave.fsub %1214, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1279 = wave.fsub %1215, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1280 = wave.fsub %1216, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1281 = wave.fsub %1217, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1282 = wave.fsub %1218, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1283 = wave.fsub %1219, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1284 = wave.fsub %1220, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1285 = wave.fsub %1221, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1286 = wave.fsub %1222, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1287 = wave.fsub %1223, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1288 = wave.fsub %1224, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1289 = wave.fsub %1225, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1290 = wave.fsub %1226, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1291 = wave.fsub %1227, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1292 = wave.fsub %1228, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1293 = wave.fsub %1229, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1294 = wave.fsub %1230, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1295 = wave.fsub %1231, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1296 = wave.fsub %1232, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1297 = wave.fsub %1233, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1298 = wave.fsub %1234, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1299 = wave.fsub %1235, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1300 = wave.fsub %1236, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1301 = wave.fsub %1237, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1302 = wave.fsub %1238, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1303 = wave.fsub %1239, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1304 = wave.fsub %1240, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1305 = wave.fsub %1241, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1306 = wave.fsub %1242, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1307 = wave.fsub %1243, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1308 = wave.fsub %1244, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1309 = wave.fsub %1245, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1310 = wave.fsub %1246, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1311 = wave.fsub %1247, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1312 = wave.fsub %1248, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1313 = wave.fsub %1249, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1314 = wave.fsub %1250, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1315 = wave.fsub %1251, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1316 = wave.fsub %1252, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1317 = wave.fsub %1253, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1318 = wave.fsub %1254, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1319 = wave.fsub %1255, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1320 = wave.fsub %1256, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1321 = wave.fsub %1257, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1322 = wave.fsub %1258, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1323 = wave.fsub %1259, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1324 = wave.fsub %1260, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1325 = wave.fsub %1261, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1326 = wave.fsub %1262, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1327 = wave.fsub %1263, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1328 = wave.fexp2 %1264 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1329 = wave.fexp2 %1265 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1330 = wave.fexp2 %1266 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1331 = wave.fexp2 %1267 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1332 = wave.fexp2 %1268 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1333 = wave.fexp2 %1269 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1334 = wave.fexp2 %1270 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1335 = wave.fexp2 %1271 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1336 = wave.fexp2 %1272 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1337 = wave.fexp2 %1273 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1338 = wave.fexp2 %1274 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1339 = wave.fexp2 %1275 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1340 = wave.fexp2 %1276 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1341 = wave.fexp2 %1277 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1342 = wave.fexp2 %1278 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1343 = wave.fexp2 %1279 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1344 = wave.pack %1328, %1329, %1330, %1331, %1332, %1333, %1334, %1335, %1336, %1337, %1338, %1339, %1340, %1341, %1342, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1345 = wave.fexp2 %1280 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1346 = wave.fexp2 %1281 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1347 = wave.fexp2 %1282 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1348 = wave.fexp2 %1283 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1349 = wave.fexp2 %1284 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1350 = wave.fexp2 %1285 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1351 = wave.fexp2 %1286 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1352 = wave.fexp2 %1287 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1353 = wave.fexp2 %1288 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1354 = wave.fexp2 %1289 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1355 = wave.fexp2 %1290 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1356 = wave.fexp2 %1291 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1357 = wave.fexp2 %1292 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1358 = wave.fexp2 %1293 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1359 = wave.fexp2 %1294 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1360 = wave.fexp2 %1295 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1361 = wave.pack %1345, %1346, %1347, %1348, %1349, %1350, %1351, %1352, %1353, %1354, %1355, %1356, %1357, %1358, %1359, %1360 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1362 = wave.fexp2 %1296 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1363 = wave.fexp2 %1297 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1364 = wave.fexp2 %1298 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1365 = wave.fexp2 %1299 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1366 = wave.fexp2 %1300 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1367 = wave.fexp2 %1301 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1368 = wave.fexp2 %1302 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1369 = wave.fexp2 %1303 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1370 = wave.fexp2 %1304 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1371 = wave.fexp2 %1305 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1372 = wave.fexp2 %1306 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1373 = wave.fexp2 %1307 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1374 = wave.fexp2 %1308 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1375 = wave.fexp2 %1309 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1376 = wave.fexp2 %1310 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1377 = wave.fexp2 %1311 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1378 = wave.pack %1362, %1363, %1364, %1365, %1366, %1367, %1368, %1369, %1370, %1371, %1372, %1373, %1374, %1375, %1376, %1377 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1379 = wave.fexp2 %1312 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1380 = wave.fexp2 %1313 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1381 = wave.fexp2 %1314 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1382 = wave.fexp2 %1315 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1383 = wave.fexp2 %1316 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1384 = wave.fexp2 %1317 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1385 = wave.fexp2 %1318 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1386 = wave.fexp2 %1319 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1387 = wave.fexp2 %1320 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1388 = wave.fexp2 %1321 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1389 = wave.fexp2 %1322 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1390 = wave.fexp2 %1323 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1391 = wave.fexp2 %1324 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1392 = wave.fexp2 %1325 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1393 = wave.fexp2 %1326 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1394 = wave.fexp2 %1327 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1395 = wave.pack %1379, %1380, %1381, %1382, %1383, %1384, %1385, %1386, %1387, %1388, %1389, %1390, %1391, %1392, %1393, %1394 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1396 = wave.fadd %1328, %1329 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1397 = wave.fadd %1330, %1331 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1398 = wave.fadd %1332, %1333 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1399 = wave.fadd %1334, %1335 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1400 = wave.fadd %1336, %1337 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1401 = wave.fadd %1338, %1339 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1402 = wave.fadd %1340, %1341 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1403 = wave.fadd %1342, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1404 = wave.fadd %1345, %1346 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1405 = wave.fadd %1347, %1348 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1406 = wave.fadd %1349, %1350 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1407 = wave.fadd %1351, %1352 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1408 = wave.fadd %1353, %1354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1409 = wave.fadd %1355, %1356 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1410 = wave.fadd %1357, %1358 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1411 = wave.fadd %1359, %1360 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1412 = wave.fadd %1396, %1397 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1413 = wave.fadd %1398, %1399 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1414 = wave.fadd %1400, %1401 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1415 = wave.fadd %1402, %1403 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1416 = wave.fadd %1404, %1405 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1417 = wave.fadd %1406, %1407 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1418 = wave.fadd %1408, %1409 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1419 = wave.fadd %1410, %1411 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1420 = wave.fadd %1412, %1413 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1421 = wave.fadd %1414, %1415 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1422 = wave.fadd %1416, %1417 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1423 = wave.fadd %1418, %1419 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1424 = wave.fadd %1420, %1421 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1425 = wave.fadd %1422, %1423 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1426 = wave.fadd %1424, %1425 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1427 = wave.shuffle %1426 from %1157 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1428 = wave.shuffle %1426 from %1159 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1429 = wave.fadd %1427, %1428 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1430 = wave.fadd %1362, %1363 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1431 = wave.fadd %1364, %1365 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1432 = wave.fadd %1366, %1367 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1433 = wave.fadd %1368, %1369 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1434 = wave.fadd %1370, %1371 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1435 = wave.fadd %1372, %1373 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1436 = wave.fadd %1374, %1375 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1437 = wave.fadd %1376, %1377 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1438 = wave.fadd %1379, %1380 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1439 = wave.fadd %1381, %1382 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1440 = wave.fadd %1383, %1384 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1441 = wave.fadd %1385, %1386 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1442 = wave.fadd %1387, %1388 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1443 = wave.fadd %1389, %1390 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1444 = wave.fadd %1391, %1392 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1445 = wave.fadd %1393, %1394 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1446 = wave.fadd %1430, %1431 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1447 = wave.fadd %1432, %1433 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1448 = wave.fadd %1434, %1435 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1449 = wave.fadd %1436, %1437 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1450 = wave.fadd %1438, %1439 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1451 = wave.fadd %1440, %1441 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1452 = wave.fadd %1442, %1443 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1453 = wave.fadd %1444, %1445 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1454 = wave.fadd %1446, %1447 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1455 = wave.fadd %1448, %1449 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1456 = wave.fadd %1450, %1451 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1457 = wave.fadd %1452, %1453 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1458 = wave.fadd %1454, %1455 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1459 = wave.fadd %1456, %1457 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1460 = wave.fadd %1458, %1459 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1461 = wave.shuffle %1460 from %1157 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1462 = wave.shuffle %1460 from %1159 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1463 = wave.fadd %1461, %1462 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1464 = wave.fsub %791#0, %1198 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1465 = wave.fsub %791#1, %1199 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1466 = wave.fexp2 %1464 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1467 = wave.fexp2 %1465 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1468 = wave.extract %791#4[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1469 = wave.fmul %1468, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1470 = wave.extract %791#4[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1471 = wave.fmul %1470, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1472 = wave.extract %791#4[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1473 = wave.fmul %1472, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1474 = wave.extract %791#4[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1475 = wave.fmul %1474, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1476 = wave.extract %791#4[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1477 = wave.fmul %1476, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1478 = wave.extract %791#4[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1479 = wave.fmul %1478, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1480 = wave.extract %791#4[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1481 = wave.fmul %1480, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1482 = wave.extract %791#4[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1483 = wave.fmul %1482, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1484 = wave.extract %791#4[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1485 = wave.fmul %1484, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1486 = wave.extract %791#4[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1487 = wave.fmul %1486, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1488 = wave.extract %791#4[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1489 = wave.fmul %1488, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1490 = wave.extract %791#4[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1491 = wave.fmul %1490, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1492 = wave.extract %791#4[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1493 = wave.fmul %1492, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1494 = wave.extract %791#4[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1495 = wave.fmul %1494, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1496 = wave.extract %791#4[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1497 = wave.fmul %1496, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1498 = wave.extract %791#4[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1499 = wave.fmul %1498, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1500 = wave.pack %1469, %1471, %1473, %1475, %1477, %1479, %1481, %1483, %1485, %1487, %1489, %1491, %1493, %1495, %1497, %1499 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1501 = wave.extract %791#5[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1502 = wave.fmul %1501, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1503 = wave.extract %791#5[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1504 = wave.fmul %1503, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1505 = wave.extract %791#5[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1506 = wave.fmul %1505, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1507 = wave.extract %791#5[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1508 = wave.fmul %1507, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1509 = wave.extract %791#5[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1510 = wave.fmul %1509, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1511 = wave.extract %791#5[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1512 = wave.fmul %1511, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1513 = wave.extract %791#5[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1514 = wave.fmul %1513, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1515 = wave.extract %791#5[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1516 = wave.fmul %1515, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1517 = wave.extract %791#5[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1518 = wave.fmul %1517, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1519 = wave.extract %791#5[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1520 = wave.fmul %1519, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1521 = wave.extract %791#5[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1522 = wave.fmul %1521, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1523 = wave.extract %791#5[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1524 = wave.fmul %1523, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1525 = wave.extract %791#5[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1526 = wave.fmul %1525, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1527 = wave.extract %791#5[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1528 = wave.fmul %1527, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1529 = wave.extract %791#5[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1530 = wave.fmul %1529, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1531 = wave.extract %791#5[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1532 = wave.fmul %1531, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1533 = wave.pack %1502, %1504, %1506, %1508, %1510, %1512, %1514, %1516, %1518, %1520, %1522, %1524, %1526, %1528, %1530, %1532 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1534 = wave.extract %791#6[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1535 = wave.fmul %1534, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1536 = wave.extract %791#6[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1537 = wave.fmul %1536, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1538 = wave.extract %791#6[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1539 = wave.fmul %1538, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1540 = wave.extract %791#6[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1541 = wave.fmul %1540, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1542 = wave.extract %791#6[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1543 = wave.fmul %1542, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1544 = wave.extract %791#6[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1545 = wave.fmul %1544, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1546 = wave.extract %791#6[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1547 = wave.fmul %1546, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1548 = wave.extract %791#6[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1549 = wave.fmul %1548, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1550 = wave.extract %791#6[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1551 = wave.fmul %1550, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1552 = wave.extract %791#6[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1553 = wave.fmul %1552, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1554 = wave.extract %791#6[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1555 = wave.fmul %1554, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1556 = wave.extract %791#6[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1557 = wave.fmul %1556, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1558 = wave.extract %791#6[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1559 = wave.fmul %1558, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1560 = wave.extract %791#6[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1561 = wave.fmul %1560, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1562 = wave.extract %791#6[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1563 = wave.fmul %1562, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1564 = wave.extract %791#6[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1565 = wave.fmul %1564, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1566 = wave.pack %1535, %1537, %1539, %1541, %1543, %1545, %1547, %1549, %1551, %1553, %1555, %1557, %1559, %1561, %1563, %1565 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1567 = wave.extract %791#7[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1568 = wave.fmul %1567, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1569 = wave.extract %791#7[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1570 = wave.fmul %1569, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1571 = wave.extract %791#7[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1572 = wave.fmul %1571, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1573 = wave.extract %791#7[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1574 = wave.fmul %1573, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1575 = wave.extract %791#7[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1576 = wave.fmul %1575, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1577 = wave.extract %791#7[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1578 = wave.fmul %1577, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1579 = wave.extract %791#7[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1580 = wave.fmul %1579, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1581 = wave.extract %791#7[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1582 = wave.fmul %1581, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1583 = wave.extract %791#7[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1584 = wave.fmul %1583, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1585 = wave.extract %791#7[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1586 = wave.fmul %1585, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1587 = wave.extract %791#7[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1588 = wave.fmul %1587, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1589 = wave.extract %791#7[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1590 = wave.fmul %1589, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1591 = wave.extract %791#7[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1592 = wave.fmul %1591, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1593 = wave.extract %791#7[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1594 = wave.fmul %1593, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1595 = wave.extract %791#7[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1596 = wave.fmul %1595, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1597 = wave.extract %791#7[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1598 = wave.fmul %1597, %1466 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1599 = wave.pack %1568, %1570, %1572, %1574, %1576, %1578, %1580, %1582, %1584, %1586, %1588, %1590, %1592, %1594, %1596, %1598 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1600 = wave.extract %791#8[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1601 = wave.fmul %1600, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1602 = wave.extract %791#8[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1603 = wave.fmul %1602, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1604 = wave.extract %791#8[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1605 = wave.fmul %1604, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1606 = wave.extract %791#8[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1607 = wave.fmul %1606, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1608 = wave.extract %791#8[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1609 = wave.fmul %1608, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1610 = wave.extract %791#8[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1611 = wave.fmul %1610, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1612 = wave.extract %791#8[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1613 = wave.fmul %1612, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1614 = wave.extract %791#8[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1615 = wave.fmul %1614, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1616 = wave.extract %791#8[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1617 = wave.fmul %1616, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1618 = wave.extract %791#8[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1619 = wave.fmul %1618, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1620 = wave.extract %791#8[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1621 = wave.fmul %1620, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1622 = wave.extract %791#8[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1623 = wave.fmul %1622, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1624 = wave.extract %791#8[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1625 = wave.fmul %1624, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1626 = wave.extract %791#8[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1627 = wave.fmul %1626, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1628 = wave.extract %791#8[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1629 = wave.fmul %1628, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1630 = wave.extract %791#8[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1631 = wave.fmul %1630, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1632 = wave.pack %1601, %1603, %1605, %1607, %1609, %1611, %1613, %1615, %1617, %1619, %1621, %1623, %1625, %1627, %1629, %1631 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1633 = wave.extract %791#9[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1634 = wave.fmul %1633, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1635 = wave.extract %791#9[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1636 = wave.fmul %1635, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1637 = wave.extract %791#9[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1638 = wave.fmul %1637, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1639 = wave.extract %791#9[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1640 = wave.fmul %1639, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1641 = wave.extract %791#9[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1642 = wave.fmul %1641, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1643 = wave.extract %791#9[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1644 = wave.fmul %1643, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1645 = wave.extract %791#9[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1646 = wave.fmul %1645, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1647 = wave.extract %791#9[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1648 = wave.fmul %1647, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1649 = wave.extract %791#9[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1650 = wave.fmul %1649, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1651 = wave.extract %791#9[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1652 = wave.fmul %1651, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1653 = wave.extract %791#9[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1654 = wave.fmul %1653, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1655 = wave.extract %791#9[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1656 = wave.fmul %1655, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1657 = wave.extract %791#9[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1658 = wave.fmul %1657, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1659 = wave.extract %791#9[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1660 = wave.fmul %1659, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1661 = wave.extract %791#9[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1662 = wave.fmul %1661, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1663 = wave.extract %791#9[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1664 = wave.fmul %1663, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1665 = wave.pack %1634, %1636, %1638, %1640, %1642, %1644, %1646, %1648, %1650, %1652, %1654, %1656, %1658, %1660, %1662, %1664 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1666 = wave.extract %791#10[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1667 = wave.fmul %1666, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1668 = wave.extract %791#10[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1669 = wave.fmul %1668, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1670 = wave.extract %791#10[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1671 = wave.fmul %1670, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1672 = wave.extract %791#10[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1673 = wave.fmul %1672, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1674 = wave.extract %791#10[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1675 = wave.fmul %1674, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1676 = wave.extract %791#10[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1677 = wave.fmul %1676, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1678 = wave.extract %791#10[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1679 = wave.fmul %1678, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1680 = wave.extract %791#10[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1681 = wave.fmul %1680, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1682 = wave.extract %791#10[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1683 = wave.fmul %1682, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1684 = wave.extract %791#10[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1685 = wave.fmul %1684, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1686 = wave.extract %791#10[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1687 = wave.fmul %1686, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1688 = wave.extract %791#10[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1689 = wave.fmul %1688, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1690 = wave.extract %791#10[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1691 = wave.fmul %1690, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1692 = wave.extract %791#10[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1693 = wave.fmul %1692, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1694 = wave.extract %791#10[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1695 = wave.fmul %1694, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1696 = wave.extract %791#10[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1697 = wave.fmul %1696, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1698 = wave.pack %1667, %1669, %1671, %1673, %1675, %1677, %1679, %1681, %1683, %1685, %1687, %1689, %1691, %1693, %1695, %1697 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1699 = wave.extract %791#11[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1700 = wave.fmul %1699, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1701 = wave.extract %791#11[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1702 = wave.fmul %1701, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1703 = wave.extract %791#11[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1704 = wave.fmul %1703, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1705 = wave.extract %791#11[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1706 = wave.fmul %1705, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1707 = wave.extract %791#11[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1708 = wave.fmul %1707, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1709 = wave.extract %791#11[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1710 = wave.fmul %1709, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1711 = wave.extract %791#11[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1712 = wave.fmul %1711, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1713 = wave.extract %791#11[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1714 = wave.fmul %1713, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1715 = wave.extract %791#11[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1716 = wave.fmul %1715, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1717 = wave.extract %791#11[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1718 = wave.fmul %1717, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1719 = wave.extract %791#11[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1720 = wave.fmul %1719, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1721 = wave.extract %791#11[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1722 = wave.fmul %1721, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1723 = wave.extract %791#11[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1724 = wave.fmul %1723, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1725 = wave.extract %791#11[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1726 = wave.fmul %1725, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1727 = wave.extract %791#11[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1728 = wave.fmul %1727, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1729 = wave.extract %791#11[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1730 = wave.fmul %1729, %1467 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1731 = wave.pack %1700, %1702, %1704, %1706, %1708, %1710, %1712, %1714, %1716, %1718, %1720, %1722, %1724, %1726, %1728, %1730 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1732 = wave.fma %791#2, %1466, %1429 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1733 = wave.fma %791#3, %1467, %1463 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1734 = wave.cast fpconvert %1344 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1735 = wave.cast fpconvert %1361 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1736 = wave.cast fpconvert %1378 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1737 = wave.cast fpconvert %1395 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1738 = wave.extract %1734[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1739 = wave.extract %1734[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1740 = wave.extract %1735[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1741 = wave.extract %1735[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1742 = wave.extract %1736[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1743 = wave.extract %1736[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1744 = wave.extract %1737[0] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1745 = wave.extract %1737[8] : !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1746 = waveamd.fragment_pack %1738 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1747 = waveamd.fragment_pack %1739 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1748 = waveamd.fragment_pack %1740 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1749 = waveamd.fragment_pack %1741 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1750 = waveamd.fragment_pack %1742 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1751 = waveamd.fragment_pack %1743 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1752 = waveamd.fragment_pack %1744 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1753 = waveamd.fragment_pack %1745 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1754 = waveamd.fragment_pack %value_30 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1755 = waveamd.fragment_pack %value_32 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1756 = waveamd.fragment_pack %value_34 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1757 = waveamd.fragment_pack %value_36 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1758 = waveamd.fragment_pack %value_38 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1759 = waveamd.fragment_pack %value_40 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1760 = waveamd.fragment_pack %value_42 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1761 = waveamd.fragment_pack %value_44 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1762 = waveamd.fragment_pack %value_46 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1763 = waveamd.fragment_pack %value_48 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1764 = waveamd.fragment_pack %value_50 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1765 = waveamd.fragment_pack %value_52 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1766 = waveamd.fragment_pack %value_54 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1767 = waveamd.fragment_pack %value_56 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1768 = waveamd.fragment_pack %value_58 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1769 = waveamd.fragment_pack %value_60 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1770 = waveamd.fragment_pack %1500 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1771 = waveamd.fragment_pack %1533 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1772 = waveamd.fragment_pack %1566 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1773 = waveamd.fragment_pack %1599 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1774 = waveamd.fragment_pack %1632 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1775 = waveamd.fragment_pack %1665 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1776 = waveamd.fragment_pack %1698 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1777 = waveamd.fragment_pack %1731 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1778 = waveamd.mma "mfma.f32.32x32x16.bf16" %1754, %1746, %1770 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1779 = waveamd.mma "mfma.f32.32x32x16.bf16" %1755, %1747, %1778 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1780 = waveamd.mma "mfma.f32.32x32x16.bf16" %1756, %1748, %1779 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1781 = waveamd.mma "mfma.f32.32x32x16.bf16" %1757, %1749, %1780 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1782 = waveamd.fragment_unpack %1781 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1783 = waveamd.mma "mfma.f32.32x32x16.bf16" %1758, %1746, %1771 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1784 = waveamd.mma "mfma.f32.32x32x16.bf16" %1759, %1747, %1783 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1785 = waveamd.mma "mfma.f32.32x32x16.bf16" %1760, %1748, %1784 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1786 = waveamd.mma "mfma.f32.32x32x16.bf16" %1761, %1749, %1785 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1787 = waveamd.fragment_unpack %1786 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1788 = waveamd.mma "mfma.f32.32x32x16.bf16" %1762, %1746, %1772 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1789 = waveamd.mma "mfma.f32.32x32x16.bf16" %1763, %1747, %1788 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1790 = waveamd.mma "mfma.f32.32x32x16.bf16" %1764, %1748, %1789 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1791 = waveamd.mma "mfma.f32.32x32x16.bf16" %1765, %1749, %1790 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1792 = waveamd.fragment_unpack %1791 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1793 = waveamd.mma "mfma.f32.32x32x16.bf16" %1766, %1746, %1773 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1794 = waveamd.mma "mfma.f32.32x32x16.bf16" %1767, %1747, %1793 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1795 = waveamd.mma "mfma.f32.32x32x16.bf16" %1768, %1748, %1794 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1796 = waveamd.mma "mfma.f32.32x32x16.bf16" %1769, %1749, %1795 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1797 = waveamd.fragment_unpack %1796 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1798 = waveamd.mma "mfma.f32.32x32x16.bf16" %1754, %1750, %1774 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1799 = waveamd.mma "mfma.f32.32x32x16.bf16" %1755, %1751, %1798 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1800 = waveamd.mma "mfma.f32.32x32x16.bf16" %1756, %1752, %1799 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1801 = waveamd.mma "mfma.f32.32x32x16.bf16" %1757, %1753, %1800 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1802 = waveamd.fragment_unpack %1801 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1803 = waveamd.mma "mfma.f32.32x32x16.bf16" %1758, %1750, %1775 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1804 = waveamd.mma "mfma.f32.32x32x16.bf16" %1759, %1751, %1803 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1805 = waveamd.mma "mfma.f32.32x32x16.bf16" %1760, %1752, %1804 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1806 = waveamd.mma "mfma.f32.32x32x16.bf16" %1761, %1753, %1805 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1807 = waveamd.fragment_unpack %1806 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1808 = waveamd.mma "mfma.f32.32x32x16.bf16" %1762, %1750, %1776 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1809 = waveamd.mma "mfma.f32.32x32x16.bf16" %1763, %1751, %1808 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1810 = waveamd.mma "mfma.f32.32x32x16.bf16" %1764, %1752, %1809 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1811 = waveamd.mma "mfma.f32.32x32x16.bf16" %1765, %1753, %1810 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1812 = waveamd.fragment_unpack %1811 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1813 = waveamd.mma "mfma.f32.32x32x16.bf16" %1766, %1750, %1777 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1814 = waveamd.mma "mfma.f32.32x32x16.bf16" %1767, %1751, %1813 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1815 = waveamd.mma "mfma.f32.32x32x16.bf16" %1768, %1752, %1814 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1816 = waveamd.mma "mfma.f32.32x32x16.bf16" %1769, %1753, %1815 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1817 = waveamd.fragment_unpack %1816 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1818 = wave.extract %1782[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1819 = wave.frcp %1732 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1820 = wave.fmul %1818, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1821 = wave.extract %1782[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1822 = wave.fmul %1821, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1823 = wave.extract %1782[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1824 = wave.fmul %1823, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1825 = wave.extract %1782[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1826 = wave.fmul %1825, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1827 = wave.extract %1782[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1828 = wave.fmul %1827, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1829 = wave.extract %1782[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1830 = wave.fmul %1829, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1831 = wave.extract %1782[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1832 = wave.fmul %1831, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1833 = wave.extract %1782[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1834 = wave.fmul %1833, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1835 = wave.extract %1782[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1836 = wave.fmul %1835, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1837 = wave.extract %1782[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1838 = wave.fmul %1837, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1839 = wave.extract %1782[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1840 = wave.fmul %1839, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1841 = wave.extract %1782[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1842 = wave.fmul %1841, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1843 = wave.extract %1782[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1844 = wave.fmul %1843, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1845 = wave.extract %1782[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1846 = wave.fmul %1845, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1847 = wave.extract %1782[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1848 = wave.fmul %1847, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1849 = wave.extract %1782[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1850 = wave.fmul %1849, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1851 = wave.pack %1820, %1822, %1824, %1826, %1828, %1830, %1832, %1834, %1836, %1838, %1840, %1842, %1844, %1846, %1848, %1850 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1852 = wave.extract %1787[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1853 = wave.fmul %1852, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1854 = wave.extract %1787[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1855 = wave.fmul %1854, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1856 = wave.extract %1787[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1857 = wave.fmul %1856, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1858 = wave.extract %1787[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1859 = wave.fmul %1858, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1860 = wave.extract %1787[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1861 = wave.fmul %1860, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1862 = wave.extract %1787[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1863 = wave.fmul %1862, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1864 = wave.extract %1787[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1865 = wave.fmul %1864, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1866 = wave.extract %1787[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1867 = wave.fmul %1866, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1868 = wave.extract %1787[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1869 = wave.fmul %1868, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1870 = wave.extract %1787[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1871 = wave.fmul %1870, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1872 = wave.extract %1787[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1873 = wave.fmul %1872, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1874 = wave.extract %1787[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1875 = wave.fmul %1874, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1876 = wave.extract %1787[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1877 = wave.fmul %1876, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1878 = wave.extract %1787[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1879 = wave.fmul %1878, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1880 = wave.extract %1787[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1881 = wave.fmul %1880, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1882 = wave.extract %1787[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1883 = wave.fmul %1882, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1884 = wave.pack %1853, %1855, %1857, %1859, %1861, %1863, %1865, %1867, %1869, %1871, %1873, %1875, %1877, %1879, %1881, %1883 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1885 = wave.extract %1792[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1886 = wave.fmul %1885, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1887 = wave.extract %1792[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1888 = wave.fmul %1887, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1889 = wave.extract %1792[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1890 = wave.fmul %1889, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1891 = wave.extract %1792[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1892 = wave.fmul %1891, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1893 = wave.extract %1792[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1894 = wave.fmul %1893, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1895 = wave.extract %1792[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1896 = wave.fmul %1895, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1897 = wave.extract %1792[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1898 = wave.fmul %1897, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1899 = wave.extract %1792[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1900 = wave.fmul %1899, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1901 = wave.extract %1792[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1902 = wave.fmul %1901, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1903 = wave.extract %1792[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1904 = wave.fmul %1903, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1905 = wave.extract %1792[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1906 = wave.fmul %1905, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1907 = wave.extract %1792[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1908 = wave.fmul %1907, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1909 = wave.extract %1792[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1910 = wave.fmul %1909, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1911 = wave.extract %1792[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1912 = wave.fmul %1911, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1913 = wave.extract %1792[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1914 = wave.fmul %1913, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1915 = wave.extract %1792[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1916 = wave.fmul %1915, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1917 = wave.pack %1886, %1888, %1890, %1892, %1894, %1896, %1898, %1900, %1902, %1904, %1906, %1908, %1910, %1912, %1914, %1916 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1918 = wave.extract %1797[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1919 = wave.fmul %1918, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1920 = wave.extract %1797[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1921 = wave.fmul %1920, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1922 = wave.extract %1797[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1923 = wave.fmul %1922, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1924 = wave.extract %1797[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1925 = wave.fmul %1924, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1926 = wave.extract %1797[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1927 = wave.fmul %1926, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1928 = wave.extract %1797[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1929 = wave.fmul %1928, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1930 = wave.extract %1797[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1931 = wave.fmul %1930, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1932 = wave.extract %1797[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1933 = wave.fmul %1932, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1934 = wave.extract %1797[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1935 = wave.fmul %1934, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1936 = wave.extract %1797[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1937 = wave.fmul %1936, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1938 = wave.extract %1797[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1939 = wave.fmul %1938, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1940 = wave.extract %1797[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1941 = wave.fmul %1940, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1942 = wave.extract %1797[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1943 = wave.fmul %1942, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1944 = wave.extract %1797[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1945 = wave.fmul %1944, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1946 = wave.extract %1797[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1947 = wave.fmul %1946, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1948 = wave.extract %1797[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1949 = wave.fmul %1948, %1819 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1950 = wave.pack %1919, %1921, %1923, %1925, %1927, %1929, %1931, %1933, %1935, %1937, %1939, %1941, %1943, %1945, %1947, %1949 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1951 = wave.extract %1802[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1952 = wave.frcp %1733 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1953 = wave.fmul %1951, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1954 = wave.extract %1802[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1955 = wave.fmul %1954, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1956 = wave.extract %1802[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1957 = wave.fmul %1956, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1958 = wave.extract %1802[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1959 = wave.fmul %1958, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1960 = wave.extract %1802[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1961 = wave.fmul %1960, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1962 = wave.extract %1802[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1963 = wave.fmul %1962, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1964 = wave.extract %1802[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1965 = wave.fmul %1964, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1966 = wave.extract %1802[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1967 = wave.fmul %1966, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1968 = wave.extract %1802[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1969 = wave.fmul %1968, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1970 = wave.extract %1802[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1971 = wave.fmul %1970, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1972 = wave.extract %1802[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1973 = wave.fmul %1972, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1974 = wave.extract %1802[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1975 = wave.fmul %1974, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1976 = wave.extract %1802[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1977 = wave.fmul %1976, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1978 = wave.extract %1802[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1979 = wave.fmul %1978, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1980 = wave.extract %1802[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1981 = wave.fmul %1980, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1982 = wave.extract %1802[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1983 = wave.fmul %1982, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1984 = wave.pack %1953, %1955, %1957, %1959, %1961, %1963, %1965, %1967, %1969, %1971, %1973, %1975, %1977, %1979, %1981, %1983 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1985 = wave.extract %1807[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1986 = wave.fmul %1985, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1987 = wave.extract %1807[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1988 = wave.fmul %1987, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1989 = wave.extract %1807[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1990 = wave.fmul %1989, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1991 = wave.extract %1807[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1992 = wave.fmul %1991, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1993 = wave.extract %1807[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1994 = wave.fmul %1993, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1995 = wave.extract %1807[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1996 = wave.fmul %1995, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1997 = wave.extract %1807[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1998 = wave.fmul %1997, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1999 = wave.extract %1807[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2000 = wave.fmul %1999, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2001 = wave.extract %1807[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2002 = wave.fmul %2001, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2003 = wave.extract %1807[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2004 = wave.fmul %2003, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2005 = wave.extract %1807[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2006 = wave.fmul %2005, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2007 = wave.extract %1807[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2008 = wave.fmul %2007, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2009 = wave.extract %1807[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2010 = wave.fmul %2009, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2011 = wave.extract %1807[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2012 = wave.fmul %2011, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2013 = wave.extract %1807[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2014 = wave.fmul %2013, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2015 = wave.extract %1807[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2016 = wave.fmul %2015, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2017 = wave.pack %1986, %1988, %1990, %1992, %1994, %1996, %1998, %2000, %2002, %2004, %2006, %2008, %2010, %2012, %2014, %2016 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2018 = wave.extract %1812[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2019 = wave.fmul %2018, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2020 = wave.extract %1812[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2021 = wave.fmul %2020, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2022 = wave.extract %1812[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2023 = wave.fmul %2022, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2024 = wave.extract %1812[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2025 = wave.fmul %2024, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2026 = wave.extract %1812[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2027 = wave.fmul %2026, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2028 = wave.extract %1812[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2029 = wave.fmul %2028, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2030 = wave.extract %1812[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2031 = wave.fmul %2030, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2032 = wave.extract %1812[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2033 = wave.fmul %2032, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2034 = wave.extract %1812[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2035 = wave.fmul %2034, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2036 = wave.extract %1812[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2037 = wave.fmul %2036, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2038 = wave.extract %1812[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2039 = wave.fmul %2038, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2040 = wave.extract %1812[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2041 = wave.fmul %2040, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2042 = wave.extract %1812[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2043 = wave.fmul %2042, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2044 = wave.extract %1812[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2045 = wave.fmul %2044, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2046 = wave.extract %1812[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2047 = wave.fmul %2046, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2048 = wave.extract %1812[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2049 = wave.fmul %2048, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2050 = wave.pack %2019, %2021, %2023, %2025, %2027, %2029, %2031, %2033, %2035, %2037, %2039, %2041, %2043, %2045, %2047, %2049 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2051 = wave.extract %1817[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2052 = wave.fmul %2051, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2053 = wave.extract %1817[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2054 = wave.fmul %2053, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2055 = wave.extract %1817[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2056 = wave.fmul %2055, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2057 = wave.extract %1817[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2058 = wave.fmul %2057, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2059 = wave.extract %1817[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2060 = wave.fmul %2059, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2061 = wave.extract %1817[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2062 = wave.fmul %2061, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2063 = wave.extract %1817[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2064 = wave.fmul %2063, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2065 = wave.extract %1817[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2066 = wave.fmul %2065, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2067 = wave.extract %1817[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2068 = wave.fmul %2067, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2069 = wave.extract %1817[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2070 = wave.fmul %2069, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2071 = wave.extract %1817[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2072 = wave.fmul %2071, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2073 = wave.extract %1817[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2074 = wave.fmul %2073, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2075 = wave.extract %1817[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2076 = wave.fmul %2075, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2077 = wave.extract %1817[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2078 = wave.fmul %2077, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2079 = wave.extract %1817[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2080 = wave.fmul %2079, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2081 = wave.extract %1817[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2082 = wave.fmul %2081, %1952 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2083 = wave.pack %2052, %2054, %2056, %2058, %2060, %2062, %2064, %2066, %2068, %2070, %2072, %2074, %2076, %2078, %2080, %2082 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2084 = wave.assume %arg15 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %2085 = wave.binary muli %139, %2084 overflow<nsw> : i32, i32 -> i32
      %2086 = wave.binary addi %2085, %138 overflow<nsw> : i32, i32 -> i32
      %2087 = wave.binary muli %180, %101 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2088 = wave.binary xori %68, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2089 = wave.binary xori %103, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2090 = wave.binary xori %67, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2091 = wave.binary xori %102, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2092 = wave.binary xori %42, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2093 = wave.binary xori %41, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2094 = wave.binary xori %40, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2095 = wave.binary xori %100, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2096 = wave.binary xori %63, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2097 = wave.binary xori %62, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2098 = wave.binary xori %61, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2099 = wave.binary xori %39, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2100 = wave.binary xori %38, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2101 = wave.binary xori %37, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2102 = wave.binary xori %36, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2103 = wave.binary xori %98, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2104 = wave.binary xori %56, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2105 = wave.binary xori %55, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2106 = wave.binary xori %54, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2107 = wave.binary xori %35, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2108 = wave.binary xori %34, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2109 = wave.binary xori %33, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2110 = wave.binary xori %32, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2111 = wave.binary xori %96, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2112 = wave.binary xori %49, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2113 = wave.binary xori %48, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2114 = wave.binary xori %47, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2115 = wave.binary xori %31, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2116 = wave.binary xori %30, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2117 = wave.binary xori %29, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2118 = wave.binary xori %28, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2119 = wave.binary xori %99, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2120 = wave.binary xori %27, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2121 = wave.binary xori %26, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2122 = wave.binary xori %25, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2123 = wave.binary xori %24, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2124 = wave.binary xori %23, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2125 = wave.binary xori %22, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2126 = wave.binary xori %21, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2127 = wave.binary xori %95, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2128 = wave.binary xori %20, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2129 = wave.binary xori %19, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2130 = wave.binary xori %18, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2131 = wave.binary xori %17, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2132 = wave.binary xori %16, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2133 = wave.binary xori %15, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2134 = wave.binary xori %14, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2135 = wave.binary xori %94, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2136 = wave.binary xori %13, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2137 = wave.binary xori %12, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2138 = wave.binary xori %11, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2139 = wave.binary xori %10, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2140 = wave.binary xori %9, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2141 = wave.binary xori %8, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2142 = wave.binary xori %7, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2143 = wave.binary xori %93, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2144 = wave.binary xori %6, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2145 = wave.binary xori %5, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2146 = wave.binary xori %4, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2147 = wave.binary xori %3, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2148 = wave.binary xori %2, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2149 = wave.binary xori %1, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2150 = wave.binary xori %0, %2087 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2151 = wave.cmpi slt %2087, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2152 = wave.cmpi slt %2088, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2153 = wave.cmpi slt %2089, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2154 = wave.cmpi slt %2090, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2155 = wave.cmpi slt %2091, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2156 = wave.cmpi slt %2092, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2157 = wave.cmpi slt %2093, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2158 = wave.cmpi slt %2094, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2159 = wave.cmpi slt %2095, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2160 = wave.cmpi slt %2096, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2161 = wave.cmpi slt %2097, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2162 = wave.cmpi slt %2098, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2163 = wave.cmpi slt %2099, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2164 = wave.cmpi slt %2100, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2165 = wave.cmpi slt %2101, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2166 = wave.cmpi slt %2102, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2167 = wave.cmpi slt %2103, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2168 = wave.cmpi slt %2104, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2169 = wave.cmpi slt %2105, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2170 = wave.cmpi slt %2106, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2171 = wave.cmpi slt %2107, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2172 = wave.cmpi slt %2108, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2173 = wave.cmpi slt %2109, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2174 = wave.cmpi slt %2110, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2175 = wave.cmpi slt %2111, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2176 = wave.cmpi slt %2112, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2177 = wave.cmpi slt %2113, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2178 = wave.cmpi slt %2114, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2179 = wave.cmpi slt %2115, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2180 = wave.cmpi slt %2116, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2181 = wave.cmpi slt %2117, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2182 = wave.cmpi slt %2118, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2183 = wave.cmpi slt %2119, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2184 = wave.cmpi slt %2120, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2185 = wave.cmpi slt %2121, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2186 = wave.cmpi slt %2122, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2187 = wave.cmpi slt %2123, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2188 = wave.cmpi slt %2124, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2189 = wave.cmpi slt %2125, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2190 = wave.cmpi slt %2126, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2191 = wave.cmpi slt %2127, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2192 = wave.cmpi slt %2128, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2193 = wave.cmpi slt %2129, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2194 = wave.cmpi slt %2130, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2195 = wave.cmpi slt %2131, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2196 = wave.cmpi slt %2132, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2197 = wave.cmpi slt %2133, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2198 = wave.cmpi slt %2134, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2199 = wave.cmpi slt %2135, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2200 = wave.cmpi slt %2136, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2201 = wave.cmpi slt %2137, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2202 = wave.cmpi slt %2138, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2203 = wave.cmpi slt %2139, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2204 = wave.cmpi slt %2140, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2205 = wave.cmpi slt %2141, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2206 = wave.cmpi slt %2142, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2207 = wave.cmpi slt %2143, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2208 = wave.cmpi slt %2144, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2209 = wave.cmpi slt %2145, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2210 = wave.cmpi slt %2146, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2211 = wave.cmpi slt %2147, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2212 = wave.cmpi slt %2148, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2213 = wave.cmpi slt %2149, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2214 = wave.cmpi slt %2150, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2215 = wave.select %177, %2151, %104 : !wave.mask<64>, !wave.mask<64>
      %2216 = wave.select %177, %2152, %104 : !wave.mask<64>, !wave.mask<64>
      %2217 = wave.select %177, %2153, %104 : !wave.mask<64>, !wave.mask<64>
      %2218 = wave.select %177, %2154, %104 : !wave.mask<64>, !wave.mask<64>
      %2219 = wave.select %177, %2155, %104 : !wave.mask<64>, !wave.mask<64>
      %2220 = wave.select %177, %2156, %104 : !wave.mask<64>, !wave.mask<64>
      %2221 = wave.select %177, %2157, %104 : !wave.mask<64>, !wave.mask<64>
      %2222 = wave.select %177, %2158, %104 : !wave.mask<64>, !wave.mask<64>
      %2223 = wave.select %177, %2159, %104 : !wave.mask<64>, !wave.mask<64>
      %2224 = wave.select %177, %2160, %104 : !wave.mask<64>, !wave.mask<64>
      %2225 = wave.select %177, %2161, %104 : !wave.mask<64>, !wave.mask<64>
      %2226 = wave.select %177, %2162, %104 : !wave.mask<64>, !wave.mask<64>
      %2227 = wave.select %177, %2163, %104 : !wave.mask<64>, !wave.mask<64>
      %2228 = wave.select %177, %2164, %104 : !wave.mask<64>, !wave.mask<64>
      %2229 = wave.select %177, %2165, %104 : !wave.mask<64>, !wave.mask<64>
      %2230 = wave.select %177, %2166, %104 : !wave.mask<64>, !wave.mask<64>
      %2231 = wave.select %177, %2167, %104 : !wave.mask<64>, !wave.mask<64>
      %2232 = wave.select %177, %2168, %104 : !wave.mask<64>, !wave.mask<64>
      %2233 = wave.select %177, %2169, %104 : !wave.mask<64>, !wave.mask<64>
      %2234 = wave.select %177, %2170, %104 : !wave.mask<64>, !wave.mask<64>
      %2235 = wave.select %177, %2171, %104 : !wave.mask<64>, !wave.mask<64>
      %2236 = wave.select %177, %2172, %104 : !wave.mask<64>, !wave.mask<64>
      %2237 = wave.select %177, %2173, %104 : !wave.mask<64>, !wave.mask<64>
      %2238 = wave.select %177, %2174, %104 : !wave.mask<64>, !wave.mask<64>
      %2239 = wave.select %177, %2175, %104 : !wave.mask<64>, !wave.mask<64>
      %2240 = wave.select %177, %2176, %104 : !wave.mask<64>, !wave.mask<64>
      %2241 = wave.select %177, %2177, %104 : !wave.mask<64>, !wave.mask<64>
      %2242 = wave.select %177, %2178, %104 : !wave.mask<64>, !wave.mask<64>
      %2243 = wave.select %177, %2179, %104 : !wave.mask<64>, !wave.mask<64>
      %2244 = wave.select %177, %2180, %104 : !wave.mask<64>, !wave.mask<64>
      %2245 = wave.select %177, %2181, %104 : !wave.mask<64>, !wave.mask<64>
      %2246 = wave.select %177, %2182, %104 : !wave.mask<64>, !wave.mask<64>
      %2247 = wave.select %177, %2183, %104 : !wave.mask<64>, !wave.mask<64>
      %2248 = wave.select %177, %2184, %104 : !wave.mask<64>, !wave.mask<64>
      %2249 = wave.select %177, %2185, %104 : !wave.mask<64>, !wave.mask<64>
      %2250 = wave.select %177, %2186, %104 : !wave.mask<64>, !wave.mask<64>
      %2251 = wave.select %177, %2187, %104 : !wave.mask<64>, !wave.mask<64>
      %2252 = wave.select %177, %2188, %104 : !wave.mask<64>, !wave.mask<64>
      %2253 = wave.select %177, %2189, %104 : !wave.mask<64>, !wave.mask<64>
      %2254 = wave.select %177, %2190, %104 : !wave.mask<64>, !wave.mask<64>
      %2255 = wave.select %177, %2191, %104 : !wave.mask<64>, !wave.mask<64>
      %2256 = wave.select %177, %2192, %104 : !wave.mask<64>, !wave.mask<64>
      %2257 = wave.select %177, %2193, %104 : !wave.mask<64>, !wave.mask<64>
      %2258 = wave.select %177, %2194, %104 : !wave.mask<64>, !wave.mask<64>
      %2259 = wave.select %177, %2195, %104 : !wave.mask<64>, !wave.mask<64>
      %2260 = wave.select %177, %2196, %104 : !wave.mask<64>, !wave.mask<64>
      %2261 = wave.select %177, %2197, %104 : !wave.mask<64>, !wave.mask<64>
      %2262 = wave.select %177, %2198, %104 : !wave.mask<64>, !wave.mask<64>
      %2263 = wave.select %177, %2199, %104 : !wave.mask<64>, !wave.mask<64>
      %2264 = wave.select %177, %2200, %104 : !wave.mask<64>, !wave.mask<64>
      %2265 = wave.select %177, %2201, %104 : !wave.mask<64>, !wave.mask<64>
      %2266 = wave.select %177, %2202, %104 : !wave.mask<64>, !wave.mask<64>
      %2267 = wave.select %177, %2203, %104 : !wave.mask<64>, !wave.mask<64>
      %2268 = wave.select %177, %2204, %104 : !wave.mask<64>, !wave.mask<64>
      %2269 = wave.select %177, %2205, %104 : !wave.mask<64>, !wave.mask<64>
      %2270 = wave.select %177, %2206, %104 : !wave.mask<64>, !wave.mask<64>
      %2271 = wave.select %177, %2207, %104 : !wave.mask<64>, !wave.mask<64>
      %2272 = wave.select %177, %2208, %104 : !wave.mask<64>, !wave.mask<64>
      %2273 = wave.select %177, %2209, %104 : !wave.mask<64>, !wave.mask<64>
      %2274 = wave.select %177, %2210, %104 : !wave.mask<64>, !wave.mask<64>
      %2275 = wave.select %177, %2211, %104 : !wave.mask<64>, !wave.mask<64>
      %2276 = wave.select %177, %2212, %104 : !wave.mask<64>, !wave.mask<64>
      %2277 = wave.select %177, %2213, %104 : !wave.mask<64>, !wave.mask<64>
      %2278 = wave.select %177, %2214, %104 : !wave.mask<64>, !wave.mask<64>
      %2279 = wave.select %178, %2151, %104 : !wave.mask<64>, !wave.mask<64>
      %2280 = wave.select %178, %2152, %104 : !wave.mask<64>, !wave.mask<64>
      %2281 = wave.select %178, %2153, %104 : !wave.mask<64>, !wave.mask<64>
      %2282 = wave.select %178, %2154, %104 : !wave.mask<64>, !wave.mask<64>
      %2283 = wave.select %178, %2155, %104 : !wave.mask<64>, !wave.mask<64>
      %2284 = wave.select %178, %2156, %104 : !wave.mask<64>, !wave.mask<64>
      %2285 = wave.select %178, %2157, %104 : !wave.mask<64>, !wave.mask<64>
      %2286 = wave.select %178, %2158, %104 : !wave.mask<64>, !wave.mask<64>
      %2287 = wave.select %178, %2159, %104 : !wave.mask<64>, !wave.mask<64>
      %2288 = wave.select %178, %2160, %104 : !wave.mask<64>, !wave.mask<64>
      %2289 = wave.select %178, %2161, %104 : !wave.mask<64>, !wave.mask<64>
      %2290 = wave.select %178, %2162, %104 : !wave.mask<64>, !wave.mask<64>
      %2291 = wave.select %178, %2163, %104 : !wave.mask<64>, !wave.mask<64>
      %2292 = wave.select %178, %2164, %104 : !wave.mask<64>, !wave.mask<64>
      %2293 = wave.select %178, %2165, %104 : !wave.mask<64>, !wave.mask<64>
      %2294 = wave.select %178, %2166, %104 : !wave.mask<64>, !wave.mask<64>
      %2295 = wave.select %178, %2167, %104 : !wave.mask<64>, !wave.mask<64>
      %2296 = wave.select %178, %2168, %104 : !wave.mask<64>, !wave.mask<64>
      %2297 = wave.select %178, %2169, %104 : !wave.mask<64>, !wave.mask<64>
      %2298 = wave.select %178, %2170, %104 : !wave.mask<64>, !wave.mask<64>
      %2299 = wave.select %178, %2171, %104 : !wave.mask<64>, !wave.mask<64>
      %2300 = wave.select %178, %2172, %104 : !wave.mask<64>, !wave.mask<64>
      %2301 = wave.select %178, %2173, %104 : !wave.mask<64>, !wave.mask<64>
      %2302 = wave.select %178, %2174, %104 : !wave.mask<64>, !wave.mask<64>
      %2303 = wave.select %178, %2175, %104 : !wave.mask<64>, !wave.mask<64>
      %2304 = wave.select %178, %2176, %104 : !wave.mask<64>, !wave.mask<64>
      %2305 = wave.select %178, %2177, %104 : !wave.mask<64>, !wave.mask<64>
      %2306 = wave.select %178, %2178, %104 : !wave.mask<64>, !wave.mask<64>
      %2307 = wave.select %178, %2179, %104 : !wave.mask<64>, !wave.mask<64>
      %2308 = wave.select %178, %2180, %104 : !wave.mask<64>, !wave.mask<64>
      %2309 = wave.select %178, %2181, %104 : !wave.mask<64>, !wave.mask<64>
      %2310 = wave.select %178, %2182, %104 : !wave.mask<64>, !wave.mask<64>
      %2311 = wave.select %178, %2183, %104 : !wave.mask<64>, !wave.mask<64>
      %2312 = wave.select %178, %2184, %104 : !wave.mask<64>, !wave.mask<64>
      %2313 = wave.select %178, %2185, %104 : !wave.mask<64>, !wave.mask<64>
      %2314 = wave.select %178, %2186, %104 : !wave.mask<64>, !wave.mask<64>
      %2315 = wave.select %178, %2187, %104 : !wave.mask<64>, !wave.mask<64>
      %2316 = wave.select %178, %2188, %104 : !wave.mask<64>, !wave.mask<64>
      %2317 = wave.select %178, %2189, %104 : !wave.mask<64>, !wave.mask<64>
      %2318 = wave.select %178, %2190, %104 : !wave.mask<64>, !wave.mask<64>
      %2319 = wave.select %178, %2191, %104 : !wave.mask<64>, !wave.mask<64>
      %2320 = wave.select %178, %2192, %104 : !wave.mask<64>, !wave.mask<64>
      %2321 = wave.select %178, %2193, %104 : !wave.mask<64>, !wave.mask<64>
      %2322 = wave.select %178, %2194, %104 : !wave.mask<64>, !wave.mask<64>
      %2323 = wave.select %178, %2195, %104 : !wave.mask<64>, !wave.mask<64>
      %2324 = wave.select %178, %2196, %104 : !wave.mask<64>, !wave.mask<64>
      %2325 = wave.select %178, %2197, %104 : !wave.mask<64>, !wave.mask<64>
      %2326 = wave.select %178, %2198, %104 : !wave.mask<64>, !wave.mask<64>
      %2327 = wave.select %178, %2199, %104 : !wave.mask<64>, !wave.mask<64>
      %2328 = wave.select %178, %2200, %104 : !wave.mask<64>, !wave.mask<64>
      %2329 = wave.select %178, %2201, %104 : !wave.mask<64>, !wave.mask<64>
      %2330 = wave.select %178, %2202, %104 : !wave.mask<64>, !wave.mask<64>
      %2331 = wave.select %178, %2203, %104 : !wave.mask<64>, !wave.mask<64>
      %2332 = wave.select %178, %2204, %104 : !wave.mask<64>, !wave.mask<64>
      %2333 = wave.select %178, %2205, %104 : !wave.mask<64>, !wave.mask<64>
      %2334 = wave.select %178, %2206, %104 : !wave.mask<64>, !wave.mask<64>
      %2335 = wave.select %178, %2207, %104 : !wave.mask<64>, !wave.mask<64>
      %2336 = wave.select %178, %2208, %104 : !wave.mask<64>, !wave.mask<64>
      %2337 = wave.select %178, %2209, %104 : !wave.mask<64>, !wave.mask<64>
      %2338 = wave.select %178, %2210, %104 : !wave.mask<64>, !wave.mask<64>
      %2339 = wave.select %178, %2211, %104 : !wave.mask<64>, !wave.mask<64>
      %2340 = wave.select %178, %2212, %104 : !wave.mask<64>, !wave.mask<64>
      %2341 = wave.select %178, %2213, %104 : !wave.mask<64>, !wave.mask<64>
      %2342 = wave.select %178, %2214, %104 : !wave.mask<64>, !wave.mask<64>
      %2343 = wave.cast fpconvert %1851 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2344 = wave.cast fpconvert %1884 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2345 = wave.cast fpconvert %1917 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2346 = wave.cast fpconvert %1950 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2347 = wave.cast fpconvert %1984 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2348 = wave.cast fpconvert %2017 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2349 = wave.cast fpconvert %2050 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2350 = wave.cast fpconvert %2083 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2351 = wave.pack %2343, %2344, %2345, %2346, %2347, %2348, %2349, %2350 : !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2352 = wave.redistribute %2351, <blocks = 1, items = 256, source_block = "0", source_item = "64*xor(2*Mod(floor(1/128*item), 2), Mod(floor(1/64*item), 2)) + xor(16*Mod(floor(1/16*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(2*Mod(floor(1/2*Mod(item, 64)), 2), xor(32*Mod(floor(1/4*slot), 2), Mod(Mod(item, 64), 2))))))", source_slot = "xor(4*Mod(floor(1/32*Mod(item, 64)), 2), xor(64*Mod(floor(1/64*slot), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(8*Mod(floor(1/8*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))))"> : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2353 = wave.index_expr <"s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + 8*Mod(floor(1/32*wi), 2) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + 8*Mod(floor(1/32*wi), 2) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2354 = wave.assume %2353 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2355 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2354) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2356 = wave.index_expr <"1 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2357 = wave.assume %2356 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2358 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2357) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2359 = wave.index_expr <"2 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2360 = wave.assume %2359 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2361 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2360) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2362 = wave.index_expr <"3 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2363 = wave.assume %2362 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2364 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2363) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2365 = wave.index_expr <"4 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2366 = wave.assume %2365 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2367 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2366) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2368 = wave.index_expr <"5 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2369 = wave.assume %2368 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2370 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2369) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2371 = wave.index_expr <"6 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2372 = wave.assume %2371 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2373 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2372) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2374 = wave.index_expr <"7 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2375 = wave.assume %2374 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2376 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2375) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2377 = wave.index_expr <"16 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2378 = wave.assume %2377 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2379 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2378) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2380 = wave.index_expr <"17 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2381 = wave.assume %2380 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2382 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2381) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2383 = wave.index_expr <"18 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2384 = wave.assume %2383 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2385 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2384) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2386 = wave.index_expr <"19 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2387 = wave.assume %2386 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2388 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2387) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2389 = wave.index_expr <"20 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2390 = wave.assume %2389 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2391 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2390) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2392 = wave.index_expr <"21 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2393 = wave.assume %2392 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2394 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2393) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2395 = wave.index_expr <"22 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2396 = wave.assume %2395 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2397 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2396) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2398 = wave.index_expr <"23 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2399 = wave.assume %2398 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2400 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2399) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2401 = wave.index_expr <"32 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2402 = wave.assume %2401 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2403 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2402) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2404 = wave.index_expr <"33 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2405 = wave.assume %2404 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2406 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2405) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2407 = wave.index_expr <"34 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2408 = wave.assume %2407 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2409 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2408) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2410 = wave.index_expr <"35 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2411 = wave.assume %2410 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2412 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2411) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2413 = wave.index_expr <"36 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2414 = wave.assume %2413 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2415 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2414) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2416 = wave.index_expr <"37 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2417 = wave.assume %2416 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2418 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2417) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2419 = wave.index_expr <"38 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2420 = wave.assume %2419 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2421 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2420) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2422 = wave.index_expr <"39 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2423 = wave.assume %2422 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2424 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2423) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2425 = wave.index_expr <"48 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2426 = wave.assume %2425 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2427 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2426) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2428 = wave.index_expr <"49 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2429 = wave.assume %2428 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2430 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2429) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2431 = wave.index_expr <"50 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2432 = wave.assume %2431 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2433 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2432) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2434 = wave.index_expr <"51 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2435 = wave.assume %2434 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2436 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2435) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2437 = wave.index_expr <"52 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2438 = wave.assume %2437 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2439 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2438) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2440 = wave.index_expr <"53 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2441 = wave.assume %2440 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2442 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2441) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2443 = wave.index_expr <"54 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2444 = wave.assume %2443 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2445 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2444) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2446 = wave.index_expr <"55 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2447 = wave.assume %2446 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2448 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2447) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2449 = wave.index_expr <"64 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2450 = wave.assume %2449 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2451 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2450) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2452 = wave.index_expr <"65 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2453 = wave.assume %2452 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2454 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2453) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2455 = wave.index_expr <"66 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2456 = wave.assume %2455 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2457 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2456) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2458 = wave.index_expr <"67 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2459 = wave.assume %2458 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2460 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2459) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2461 = wave.index_expr <"68 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2462 = wave.assume %2461 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2463 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2462) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2464 = wave.index_expr <"69 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2465 = wave.assume %2464 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2466 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2465) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2467 = wave.index_expr <"70 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2468 = wave.assume %2467 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2469 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2468) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2470 = wave.index_expr <"71 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2471 = wave.assume %2470 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2472 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2471) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2473 = wave.index_expr <"80 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2474 = wave.assume %2473 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2475 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2474) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2476 = wave.index_expr <"81 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2477 = wave.assume %2476 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2478 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2477) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2479 = wave.index_expr <"82 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2480 = wave.assume %2479 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2481 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2480) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2482 = wave.index_expr <"83 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2483 = wave.assume %2482 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2484 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2483) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2485 = wave.index_expr <"84 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2486 = wave.assume %2485 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2487 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2486) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2488 = wave.index_expr <"85 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2489 = wave.assume %2488 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2490 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2489) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2491 = wave.index_expr <"86 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2492 = wave.assume %2491 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2493 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2492) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2494 = wave.index_expr <"87 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2495 = wave.assume %2494 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2496 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2495) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2497 = wave.index_expr <"96 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2498 = wave.assume %2497 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2499 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2498) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2500 = wave.index_expr <"97 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2501 = wave.assume %2500 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2502 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2501) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2503 = wave.index_expr <"98 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2504 = wave.assume %2503 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2505 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2504) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2506 = wave.index_expr <"99 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2507 = wave.assume %2506 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2508 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2507) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2509 = wave.index_expr <"100 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2510 = wave.assume %2509 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2511 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2510) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2512 = wave.index_expr <"101 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2513 = wave.assume %2512 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2514 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2513) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2515 = wave.index_expr <"102 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2516 = wave.assume %2515 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2517 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2516) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2518 = wave.index_expr <"103 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2519 = wave.assume %2518 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2520 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2519) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2521 = wave.index_expr <"112 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2522 = wave.assume %2521 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2523 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2522) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2524 = wave.index_expr <"113 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2525 = wave.assume %2524 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2526 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2525) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2527 = wave.index_expr <"114 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2528 = wave.assume %2527 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2529 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2528) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2530 = wave.index_expr <"115 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2531 = wave.assume %2530 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2532 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2531) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2533 = wave.index_expr <"116 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2534 = wave.assume %2533 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2535 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2534) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2536 = wave.index_expr <"117 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2537 = wave.assume %2536 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2538 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2537) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2539 = wave.index_expr <"118 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2540 = wave.assume %2539 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2541 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2540) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2542 = wave.index_expr <"119 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2543 = wave.assume %2542 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2544 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2543) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2545 = wave.index_expr <"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + 8*Mod(floor(1/32*wi), 2) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + 8*Mod(floor(1/32*wi), 2) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2546 = wave.assume %2545 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2547 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2546) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2548 = wave.index_expr <"1 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2549 = wave.assume %2548 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2550 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2549) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2551 = wave.index_expr <"2 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2552 = wave.assume %2551 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2553 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2552) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2554 = wave.index_expr <"3 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2555 = wave.assume %2554 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2556 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2555) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2557 = wave.index_expr <"4 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2558 = wave.assume %2557 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2559 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2558) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2560 = wave.index_expr <"5 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2561 = wave.assume %2560 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2562 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2561) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2563 = wave.index_expr <"6 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2564 = wave.assume %2563 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2565 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2564) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2566 = wave.index_expr <"7 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2567 = wave.assume %2566 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2568 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2567) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2569 = wave.index_expr <"16 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2570 = wave.assume %2569 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2571 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2570) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2572 = wave.index_expr <"17 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2573 = wave.assume %2572 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2574 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2573) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2575 = wave.index_expr <"18 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2576 = wave.assume %2575 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2577 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2576) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2578 = wave.index_expr <"19 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2579 = wave.assume %2578 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2580 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2579) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2581 = wave.index_expr <"20 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2582 = wave.assume %2581 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2583 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2582) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2584 = wave.index_expr <"21 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2585 = wave.assume %2584 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2586 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2585) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2587 = wave.index_expr <"22 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2588 = wave.assume %2587 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2589 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2588) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2590 = wave.index_expr <"23 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2591 = wave.assume %2590 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2592 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2591) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2593 = wave.index_expr <"32 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2594 = wave.assume %2593 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2595 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2594) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2596 = wave.index_expr <"33 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2597 = wave.assume %2596 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2598 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2597) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2599 = wave.index_expr <"34 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2600 = wave.assume %2599 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2601 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2600) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2602 = wave.index_expr <"35 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2603 = wave.assume %2602 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2604 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2603) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2605 = wave.index_expr <"36 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2606 = wave.assume %2605 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2607 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2606) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2608 = wave.index_expr <"37 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2609 = wave.assume %2608 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2610 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2609) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2611 = wave.index_expr <"38 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2612 = wave.assume %2611 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2613 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2612) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2614 = wave.index_expr <"39 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2615 = wave.assume %2614 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2616 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2615) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2617 = wave.index_expr <"48 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2618 = wave.assume %2617 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2619 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2618) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2620 = wave.index_expr <"49 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2621 = wave.assume %2620 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2622 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2621) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2623 = wave.index_expr <"50 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2624 = wave.assume %2623 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2625 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2624) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2626 = wave.index_expr <"51 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2627 = wave.assume %2626 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2628 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2627) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2629 = wave.index_expr <"52 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2630 = wave.assume %2629 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2631 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2630) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2632 = wave.index_expr <"53 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2633 = wave.assume %2632 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2634 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2633) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2635 = wave.index_expr <"54 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2636 = wave.assume %2635 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2637 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2636) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2638 = wave.index_expr <"55 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2639 = wave.assume %2638 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2640 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2639) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2641 = wave.index_expr <"64 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2642 = wave.assume %2641 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2643 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2642) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2644 = wave.index_expr <"65 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2645 = wave.assume %2644 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2646 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2645) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2647 = wave.index_expr <"66 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2648 = wave.assume %2647 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2649 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2648) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2650 = wave.index_expr <"67 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2651 = wave.assume %2650 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2652 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2651) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2653 = wave.index_expr <"68 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2654 = wave.assume %2653 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2655 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2654) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2656 = wave.index_expr <"69 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2657 = wave.assume %2656 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2658 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2657) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2659 = wave.index_expr <"70 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2660 = wave.assume %2659 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2661 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2660) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2662 = wave.index_expr <"71 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2663 = wave.assume %2662 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2664 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2663) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2665 = wave.index_expr <"80 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2666 = wave.assume %2665 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2667 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2666) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2668 = wave.index_expr <"81 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2669 = wave.assume %2668 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2670 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2669) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2671 = wave.index_expr <"82 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2672 = wave.assume %2671 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2673 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2672) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2674 = wave.index_expr <"83 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2675 = wave.assume %2674 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2676 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2675) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2677 = wave.index_expr <"84 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2678 = wave.assume %2677 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2679 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2678) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2680 = wave.index_expr <"85 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2681 = wave.assume %2680 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2682 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2681) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2683 = wave.index_expr <"86 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2684 = wave.assume %2683 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2685 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2684) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2686 = wave.index_expr <"87 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2687 = wave.assume %2686 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2688 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2687) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2689 = wave.index_expr <"96 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2690 = wave.assume %2689 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2691 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2690) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2692 = wave.index_expr <"97 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2693 = wave.assume %2692 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2694 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2693) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2695 = wave.index_expr <"98 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2696 = wave.assume %2695 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2697 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2696) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2698 = wave.index_expr <"99 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2699 = wave.assume %2698 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2700 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2699) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2701 = wave.index_expr <"100 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2702 = wave.assume %2701 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2703 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2702) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2704 = wave.index_expr <"101 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2705 = wave.assume %2704 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2706 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2705) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2707 = wave.index_expr <"102 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2708 = wave.assume %2707 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2709 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2708) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2710 = wave.index_expr <"103 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2711 = wave.assume %2710 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2712 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2711) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2713 = wave.index_expr <"112 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2714 = wave.assume %2713 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2715 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2714) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2716 = wave.index_expr <"113 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2717 = wave.assume %2716 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2718 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2717) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2719 = wave.index_expr <"114 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2720 = wave.assume %2719 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2721 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2720) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2722 = wave.index_expr <"115 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2723 = wave.assume %2722 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2724 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2723) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2725 = wave.index_expr <"116 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2726 = wave.assume %2725 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2727 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2726) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2728 = wave.index_expr <"117 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2729 = wave.assume %2728 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2730 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2729) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2731 = wave.index_expr <"118 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2732 = wave.assume %2731 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2733 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2732) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2734 = wave.index_expr <"119 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2084, %2086) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2735 = wave.assume %2734 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2736 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2735) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2737 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      wave.where %2215, %2216, %2217, %2218, %2219, %2220, %2221, %2222, %2223, %2224, %2225, %2226, %2227, %2228, %2229, %2230, %2231, %2232, %2233, %2234, %2235, %2236, %2237, %2238, %2239, %2240, %2241, %2242, %2243, %2244, %2245, %2246, %2247, %2248, %2249, %2250, %2251, %2252, %2253, %2254, %2255, %2256, %2257, %2258, %2259, %2260, %2261, %2262, %2263, %2264, %2265, %2266, %2267, %2268, %2269, %2270, %2271, %2272, %2273, %2274, %2275, %2276, %2277, %2278, %2279, %2280, %2281, %2282, %2283, %2284, %2285, %2286, %2287, %2288, %2289, %2290, %2291, %2292, %2293, %2294, %2295, %2296, %2297, %2298, %2299, %2300, %2301, %2302, %2303, %2304, %2305, %2306, %2307, %2308, %2309, %2310, %2311, %2312, %2313, %2314, %2315, %2316, %2317, %2318, %2319, %2320, %2321, %2322, %2323, %2324, %2325, %2326, %2327, %2328, %2329, %2330, %2331, %2332, %2333, %2334, %2335, %2336, %2337, %2338, %2339, %2340, %2341, %2342 {
        %2738 = wave.scatter %2352 to %2737 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%2355, %2358, %2361, %2364, %2367, %2370, %2373, %2376, %2379, %2382, %2385, %2388, %2391, %2394, %2397, %2400, %2403, %2406, %2409, %2412, %2415, %2418, %2421, %2424, %2427, %2430, %2433, %2436, %2439, %2442, %2445, %2448, %2451, %2454, %2457, %2460, %2463, %2466, %2469, %2472, %2475, %2478, %2481, %2484, %2487, %2490, %2493, %2496, %2499, %2502, %2505, %2508, %2511, %2514, %2517, %2520, %2523, %2526, %2529, %2532, %2535, %2538, %2541, %2544, %2547, %2550, %2553, %2556, %2559, %2562, %2565, %2568, %2571, %2574, %2577, %2580, %2583, %2586, %2589, %2592, %2595, %2598, %2601, %2604, %2607, %2610, %2613, %2616, %2619, %2622, %2625, %2628, %2631, %2634, %2637, %2640, %2643, %2646, %2649, %2652, %2655, %2658, %2661, %2664, %2667, %2670, %2673, %2676, %2679, %2682, %2685, %2688, %2691, %2694, %2697, %2700, %2703, %2706, %2709, %2712, %2715, %2718, %2721, %2724, %2727, %2730, %2733, %2736) : (!wave.simd<vector<128xbf16>, 64>, !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> !wave.mem.token
      } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
      return
    }
  }
}
