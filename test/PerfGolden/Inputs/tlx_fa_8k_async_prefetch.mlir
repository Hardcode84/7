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
        %value_94, %token_95 = wave.gather %666 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%284, %287, %290, %293, %296, %299, %302, %305, %308, %311, %314, %317, %320, %323, %326, %329, %332, %335, %338, %341, %344, %347, %350, %353, %356, %359, %362, %365, %368, %371, %374, %377, %380, %383, %386, %389, %392, %395, %398, %401, %404, %407, %410, %413, %416, %419, %422, %425, %428, %431, %434, %437, %440, %443, %446, %449, %452, %455, %458, %461, %464, %467, %470, %473, %476, %479, %482, %485, %488, %491, %494, %497, %500, %503, %506, %509, %512, %515, %518, %521, %524, %527, %530, %533, %536, %539, %542, %545, %548, %551, %554, %557, %560, %563, %566, %569, %572, %575, %578, %581, %584, %587, %590, %593, %596, %599, %602, %605, %608, %611, %614, %617, %620, %623, %626, %629, %632, %635, %638, %641, %644, %647, %650, %653, %656, %659, %662, %665) : (!wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> (!wave.simd<vector<128xbf16>, 64>, !wave.mem.token)
        wave.yield %value_94, %token_95 : !wave.simd<vector<128xbf16>, 64>, !wave.mem.token
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
        %2884 = wave.binary addi %arg19, %c64_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %2885 = wave.splat %2884 : i32 -> !wave.simd<i32, 64>
        %2886 = wave.binary addi %698, %2885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2887 = wave.binary addi %702, %2885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2888 = wave.binary addi %706, %2885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2889 = wave.binary addi %710, %2885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
        %2890 = wave.barrier %arg32 : (!wave.mem.token) -> !wave.mem.token
        %2891 = wave.cmpi slt %2886, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2892 = wave.cmpi slt %2887, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2893 = wave.cmpi slt %2888, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2894 = wave.cmpi slt %2889, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
        %2895 = wave.binary divui %arg19, %c64_i32 : i32, i32 -> i32
        %2896 = wave.binary remui %2895, %c2_i32 : i32, i32 -> i32
        %2897 = wave.binary addi %2895, %c1_i32 overflow<nsw, nuw> : i32, i32 -> i32
        %2898 = wave.binary remui %2897, %c2_i32 : i32, i32 -> i32
        %2899 = wave.binary muli %2896, %c8320_i32 overflow<nsw> : i32, i32 -> i32
        %2900 = wave.ptr_add %687, %2899 : !wave.ptr<#wave.shared, bf16>, i32 -> !wave.ptr<#wave.shared, bf16>
        %2901 = wave.join %arg32, %2890 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2902 = wave.index_expr <"8*floor(1/32*Mod(wi, 64)) + 128*floor(1/16*Mod(Mod(wi, 64), 32)) + 4160*Mod(floor(1/8*Mod(Mod(wi, 64), 32)), 2) + 2080*Mod(floor(1/4*Mod(Mod(wi, 64), 32)), 2) + 1040*Mod(floor(1/2*Mod(Mod(wi, 64), 32)), 2) + 520*Mod(Mod(Mod(wi, 64), 32), 2)"> ["wi"](%140) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %2903 = wave.ptr_add %2900, %2902 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_94, %token_95 = wave.load %2903 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2904 = wave.binary addi %2902, %83 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2905 = wave.ptr_add %2900, %2904 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_96, %token_97 = wave.load %2905 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2906 = wave.binary addi %2902, %82 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2907 = wave.ptr_add %2900, %2906 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_98, %token_99 = wave.load %2907 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2908 = wave.binary addi %2902, %81 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2909 = wave.ptr_add %2900, %2908 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_100, %token_101 = wave.load %2909 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2910 = wave.binary addi %2902, %80 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2911 = wave.ptr_add %2900, %2910 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_102, %token_103 = wave.load %2911 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2912 = wave.binary addi %2902, %79 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2913 = wave.ptr_add %2900, %2912 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_104, %token_105 = wave.load %2913 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2914 = wave.binary addi %2902, %78 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2915 = wave.ptr_add %2900, %2914 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_106, %token_107 = wave.load %2915 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2916 = wave.binary addi %2902, %77 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2917 = wave.ptr_add %2900, %2916 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_108, %token_109 = wave.load %2917 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2918 = wave.binary addi %2902, %76 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2919 = wave.ptr_add %2900, %2918 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_110, %token_111 = wave.load %2919 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2920 = wave.binary addi %2902, %75 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2921 = wave.ptr_add %2900, %2920 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_112, %token_113 = wave.load %2921 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2922 = wave.binary addi %2902, %74 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2923 = wave.ptr_add %2900, %2922 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_114, %token_115 = wave.load %2923 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2924 = wave.binary addi %2902, %73 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2925 = wave.ptr_add %2900, %2924 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_116, %token_117 = wave.load %2925 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2926 = wave.binary addi %2902, %72 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2927 = wave.ptr_add %2900, %2926 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_118, %token_119 = wave.load %2927 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2928 = wave.binary addi %2902, %71 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2929 = wave.ptr_add %2900, %2928 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_120, %token_121 = wave.load %2929 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2930 = wave.binary addi %2902, %70 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2931 = wave.ptr_add %2900, %2930 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_122, %token_123 = wave.load %2931 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2932 = wave.binary addi %2902, %69 overflow<nsw> : !wave.simd<index, 64>, !wave.simd<index, 64> -> !wave.simd<index, 64>
        %2933 = wave.ptr_add %2900, %2932 : !wave.ptr<#wave.shared, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, bf16>, 64>
        %value_124, %token_125 = wave.load %2933 after %2901 : (!wave.simd<!wave.ptr<#wave.shared, bf16>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xbf16>, 64>, !wave.mem.token)
        %2934 = wave.join %token_95, %token_97, %token_99, %token_101, %token_103, %token_105, %token_107, %token_109, %token_111, %token_113, %token_115, %token_117, %token_119, %token_121, %token_123, %token_125 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %2935 = wave.binary muli %2896, %c8704_i32 overflow<nsw> : i32, i32 -> i32
        %2936 = wave.ptr_add %688, %2935 : !wave.ptr<#wave.shared, bf16>, i32 -> !wave.ptr<#wave.shared, bf16>
        %value_126, %token_127 = wave.gather %2936 mapping <bit_offset = <"16*(4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2937 = wave.extract %value_126[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2938 = wave.extract %value_126[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2939 = wave.extract %value_126[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2940 = wave.extract %value_126[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_128, %token_129 = wave.gather %2936 mapping <bit_offset = <"16*(2176 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2941 = wave.extract %value_128[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2942 = wave.extract %value_128[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2943 = wave.extract %value_128[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2944 = wave.extract %value_128[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2945 = wave.pack %2937, %2938, %2939, %2940, %2941, %2942, %2943, %2944 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_130, %token_131 = wave.gather %2936 mapping <bit_offset = <"16*(128 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2946 = wave.extract %value_130[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2947 = wave.extract %value_130[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2948 = wave.extract %value_130[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2949 = wave.extract %value_130[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_132, %token_133 = wave.gather %2936 mapping <bit_offset = <"16*(2304 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2950 = wave.extract %value_132[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2951 = wave.extract %value_132[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2952 = wave.extract %value_132[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2953 = wave.extract %value_132[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2954 = wave.pack %2946, %2947, %2948, %2949, %2950, %2951, %2952, %2953 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_134, %token_135 = wave.gather %2936 mapping <bit_offset = <"16*(256 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2955 = wave.extract %value_134[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2956 = wave.extract %value_134[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2957 = wave.extract %value_134[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2958 = wave.extract %value_134[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_136, %token_137 = wave.gather %2936 mapping <bit_offset = <"16*(2432 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2959 = wave.extract %value_136[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2960 = wave.extract %value_136[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2961 = wave.extract %value_136[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2962 = wave.extract %value_136[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2963 = wave.pack %2955, %2956, %2957, %2958, %2959, %2960, %2961, %2962 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_138, %token_139 = wave.gather %2936 mapping <bit_offset = <"16*(384 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2964 = wave.extract %value_138[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2965 = wave.extract %value_138[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2966 = wave.extract %value_138[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2967 = wave.extract %value_138[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_140, %token_141 = wave.gather %2936 mapping <bit_offset = <"16*(2560 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2968 = wave.extract %value_140[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2969 = wave.extract %value_140[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2970 = wave.extract %value_140[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2971 = wave.extract %value_140[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2972 = wave.pack %2964, %2965, %2966, %2967, %2968, %2969, %2970, %2971 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_142, %token_143 = wave.gather %2936 mapping <bit_offset = <"16*(32 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2973 = wave.extract %value_142[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2974 = wave.extract %value_142[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2975 = wave.extract %value_142[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2976 = wave.extract %value_142[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_144, %token_145 = wave.gather %2936 mapping <bit_offset = <"16*(2208 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2977 = wave.extract %value_144[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2978 = wave.extract %value_144[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2979 = wave.extract %value_144[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2980 = wave.extract %value_144[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2981 = wave.pack %2973, %2974, %2975, %2976, %2977, %2978, %2979, %2980 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_146, %token_147 = wave.gather %2936 mapping <bit_offset = <"16*(160 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2982 = wave.extract %value_146[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2983 = wave.extract %value_146[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2984 = wave.extract %value_146[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2985 = wave.extract %value_146[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_148, %token_149 = wave.gather %2936 mapping <bit_offset = <"16*(2336 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2986 = wave.extract %value_148[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2987 = wave.extract %value_148[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2988 = wave.extract %value_148[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2989 = wave.extract %value_148[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2990 = wave.pack %2982, %2983, %2984, %2985, %2986, %2987, %2988, %2989 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_150, %token_151 = wave.gather %2936 mapping <bit_offset = <"16*(288 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2991 = wave.extract %value_150[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2992 = wave.extract %value_150[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2993 = wave.extract %value_150[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2994 = wave.extract %value_150[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_152, %token_153 = wave.gather %2936 mapping <bit_offset = <"16*(2464 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %2995 = wave.extract %value_152[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2996 = wave.extract %value_152[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2997 = wave.extract %value_152[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2998 = wave.extract %value_152[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %2999 = wave.pack %2991, %2992, %2993, %2994, %2995, %2996, %2997, %2998 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_154, %token_155 = wave.gather %2936 mapping <bit_offset = <"16*(416 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3000 = wave.extract %value_154[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3001 = wave.extract %value_154[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3002 = wave.extract %value_154[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3003 = wave.extract %value_154[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_156, %token_157 = wave.gather %2936 mapping <bit_offset = <"16*(2592 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3004 = wave.extract %value_156[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3005 = wave.extract %value_156[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3006 = wave.extract %value_156[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3007 = wave.extract %value_156[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3008 = wave.pack %3000, %3001, %3002, %3003, %3004, %3005, %3006, %3007 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_158, %token_159 = wave.gather %2936 mapping <bit_offset = <"16*(64 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3009 = wave.extract %value_158[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3010 = wave.extract %value_158[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3011 = wave.extract %value_158[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3012 = wave.extract %value_158[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_160, %token_161 = wave.gather %2936 mapping <bit_offset = <"16*(2240 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3013 = wave.extract %value_160[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3014 = wave.extract %value_160[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3015 = wave.extract %value_160[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3016 = wave.extract %value_160[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3017 = wave.pack %3009, %3010, %3011, %3012, %3013, %3014, %3015, %3016 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_162, %token_163 = wave.gather %2936 mapping <bit_offset = <"16*(192 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3018 = wave.extract %value_162[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3019 = wave.extract %value_162[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3020 = wave.extract %value_162[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3021 = wave.extract %value_162[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_164, %token_165 = wave.gather %2936 mapping <bit_offset = <"16*(2368 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3022 = wave.extract %value_164[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3023 = wave.extract %value_164[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3024 = wave.extract %value_164[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3025 = wave.extract %value_164[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3026 = wave.pack %3018, %3019, %3020, %3021, %3022, %3023, %3024, %3025 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_166, %token_167 = wave.gather %2936 mapping <bit_offset = <"16*(320 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3027 = wave.extract %value_166[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3028 = wave.extract %value_166[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3029 = wave.extract %value_166[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3030 = wave.extract %value_166[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_168, %token_169 = wave.gather %2936 mapping <bit_offset = <"16*(2496 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3031 = wave.extract %value_168[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3032 = wave.extract %value_168[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3033 = wave.extract %value_168[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3034 = wave.extract %value_168[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3035 = wave.pack %3027, %3028, %3029, %3030, %3031, %3032, %3033, %3034 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_170, %token_171 = wave.gather %2936 mapping <bit_offset = <"16*(448 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3036 = wave.extract %value_170[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3037 = wave.extract %value_170[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3038 = wave.extract %value_170[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3039 = wave.extract %value_170[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_172, %token_173 = wave.gather %2936 mapping <bit_offset = <"16*(2624 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3040 = wave.extract %value_172[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3041 = wave.extract %value_172[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3042 = wave.extract %value_172[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3043 = wave.extract %value_172[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3044 = wave.pack %3036, %3037, %3038, %3039, %3040, %3041, %3042, %3043 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_174, %token_175 = wave.gather %2936 mapping <bit_offset = <"16*(96 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3045 = wave.extract %value_174[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3046 = wave.extract %value_174[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3047 = wave.extract %value_174[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3048 = wave.extract %value_174[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_176, %token_177 = wave.gather %2936 mapping <bit_offset = <"16*(2272 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3049 = wave.extract %value_176[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3050 = wave.extract %value_176[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3051 = wave.extract %value_176[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3052 = wave.extract %value_176[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3053 = wave.pack %3045, %3046, %3047, %3048, %3049, %3050, %3051, %3052 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_178, %token_179 = wave.gather %2936 mapping <bit_offset = <"16*(224 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3054 = wave.extract %value_178[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3055 = wave.extract %value_178[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3056 = wave.extract %value_178[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3057 = wave.extract %value_178[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_180, %token_181 = wave.gather %2936 mapping <bit_offset = <"16*(2400 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3058 = wave.extract %value_180[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3059 = wave.extract %value_180[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3060 = wave.extract %value_180[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3061 = wave.extract %value_180[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3062 = wave.pack %3054, %3055, %3056, %3057, %3058, %3059, %3060, %3061 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_182, %token_183 = wave.gather %2936 mapping <bit_offset = <"16*(352 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3063 = wave.extract %value_182[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3064 = wave.extract %value_182[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3065 = wave.extract %value_182[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3066 = wave.extract %value_182[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_184, %token_185 = wave.gather %2936 mapping <bit_offset = <"16*(2528 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3067 = wave.extract %value_184[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3068 = wave.extract %value_184[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3069 = wave.extract %value_184[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3070 = wave.extract %value_184[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3071 = wave.pack %3063, %3064, %3065, %3066, %3067, %3068, %3069, %3070 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %value_186, %token_187 = wave.gather %2936 mapping <bit_offset = <"16*(480 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3072 = wave.extract %value_186[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3073 = wave.extract %value_186[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3074 = wave.extract %value_186[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3075 = wave.extract %value_186[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %value_188, %token_189 = wave.gather %2936 mapping <bit_offset = <"16*(2656 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %2901 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
        %3076 = wave.extract %value_188[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3077 = wave.extract %value_188[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3078 = wave.extract %value_188[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3079 = wave.extract %value_188[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
        %3080 = wave.pack %3072, %3073, %3074, %3075, %3076, %3077, %3078, %3079 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3081 = wave.join %token_127, %token_129, %token_131, %token_133, %token_135, %token_137, %token_139, %token_141, %token_143, %token_145, %token_147, %token_149, %token_151, %token_153, %token_155, %token_157, %token_159, %token_161, %token_163, %token_165, %token_167, %token_169, %token_171, %token_173, %token_175, %token_177, %token_179, %token_181, %token_183, %token_185, %token_187, %token_189 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3082 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %3083 = wave.binary muli %2884, %3082 overflow<nsw> : i32, i32 -> i32
        %3084 = wave.binary muli %2898, %c4160_i32 overflow<nsw> : i32, i32 -> i32
        %3085 = wave.barrier %2934, %3081 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %3086 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3082, %3083, %128) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3087 = wave.assume %3086 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3088 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3087) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3089 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3082, %3083, %128) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3090 = wave.assume %3089 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3091 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3090) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3092 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3082, %3083, %128) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3093 = wave.assume %3092 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3094 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3093) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3095 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3082, %3083, %128) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3096 = wave.assume %3095 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3097 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3096) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3098 = wave.ptr_add %728, %3088 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3099 = wave.ptr_add %733, %3084 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3100 = wave.select %2891, %3098, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3101 = waveamd.dma_load_lds %3100 -> %3099 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3102 = wave.ptr_add %728, %3091 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3103 = wave.ptr_add %739, %3084 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3104 = wave.select %2892, %3102, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3105 = waveamd.dma_load_lds %3104 -> %3103 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3106 = wave.ptr_add %728, %3094 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3107 = wave.ptr_add %744, %3084 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3108 = wave.select %2893, %3106, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3109 = waveamd.dma_load_lds %3108 -> %3107 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3110 = wave.ptr_add %728, %3097 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3111 = wave.ptr_add %749, %3084 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3112 = wave.select %2894, %3110, %734 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3113 = waveamd.dma_load_lds %3112 -> %3111 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3114 = wave.join %3101, %3105, %3109, %3113 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3115 = wave.assume %arg12 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
        %3116 = wave.binary muli %2884, %3115 overflow<nsw> : i32, i32 -> i32
        %3117 = wave.binary muli %2898, %c4352_i32 overflow<nsw> : i32, i32 -> i32
        %3118 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3115, %3116, %133) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3119 = wave.assume %3118 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3120 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3119) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3121 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3115, %3116, %133) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3122 = wave.assume %3121 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3123 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3122) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3124 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/512*wi), 2), xor(4*Mod(floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3115, %3116, %133) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3125 = wave.assume %3124 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3126 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3125) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3127 = wave.index_expr <"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/32*wi), 2) + 16*Mod(floor(1/16*wi), 2), Mod(floor(1/64*wi), 2))))) + 8*Mod(wi, 2) + 64*Mod(floor(1/8*wi), 2) + 32*Mod(floor(1/4*wi), 2) + 16*Mod(floor(1/2*wi), 2)"> assuming [#wave.pred<"s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) >= 0">, #wave.pred<"-1073741816 + s1 + s2 + s0*xor(8*Mod(1 + floor(1/2 + 1/512*wi), 2), xor(4*Mod(1 + floor(1/256*wi), 2), xor(2*Mod(floor(1/128*wi), 2), xor(Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), 32*Mod(floor(1/32*wi), 2)))))) + xor(64*Mod(floor(1/8*wi), 2), xor(32*Mod(floor(1/4*wi), 2), xor(8*Mod(wi, 2), 16*Mod(floor(1/2*wi), 2)))) <= 0">] ["wi", "s0", "s1", "s2"](%140, %3115, %3116, %133) : (!wave.simd<i32, 64>, i32, i32, i32) -> !wave.simd<index, 64>
        %3128 = wave.assume %3127 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] : !wave.simd<index, 64>
        %3129 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741816 + x <= 0">] ["x"](%3128) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
        %3130 = wave.ptr_add %766, %3120 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3131 = wave.ptr_add %769, %3117 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3132 = wave.select %2891, %3130, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3133 = waveamd.dma_load_lds %3132 -> %3131 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3134 = wave.ptr_add %766, %3123 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3135 = wave.ptr_add %775, %3117 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3136 = wave.select %2892, %3134, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3137 = waveamd.dma_load_lds %3136 -> %3135 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3138 = wave.ptr_add %766, %3126 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3139 = wave.ptr_add %780, %3117 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3140 = wave.select %2893, %3138, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3141 = waveamd.dma_load_lds %3140 -> %3139 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3142 = wave.ptr_add %766, %3129 : !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3143 = wave.ptr_add %785, %3117 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
        %3144 = wave.select %2894, %3142, %770 : !wave.mask<64>, !wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>
        %3145 = waveamd.dma_load_lds %3144 -> %3143 after %668 {bytes = 16 : i64, zero_fill_inactive} : (!wave.simd<!wave.ptr<#waveamd.buffer, bf16>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
        %3146 = wave.join %3133, %3137, %3141, %3145 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3147 = wave.join %3114, %3146 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3148 = waveamd.fragment_pack %671 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3149 = waveamd.fragment_pack %672 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3150 = waveamd.fragment_pack %673 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3151 = waveamd.fragment_pack %674 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3152 = waveamd.fragment_pack %675 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3153 = waveamd.fragment_pack %676 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3154 = waveamd.fragment_pack %677 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3155 = waveamd.fragment_pack %678 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3156 = waveamd.fragment_pack %679 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3157 = waveamd.fragment_pack %680 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3158 = waveamd.fragment_pack %681 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3159 = waveamd.fragment_pack %682 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3160 = waveamd.fragment_pack %683 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3161 = waveamd.fragment_pack %684 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3162 = waveamd.fragment_pack %685 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3163 = waveamd.fragment_pack %686 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3164 = waveamd.fragment_pack %value_94 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3165 = waveamd.fragment_pack %value_96 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3166 = waveamd.fragment_pack %value_98 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3167 = waveamd.fragment_pack %value_100 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3168 = waveamd.fragment_pack %value_102 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3169 = waveamd.fragment_pack %value_104 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3170 = waveamd.fragment_pack %value_106 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3171 = waveamd.fragment_pack %value_108 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3172 = waveamd.fragment_pack %value_110 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3173 = waveamd.fragment_pack %value_112 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3174 = waveamd.fragment_pack %value_114 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3175 = waveamd.fragment_pack %value_116 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3176 = waveamd.fragment_pack %value_118 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3177 = waveamd.fragment_pack %value_120 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3178 = waveamd.fragment_pack %value_122 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3179 = waveamd.fragment_pack %value_124 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3180 = waveamd.fragment_pack %112 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3181 = waveamd.mma "mfma.f32.32x32x16.bf16" %3164, %3148, %3180 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3182 = waveamd.mma "mfma.f32.32x32x16.bf16" %3165, %3149, %3181 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3183 = waveamd.mma "mfma.f32.32x32x16.bf16" %3166, %3150, %3182 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3184 = waveamd.mma "mfma.f32.32x32x16.bf16" %3167, %3151, %3183 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3185 = waveamd.mma "mfma.f32.32x32x16.bf16" %3168, %3152, %3184 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3186 = waveamd.mma "mfma.f32.32x32x16.bf16" %3169, %3153, %3185 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3187 = waveamd.mma "mfma.f32.32x32x16.bf16" %3170, %3154, %3186 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3188 = waveamd.mma "mfma.f32.32x32x16.bf16" %3171, %3155, %3187 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3189 = waveamd.fragment_unpack %3188 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3190 = waveamd.mma "mfma.f32.32x32x16.bf16" %3172, %3148, %3180 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3191 = waveamd.mma "mfma.f32.32x32x16.bf16" %3173, %3149, %3190 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3192 = waveamd.mma "mfma.f32.32x32x16.bf16" %3174, %3150, %3191 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3193 = waveamd.mma "mfma.f32.32x32x16.bf16" %3175, %3151, %3192 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3194 = waveamd.mma "mfma.f32.32x32x16.bf16" %3176, %3152, %3193 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3195 = waveamd.mma "mfma.f32.32x32x16.bf16" %3177, %3153, %3194 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3196 = waveamd.mma "mfma.f32.32x32x16.bf16" %3178, %3154, %3195 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3197 = waveamd.mma "mfma.f32.32x32x16.bf16" %3179, %3155, %3196 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3198 = waveamd.fragment_unpack %3197 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3199 = waveamd.mma "mfma.f32.32x32x16.bf16" %3164, %3156, %3180 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3200 = waveamd.mma "mfma.f32.32x32x16.bf16" %3165, %3157, %3199 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3201 = waveamd.mma "mfma.f32.32x32x16.bf16" %3166, %3158, %3200 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3202 = waveamd.mma "mfma.f32.32x32x16.bf16" %3167, %3159, %3201 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3203 = waveamd.mma "mfma.f32.32x32x16.bf16" %3168, %3160, %3202 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3204 = waveamd.mma "mfma.f32.32x32x16.bf16" %3169, %3161, %3203 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3205 = waveamd.mma "mfma.f32.32x32x16.bf16" %3170, %3162, %3204 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3206 = waveamd.mma "mfma.f32.32x32x16.bf16" %3171, %3163, %3205 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3207 = waveamd.fragment_unpack %3206 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3208 = waveamd.mma "mfma.f32.32x32x16.bf16" %3172, %3156, %3180 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3209 = waveamd.mma "mfma.f32.32x32x16.bf16" %3173, %3157, %3208 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3210 = waveamd.mma "mfma.f32.32x32x16.bf16" %3174, %3158, %3209 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3211 = waveamd.mma "mfma.f32.32x32x16.bf16" %3175, %3159, %3210 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3212 = waveamd.mma "mfma.f32.32x32x16.bf16" %3176, %3160, %3211 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3213 = waveamd.mma "mfma.f32.32x32x16.bf16" %3177, %3161, %3212 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3214 = waveamd.mma "mfma.f32.32x32x16.bf16" %3178, %3162, %3213 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3215 = waveamd.mma "mfma.f32.32x32x16.bf16" %3179, %3163, %3214 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3216 = waveamd.fragment_unpack %3215 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3217 = wave.lane_id : !wave.simd<i32, 64>
        %3218 = wave.extract %3189[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3219 = wave.extract %3189[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3220 = wave.extract %3189[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3221 = wave.extract %3189[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3222 = wave.extract %3189[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3223 = wave.extract %3189[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3224 = wave.extract %3189[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3225 = wave.extract %3189[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3226 = wave.extract %3189[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3227 = wave.extract %3189[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3228 = wave.extract %3189[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3229 = wave.extract %3189[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3230 = wave.extract %3189[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3231 = wave.extract %3189[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3232 = wave.extract %3189[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3233 = wave.extract %3189[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3234 = wave.extract %3198[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3235 = wave.extract %3198[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3236 = wave.extract %3198[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3237 = wave.extract %3198[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3238 = wave.extract %3198[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3239 = wave.extract %3198[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3240 = wave.extract %3198[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3241 = wave.extract %3198[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3242 = wave.extract %3198[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3243 = wave.extract %3198[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3244 = wave.extract %3198[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3245 = wave.extract %3198[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3246 = wave.extract %3198[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3247 = wave.extract %3198[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3248 = wave.extract %3198[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3249 = wave.extract %3198[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3250 = wave.fmax %3218, %3219 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3251 = wave.fmax %3220, %3221 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3252 = wave.fmax %3222, %3223 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3253 = wave.fmax %3224, %3225 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3254 = wave.fmax %3226, %3227 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3255 = wave.fmax %3228, %3229 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3256 = wave.fmax %3230, %3231 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3257 = wave.fmax %3232, %3233 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3258 = wave.fmax %3234, %3235 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3259 = wave.fmax %3236, %3237 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3260 = wave.fmax %3238, %3239 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3261 = wave.fmax %3240, %3241 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3262 = wave.fmax %3242, %3243 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3263 = wave.fmax %3244, %3245 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3264 = wave.fmax %3246, %3247 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3265 = wave.fmax %3248, %3249 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3266 = wave.fmax %3250, %3251 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3267 = wave.fmax %3252, %3253 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3268 = wave.fmax %3254, %3255 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3269 = wave.fmax %3256, %3257 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3270 = wave.fmax %3258, %3259 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3271 = wave.fmax %3260, %3261 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3272 = wave.fmax %3262, %3263 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3273 = wave.fmax %3264, %3265 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3274 = wave.fmax %3266, %3267 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3275 = wave.fmax %3268, %3269 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3276 = wave.fmax %3270, %3271 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3277 = wave.fmax %3272, %3273 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3278 = wave.fmax %3274, %3275 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3279 = wave.fmax %3276, %3277 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3280 = wave.fmax %3278, %3279 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3281 = wave.index_expr <"Mod(wi, 2) + 16*Mod(floor(1/16*wi), 2) + 8*Mod(floor(1/8*wi), 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> ["wi"](%3217) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %3282 = wave.shuffle %3280 from %3281 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3283 = wave.index_expr <"xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(32 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2)))))"> ["wi"](%3217) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
        %3284 = wave.shuffle %3280 from %3283 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3285 = wave.fmax %3282, %3284 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3286 = wave.extract %3207[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3287 = wave.extract %3207[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3288 = wave.extract %3207[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3289 = wave.extract %3207[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3290 = wave.extract %3207[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3291 = wave.extract %3207[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3292 = wave.extract %3207[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3293 = wave.extract %3207[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3294 = wave.extract %3207[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3295 = wave.extract %3207[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3296 = wave.extract %3207[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3297 = wave.extract %3207[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3298 = wave.extract %3207[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3299 = wave.extract %3207[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3300 = wave.extract %3207[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3301 = wave.extract %3207[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3302 = wave.extract %3216[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3303 = wave.extract %3216[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3304 = wave.extract %3216[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3305 = wave.extract %3216[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3306 = wave.extract %3216[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3307 = wave.extract %3216[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3308 = wave.extract %3216[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3309 = wave.extract %3216[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3310 = wave.extract %3216[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3311 = wave.extract %3216[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3312 = wave.extract %3216[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3313 = wave.extract %3216[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3314 = wave.extract %3216[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3315 = wave.extract %3216[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3316 = wave.extract %3216[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3317 = wave.extract %3216[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3318 = wave.fmax %3286, %3287 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3319 = wave.fmax %3288, %3289 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3320 = wave.fmax %3290, %3291 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3321 = wave.fmax %3292, %3293 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3322 = wave.fmax %3294, %3295 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3323 = wave.fmax %3296, %3297 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3324 = wave.fmax %3298, %3299 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3325 = wave.fmax %3300, %3301 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3326 = wave.fmax %3302, %3303 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3327 = wave.fmax %3304, %3305 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3328 = wave.fmax %3306, %3307 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3329 = wave.fmax %3308, %3309 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3330 = wave.fmax %3310, %3311 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3331 = wave.fmax %3312, %3313 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3332 = wave.fmax %3314, %3315 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3333 = wave.fmax %3316, %3317 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3334 = wave.fmax %3318, %3319 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3335 = wave.fmax %3320, %3321 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3336 = wave.fmax %3322, %3323 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3337 = wave.fmax %3324, %3325 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3338 = wave.fmax %3326, %3327 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3339 = wave.fmax %3328, %3329 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3340 = wave.fmax %3330, %3331 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3341 = wave.fmax %3332, %3333 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3342 = wave.fmax %3334, %3335 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3343 = wave.fmax %3336, %3337 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3344 = wave.fmax %3338, %3339 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3345 = wave.fmax %3340, %3341 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3346 = wave.fmax %3342, %3343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3347 = wave.fmax %3344, %3345 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3348 = wave.fmax %3346, %3347 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3349 = wave.shuffle %3348 from %3281 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3350 = wave.shuffle %3348 from %3283 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3351 = wave.fmax %3349, %3350 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3352 = wave.fmul %3285, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3353 = wave.fmul %3351, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3354 = wave.fmax %arg20, %3352 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3355 = wave.fmax %arg21, %3353 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3356 = wave.fmul %3218, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3357 = wave.fmul %3219, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3358 = wave.fmul %3220, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3359 = wave.fmul %3221, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3360 = wave.fmul %3222, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3361 = wave.fmul %3223, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3362 = wave.fmul %3224, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3363 = wave.fmul %3225, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3364 = wave.fmul %3226, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3365 = wave.fmul %3227, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3366 = wave.fmul %3228, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3367 = wave.fmul %3229, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3368 = wave.fmul %3230, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3369 = wave.fmul %3231, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3370 = wave.fmul %3232, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3371 = wave.fmul %3233, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3372 = wave.fmul %3234, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3373 = wave.fmul %3235, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3374 = wave.fmul %3236, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3375 = wave.fmul %3237, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3376 = wave.fmul %3238, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3377 = wave.fmul %3239, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3378 = wave.fmul %3240, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3379 = wave.fmul %3241, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3380 = wave.fmul %3242, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3381 = wave.fmul %3243, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3382 = wave.fmul %3244, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3383 = wave.fmul %3245, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3384 = wave.fmul %3246, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3385 = wave.fmul %3247, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3386 = wave.fmul %3248, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3387 = wave.fmul %3249, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3388 = wave.fmul %3286, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3389 = wave.fmul %3287, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3390 = wave.fmul %3288, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3391 = wave.fmul %3289, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3392 = wave.fmul %3290, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3393 = wave.fmul %3291, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3394 = wave.fmul %3292, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3395 = wave.fmul %3293, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3396 = wave.fmul %3294, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3397 = wave.fmul %3295, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3398 = wave.fmul %3296, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3399 = wave.fmul %3297, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3400 = wave.fmul %3298, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3401 = wave.fmul %3299, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3402 = wave.fmul %3300, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3403 = wave.fmul %3301, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3404 = wave.fmul %3302, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3405 = wave.fmul %3303, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3406 = wave.fmul %3304, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3407 = wave.fmul %3305, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3408 = wave.fmul %3306, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3409 = wave.fmul %3307, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3410 = wave.fmul %3308, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3411 = wave.fmul %3309, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3412 = wave.fmul %3310, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3413 = wave.fmul %3311, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3414 = wave.fmul %3312, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3415 = wave.fmul %3313, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3416 = wave.fmul %3314, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3417 = wave.fmul %3315, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3418 = wave.fmul %3316, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3419 = wave.fmul %3317, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3420 = wave.fsub %3356, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3421 = wave.fsub %3357, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3422 = wave.fsub %3358, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3423 = wave.fsub %3359, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3424 = wave.fsub %3360, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3425 = wave.fsub %3361, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3426 = wave.fsub %3362, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3427 = wave.fsub %3363, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3428 = wave.fsub %3364, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3429 = wave.fsub %3365, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3430 = wave.fsub %3366, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3431 = wave.fsub %3367, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3432 = wave.fsub %3368, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3433 = wave.fsub %3369, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3434 = wave.fsub %3370, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3435 = wave.fsub %3371, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3436 = wave.fsub %3372, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3437 = wave.fsub %3373, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3438 = wave.fsub %3374, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3439 = wave.fsub %3375, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3440 = wave.fsub %3376, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3441 = wave.fsub %3377, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3442 = wave.fsub %3378, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3443 = wave.fsub %3379, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3444 = wave.fsub %3380, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3445 = wave.fsub %3381, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3446 = wave.fsub %3382, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3447 = wave.fsub %3383, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3448 = wave.fsub %3384, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3449 = wave.fsub %3385, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3450 = wave.fsub %3386, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3451 = wave.fsub %3387, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3452 = wave.fsub %3388, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3453 = wave.fsub %3389, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3454 = wave.fsub %3390, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3455 = wave.fsub %3391, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3456 = wave.fsub %3392, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3457 = wave.fsub %3393, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3458 = wave.fsub %3394, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3459 = wave.fsub %3395, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3460 = wave.fsub %3396, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3461 = wave.fsub %3397, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3462 = wave.fsub %3398, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3463 = wave.fsub %3399, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3464 = wave.fsub %3400, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3465 = wave.fsub %3401, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3466 = wave.fsub %3402, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3467 = wave.fsub %3403, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3468 = wave.fsub %3404, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3469 = wave.fsub %3405, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3470 = wave.fsub %3406, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3471 = wave.fsub %3407, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3472 = wave.fsub %3408, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3473 = wave.fsub %3409, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3474 = wave.fsub %3410, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3475 = wave.fsub %3411, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3476 = wave.fsub %3412, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3477 = wave.fsub %3413, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3478 = wave.fsub %3414, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3479 = wave.fsub %3415, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3480 = wave.fsub %3416, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3481 = wave.fsub %3417, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3482 = wave.fsub %3418, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3483 = wave.fsub %3419, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3484 = wave.fexp2 %3420 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3485 = wave.fexp2 %3421 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3486 = wave.fexp2 %3422 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3487 = wave.fexp2 %3423 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3488 = wave.fexp2 %3424 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3489 = wave.fexp2 %3425 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3490 = wave.fexp2 %3426 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3491 = wave.fexp2 %3427 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3492 = wave.fexp2 %3428 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3493 = wave.fexp2 %3429 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3494 = wave.fexp2 %3430 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3495 = wave.fexp2 %3431 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3496 = wave.fexp2 %3432 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3497 = wave.fexp2 %3433 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3498 = wave.fexp2 %3434 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3499 = wave.fexp2 %3435 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3500 = wave.pack %3484, %3485, %3486, %3487, %3488, %3489, %3490, %3491, %3492, %3493, %3494, %3495, %3496, %3497, %3498, %3499 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3501 = wave.fexp2 %3436 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3502 = wave.fexp2 %3437 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3503 = wave.fexp2 %3438 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3504 = wave.fexp2 %3439 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3505 = wave.fexp2 %3440 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3506 = wave.fexp2 %3441 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3507 = wave.fexp2 %3442 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3508 = wave.fexp2 %3443 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3509 = wave.fexp2 %3444 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3510 = wave.fexp2 %3445 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3511 = wave.fexp2 %3446 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3512 = wave.fexp2 %3447 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3513 = wave.fexp2 %3448 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3514 = wave.fexp2 %3449 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3515 = wave.fexp2 %3450 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3516 = wave.fexp2 %3451 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3517 = wave.pack %3501, %3502, %3503, %3504, %3505, %3506, %3507, %3508, %3509, %3510, %3511, %3512, %3513, %3514, %3515, %3516 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3518 = wave.fexp2 %3452 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3519 = wave.fexp2 %3453 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3520 = wave.fexp2 %3454 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3521 = wave.fexp2 %3455 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3522 = wave.fexp2 %3456 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3523 = wave.fexp2 %3457 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3524 = wave.fexp2 %3458 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3525 = wave.fexp2 %3459 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3526 = wave.fexp2 %3460 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3527 = wave.fexp2 %3461 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3528 = wave.fexp2 %3462 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3529 = wave.fexp2 %3463 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3530 = wave.fexp2 %3464 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3531 = wave.fexp2 %3465 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3532 = wave.fexp2 %3466 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3533 = wave.fexp2 %3467 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3534 = wave.pack %3518, %3519, %3520, %3521, %3522, %3523, %3524, %3525, %3526, %3527, %3528, %3529, %3530, %3531, %3532, %3533 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3535 = wave.fexp2 %3468 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3536 = wave.fexp2 %3469 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3537 = wave.fexp2 %3470 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3538 = wave.fexp2 %3471 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3539 = wave.fexp2 %3472 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3540 = wave.fexp2 %3473 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3541 = wave.fexp2 %3474 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3542 = wave.fexp2 %3475 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3543 = wave.fexp2 %3476 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3544 = wave.fexp2 %3477 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3545 = wave.fexp2 %3478 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3546 = wave.fexp2 %3479 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3547 = wave.fexp2 %3480 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3548 = wave.fexp2 %3481 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3549 = wave.fexp2 %3482 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3550 = wave.fexp2 %3483 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3551 = wave.pack %3535, %3536, %3537, %3538, %3539, %3540, %3541, %3542, %3543, %3544, %3545, %3546, %3547, %3548, %3549, %3550 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3552 = wave.fadd %3484, %3485 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3553 = wave.fadd %3486, %3487 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3554 = wave.fadd %3488, %3489 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3555 = wave.fadd %3490, %3491 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3556 = wave.fadd %3492, %3493 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3557 = wave.fadd %3494, %3495 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3558 = wave.fadd %3496, %3497 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3559 = wave.fadd %3498, %3499 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3560 = wave.fadd %3501, %3502 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3561 = wave.fadd %3503, %3504 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3562 = wave.fadd %3505, %3506 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3563 = wave.fadd %3507, %3508 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3564 = wave.fadd %3509, %3510 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3565 = wave.fadd %3511, %3512 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3566 = wave.fadd %3513, %3514 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3567 = wave.fadd %3515, %3516 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3568 = wave.fadd %3552, %3553 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3569 = wave.fadd %3554, %3555 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3570 = wave.fadd %3556, %3557 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3571 = wave.fadd %3558, %3559 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3572 = wave.fadd %3560, %3561 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3573 = wave.fadd %3562, %3563 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3574 = wave.fadd %3564, %3565 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3575 = wave.fadd %3566, %3567 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3576 = wave.fadd %3568, %3569 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3577 = wave.fadd %3570, %3571 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3578 = wave.fadd %3572, %3573 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3579 = wave.fadd %3574, %3575 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3580 = wave.fadd %3576, %3577 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3581 = wave.fadd %3578, %3579 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3582 = wave.fadd %3580, %3581 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3583 = wave.shuffle %3582 from %3281 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3584 = wave.shuffle %3582 from %3283 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3585 = wave.fadd %3583, %3584 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3586 = wave.fadd %3518, %3519 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3587 = wave.fadd %3520, %3521 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3588 = wave.fadd %3522, %3523 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3589 = wave.fadd %3524, %3525 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3590 = wave.fadd %3526, %3527 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3591 = wave.fadd %3528, %3529 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3592 = wave.fadd %3530, %3531 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3593 = wave.fadd %3532, %3533 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3594 = wave.fadd %3535, %3536 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3595 = wave.fadd %3537, %3538 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3596 = wave.fadd %3539, %3540 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3597 = wave.fadd %3541, %3542 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3598 = wave.fadd %3543, %3544 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3599 = wave.fadd %3545, %3546 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3600 = wave.fadd %3547, %3548 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3601 = wave.fadd %3549, %3550 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3602 = wave.fadd %3586, %3587 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3603 = wave.fadd %3588, %3589 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3604 = wave.fadd %3590, %3591 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3605 = wave.fadd %3592, %3593 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3606 = wave.fadd %3594, %3595 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3607 = wave.fadd %3596, %3597 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3608 = wave.fadd %3598, %3599 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3609 = wave.fadd %3600, %3601 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3610 = wave.fadd %3602, %3603 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3611 = wave.fadd %3604, %3605 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3612 = wave.fadd %3606, %3607 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3613 = wave.fadd %3608, %3609 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3614 = wave.fadd %3610, %3611 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3615 = wave.fadd %3612, %3613 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3616 = wave.fadd %3614, %3615 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3617 = wave.shuffle %3616 from %3281 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3618 = wave.shuffle %3616 from %3283 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
        %3619 = wave.fadd %3617, %3618 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3620 = wave.fsub %arg20, %3354 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3621 = wave.fsub %arg21, %3355 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3622 = wave.fexp2 %3620 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3623 = wave.fexp2 %3621 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3624 = wave.extract %arg24[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3625 = wave.fmul %3624, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3626 = wave.extract %arg24[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3627 = wave.fmul %3626, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3628 = wave.extract %arg24[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3629 = wave.fmul %3628, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3630 = wave.extract %arg24[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3631 = wave.fmul %3630, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3632 = wave.extract %arg24[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3633 = wave.fmul %3632, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3634 = wave.extract %arg24[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3635 = wave.fmul %3634, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3636 = wave.extract %arg24[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3637 = wave.fmul %3636, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3638 = wave.extract %arg24[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3639 = wave.fmul %3638, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3640 = wave.extract %arg24[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3641 = wave.fmul %3640, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3642 = wave.extract %arg24[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3643 = wave.fmul %3642, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3644 = wave.extract %arg24[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3645 = wave.fmul %3644, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3646 = wave.extract %arg24[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3647 = wave.fmul %3646, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3648 = wave.extract %arg24[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3649 = wave.fmul %3648, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3650 = wave.extract %arg24[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3651 = wave.fmul %3650, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3652 = wave.extract %arg24[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3653 = wave.fmul %3652, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3654 = wave.extract %arg24[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3655 = wave.fmul %3654, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3656 = wave.pack %3625, %3627, %3629, %3631, %3633, %3635, %3637, %3639, %3641, %3643, %3645, %3647, %3649, %3651, %3653, %3655 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3657 = wave.extract %arg25[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3658 = wave.fmul %3657, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3659 = wave.extract %arg25[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3660 = wave.fmul %3659, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3661 = wave.extract %arg25[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3662 = wave.fmul %3661, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3663 = wave.extract %arg25[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3664 = wave.fmul %3663, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3665 = wave.extract %arg25[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3666 = wave.fmul %3665, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3667 = wave.extract %arg25[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3668 = wave.fmul %3667, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3669 = wave.extract %arg25[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3670 = wave.fmul %3669, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3671 = wave.extract %arg25[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3672 = wave.fmul %3671, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3673 = wave.extract %arg25[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3674 = wave.fmul %3673, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3675 = wave.extract %arg25[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3676 = wave.fmul %3675, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3677 = wave.extract %arg25[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3678 = wave.fmul %3677, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3679 = wave.extract %arg25[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3680 = wave.fmul %3679, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3681 = wave.extract %arg25[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3682 = wave.fmul %3681, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3683 = wave.extract %arg25[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3684 = wave.fmul %3683, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3685 = wave.extract %arg25[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3686 = wave.fmul %3685, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3687 = wave.extract %arg25[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3688 = wave.fmul %3687, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3689 = wave.pack %3658, %3660, %3662, %3664, %3666, %3668, %3670, %3672, %3674, %3676, %3678, %3680, %3682, %3684, %3686, %3688 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3690 = wave.extract %arg26[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3691 = wave.fmul %3690, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3692 = wave.extract %arg26[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3693 = wave.fmul %3692, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3694 = wave.extract %arg26[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3695 = wave.fmul %3694, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3696 = wave.extract %arg26[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3697 = wave.fmul %3696, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3698 = wave.extract %arg26[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3699 = wave.fmul %3698, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3700 = wave.extract %arg26[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3701 = wave.fmul %3700, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3702 = wave.extract %arg26[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3703 = wave.fmul %3702, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3704 = wave.extract %arg26[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3705 = wave.fmul %3704, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3706 = wave.extract %arg26[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3707 = wave.fmul %3706, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3708 = wave.extract %arg26[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3709 = wave.fmul %3708, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3710 = wave.extract %arg26[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3711 = wave.fmul %3710, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3712 = wave.extract %arg26[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3713 = wave.fmul %3712, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3714 = wave.extract %arg26[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3715 = wave.fmul %3714, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3716 = wave.extract %arg26[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3717 = wave.fmul %3716, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3718 = wave.extract %arg26[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3719 = wave.fmul %3718, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3720 = wave.extract %arg26[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3721 = wave.fmul %3720, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3722 = wave.pack %3691, %3693, %3695, %3697, %3699, %3701, %3703, %3705, %3707, %3709, %3711, %3713, %3715, %3717, %3719, %3721 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3723 = wave.extract %arg27[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3724 = wave.fmul %3723, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3725 = wave.extract %arg27[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3726 = wave.fmul %3725, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3727 = wave.extract %arg27[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3728 = wave.fmul %3727, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3729 = wave.extract %arg27[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3730 = wave.fmul %3729, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3731 = wave.extract %arg27[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3732 = wave.fmul %3731, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3733 = wave.extract %arg27[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3734 = wave.fmul %3733, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3735 = wave.extract %arg27[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3736 = wave.fmul %3735, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3737 = wave.extract %arg27[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3738 = wave.fmul %3737, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3739 = wave.extract %arg27[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3740 = wave.fmul %3739, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3741 = wave.extract %arg27[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3742 = wave.fmul %3741, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3743 = wave.extract %arg27[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3744 = wave.fmul %3743, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3745 = wave.extract %arg27[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3746 = wave.fmul %3745, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3747 = wave.extract %arg27[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3748 = wave.fmul %3747, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3749 = wave.extract %arg27[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3750 = wave.fmul %3749, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3751 = wave.extract %arg27[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3752 = wave.fmul %3751, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3753 = wave.extract %arg27[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3754 = wave.fmul %3753, %3622 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3755 = wave.pack %3724, %3726, %3728, %3730, %3732, %3734, %3736, %3738, %3740, %3742, %3744, %3746, %3748, %3750, %3752, %3754 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3756 = wave.extract %arg28[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3757 = wave.fmul %3756, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3758 = wave.extract %arg28[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3759 = wave.fmul %3758, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3760 = wave.extract %arg28[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3761 = wave.fmul %3760, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3762 = wave.extract %arg28[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3763 = wave.fmul %3762, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3764 = wave.extract %arg28[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3765 = wave.fmul %3764, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3766 = wave.extract %arg28[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3767 = wave.fmul %3766, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3768 = wave.extract %arg28[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3769 = wave.fmul %3768, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3770 = wave.extract %arg28[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3771 = wave.fmul %3770, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3772 = wave.extract %arg28[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3773 = wave.fmul %3772, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3774 = wave.extract %arg28[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3775 = wave.fmul %3774, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3776 = wave.extract %arg28[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3777 = wave.fmul %3776, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3778 = wave.extract %arg28[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3779 = wave.fmul %3778, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3780 = wave.extract %arg28[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3781 = wave.fmul %3780, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3782 = wave.extract %arg28[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3783 = wave.fmul %3782, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3784 = wave.extract %arg28[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3785 = wave.fmul %3784, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3786 = wave.extract %arg28[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3787 = wave.fmul %3786, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3788 = wave.pack %3757, %3759, %3761, %3763, %3765, %3767, %3769, %3771, %3773, %3775, %3777, %3779, %3781, %3783, %3785, %3787 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3789 = wave.extract %arg29[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3790 = wave.fmul %3789, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3791 = wave.extract %arg29[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3792 = wave.fmul %3791, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3793 = wave.extract %arg29[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3794 = wave.fmul %3793, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3795 = wave.extract %arg29[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3796 = wave.fmul %3795, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3797 = wave.extract %arg29[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3798 = wave.fmul %3797, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3799 = wave.extract %arg29[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3800 = wave.fmul %3799, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3801 = wave.extract %arg29[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3802 = wave.fmul %3801, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3803 = wave.extract %arg29[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3804 = wave.fmul %3803, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3805 = wave.extract %arg29[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3806 = wave.fmul %3805, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3807 = wave.extract %arg29[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3808 = wave.fmul %3807, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3809 = wave.extract %arg29[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3810 = wave.fmul %3809, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3811 = wave.extract %arg29[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3812 = wave.fmul %3811, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3813 = wave.extract %arg29[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3814 = wave.fmul %3813, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3815 = wave.extract %arg29[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3816 = wave.fmul %3815, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3817 = wave.extract %arg29[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3818 = wave.fmul %3817, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3819 = wave.extract %arg29[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3820 = wave.fmul %3819, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3821 = wave.pack %3790, %3792, %3794, %3796, %3798, %3800, %3802, %3804, %3806, %3808, %3810, %3812, %3814, %3816, %3818, %3820 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3822 = wave.extract %arg30[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3823 = wave.fmul %3822, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3824 = wave.extract %arg30[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3825 = wave.fmul %3824, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3826 = wave.extract %arg30[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3827 = wave.fmul %3826, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3828 = wave.extract %arg30[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3829 = wave.fmul %3828, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3830 = wave.extract %arg30[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3831 = wave.fmul %3830, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3832 = wave.extract %arg30[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3833 = wave.fmul %3832, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3834 = wave.extract %arg30[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3835 = wave.fmul %3834, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3836 = wave.extract %arg30[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3837 = wave.fmul %3836, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3838 = wave.extract %arg30[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3839 = wave.fmul %3838, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3840 = wave.extract %arg30[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3841 = wave.fmul %3840, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3842 = wave.extract %arg30[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3843 = wave.fmul %3842, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3844 = wave.extract %arg30[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3845 = wave.fmul %3844, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3846 = wave.extract %arg30[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3847 = wave.fmul %3846, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3848 = wave.extract %arg30[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3849 = wave.fmul %3848, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3850 = wave.extract %arg30[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3851 = wave.fmul %3850, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3852 = wave.extract %arg30[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3853 = wave.fmul %3852, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3854 = wave.pack %3823, %3825, %3827, %3829, %3831, %3833, %3835, %3837, %3839, %3841, %3843, %3845, %3847, %3849, %3851, %3853 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3855 = wave.extract %arg31[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3856 = wave.fmul %3855, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3857 = wave.extract %arg31[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3858 = wave.fmul %3857, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3859 = wave.extract %arg31[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3860 = wave.fmul %3859, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3861 = wave.extract %arg31[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3862 = wave.fmul %3861, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3863 = wave.extract %arg31[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3864 = wave.fmul %3863, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3865 = wave.extract %arg31[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3866 = wave.fmul %3865, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3867 = wave.extract %arg31[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3868 = wave.fmul %3867, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3869 = wave.extract %arg31[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3870 = wave.fmul %3869, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3871 = wave.extract %arg31[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3872 = wave.fmul %3871, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3873 = wave.extract %arg31[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3874 = wave.fmul %3873, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3875 = wave.extract %arg31[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3876 = wave.fmul %3875, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3877 = wave.extract %arg31[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3878 = wave.fmul %3877, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3879 = wave.extract %arg31[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3880 = wave.fmul %3879, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3881 = wave.extract %arg31[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3882 = wave.fmul %3881, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3883 = wave.extract %arg31[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3884 = wave.fmul %3883, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3885 = wave.extract %arg31[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
        %3886 = wave.fmul %3885, %3623 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3887 = wave.pack %3856, %3858, %3860, %3862, %3864, %3866, %3868, %3870, %3872, %3874, %3876, %3878, %3880, %3882, %3884, %3886 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
        %3888 = wave.fma %arg22, %3622, %3585 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3889 = wave.fma %arg23, %3623, %3619 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
        %3890 = wave.cast fpconvert %3500 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3891 = wave.cast fpconvert %3517 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3892 = wave.cast fpconvert %3534 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3893 = wave.cast fpconvert %3551 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
        %3894 = wave.pack %3890, %3891, %3892, %3893 : !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<64xbf16>, 64>
        %3895 = wave.redistribute %3894, <blocks = 1, items = 256, source_block = "0", source_item = "64*xor(2*Mod(floor(1/128*item), 2), Mod(floor(1/64*item), 2)) + xor(16*Mod(floor(1/16*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(2*Mod(floor(1/2*Mod(item, 64)), 2), xor(32*Mod(floor(1/4*slot), 2), Mod(Mod(item, 64), 2))))))", source_slot = "xor(4*Mod(floor(1/32*Mod(item, 64)), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(8*Mod(floor(1/8*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2))))))"> : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<64xbf16>, 64>
        %3896 = wave.extract %3895[0] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3897 = wave.extract %3895[8] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3898 = wave.extract %3895[16] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3899 = wave.extract %3895[24] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3900 = wave.extract %3895[32] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3901 = wave.extract %3895[40] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3902 = wave.extract %3895[48] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3903 = wave.extract %3895[56] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
        %3904 = waveamd.fragment_pack %3896 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3905 = waveamd.fragment_pack %3897 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3906 = waveamd.fragment_pack %3898 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3907 = waveamd.fragment_pack %3899 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3908 = waveamd.fragment_pack %3900 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3909 = waveamd.fragment_pack %3901 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3910 = waveamd.fragment_pack %3902 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3911 = waveamd.fragment_pack %3903 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
        %3912 = waveamd.fragment_pack %2945 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3913 = waveamd.fragment_pack %2954 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3914 = waveamd.fragment_pack %2963 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3915 = waveamd.fragment_pack %2972 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3916 = waveamd.fragment_pack %2981 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3917 = waveamd.fragment_pack %2990 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3918 = waveamd.fragment_pack %2999 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3919 = waveamd.fragment_pack %3008 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3920 = waveamd.fragment_pack %3017 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3921 = waveamd.fragment_pack %3026 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3922 = waveamd.fragment_pack %3035 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3923 = waveamd.fragment_pack %3044 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3924 = waveamd.fragment_pack %3053 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3925 = waveamd.fragment_pack %3062 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3926 = waveamd.fragment_pack %3071 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3927 = waveamd.fragment_pack %3080 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
        %3928 = waveamd.fragment_pack %3656 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3929 = waveamd.fragment_pack %3689 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3930 = waveamd.fragment_pack %3722 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3931 = waveamd.fragment_pack %3755 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3932 = waveamd.fragment_pack %3788 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3933 = waveamd.fragment_pack %3821 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3934 = waveamd.fragment_pack %3854 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3935 = waveamd.fragment_pack %3887 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3936 = waveamd.mma "mfma.f32.32x32x16.bf16" %3912, %3904, %3928 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3937 = waveamd.mma "mfma.f32.32x32x16.bf16" %3913, %3905, %3936 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3938 = waveamd.mma "mfma.f32.32x32x16.bf16" %3914, %3906, %3937 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3939 = waveamd.mma "mfma.f32.32x32x16.bf16" %3915, %3907, %3938 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3940 = waveamd.fragment_unpack %3939 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3941 = waveamd.mma "mfma.f32.32x32x16.bf16" %3916, %3904, %3929 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3942 = waveamd.mma "mfma.f32.32x32x16.bf16" %3917, %3905, %3941 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3943 = waveamd.mma "mfma.f32.32x32x16.bf16" %3918, %3906, %3942 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3944 = waveamd.mma "mfma.f32.32x32x16.bf16" %3919, %3907, %3943 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3945 = waveamd.fragment_unpack %3944 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3946 = waveamd.mma "mfma.f32.32x32x16.bf16" %3920, %3904, %3930 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3947 = waveamd.mma "mfma.f32.32x32x16.bf16" %3921, %3905, %3946 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3948 = waveamd.mma "mfma.f32.32x32x16.bf16" %3922, %3906, %3947 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3949 = waveamd.mma "mfma.f32.32x32x16.bf16" %3923, %3907, %3948 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3950 = waveamd.fragment_unpack %3949 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3951 = waveamd.mma "mfma.f32.32x32x16.bf16" %3924, %3904, %3931 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3952 = waveamd.mma "mfma.f32.32x32x16.bf16" %3925, %3905, %3951 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3953 = waveamd.mma "mfma.f32.32x32x16.bf16" %3926, %3906, %3952 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3954 = waveamd.mma "mfma.f32.32x32x16.bf16" %3927, %3907, %3953 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3955 = waveamd.fragment_unpack %3954 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3956 = waveamd.mma "mfma.f32.32x32x16.bf16" %3912, %3908, %3932 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3957 = waveamd.mma "mfma.f32.32x32x16.bf16" %3913, %3909, %3956 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3958 = waveamd.mma "mfma.f32.32x32x16.bf16" %3914, %3910, %3957 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3959 = waveamd.mma "mfma.f32.32x32x16.bf16" %3915, %3911, %3958 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3960 = waveamd.fragment_unpack %3959 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3961 = waveamd.mma "mfma.f32.32x32x16.bf16" %3916, %3908, %3933 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3962 = waveamd.mma "mfma.f32.32x32x16.bf16" %3917, %3909, %3961 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3963 = waveamd.mma "mfma.f32.32x32x16.bf16" %3918, %3910, %3962 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3964 = waveamd.mma "mfma.f32.32x32x16.bf16" %3919, %3911, %3963 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3965 = waveamd.fragment_unpack %3964 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3966 = waveamd.mma "mfma.f32.32x32x16.bf16" %3920, %3908, %3934 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3967 = waveamd.mma "mfma.f32.32x32x16.bf16" %3921, %3909, %3966 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3968 = waveamd.mma "mfma.f32.32x32x16.bf16" %3922, %3910, %3967 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3969 = waveamd.mma "mfma.f32.32x32x16.bf16" %3923, %3911, %3968 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3970 = waveamd.fragment_unpack %3969 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        %3971 = waveamd.mma "mfma.f32.32x32x16.bf16" %3924, %3908, %3935 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3972 = waveamd.mma "mfma.f32.32x32x16.bf16" %3925, %3909, %3971 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3973 = waveamd.mma "mfma.f32.32x32x16.bf16" %3926, %3910, %3972 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3974 = waveamd.mma "mfma.f32.32x32x16.bf16" %3927, %3911, %3973 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
        %3975 = waveamd.fragment_unpack %3974 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
        scf.yield %3354, %3355, %3888, %3889, %3940, %3945, %3950, %3955, %3960, %3965, %3970, %3975, %3147 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.simd<vector<16xf32>, 64>, !wave.mem.token
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
      %value_30, %token_31 = wave.gather %830 mapping <bit_offset = <"16*(4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %831 = wave.extract %value_30[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %832 = wave.extract %value_30[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %833 = wave.extract %value_30[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %834 = wave.extract %value_30[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_32, %token_33 = wave.gather %830 mapping <bit_offset = <"16*(2176 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %835 = wave.extract %value_32[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %836 = wave.extract %value_32[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %837 = wave.extract %value_32[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %838 = wave.extract %value_32[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %839 = wave.pack %831, %832, %833, %834, %835, %836, %837, %838 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_34, %token_35 = wave.gather %830 mapping <bit_offset = <"16*(128 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %840 = wave.extract %value_34[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %841 = wave.extract %value_34[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %842 = wave.extract %value_34[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %843 = wave.extract %value_34[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_36, %token_37 = wave.gather %830 mapping <bit_offset = <"16*(2304 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %844 = wave.extract %value_36[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %845 = wave.extract %value_36[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %846 = wave.extract %value_36[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %847 = wave.extract %value_36[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %848 = wave.pack %840, %841, %842, %843, %844, %845, %846, %847 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_38, %token_39 = wave.gather %830 mapping <bit_offset = <"16*(256 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %849 = wave.extract %value_38[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %850 = wave.extract %value_38[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %851 = wave.extract %value_38[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %852 = wave.extract %value_38[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_40, %token_41 = wave.gather %830 mapping <bit_offset = <"16*(2432 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %853 = wave.extract %value_40[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %854 = wave.extract %value_40[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %855 = wave.extract %value_40[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %856 = wave.extract %value_40[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %857 = wave.pack %849, %850, %851, %852, %853, %854, %855, %856 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_42, %token_43 = wave.gather %830 mapping <bit_offset = <"16*(384 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %858 = wave.extract %value_42[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %859 = wave.extract %value_42[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %860 = wave.extract %value_42[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %861 = wave.extract %value_42[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_44, %token_45 = wave.gather %830 mapping <bit_offset = <"16*(2560 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %862 = wave.extract %value_44[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %863 = wave.extract %value_44[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %864 = wave.extract %value_44[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %865 = wave.extract %value_44[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %866 = wave.pack %858, %859, %860, %861, %862, %863, %864, %865 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_46, %token_47 = wave.gather %830 mapping <bit_offset = <"16*(32 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %867 = wave.extract %value_46[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %868 = wave.extract %value_46[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %869 = wave.extract %value_46[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %870 = wave.extract %value_46[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_48, %token_49 = wave.gather %830 mapping <bit_offset = <"16*(2208 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %871 = wave.extract %value_48[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %872 = wave.extract %value_48[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %873 = wave.extract %value_48[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %874 = wave.extract %value_48[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %875 = wave.pack %867, %868, %869, %870, %871, %872, %873, %874 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_50, %token_51 = wave.gather %830 mapping <bit_offset = <"16*(160 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %876 = wave.extract %value_50[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %877 = wave.extract %value_50[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %878 = wave.extract %value_50[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %879 = wave.extract %value_50[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_52, %token_53 = wave.gather %830 mapping <bit_offset = <"16*(2336 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %880 = wave.extract %value_52[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %881 = wave.extract %value_52[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %882 = wave.extract %value_52[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %883 = wave.extract %value_52[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %884 = wave.pack %876, %877, %878, %879, %880, %881, %882, %883 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_54, %token_55 = wave.gather %830 mapping <bit_offset = <"16*(288 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %885 = wave.extract %value_54[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %886 = wave.extract %value_54[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %887 = wave.extract %value_54[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %888 = wave.extract %value_54[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_56, %token_57 = wave.gather %830 mapping <bit_offset = <"16*(2464 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %889 = wave.extract %value_56[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %890 = wave.extract %value_56[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %891 = wave.extract %value_56[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %892 = wave.extract %value_56[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %893 = wave.pack %885, %886, %887, %888, %889, %890, %891, %892 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_58, %token_59 = wave.gather %830 mapping <bit_offset = <"16*(416 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %894 = wave.extract %value_58[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %895 = wave.extract %value_58[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %896 = wave.extract %value_58[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %897 = wave.extract %value_58[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_60, %token_61 = wave.gather %830 mapping <bit_offset = <"16*(2592 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %898 = wave.extract %value_60[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %899 = wave.extract %value_60[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %900 = wave.extract %value_60[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %901 = wave.extract %value_60[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %902 = wave.pack %894, %895, %896, %897, %898, %899, %900, %901 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_62, %token_63 = wave.gather %830 mapping <bit_offset = <"16*(64 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %903 = wave.extract %value_62[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %904 = wave.extract %value_62[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %905 = wave.extract %value_62[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %906 = wave.extract %value_62[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_64, %token_65 = wave.gather %830 mapping <bit_offset = <"16*(2240 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %907 = wave.extract %value_64[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %908 = wave.extract %value_64[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %909 = wave.extract %value_64[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %910 = wave.extract %value_64[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %911 = wave.pack %903, %904, %905, %906, %907, %908, %909, %910 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_66, %token_67 = wave.gather %830 mapping <bit_offset = <"16*(192 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %912 = wave.extract %value_66[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %913 = wave.extract %value_66[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %914 = wave.extract %value_66[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %915 = wave.extract %value_66[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_68, %token_69 = wave.gather %830 mapping <bit_offset = <"16*(2368 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %916 = wave.extract %value_68[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %917 = wave.extract %value_68[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %918 = wave.extract %value_68[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %919 = wave.extract %value_68[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %920 = wave.pack %912, %913, %914, %915, %916, %917, %918, %919 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_70, %token_71 = wave.gather %830 mapping <bit_offset = <"16*(320 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %921 = wave.extract %value_70[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %922 = wave.extract %value_70[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %923 = wave.extract %value_70[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %924 = wave.extract %value_70[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_72, %token_73 = wave.gather %830 mapping <bit_offset = <"16*(2496 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %925 = wave.extract %value_72[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %926 = wave.extract %value_72[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %927 = wave.extract %value_72[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %928 = wave.extract %value_72[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %929 = wave.pack %921, %922, %923, %924, %925, %926, %927, %928 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_74, %token_75 = wave.gather %830 mapping <bit_offset = <"16*(448 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %930 = wave.extract %value_74[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %931 = wave.extract %value_74[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %932 = wave.extract %value_74[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %933 = wave.extract %value_74[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_76, %token_77 = wave.gather %830 mapping <bit_offset = <"16*(2624 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %934 = wave.extract %value_76[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %935 = wave.extract %value_76[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %936 = wave.extract %value_76[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %937 = wave.extract %value_76[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %938 = wave.pack %930, %931, %932, %933, %934, %935, %936, %937 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_78, %token_79 = wave.gather %830 mapping <bit_offset = <"16*(96 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %939 = wave.extract %value_78[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %940 = wave.extract %value_78[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %941 = wave.extract %value_78[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %942 = wave.extract %value_78[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_80, %token_81 = wave.gather %830 mapping <bit_offset = <"16*(2272 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %943 = wave.extract %value_80[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %944 = wave.extract %value_80[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %945 = wave.extract %value_80[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %946 = wave.extract %value_80[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %947 = wave.pack %939, %940, %941, %942, %943, %944, %945, %946 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_82, %token_83 = wave.gather %830 mapping <bit_offset = <"16*(224 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %948 = wave.extract %value_82[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %949 = wave.extract %value_82[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %950 = wave.extract %value_82[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %951 = wave.extract %value_82[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_84, %token_85 = wave.gather %830 mapping <bit_offset = <"16*(2400 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %952 = wave.extract %value_84[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %953 = wave.extract %value_84[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %954 = wave.extract %value_84[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %955 = wave.extract %value_84[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %956 = wave.pack %948, %949, %950, %951, %952, %953, %954, %955 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_86, %token_87 = wave.gather %830 mapping <bit_offset = <"16*(352 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %957 = wave.extract %value_86[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %958 = wave.extract %value_86[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %959 = wave.extract %value_86[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %960 = wave.extract %value_86[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_88, %token_89 = wave.gather %830 mapping <bit_offset = <"16*(2528 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %961 = wave.extract %value_88[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %962 = wave.extract %value_88[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %963 = wave.extract %value_88[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %964 = wave.extract %value_88[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %965 = wave.pack %957, %958, %959, %960, %961, %962, %963, %964 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %value_90, %token_91 = wave.gather %830 mapping <bit_offset = <"16*(480 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %966 = wave.extract %value_90[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %967 = wave.extract %value_90[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %968 = wave.extract %value_90[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %969 = wave.extract %value_90[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %value_92, %token_93 = wave.gather %830 mapping <bit_offset = <"16*(2656 + 4352*floor(1/32*Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64)) + 16*floor(1/16*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 32)) + 544*floor(1/4*Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16)) + Mod(Mod(item, 64), 4) + 4*Mod(Mod(Mod(item + 4*slot + floor(1/4*Mod(Mod(item, 64), 16)) - Mod(Mod(item, 64), 16), 64), 16), 4))">> bindings []() packet_bindings []() after %796 : (!wave.ptr<#wave.shared, bf16>, !wave.mem.token) -> (!wave.simd<vector<4xbf16>, 64>, !wave.mem.token)
      %970 = wave.extract %value_92[0] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %971 = wave.extract %value_92[1] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %972 = wave.extract %value_92[2] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %973 = wave.extract %value_92[3] : !wave.simd<vector<4xbf16>, 64> -> !wave.simd<bf16, 64>
      %974 = wave.pack %966, %967, %968, %969, %970, %971, %972, %973 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<8xbf16>, 64>
      %975 = waveamd.fragment_pack %671 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %976 = waveamd.fragment_pack %672 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %977 = waveamd.fragment_pack %673 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %978 = waveamd.fragment_pack %674 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %979 = waveamd.fragment_pack %675 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %980 = waveamd.fragment_pack %676 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %981 = waveamd.fragment_pack %677 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %982 = waveamd.fragment_pack %678 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %983 = waveamd.fragment_pack %679 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %984 = waveamd.fragment_pack %680 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %985 = waveamd.fragment_pack %681 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %986 = waveamd.fragment_pack %682 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %987 = waveamd.fragment_pack %683 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %988 = waveamd.fragment_pack %684 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %989 = waveamd.fragment_pack %685 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %990 = waveamd.fragment_pack %686 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %991 = waveamd.fragment_pack %value : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %992 = waveamd.fragment_pack %value_0 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %993 = waveamd.fragment_pack %value_2 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %994 = waveamd.fragment_pack %value_4 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %995 = waveamd.fragment_pack %value_6 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %996 = waveamd.fragment_pack %value_8 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %997 = waveamd.fragment_pack %value_10 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %998 = waveamd.fragment_pack %value_12 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %999 = waveamd.fragment_pack %value_14 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1000 = waveamd.fragment_pack %value_16 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1001 = waveamd.fragment_pack %value_18 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1002 = waveamd.fragment_pack %value_20 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1003 = waveamd.fragment_pack %value_22 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1004 = waveamd.fragment_pack %value_24 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1005 = waveamd.fragment_pack %value_26 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1006 = waveamd.fragment_pack %value_28 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1007 = waveamd.fragment_pack %112 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1008 = waveamd.mma "mfma.f32.32x32x16.bf16" %991, %975, %1007 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1009 = waveamd.mma "mfma.f32.32x32x16.bf16" %992, %976, %1008 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1010 = waveamd.mma "mfma.f32.32x32x16.bf16" %993, %977, %1009 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1011 = waveamd.mma "mfma.f32.32x32x16.bf16" %994, %978, %1010 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1012 = waveamd.mma "mfma.f32.32x32x16.bf16" %995, %979, %1011 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1013 = waveamd.mma "mfma.f32.32x32x16.bf16" %996, %980, %1012 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1014 = waveamd.mma "mfma.f32.32x32x16.bf16" %997, %981, %1013 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1015 = waveamd.mma "mfma.f32.32x32x16.bf16" %998, %982, %1014 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1016 = waveamd.fragment_unpack %1015 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1017 = waveamd.mma "mfma.f32.32x32x16.bf16" %999, %975, %1007 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1018 = waveamd.mma "mfma.f32.32x32x16.bf16" %1000, %976, %1017 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1019 = waveamd.mma "mfma.f32.32x32x16.bf16" %1001, %977, %1018 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1020 = waveamd.mma "mfma.f32.32x32x16.bf16" %1002, %978, %1019 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1021 = waveamd.mma "mfma.f32.32x32x16.bf16" %1003, %979, %1020 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1022 = waveamd.mma "mfma.f32.32x32x16.bf16" %1004, %980, %1021 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1023 = waveamd.mma "mfma.f32.32x32x16.bf16" %1005, %981, %1022 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1024 = waveamd.mma "mfma.f32.32x32x16.bf16" %1006, %982, %1023 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1025 = waveamd.fragment_unpack %1024 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1026 = waveamd.mma "mfma.f32.32x32x16.bf16" %991, %983, %1007 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1027 = waveamd.mma "mfma.f32.32x32x16.bf16" %992, %984, %1026 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1028 = waveamd.mma "mfma.f32.32x32x16.bf16" %993, %985, %1027 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1029 = waveamd.mma "mfma.f32.32x32x16.bf16" %994, %986, %1028 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1030 = waveamd.mma "mfma.f32.32x32x16.bf16" %995, %987, %1029 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1031 = waveamd.mma "mfma.f32.32x32x16.bf16" %996, %988, %1030 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1032 = waveamd.mma "mfma.f32.32x32x16.bf16" %997, %989, %1031 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1033 = waveamd.mma "mfma.f32.32x32x16.bf16" %998, %990, %1032 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1034 = waveamd.fragment_unpack %1033 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1035 = waveamd.mma "mfma.f32.32x32x16.bf16" %999, %983, %1007 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1036 = waveamd.mma "mfma.f32.32x32x16.bf16" %1000, %984, %1035 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1037 = waveamd.mma "mfma.f32.32x32x16.bf16" %1001, %985, %1036 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1038 = waveamd.mma "mfma.f32.32x32x16.bf16" %1002, %986, %1037 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1039 = waveamd.mma "mfma.f32.32x32x16.bf16" %1003, %987, %1038 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1040 = waveamd.mma "mfma.f32.32x32x16.bf16" %1004, %988, %1039 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1041 = waveamd.mma "mfma.f32.32x32x16.bf16" %1005, %989, %1040 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1042 = waveamd.mma "mfma.f32.32x32x16.bf16" %1006, %990, %1041 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1043 = waveamd.fragment_unpack %1042 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1044 = wave.binary muli %180, %102 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1045 = wave.splat %790 : i32 -> !wave.simd<i32, 64>
      %1046 = wave.binary addi %1044, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1047 = wave.binary xori %68, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1048 = wave.binary addi %1047, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1049 = wave.binary xori %103, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1050 = wave.binary addi %1049, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1051 = wave.binary xori %67, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1052 = wave.binary addi %1051, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1053 = wave.binary xori %101, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1054 = wave.binary addi %1053, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1055 = wave.binary xori %66, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1056 = wave.binary addi %1055, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1057 = wave.binary xori %65, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1058 = wave.binary addi %1057, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1059 = wave.binary xori %64, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1060 = wave.binary addi %1059, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1061 = wave.binary xori %100, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1062 = wave.binary addi %1061, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1063 = wave.binary xori %63, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1064 = wave.binary addi %1063, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1065 = wave.binary xori %62, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1066 = wave.binary addi %1065, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1067 = wave.binary xori %61, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1068 = wave.binary addi %1067, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1069 = wave.binary xori %60, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1070 = wave.binary addi %1069, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1071 = wave.binary xori %59, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1072 = wave.binary addi %1071, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1073 = wave.binary xori %58, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1074 = wave.binary addi %1073, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1075 = wave.binary xori %57, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1076 = wave.binary addi %1075, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1077 = wave.binary xori %98, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1078 = wave.binary addi %1077, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1079 = wave.binary xori %56, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1080 = wave.binary addi %1079, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1081 = wave.binary xori %55, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1082 = wave.binary addi %1081, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1083 = wave.binary xori %54, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1084 = wave.binary addi %1083, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1085 = wave.binary xori %53, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1086 = wave.binary addi %1085, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1087 = wave.binary xori %52, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1088 = wave.binary addi %1087, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1089 = wave.binary xori %51, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1090 = wave.binary addi %1089, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1091 = wave.binary xori %50, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1092 = wave.binary addi %1091, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1093 = wave.binary xori %96, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1094 = wave.binary addi %1093, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1095 = wave.binary xori %49, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1096 = wave.binary addi %1095, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1097 = wave.binary xori %48, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1098 = wave.binary addi %1097, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1099 = wave.binary xori %47, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1100 = wave.binary addi %1099, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1101 = wave.binary xori %46, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1102 = wave.binary addi %1101, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1103 = wave.binary xori %45, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1104 = wave.binary addi %1103, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1105 = wave.binary xori %44, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1106 = wave.binary addi %1105, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1107 = wave.binary xori %43, %1044 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1108 = wave.binary addi %1107, %1045 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1109 = wave.cmpi slt %1046, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1110 = wave.cmpi slt %1048, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1111 = wave.cmpi slt %1050, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1112 = wave.cmpi slt %1052, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1113 = wave.cmpi slt %1054, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1114 = wave.cmpi slt %1056, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1115 = wave.cmpi slt %1058, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1116 = wave.cmpi slt %1060, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1117 = wave.cmpi slt %1062, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1118 = wave.cmpi slt %1064, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1119 = wave.cmpi slt %1066, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1120 = wave.cmpi slt %1068, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1121 = wave.cmpi slt %1070, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1122 = wave.cmpi slt %1072, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1123 = wave.cmpi slt %1074, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1124 = wave.cmpi slt %1076, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1125 = wave.cmpi slt %1078, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1126 = wave.cmpi slt %1080, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1127 = wave.cmpi slt %1082, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1128 = wave.cmpi slt %1084, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1129 = wave.cmpi slt %1086, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1130 = wave.cmpi slt %1088, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1131 = wave.cmpi slt %1090, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1132 = wave.cmpi slt %1092, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1133 = wave.cmpi slt %1094, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1134 = wave.cmpi slt %1096, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1135 = wave.cmpi slt %1098, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1136 = wave.cmpi slt %1100, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1137 = wave.cmpi slt %1102, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1138 = wave.cmpi slt %1104, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1139 = wave.cmpi slt %1106, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1140 = wave.cmpi slt %1108, %176 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %1141 = wave.extract %1016[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1142 = wave.extract %1016[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1143 = wave.extract %1016[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1144 = wave.extract %1016[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1145 = wave.extract %1016[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1146 = wave.extract %1016[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1147 = wave.extract %1016[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1148 = wave.extract %1016[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1149 = wave.extract %1016[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1150 = wave.extract %1016[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1151 = wave.extract %1016[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1152 = wave.extract %1016[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1153 = wave.extract %1016[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1154 = wave.extract %1016[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1155 = wave.extract %1016[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1156 = wave.extract %1016[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1157 = wave.extract %1025[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1158 = wave.extract %1025[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1159 = wave.extract %1025[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1160 = wave.extract %1025[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1161 = wave.extract %1025[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1162 = wave.extract %1025[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1163 = wave.extract %1025[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1164 = wave.extract %1025[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1165 = wave.extract %1025[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1166 = wave.extract %1025[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1167 = wave.extract %1025[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1168 = wave.extract %1025[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1169 = wave.extract %1025[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1170 = wave.extract %1025[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1171 = wave.extract %1025[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1172 = wave.extract %1025[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1173 = wave.extract %1034[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1174 = wave.extract %1034[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1175 = wave.extract %1034[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1176 = wave.extract %1034[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1177 = wave.extract %1034[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1178 = wave.extract %1034[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1179 = wave.extract %1034[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1180 = wave.extract %1034[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1181 = wave.extract %1034[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1182 = wave.extract %1034[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1183 = wave.extract %1034[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1184 = wave.extract %1034[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1185 = wave.extract %1034[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1186 = wave.extract %1034[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1187 = wave.extract %1034[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1188 = wave.extract %1034[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1189 = wave.extract %1043[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1190 = wave.extract %1043[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1191 = wave.extract %1043[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1192 = wave.extract %1043[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1193 = wave.extract %1043[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1194 = wave.extract %1043[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1195 = wave.extract %1043[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1196 = wave.extract %1043[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1197 = wave.extract %1043[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1198 = wave.extract %1043[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1199 = wave.extract %1043[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1200 = wave.extract %1043[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1201 = wave.extract %1043[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1202 = wave.extract %1043[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1203 = wave.extract %1043[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1204 = wave.extract %1043[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1205 = wave.select %1109, %1141, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1206 = wave.select %1110, %1142, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1207 = wave.select %1111, %1143, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1208 = wave.select %1112, %1144, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1209 = wave.select %1113, %1145, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1210 = wave.select %1114, %1146, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1211 = wave.select %1115, %1147, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1212 = wave.select %1116, %1148, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1213 = wave.select %1117, %1149, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1214 = wave.select %1118, %1150, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1215 = wave.select %1119, %1151, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1216 = wave.select %1120, %1152, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1217 = wave.select %1121, %1153, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1218 = wave.select %1122, %1154, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1219 = wave.select %1123, %1155, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1220 = wave.select %1124, %1156, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1221 = wave.select %1125, %1157, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1222 = wave.select %1126, %1158, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1223 = wave.select %1127, %1159, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1224 = wave.select %1128, %1160, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1225 = wave.select %1129, %1161, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1226 = wave.select %1130, %1162, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1227 = wave.select %1131, %1163, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1228 = wave.select %1132, %1164, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1229 = wave.select %1133, %1165, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1230 = wave.select %1134, %1166, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1231 = wave.select %1135, %1167, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1232 = wave.select %1136, %1168, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1233 = wave.select %1137, %1169, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1234 = wave.select %1138, %1170, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1235 = wave.select %1139, %1171, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1236 = wave.select %1140, %1172, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1237 = wave.select %1109, %1173, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1238 = wave.select %1110, %1174, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1239 = wave.select %1111, %1175, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1240 = wave.select %1112, %1176, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1241 = wave.select %1113, %1177, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1242 = wave.select %1114, %1178, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1243 = wave.select %1115, %1179, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1244 = wave.select %1116, %1180, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1245 = wave.select %1117, %1181, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1246 = wave.select %1118, %1182, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1247 = wave.select %1119, %1183, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1248 = wave.select %1120, %1184, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1249 = wave.select %1121, %1185, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1250 = wave.select %1122, %1186, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1251 = wave.select %1123, %1187, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1252 = wave.select %1124, %1188, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1253 = wave.select %1125, %1189, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1254 = wave.select %1126, %1190, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1255 = wave.select %1127, %1191, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1256 = wave.select %1128, %1192, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1257 = wave.select %1129, %1193, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1258 = wave.select %1130, %1194, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1259 = wave.select %1131, %1195, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1260 = wave.select %1132, %1196, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1261 = wave.select %1133, %1197, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1262 = wave.select %1134, %1198, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1263 = wave.select %1135, %1199, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1264 = wave.select %1136, %1200, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1265 = wave.select %1137, %1201, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1266 = wave.select %1138, %1202, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1267 = wave.select %1139, %1203, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1268 = wave.select %1140, %1204, %108 : !wave.mask<64>, !wave.simd<f32, 64>
      %1269 = wave.lane_id : !wave.simd<i32, 64>
      %1270 = wave.fmax %1205, %1206 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1271 = wave.fmax %1207, %1208 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1272 = wave.fmax %1209, %1210 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1273 = wave.fmax %1211, %1212 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1274 = wave.fmax %1213, %1214 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1275 = wave.fmax %1215, %1216 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1276 = wave.fmax %1217, %1218 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1277 = wave.fmax %1219, %1220 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1278 = wave.fmax %1221, %1222 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1279 = wave.fmax %1223, %1224 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1280 = wave.fmax %1225, %1226 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1281 = wave.fmax %1227, %1228 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1282 = wave.fmax %1229, %1230 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1283 = wave.fmax %1231, %1232 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1284 = wave.fmax %1233, %1234 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1285 = wave.fmax %1235, %1236 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1286 = wave.fmax %1270, %1271 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1287 = wave.fmax %1272, %1273 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1288 = wave.fmax %1274, %1275 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1289 = wave.fmax %1276, %1277 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1290 = wave.fmax %1278, %1279 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1291 = wave.fmax %1280, %1281 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1292 = wave.fmax %1282, %1283 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1293 = wave.fmax %1284, %1285 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1294 = wave.fmax %1286, %1287 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1295 = wave.fmax %1288, %1289 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1296 = wave.fmax %1290, %1291 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1297 = wave.fmax %1292, %1293 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1298 = wave.fmax %1294, %1295 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1299 = wave.fmax %1296, %1297 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1300 = wave.fmax %1298, %1299 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1301 = wave.index_expr <"Mod(wi, 2) + 16*Mod(floor(1/16*wi), 2) + 8*Mod(floor(1/8*wi), 2) + 4*Mod(floor(1/4*wi), 2) + 2*Mod(floor(1/2*wi), 2)"> ["wi"](%1269) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1302 = wave.shuffle %1300 from %1301 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1303 = wave.index_expr <"xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(32 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2)))))"> ["wi"](%1269) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1304 = wave.shuffle %1300 from %1303 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1305 = wave.fmax %1302, %1304 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1306 = wave.fmax %1237, %1238 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1307 = wave.fmax %1239, %1240 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1308 = wave.fmax %1241, %1242 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1309 = wave.fmax %1243, %1244 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1310 = wave.fmax %1245, %1246 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1311 = wave.fmax %1247, %1248 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1312 = wave.fmax %1249, %1250 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1313 = wave.fmax %1251, %1252 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1314 = wave.fmax %1253, %1254 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1315 = wave.fmax %1255, %1256 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1316 = wave.fmax %1257, %1258 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1317 = wave.fmax %1259, %1260 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1318 = wave.fmax %1261, %1262 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1319 = wave.fmax %1263, %1264 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1320 = wave.fmax %1265, %1266 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1321 = wave.fmax %1267, %1268 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1322 = wave.fmax %1306, %1307 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1323 = wave.fmax %1308, %1309 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1324 = wave.fmax %1310, %1311 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1325 = wave.fmax %1312, %1313 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1326 = wave.fmax %1314, %1315 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1327 = wave.fmax %1316, %1317 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1328 = wave.fmax %1318, %1319 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1329 = wave.fmax %1320, %1321 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1330 = wave.fmax %1322, %1323 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1331 = wave.fmax %1324, %1325 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1332 = wave.fmax %1326, %1327 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1333 = wave.fmax %1328, %1329 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1334 = wave.fmax %1330, %1331 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1335 = wave.fmax %1332, %1333 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1336 = wave.fmax %1334, %1335 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1337 = wave.shuffle %1336 from %1301 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1338 = wave.shuffle %1336 from %1303 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1339 = wave.fmax %1337, %1338 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1340 = wave.fmul %1305, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1341 = wave.fmul %1339, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1342 = wave.fmax %791#0, %1340 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1343 = wave.fmax %791#1, %1341 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1344 = wave.fmul %1205, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1345 = wave.fmul %1206, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1346 = wave.fmul %1207, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1347 = wave.fmul %1208, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1348 = wave.fmul %1209, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1349 = wave.fmul %1210, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1350 = wave.fmul %1211, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1351 = wave.fmul %1212, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1352 = wave.fmul %1213, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1353 = wave.fmul %1214, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1354 = wave.fmul %1215, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1355 = wave.fmul %1216, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1356 = wave.fmul %1217, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1357 = wave.fmul %1218, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1358 = wave.fmul %1219, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1359 = wave.fmul %1220, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1360 = wave.fmul %1221, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1361 = wave.fmul %1222, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1362 = wave.fmul %1223, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1363 = wave.fmul %1224, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1364 = wave.fmul %1225, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1365 = wave.fmul %1226, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1366 = wave.fmul %1227, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1367 = wave.fmul %1228, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1368 = wave.fmul %1229, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1369 = wave.fmul %1230, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1370 = wave.fmul %1231, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1371 = wave.fmul %1232, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1372 = wave.fmul %1233, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1373 = wave.fmul %1234, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1374 = wave.fmul %1235, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1375 = wave.fmul %1236, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1376 = wave.fmul %1237, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1377 = wave.fmul %1238, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1378 = wave.fmul %1239, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1379 = wave.fmul %1240, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1380 = wave.fmul %1241, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1381 = wave.fmul %1242, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1382 = wave.fmul %1243, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1383 = wave.fmul %1244, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1384 = wave.fmul %1245, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1385 = wave.fmul %1246, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1386 = wave.fmul %1247, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1387 = wave.fmul %1248, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1388 = wave.fmul %1249, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1389 = wave.fmul %1250, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1390 = wave.fmul %1251, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1391 = wave.fmul %1252, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1392 = wave.fmul %1253, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1393 = wave.fmul %1254, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1394 = wave.fmul %1255, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1395 = wave.fmul %1256, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1396 = wave.fmul %1257, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1397 = wave.fmul %1258, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1398 = wave.fmul %1259, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1399 = wave.fmul %1260, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1400 = wave.fmul %1261, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1401 = wave.fmul %1262, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1402 = wave.fmul %1263, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1403 = wave.fmul %1264, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1404 = wave.fmul %1265, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1405 = wave.fmul %1266, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1406 = wave.fmul %1267, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1407 = wave.fmul %1268, %107 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1408 = wave.fsub %1344, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1409 = wave.fsub %1345, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1410 = wave.fsub %1346, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1411 = wave.fsub %1347, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1412 = wave.fsub %1348, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1413 = wave.fsub %1349, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1414 = wave.fsub %1350, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1415 = wave.fsub %1351, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1416 = wave.fsub %1352, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1417 = wave.fsub %1353, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1418 = wave.fsub %1354, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1419 = wave.fsub %1355, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1420 = wave.fsub %1356, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1421 = wave.fsub %1357, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1422 = wave.fsub %1358, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1423 = wave.fsub %1359, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1424 = wave.fsub %1360, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1425 = wave.fsub %1361, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1426 = wave.fsub %1362, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1427 = wave.fsub %1363, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1428 = wave.fsub %1364, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1429 = wave.fsub %1365, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1430 = wave.fsub %1366, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1431 = wave.fsub %1367, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1432 = wave.fsub %1368, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1433 = wave.fsub %1369, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1434 = wave.fsub %1370, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1435 = wave.fsub %1371, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1436 = wave.fsub %1372, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1437 = wave.fsub %1373, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1438 = wave.fsub %1374, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1439 = wave.fsub %1375, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1440 = wave.fsub %1376, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1441 = wave.fsub %1377, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1442 = wave.fsub %1378, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1443 = wave.fsub %1379, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1444 = wave.fsub %1380, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1445 = wave.fsub %1381, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1446 = wave.fsub %1382, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1447 = wave.fsub %1383, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1448 = wave.fsub %1384, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1449 = wave.fsub %1385, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1450 = wave.fsub %1386, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1451 = wave.fsub %1387, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1452 = wave.fsub %1388, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1453 = wave.fsub %1389, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1454 = wave.fsub %1390, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1455 = wave.fsub %1391, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1456 = wave.fsub %1392, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1457 = wave.fsub %1393, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1458 = wave.fsub %1394, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1459 = wave.fsub %1395, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1460 = wave.fsub %1396, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1461 = wave.fsub %1397, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1462 = wave.fsub %1398, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1463 = wave.fsub %1399, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1464 = wave.fsub %1400, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1465 = wave.fsub %1401, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1466 = wave.fsub %1402, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1467 = wave.fsub %1403, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1468 = wave.fsub %1404, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1469 = wave.fsub %1405, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1470 = wave.fsub %1406, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1471 = wave.fsub %1407, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1472 = wave.fexp2 %1408 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1473 = wave.fexp2 %1409 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1474 = wave.fexp2 %1410 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1475 = wave.fexp2 %1411 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1476 = wave.fexp2 %1412 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1477 = wave.fexp2 %1413 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1478 = wave.fexp2 %1414 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1479 = wave.fexp2 %1415 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1480 = wave.fexp2 %1416 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1481 = wave.fexp2 %1417 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1482 = wave.fexp2 %1418 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1483 = wave.fexp2 %1419 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1484 = wave.fexp2 %1420 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1485 = wave.fexp2 %1421 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1486 = wave.fexp2 %1422 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1487 = wave.fexp2 %1423 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1488 = wave.pack %1472, %1473, %1474, %1475, %1476, %1477, %1478, %1479, %1480, %1481, %1482, %1483, %1484, %1485, %1486, %1487 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1489 = wave.fexp2 %1424 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1490 = wave.fexp2 %1425 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1491 = wave.fexp2 %1426 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1492 = wave.fexp2 %1427 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1493 = wave.fexp2 %1428 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1494 = wave.fexp2 %1429 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1495 = wave.fexp2 %1430 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1496 = wave.fexp2 %1431 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1497 = wave.fexp2 %1432 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1498 = wave.fexp2 %1433 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1499 = wave.fexp2 %1434 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1500 = wave.fexp2 %1435 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1501 = wave.fexp2 %1436 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1502 = wave.fexp2 %1437 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1503 = wave.fexp2 %1438 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1504 = wave.fexp2 %1439 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1505 = wave.pack %1489, %1490, %1491, %1492, %1493, %1494, %1495, %1496, %1497, %1498, %1499, %1500, %1501, %1502, %1503, %1504 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1506 = wave.fexp2 %1440 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1507 = wave.fexp2 %1441 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1508 = wave.fexp2 %1442 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1509 = wave.fexp2 %1443 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1510 = wave.fexp2 %1444 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1511 = wave.fexp2 %1445 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1512 = wave.fexp2 %1446 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1513 = wave.fexp2 %1447 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1514 = wave.fexp2 %1448 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1515 = wave.fexp2 %1449 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1516 = wave.fexp2 %1450 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1517 = wave.fexp2 %1451 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1518 = wave.fexp2 %1452 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1519 = wave.fexp2 %1453 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1520 = wave.fexp2 %1454 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1521 = wave.fexp2 %1455 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1522 = wave.pack %1506, %1507, %1508, %1509, %1510, %1511, %1512, %1513, %1514, %1515, %1516, %1517, %1518, %1519, %1520, %1521 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1523 = wave.fexp2 %1456 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1524 = wave.fexp2 %1457 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1525 = wave.fexp2 %1458 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1526 = wave.fexp2 %1459 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1527 = wave.fexp2 %1460 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1528 = wave.fexp2 %1461 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1529 = wave.fexp2 %1462 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1530 = wave.fexp2 %1463 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1531 = wave.fexp2 %1464 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1532 = wave.fexp2 %1465 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1533 = wave.fexp2 %1466 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1534 = wave.fexp2 %1467 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1535 = wave.fexp2 %1468 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1536 = wave.fexp2 %1469 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1537 = wave.fexp2 %1470 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1538 = wave.fexp2 %1471 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1539 = wave.pack %1523, %1524, %1525, %1526, %1527, %1528, %1529, %1530, %1531, %1532, %1533, %1534, %1535, %1536, %1537, %1538 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1540 = wave.fadd %1472, %1473 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1541 = wave.fadd %1474, %1475 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1542 = wave.fadd %1476, %1477 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1543 = wave.fadd %1478, %1479 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1544 = wave.fadd %1480, %1481 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1545 = wave.fadd %1482, %1483 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1546 = wave.fadd %1484, %1485 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1547 = wave.fadd %1486, %1487 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1548 = wave.fadd %1489, %1490 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1549 = wave.fadd %1491, %1492 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1550 = wave.fadd %1493, %1494 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1551 = wave.fadd %1495, %1496 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1552 = wave.fadd %1497, %1498 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1553 = wave.fadd %1499, %1500 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1554 = wave.fadd %1501, %1502 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1555 = wave.fadd %1503, %1504 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1556 = wave.fadd %1540, %1541 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1557 = wave.fadd %1542, %1543 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1558 = wave.fadd %1544, %1545 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1559 = wave.fadd %1546, %1547 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1560 = wave.fadd %1548, %1549 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1561 = wave.fadd %1550, %1551 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1562 = wave.fadd %1552, %1553 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1563 = wave.fadd %1554, %1555 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1564 = wave.fadd %1556, %1557 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1565 = wave.fadd %1558, %1559 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1566 = wave.fadd %1560, %1561 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1567 = wave.fadd %1562, %1563 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1568 = wave.fadd %1564, %1565 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1569 = wave.fadd %1566, %1567 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1570 = wave.fadd %1568, %1569 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1571 = wave.shuffle %1570 from %1301 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1572 = wave.shuffle %1570 from %1303 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1573 = wave.fadd %1571, %1572 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1574 = wave.fadd %1506, %1507 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1575 = wave.fadd %1508, %1509 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1576 = wave.fadd %1510, %1511 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1577 = wave.fadd %1512, %1513 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1578 = wave.fadd %1514, %1515 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1579 = wave.fadd %1516, %1517 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1580 = wave.fadd %1518, %1519 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1581 = wave.fadd %1520, %1521 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1582 = wave.fadd %1523, %1524 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1583 = wave.fadd %1525, %1526 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1584 = wave.fadd %1527, %1528 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1585 = wave.fadd %1529, %1530 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1586 = wave.fadd %1531, %1532 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1587 = wave.fadd %1533, %1534 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1588 = wave.fadd %1535, %1536 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1589 = wave.fadd %1537, %1538 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1590 = wave.fadd %1574, %1575 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1591 = wave.fadd %1576, %1577 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1592 = wave.fadd %1578, %1579 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1593 = wave.fadd %1580, %1581 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1594 = wave.fadd %1582, %1583 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1595 = wave.fadd %1584, %1585 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1596 = wave.fadd %1586, %1587 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1597 = wave.fadd %1588, %1589 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1598 = wave.fadd %1590, %1591 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1599 = wave.fadd %1592, %1593 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1600 = wave.fadd %1594, %1595 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1601 = wave.fadd %1596, %1597 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1602 = wave.fadd %1598, %1599 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1603 = wave.fadd %1600, %1601 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1604 = wave.fadd %1602, %1603 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1605 = wave.shuffle %1604 from %1301 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1606 = wave.shuffle %1604 from %1303 : !wave.simd<f32, 64>, !wave.simd<index, 64> -> !wave.simd<f32, 64>
      %1607 = wave.fadd %1605, %1606 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1608 = wave.fsub %791#0, %1342 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1609 = wave.fsub %791#1, %1343 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1610 = wave.fexp2 %1608 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1611 = wave.fexp2 %1609 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1612 = wave.extract %791#4[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1613 = wave.fmul %1612, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1614 = wave.extract %791#4[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1615 = wave.fmul %1614, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1616 = wave.extract %791#4[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1617 = wave.fmul %1616, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1618 = wave.extract %791#4[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1619 = wave.fmul %1618, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1620 = wave.extract %791#4[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1621 = wave.fmul %1620, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1622 = wave.extract %791#4[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1623 = wave.fmul %1622, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1624 = wave.extract %791#4[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1625 = wave.fmul %1624, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1626 = wave.extract %791#4[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1627 = wave.fmul %1626, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1628 = wave.extract %791#4[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1629 = wave.fmul %1628, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1630 = wave.extract %791#4[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1631 = wave.fmul %1630, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1632 = wave.extract %791#4[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1633 = wave.fmul %1632, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1634 = wave.extract %791#4[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1635 = wave.fmul %1634, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1636 = wave.extract %791#4[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1637 = wave.fmul %1636, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1638 = wave.extract %791#4[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1639 = wave.fmul %1638, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1640 = wave.extract %791#4[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1641 = wave.fmul %1640, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1642 = wave.extract %791#4[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1643 = wave.fmul %1642, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1644 = wave.pack %1613, %1615, %1617, %1619, %1621, %1623, %1625, %1627, %1629, %1631, %1633, %1635, %1637, %1639, %1641, %1643 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1645 = wave.extract %791#5[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1646 = wave.fmul %1645, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1647 = wave.extract %791#5[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1648 = wave.fmul %1647, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1649 = wave.extract %791#5[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1650 = wave.fmul %1649, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1651 = wave.extract %791#5[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1652 = wave.fmul %1651, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1653 = wave.extract %791#5[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1654 = wave.fmul %1653, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1655 = wave.extract %791#5[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1656 = wave.fmul %1655, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1657 = wave.extract %791#5[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1658 = wave.fmul %1657, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1659 = wave.extract %791#5[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1660 = wave.fmul %1659, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1661 = wave.extract %791#5[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1662 = wave.fmul %1661, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1663 = wave.extract %791#5[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1664 = wave.fmul %1663, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1665 = wave.extract %791#5[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1666 = wave.fmul %1665, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1667 = wave.extract %791#5[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1668 = wave.fmul %1667, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1669 = wave.extract %791#5[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1670 = wave.fmul %1669, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1671 = wave.extract %791#5[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1672 = wave.fmul %1671, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1673 = wave.extract %791#5[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1674 = wave.fmul %1673, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1675 = wave.extract %791#5[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1676 = wave.fmul %1675, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1677 = wave.pack %1646, %1648, %1650, %1652, %1654, %1656, %1658, %1660, %1662, %1664, %1666, %1668, %1670, %1672, %1674, %1676 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1678 = wave.extract %791#6[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1679 = wave.fmul %1678, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1680 = wave.extract %791#6[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1681 = wave.fmul %1680, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1682 = wave.extract %791#6[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1683 = wave.fmul %1682, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1684 = wave.extract %791#6[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1685 = wave.fmul %1684, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1686 = wave.extract %791#6[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1687 = wave.fmul %1686, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1688 = wave.extract %791#6[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1689 = wave.fmul %1688, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1690 = wave.extract %791#6[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1691 = wave.fmul %1690, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1692 = wave.extract %791#6[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1693 = wave.fmul %1692, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1694 = wave.extract %791#6[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1695 = wave.fmul %1694, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1696 = wave.extract %791#6[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1697 = wave.fmul %1696, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1698 = wave.extract %791#6[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1699 = wave.fmul %1698, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1700 = wave.extract %791#6[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1701 = wave.fmul %1700, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1702 = wave.extract %791#6[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1703 = wave.fmul %1702, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1704 = wave.extract %791#6[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1705 = wave.fmul %1704, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1706 = wave.extract %791#6[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1707 = wave.fmul %1706, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1708 = wave.extract %791#6[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1709 = wave.fmul %1708, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1710 = wave.pack %1679, %1681, %1683, %1685, %1687, %1689, %1691, %1693, %1695, %1697, %1699, %1701, %1703, %1705, %1707, %1709 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1711 = wave.extract %791#7[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1712 = wave.fmul %1711, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1713 = wave.extract %791#7[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1714 = wave.fmul %1713, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1715 = wave.extract %791#7[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1716 = wave.fmul %1715, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1717 = wave.extract %791#7[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1718 = wave.fmul %1717, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1719 = wave.extract %791#7[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1720 = wave.fmul %1719, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1721 = wave.extract %791#7[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1722 = wave.fmul %1721, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1723 = wave.extract %791#7[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1724 = wave.fmul %1723, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1725 = wave.extract %791#7[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1726 = wave.fmul %1725, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1727 = wave.extract %791#7[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1728 = wave.fmul %1727, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1729 = wave.extract %791#7[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1730 = wave.fmul %1729, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1731 = wave.extract %791#7[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1732 = wave.fmul %1731, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1733 = wave.extract %791#7[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1734 = wave.fmul %1733, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1735 = wave.extract %791#7[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1736 = wave.fmul %1735, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1737 = wave.extract %791#7[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1738 = wave.fmul %1737, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1739 = wave.extract %791#7[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1740 = wave.fmul %1739, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1741 = wave.extract %791#7[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1742 = wave.fmul %1741, %1610 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1743 = wave.pack %1712, %1714, %1716, %1718, %1720, %1722, %1724, %1726, %1728, %1730, %1732, %1734, %1736, %1738, %1740, %1742 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1744 = wave.extract %791#8[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1745 = wave.fmul %1744, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1746 = wave.extract %791#8[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1747 = wave.fmul %1746, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1748 = wave.extract %791#8[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1749 = wave.fmul %1748, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1750 = wave.extract %791#8[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1751 = wave.fmul %1750, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1752 = wave.extract %791#8[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1753 = wave.fmul %1752, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1754 = wave.extract %791#8[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1755 = wave.fmul %1754, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1756 = wave.extract %791#8[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1757 = wave.fmul %1756, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1758 = wave.extract %791#8[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1759 = wave.fmul %1758, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1760 = wave.extract %791#8[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1761 = wave.fmul %1760, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1762 = wave.extract %791#8[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1763 = wave.fmul %1762, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1764 = wave.extract %791#8[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1765 = wave.fmul %1764, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1766 = wave.extract %791#8[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1767 = wave.fmul %1766, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1768 = wave.extract %791#8[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1769 = wave.fmul %1768, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1770 = wave.extract %791#8[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1771 = wave.fmul %1770, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1772 = wave.extract %791#8[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1773 = wave.fmul %1772, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1774 = wave.extract %791#8[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1775 = wave.fmul %1774, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1776 = wave.pack %1745, %1747, %1749, %1751, %1753, %1755, %1757, %1759, %1761, %1763, %1765, %1767, %1769, %1771, %1773, %1775 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1777 = wave.extract %791#9[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1778 = wave.fmul %1777, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1779 = wave.extract %791#9[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1780 = wave.fmul %1779, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1781 = wave.extract %791#9[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1782 = wave.fmul %1781, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1783 = wave.extract %791#9[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1784 = wave.fmul %1783, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1785 = wave.extract %791#9[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1786 = wave.fmul %1785, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1787 = wave.extract %791#9[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1788 = wave.fmul %1787, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1789 = wave.extract %791#9[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1790 = wave.fmul %1789, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1791 = wave.extract %791#9[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1792 = wave.fmul %1791, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1793 = wave.extract %791#9[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1794 = wave.fmul %1793, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1795 = wave.extract %791#9[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1796 = wave.fmul %1795, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1797 = wave.extract %791#9[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1798 = wave.fmul %1797, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1799 = wave.extract %791#9[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1800 = wave.fmul %1799, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1801 = wave.extract %791#9[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1802 = wave.fmul %1801, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1803 = wave.extract %791#9[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1804 = wave.fmul %1803, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1805 = wave.extract %791#9[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1806 = wave.fmul %1805, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1807 = wave.extract %791#9[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1808 = wave.fmul %1807, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1809 = wave.pack %1778, %1780, %1782, %1784, %1786, %1788, %1790, %1792, %1794, %1796, %1798, %1800, %1802, %1804, %1806, %1808 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1810 = wave.extract %791#10[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1811 = wave.fmul %1810, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1812 = wave.extract %791#10[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1813 = wave.fmul %1812, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1814 = wave.extract %791#10[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1815 = wave.fmul %1814, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1816 = wave.extract %791#10[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1817 = wave.fmul %1816, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1818 = wave.extract %791#10[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1819 = wave.fmul %1818, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1820 = wave.extract %791#10[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1821 = wave.fmul %1820, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1822 = wave.extract %791#10[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1823 = wave.fmul %1822, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1824 = wave.extract %791#10[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1825 = wave.fmul %1824, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1826 = wave.extract %791#10[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1827 = wave.fmul %1826, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1828 = wave.extract %791#10[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1829 = wave.fmul %1828, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1830 = wave.extract %791#10[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1831 = wave.fmul %1830, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1832 = wave.extract %791#10[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1833 = wave.fmul %1832, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1834 = wave.extract %791#10[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1835 = wave.fmul %1834, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1836 = wave.extract %791#10[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1837 = wave.fmul %1836, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1838 = wave.extract %791#10[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1839 = wave.fmul %1838, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1840 = wave.extract %791#10[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1841 = wave.fmul %1840, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1842 = wave.pack %1811, %1813, %1815, %1817, %1819, %1821, %1823, %1825, %1827, %1829, %1831, %1833, %1835, %1837, %1839, %1841 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1843 = wave.extract %791#11[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1844 = wave.fmul %1843, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1845 = wave.extract %791#11[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1846 = wave.fmul %1845, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1847 = wave.extract %791#11[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1848 = wave.fmul %1847, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1849 = wave.extract %791#11[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1850 = wave.fmul %1849, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1851 = wave.extract %791#11[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1852 = wave.fmul %1851, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1853 = wave.extract %791#11[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1854 = wave.fmul %1853, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1855 = wave.extract %791#11[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1856 = wave.fmul %1855, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1857 = wave.extract %791#11[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1858 = wave.fmul %1857, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1859 = wave.extract %791#11[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1860 = wave.fmul %1859, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1861 = wave.extract %791#11[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1862 = wave.fmul %1861, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1863 = wave.extract %791#11[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1864 = wave.fmul %1863, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1865 = wave.extract %791#11[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1866 = wave.fmul %1865, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1867 = wave.extract %791#11[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1868 = wave.fmul %1867, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1869 = wave.extract %791#11[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1870 = wave.fmul %1869, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1871 = wave.extract %791#11[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1872 = wave.fmul %1871, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1873 = wave.extract %791#11[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1874 = wave.fmul %1873, %1611 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1875 = wave.pack %1844, %1846, %1848, %1850, %1852, %1854, %1856, %1858, %1860, %1862, %1864, %1866, %1868, %1870, %1872, %1874 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1876 = wave.fma %791#2, %1610, %1573 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1877 = wave.fma %791#3, %1611, %1607 fastmath<contract> : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1878 = wave.cast fpconvert %1488 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1879 = wave.cast fpconvert %1505 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1880 = wave.cast fpconvert %1522 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1881 = wave.cast fpconvert %1539 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %1882 = wave.pack %1878, %1879, %1880, %1881 : !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<64xbf16>, 64>
      %1883 = wave.redistribute %1882, <blocks = 1, items = 256, source_block = "0", source_item = "64*xor(2*Mod(floor(1/128*item), 2), Mod(floor(1/64*item), 2)) + xor(16*Mod(floor(1/16*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(2*Mod(floor(1/2*Mod(item, 64)), 2), xor(32*Mod(floor(1/4*slot), 2), Mod(Mod(item, 64), 2))))))", source_slot = "xor(4*Mod(floor(1/32*Mod(item, 64)), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(8*Mod(floor(1/8*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2))))))"> : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<64xbf16>, 64>
      %1884 = wave.extract %1883[0] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1885 = wave.extract %1883[8] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1886 = wave.extract %1883[16] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1887 = wave.extract %1883[24] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1888 = wave.extract %1883[32] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1889 = wave.extract %1883[40] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1890 = wave.extract %1883[48] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1891 = wave.extract %1883[56] : !wave.simd<vector<64xbf16>, 64> -> !wave.simd<vector<8xbf16>, 64>
      %1892 = waveamd.fragment_pack %1884 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1893 = waveamd.fragment_pack %1885 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1894 = waveamd.fragment_pack %1886 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1895 = waveamd.fragment_pack %1887 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1896 = waveamd.fragment_pack %1888 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1897 = waveamd.fragment_pack %1889 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1898 = waveamd.fragment_pack %1890 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1899 = waveamd.fragment_pack %1891 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<1, bf16, 32, 32, 64, 4>
      %1900 = waveamd.fragment_pack %839 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1901 = waveamd.fragment_pack %848 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1902 = waveamd.fragment_pack %857 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1903 = waveamd.fragment_pack %866 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1904 = waveamd.fragment_pack %875 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1905 = waveamd.fragment_pack %884 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1906 = waveamd.fragment_pack %893 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1907 = waveamd.fragment_pack %902 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1908 = waveamd.fragment_pack %911 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1909 = waveamd.fragment_pack %920 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1910 = waveamd.fragment_pack %929 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1911 = waveamd.fragment_pack %938 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1912 = waveamd.fragment_pack %947 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1913 = waveamd.fragment_pack %956 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1914 = waveamd.fragment_pack %965 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1915 = waveamd.fragment_pack %974 : !wave.simd<vector<8xbf16>, 64> -> !waveamd.fragment<0, bf16, 32, 32, 64, 4>
      %1916 = waveamd.fragment_pack %1644 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1917 = waveamd.fragment_pack %1677 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1918 = waveamd.fragment_pack %1710 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1919 = waveamd.fragment_pack %1743 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1920 = waveamd.fragment_pack %1776 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1921 = waveamd.fragment_pack %1809 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1922 = waveamd.fragment_pack %1842 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1923 = waveamd.fragment_pack %1875 : !wave.simd<vector<16xf32>, 64> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1924 = waveamd.mma "mfma.f32.32x32x16.bf16" %1900, %1892, %1916 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1925 = waveamd.mma "mfma.f32.32x32x16.bf16" %1901, %1893, %1924 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1926 = waveamd.mma "mfma.f32.32x32x16.bf16" %1902, %1894, %1925 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1927 = waveamd.mma "mfma.f32.32x32x16.bf16" %1903, %1895, %1926 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1928 = waveamd.fragment_unpack %1927 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1929 = waveamd.mma "mfma.f32.32x32x16.bf16" %1904, %1892, %1917 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1930 = waveamd.mma "mfma.f32.32x32x16.bf16" %1905, %1893, %1929 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1931 = waveamd.mma "mfma.f32.32x32x16.bf16" %1906, %1894, %1930 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1932 = waveamd.mma "mfma.f32.32x32x16.bf16" %1907, %1895, %1931 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1933 = waveamd.fragment_unpack %1932 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1934 = waveamd.mma "mfma.f32.32x32x16.bf16" %1908, %1892, %1918 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1935 = waveamd.mma "mfma.f32.32x32x16.bf16" %1909, %1893, %1934 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1936 = waveamd.mma "mfma.f32.32x32x16.bf16" %1910, %1894, %1935 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1937 = waveamd.mma "mfma.f32.32x32x16.bf16" %1911, %1895, %1936 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1938 = waveamd.fragment_unpack %1937 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1939 = waveamd.mma "mfma.f32.32x32x16.bf16" %1912, %1892, %1919 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1940 = waveamd.mma "mfma.f32.32x32x16.bf16" %1913, %1893, %1939 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1941 = waveamd.mma "mfma.f32.32x32x16.bf16" %1914, %1894, %1940 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1942 = waveamd.mma "mfma.f32.32x32x16.bf16" %1915, %1895, %1941 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1943 = waveamd.fragment_unpack %1942 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1944 = waveamd.mma "mfma.f32.32x32x16.bf16" %1900, %1896, %1920 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1945 = waveamd.mma "mfma.f32.32x32x16.bf16" %1901, %1897, %1944 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1946 = waveamd.mma "mfma.f32.32x32x16.bf16" %1902, %1898, %1945 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1947 = waveamd.mma "mfma.f32.32x32x16.bf16" %1903, %1899, %1946 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1948 = waveamd.fragment_unpack %1947 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1949 = waveamd.mma "mfma.f32.32x32x16.bf16" %1904, %1896, %1921 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1950 = waveamd.mma "mfma.f32.32x32x16.bf16" %1905, %1897, %1949 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1951 = waveamd.mma "mfma.f32.32x32x16.bf16" %1906, %1898, %1950 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1952 = waveamd.mma "mfma.f32.32x32x16.bf16" %1907, %1899, %1951 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1953 = waveamd.fragment_unpack %1952 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1954 = waveamd.mma "mfma.f32.32x32x16.bf16" %1908, %1896, %1922 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1955 = waveamd.mma "mfma.f32.32x32x16.bf16" %1909, %1897, %1954 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1956 = waveamd.mma "mfma.f32.32x32x16.bf16" %1910, %1898, %1955 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1957 = waveamd.mma "mfma.f32.32x32x16.bf16" %1911, %1899, %1956 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1958 = waveamd.fragment_unpack %1957 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1959 = waveamd.mma "mfma.f32.32x32x16.bf16" %1912, %1896, %1923 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1960 = waveamd.mma "mfma.f32.32x32x16.bf16" %1913, %1897, %1959 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1961 = waveamd.mma "mfma.f32.32x32x16.bf16" %1914, %1898, %1960 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1962 = waveamd.mma "mfma.f32.32x32x16.bf16" %1915, %1899, %1961 : !waveamd.fragment<0, bf16, 32, 32, 64, 4>, !waveamd.fragment<1, bf16, 32, 32, 64, 4>, !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !waveamd.fragment<2, f32, 32, 32, 64, 16>
      %1963 = waveamd.fragment_unpack %1962 : !waveamd.fragment<2, f32, 32, 32, 64, 16> -> !wave.simd<vector<16xf32>, 64>
      %1964 = wave.extract %1928[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1965 = wave.frcp %1876 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1966 = wave.fmul %1964, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1967 = wave.extract %1928[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1968 = wave.fmul %1967, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1969 = wave.extract %1928[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1970 = wave.fmul %1969, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1971 = wave.extract %1928[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1972 = wave.fmul %1971, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1973 = wave.extract %1928[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1974 = wave.fmul %1973, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1975 = wave.extract %1928[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1976 = wave.fmul %1975, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1977 = wave.extract %1928[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1978 = wave.fmul %1977, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1979 = wave.extract %1928[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1980 = wave.fmul %1979, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1981 = wave.extract %1928[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1982 = wave.fmul %1981, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1983 = wave.extract %1928[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1984 = wave.fmul %1983, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1985 = wave.extract %1928[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1986 = wave.fmul %1985, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1987 = wave.extract %1928[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1988 = wave.fmul %1987, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1989 = wave.extract %1928[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1990 = wave.fmul %1989, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1991 = wave.extract %1928[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1992 = wave.fmul %1991, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1993 = wave.extract %1928[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1994 = wave.fmul %1993, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1995 = wave.extract %1928[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1996 = wave.fmul %1995, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %1997 = wave.pack %1966, %1968, %1970, %1972, %1974, %1976, %1978, %1980, %1982, %1984, %1986, %1988, %1990, %1992, %1994, %1996 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %1998 = wave.extract %1933[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %1999 = wave.fmul %1998, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2000 = wave.extract %1933[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2001 = wave.fmul %2000, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2002 = wave.extract %1933[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2003 = wave.fmul %2002, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2004 = wave.extract %1933[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2005 = wave.fmul %2004, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2006 = wave.extract %1933[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2007 = wave.fmul %2006, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2008 = wave.extract %1933[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2009 = wave.fmul %2008, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2010 = wave.extract %1933[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2011 = wave.fmul %2010, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2012 = wave.extract %1933[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2013 = wave.fmul %2012, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2014 = wave.extract %1933[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2015 = wave.fmul %2014, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2016 = wave.extract %1933[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2017 = wave.fmul %2016, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2018 = wave.extract %1933[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2019 = wave.fmul %2018, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2020 = wave.extract %1933[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2021 = wave.fmul %2020, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2022 = wave.extract %1933[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2023 = wave.fmul %2022, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2024 = wave.extract %1933[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2025 = wave.fmul %2024, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2026 = wave.extract %1933[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2027 = wave.fmul %2026, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2028 = wave.extract %1933[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2029 = wave.fmul %2028, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2030 = wave.pack %1999, %2001, %2003, %2005, %2007, %2009, %2011, %2013, %2015, %2017, %2019, %2021, %2023, %2025, %2027, %2029 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2031 = wave.extract %1938[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2032 = wave.fmul %2031, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2033 = wave.extract %1938[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2034 = wave.fmul %2033, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2035 = wave.extract %1938[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2036 = wave.fmul %2035, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2037 = wave.extract %1938[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2038 = wave.fmul %2037, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2039 = wave.extract %1938[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2040 = wave.fmul %2039, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2041 = wave.extract %1938[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2042 = wave.fmul %2041, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2043 = wave.extract %1938[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2044 = wave.fmul %2043, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2045 = wave.extract %1938[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2046 = wave.fmul %2045, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2047 = wave.extract %1938[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2048 = wave.fmul %2047, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2049 = wave.extract %1938[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2050 = wave.fmul %2049, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2051 = wave.extract %1938[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2052 = wave.fmul %2051, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2053 = wave.extract %1938[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2054 = wave.fmul %2053, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2055 = wave.extract %1938[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2056 = wave.fmul %2055, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2057 = wave.extract %1938[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2058 = wave.fmul %2057, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2059 = wave.extract %1938[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2060 = wave.fmul %2059, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2061 = wave.extract %1938[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2062 = wave.fmul %2061, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2063 = wave.pack %2032, %2034, %2036, %2038, %2040, %2042, %2044, %2046, %2048, %2050, %2052, %2054, %2056, %2058, %2060, %2062 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2064 = wave.extract %1943[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2065 = wave.fmul %2064, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2066 = wave.extract %1943[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2067 = wave.fmul %2066, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2068 = wave.extract %1943[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2069 = wave.fmul %2068, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2070 = wave.extract %1943[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2071 = wave.fmul %2070, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2072 = wave.extract %1943[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2073 = wave.fmul %2072, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2074 = wave.extract %1943[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2075 = wave.fmul %2074, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2076 = wave.extract %1943[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2077 = wave.fmul %2076, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2078 = wave.extract %1943[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2079 = wave.fmul %2078, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2080 = wave.extract %1943[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2081 = wave.fmul %2080, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2082 = wave.extract %1943[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2083 = wave.fmul %2082, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2084 = wave.extract %1943[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2085 = wave.fmul %2084, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2086 = wave.extract %1943[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2087 = wave.fmul %2086, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2088 = wave.extract %1943[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2089 = wave.fmul %2088, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2090 = wave.extract %1943[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2091 = wave.fmul %2090, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2092 = wave.extract %1943[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2093 = wave.fmul %2092, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2094 = wave.extract %1943[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2095 = wave.fmul %2094, %1965 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2096 = wave.pack %2065, %2067, %2069, %2071, %2073, %2075, %2077, %2079, %2081, %2083, %2085, %2087, %2089, %2091, %2093, %2095 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2097 = wave.extract %1948[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2098 = wave.frcp %1877 : !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2099 = wave.fmul %2097, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2100 = wave.extract %1948[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2101 = wave.fmul %2100, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2102 = wave.extract %1948[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2103 = wave.fmul %2102, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2104 = wave.extract %1948[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2105 = wave.fmul %2104, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2106 = wave.extract %1948[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2107 = wave.fmul %2106, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2108 = wave.extract %1948[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2109 = wave.fmul %2108, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2110 = wave.extract %1948[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2111 = wave.fmul %2110, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2112 = wave.extract %1948[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2113 = wave.fmul %2112, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2114 = wave.extract %1948[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2115 = wave.fmul %2114, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2116 = wave.extract %1948[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2117 = wave.fmul %2116, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2118 = wave.extract %1948[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2119 = wave.fmul %2118, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2120 = wave.extract %1948[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2121 = wave.fmul %2120, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2122 = wave.extract %1948[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2123 = wave.fmul %2122, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2124 = wave.extract %1948[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2125 = wave.fmul %2124, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2126 = wave.extract %1948[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2127 = wave.fmul %2126, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2128 = wave.extract %1948[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2129 = wave.fmul %2128, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2130 = wave.pack %2099, %2101, %2103, %2105, %2107, %2109, %2111, %2113, %2115, %2117, %2119, %2121, %2123, %2125, %2127, %2129 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2131 = wave.extract %1953[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2132 = wave.fmul %2131, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2133 = wave.extract %1953[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2134 = wave.fmul %2133, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2135 = wave.extract %1953[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2136 = wave.fmul %2135, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2137 = wave.extract %1953[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2138 = wave.fmul %2137, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2139 = wave.extract %1953[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2140 = wave.fmul %2139, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2141 = wave.extract %1953[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2142 = wave.fmul %2141, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2143 = wave.extract %1953[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2144 = wave.fmul %2143, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2145 = wave.extract %1953[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2146 = wave.fmul %2145, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2147 = wave.extract %1953[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2148 = wave.fmul %2147, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2149 = wave.extract %1953[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2150 = wave.fmul %2149, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2151 = wave.extract %1953[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2152 = wave.fmul %2151, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2153 = wave.extract %1953[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2154 = wave.fmul %2153, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2155 = wave.extract %1953[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2156 = wave.fmul %2155, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2157 = wave.extract %1953[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2158 = wave.fmul %2157, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2159 = wave.extract %1953[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2160 = wave.fmul %2159, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2161 = wave.extract %1953[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2162 = wave.fmul %2161, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2163 = wave.pack %2132, %2134, %2136, %2138, %2140, %2142, %2144, %2146, %2148, %2150, %2152, %2154, %2156, %2158, %2160, %2162 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2164 = wave.extract %1958[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2165 = wave.fmul %2164, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2166 = wave.extract %1958[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2167 = wave.fmul %2166, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2168 = wave.extract %1958[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2169 = wave.fmul %2168, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2170 = wave.extract %1958[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2171 = wave.fmul %2170, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2172 = wave.extract %1958[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2173 = wave.fmul %2172, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2174 = wave.extract %1958[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2175 = wave.fmul %2174, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2176 = wave.extract %1958[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2177 = wave.fmul %2176, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2178 = wave.extract %1958[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2179 = wave.fmul %2178, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2180 = wave.extract %1958[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2181 = wave.fmul %2180, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2182 = wave.extract %1958[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2183 = wave.fmul %2182, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2184 = wave.extract %1958[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2185 = wave.fmul %2184, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2186 = wave.extract %1958[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2187 = wave.fmul %2186, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2188 = wave.extract %1958[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2189 = wave.fmul %2188, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2190 = wave.extract %1958[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2191 = wave.fmul %2190, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2192 = wave.extract %1958[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2193 = wave.fmul %2192, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2194 = wave.extract %1958[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2195 = wave.fmul %2194, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2196 = wave.pack %2165, %2167, %2169, %2171, %2173, %2175, %2177, %2179, %2181, %2183, %2185, %2187, %2189, %2191, %2193, %2195 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2197 = wave.extract %1963[0] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2198 = wave.fmul %2197, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2199 = wave.extract %1963[1] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2200 = wave.fmul %2199, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2201 = wave.extract %1963[2] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2202 = wave.fmul %2201, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2203 = wave.extract %1963[3] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2204 = wave.fmul %2203, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2205 = wave.extract %1963[4] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2206 = wave.fmul %2205, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2207 = wave.extract %1963[5] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2208 = wave.fmul %2207, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2209 = wave.extract %1963[6] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2210 = wave.fmul %2209, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2211 = wave.extract %1963[7] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2212 = wave.fmul %2211, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2213 = wave.extract %1963[8] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2214 = wave.fmul %2213, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2215 = wave.extract %1963[9] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2216 = wave.fmul %2215, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2217 = wave.extract %1963[10] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2218 = wave.fmul %2217, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2219 = wave.extract %1963[11] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2220 = wave.fmul %2219, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2221 = wave.extract %1963[12] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2222 = wave.fmul %2221, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2223 = wave.extract %1963[13] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2224 = wave.fmul %2223, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2225 = wave.extract %1963[14] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2226 = wave.fmul %2225, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2227 = wave.extract %1963[15] : !wave.simd<vector<16xf32>, 64> -> !wave.simd<f32, 64>
      %2228 = wave.fmul %2227, %2098 : !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<f32, 64>
      %2229 = wave.pack %2198, %2200, %2202, %2204, %2206, %2208, %2210, %2212, %2214, %2216, %2218, %2220, %2222, %2224, %2226, %2228 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<16xf32>, 64>
      %2230 = wave.assume %arg15 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">, #wave.pred<"Mod(x, 16) == 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">, #wave.pred<"-1 + x >= 0">] : i32
      %2231 = wave.binary muli %139, %2230 overflow<nsw> : i32, i32 -> i32
      %2232 = wave.binary addi %2231, %138 overflow<nsw> : i32, i32 -> i32
      %2233 = wave.binary muli %180, %101 overflow<nsw> : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2234 = wave.binary xori %68, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2235 = wave.binary xori %103, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2236 = wave.binary xori %67, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2237 = wave.binary xori %102, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2238 = wave.binary xori %42, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2239 = wave.binary xori %41, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2240 = wave.binary xori %40, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2241 = wave.binary xori %100, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2242 = wave.binary xori %63, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2243 = wave.binary xori %62, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2244 = wave.binary xori %61, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2245 = wave.binary xori %39, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2246 = wave.binary xori %38, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2247 = wave.binary xori %37, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2248 = wave.binary xori %36, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2249 = wave.binary xori %98, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2250 = wave.binary xori %56, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2251 = wave.binary xori %55, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2252 = wave.binary xori %54, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2253 = wave.binary xori %35, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2254 = wave.binary xori %34, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2255 = wave.binary xori %33, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2256 = wave.binary xori %32, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2257 = wave.binary xori %96, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2258 = wave.binary xori %49, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2259 = wave.binary xori %48, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2260 = wave.binary xori %47, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2261 = wave.binary xori %31, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2262 = wave.binary xori %30, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2263 = wave.binary xori %29, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2264 = wave.binary xori %28, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2265 = wave.binary xori %99, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2266 = wave.binary xori %27, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2267 = wave.binary xori %26, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2268 = wave.binary xori %25, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2269 = wave.binary xori %24, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2270 = wave.binary xori %23, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2271 = wave.binary xori %22, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2272 = wave.binary xori %21, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2273 = wave.binary xori %95, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2274 = wave.binary xori %20, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2275 = wave.binary xori %19, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2276 = wave.binary xori %18, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2277 = wave.binary xori %17, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2278 = wave.binary xori %16, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2279 = wave.binary xori %15, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2280 = wave.binary xori %14, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2281 = wave.binary xori %94, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2282 = wave.binary xori %13, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2283 = wave.binary xori %12, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2284 = wave.binary xori %11, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2285 = wave.binary xori %10, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2286 = wave.binary xori %9, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2287 = wave.binary xori %8, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2288 = wave.binary xori %7, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2289 = wave.binary xori %93, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2290 = wave.binary xori %6, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2291 = wave.binary xori %5, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2292 = wave.binary xori %4, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2293 = wave.binary xori %3, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2294 = wave.binary xori %2, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2295 = wave.binary xori %1, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2296 = wave.binary xori %0, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2297 = wave.cmpi slt %2233, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2298 = wave.cmpi slt %2234, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2299 = wave.cmpi slt %2235, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2300 = wave.cmpi slt %2236, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2301 = wave.cmpi slt %2237, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2302 = wave.cmpi slt %2238, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2303 = wave.cmpi slt %2239, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2304 = wave.cmpi slt %2240, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2305 = wave.cmpi slt %2241, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2306 = wave.cmpi slt %2242, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2307 = wave.cmpi slt %2243, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2308 = wave.cmpi slt %2244, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2309 = wave.cmpi slt %2245, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2310 = wave.cmpi slt %2246, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2311 = wave.cmpi slt %2247, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2312 = wave.cmpi slt %2248, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2313 = wave.cmpi slt %2249, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2314 = wave.cmpi slt %2250, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2315 = wave.cmpi slt %2251, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2316 = wave.cmpi slt %2252, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2317 = wave.cmpi slt %2253, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2318 = wave.cmpi slt %2254, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2319 = wave.cmpi slt %2255, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2320 = wave.cmpi slt %2256, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2321 = wave.cmpi slt %2257, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2322 = wave.cmpi slt %2258, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2323 = wave.cmpi slt %2259, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2324 = wave.cmpi slt %2260, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2325 = wave.cmpi slt %2261, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2326 = wave.cmpi slt %2262, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2327 = wave.cmpi slt %2263, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2328 = wave.cmpi slt %2264, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2329 = wave.cmpi slt %2265, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2330 = wave.cmpi slt %2266, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2331 = wave.cmpi slt %2267, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2332 = wave.cmpi slt %2268, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2333 = wave.cmpi slt %2269, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2334 = wave.cmpi slt %2270, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2335 = wave.cmpi slt %2271, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2336 = wave.cmpi slt %2272, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2337 = wave.cmpi slt %2273, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2338 = wave.cmpi slt %2274, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2339 = wave.cmpi slt %2275, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2340 = wave.cmpi slt %2276, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2341 = wave.cmpi slt %2277, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2342 = wave.cmpi slt %2278, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2343 = wave.cmpi slt %2279, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2344 = wave.cmpi slt %2280, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2345 = wave.cmpi slt %2281, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2346 = wave.cmpi slt %2282, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2347 = wave.cmpi slt %2283, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2348 = wave.cmpi slt %2284, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2349 = wave.cmpi slt %2285, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2350 = wave.cmpi slt %2286, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2351 = wave.cmpi slt %2287, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2352 = wave.cmpi slt %2288, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2353 = wave.cmpi slt %2289, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2354 = wave.cmpi slt %2290, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2355 = wave.cmpi slt %2291, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2356 = wave.cmpi slt %2292, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2357 = wave.cmpi slt %2293, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2358 = wave.cmpi slt %2294, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2359 = wave.cmpi slt %2295, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2360 = wave.cmpi slt %2296, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
      %2361 = wave.select %177, %2297, %104 : !wave.mask<64>, !wave.mask<64>
      %2362 = wave.select %177, %2298, %104 : !wave.mask<64>, !wave.mask<64>
      %2363 = wave.select %177, %2299, %104 : !wave.mask<64>, !wave.mask<64>
      %2364 = wave.select %177, %2300, %104 : !wave.mask<64>, !wave.mask<64>
      %2365 = wave.select %177, %2301, %104 : !wave.mask<64>, !wave.mask<64>
      %2366 = wave.select %177, %2302, %104 : !wave.mask<64>, !wave.mask<64>
      %2367 = wave.select %177, %2303, %104 : !wave.mask<64>, !wave.mask<64>
      %2368 = wave.select %177, %2304, %104 : !wave.mask<64>, !wave.mask<64>
      %2369 = wave.select %177, %2305, %104 : !wave.mask<64>, !wave.mask<64>
      %2370 = wave.select %177, %2306, %104 : !wave.mask<64>, !wave.mask<64>
      %2371 = wave.select %177, %2307, %104 : !wave.mask<64>, !wave.mask<64>
      %2372 = wave.select %177, %2308, %104 : !wave.mask<64>, !wave.mask<64>
      %2373 = wave.select %177, %2309, %104 : !wave.mask<64>, !wave.mask<64>
      %2374 = wave.select %177, %2310, %104 : !wave.mask<64>, !wave.mask<64>
      %2375 = wave.select %177, %2311, %104 : !wave.mask<64>, !wave.mask<64>
      %2376 = wave.select %177, %2312, %104 : !wave.mask<64>, !wave.mask<64>
      %2377 = wave.select %177, %2313, %104 : !wave.mask<64>, !wave.mask<64>
      %2378 = wave.select %177, %2314, %104 : !wave.mask<64>, !wave.mask<64>
      %2379 = wave.select %177, %2315, %104 : !wave.mask<64>, !wave.mask<64>
      %2380 = wave.select %177, %2316, %104 : !wave.mask<64>, !wave.mask<64>
      %2381 = wave.select %177, %2317, %104 : !wave.mask<64>, !wave.mask<64>
      %2382 = wave.select %177, %2318, %104 : !wave.mask<64>, !wave.mask<64>
      %2383 = wave.select %177, %2319, %104 : !wave.mask<64>, !wave.mask<64>
      %2384 = wave.select %177, %2320, %104 : !wave.mask<64>, !wave.mask<64>
      %2385 = wave.select %177, %2321, %104 : !wave.mask<64>, !wave.mask<64>
      %2386 = wave.select %177, %2322, %104 : !wave.mask<64>, !wave.mask<64>
      %2387 = wave.select %177, %2323, %104 : !wave.mask<64>, !wave.mask<64>
      %2388 = wave.select %177, %2324, %104 : !wave.mask<64>, !wave.mask<64>
      %2389 = wave.select %177, %2325, %104 : !wave.mask<64>, !wave.mask<64>
      %2390 = wave.select %177, %2326, %104 : !wave.mask<64>, !wave.mask<64>
      %2391 = wave.select %177, %2327, %104 : !wave.mask<64>, !wave.mask<64>
      %2392 = wave.select %177, %2328, %104 : !wave.mask<64>, !wave.mask<64>
      %2393 = wave.select %177, %2329, %104 : !wave.mask<64>, !wave.mask<64>
      %2394 = wave.select %177, %2330, %104 : !wave.mask<64>, !wave.mask<64>
      %2395 = wave.select %177, %2331, %104 : !wave.mask<64>, !wave.mask<64>
      %2396 = wave.select %177, %2332, %104 : !wave.mask<64>, !wave.mask<64>
      %2397 = wave.select %177, %2333, %104 : !wave.mask<64>, !wave.mask<64>
      %2398 = wave.select %177, %2334, %104 : !wave.mask<64>, !wave.mask<64>
      %2399 = wave.select %177, %2335, %104 : !wave.mask<64>, !wave.mask<64>
      %2400 = wave.select %177, %2336, %104 : !wave.mask<64>, !wave.mask<64>
      %2401 = wave.select %177, %2337, %104 : !wave.mask<64>, !wave.mask<64>
      %2402 = wave.select %177, %2338, %104 : !wave.mask<64>, !wave.mask<64>
      %2403 = wave.select %177, %2339, %104 : !wave.mask<64>, !wave.mask<64>
      %2404 = wave.select %177, %2340, %104 : !wave.mask<64>, !wave.mask<64>
      %2405 = wave.select %177, %2341, %104 : !wave.mask<64>, !wave.mask<64>
      %2406 = wave.select %177, %2342, %104 : !wave.mask<64>, !wave.mask<64>
      %2407 = wave.select %177, %2343, %104 : !wave.mask<64>, !wave.mask<64>
      %2408 = wave.select %177, %2344, %104 : !wave.mask<64>, !wave.mask<64>
      %2409 = wave.select %177, %2345, %104 : !wave.mask<64>, !wave.mask<64>
      %2410 = wave.select %177, %2346, %104 : !wave.mask<64>, !wave.mask<64>
      %2411 = wave.select %177, %2347, %104 : !wave.mask<64>, !wave.mask<64>
      %2412 = wave.select %177, %2348, %104 : !wave.mask<64>, !wave.mask<64>
      %2413 = wave.select %177, %2349, %104 : !wave.mask<64>, !wave.mask<64>
      %2414 = wave.select %177, %2350, %104 : !wave.mask<64>, !wave.mask<64>
      %2415 = wave.select %177, %2351, %104 : !wave.mask<64>, !wave.mask<64>
      %2416 = wave.select %177, %2352, %104 : !wave.mask<64>, !wave.mask<64>
      %2417 = wave.select %177, %2353, %104 : !wave.mask<64>, !wave.mask<64>
      %2418 = wave.select %177, %2354, %104 : !wave.mask<64>, !wave.mask<64>
      %2419 = wave.select %177, %2355, %104 : !wave.mask<64>, !wave.mask<64>
      %2420 = wave.select %177, %2356, %104 : !wave.mask<64>, !wave.mask<64>
      %2421 = wave.select %177, %2357, %104 : !wave.mask<64>, !wave.mask<64>
      %2422 = wave.select %177, %2358, %104 : !wave.mask<64>, !wave.mask<64>
      %2423 = wave.select %177, %2359, %104 : !wave.mask<64>, !wave.mask<64>
      %2424 = wave.select %177, %2360, %104 : !wave.mask<64>, !wave.mask<64>
      %2425 = wave.select %178, %2297, %104 : !wave.mask<64>, !wave.mask<64>
      %2426 = wave.select %178, %2298, %104 : !wave.mask<64>, !wave.mask<64>
      %2427 = wave.select %178, %2299, %104 : !wave.mask<64>, !wave.mask<64>
      %2428 = wave.select %178, %2300, %104 : !wave.mask<64>, !wave.mask<64>
      %2429 = wave.select %178, %2301, %104 : !wave.mask<64>, !wave.mask<64>
      %2430 = wave.select %178, %2302, %104 : !wave.mask<64>, !wave.mask<64>
      %2431 = wave.select %178, %2303, %104 : !wave.mask<64>, !wave.mask<64>
      %2432 = wave.select %178, %2304, %104 : !wave.mask<64>, !wave.mask<64>
      %2433 = wave.select %178, %2305, %104 : !wave.mask<64>, !wave.mask<64>
      %2434 = wave.select %178, %2306, %104 : !wave.mask<64>, !wave.mask<64>
      %2435 = wave.select %178, %2307, %104 : !wave.mask<64>, !wave.mask<64>
      %2436 = wave.select %178, %2308, %104 : !wave.mask<64>, !wave.mask<64>
      %2437 = wave.select %178, %2309, %104 : !wave.mask<64>, !wave.mask<64>
      %2438 = wave.select %178, %2310, %104 : !wave.mask<64>, !wave.mask<64>
      %2439 = wave.select %178, %2311, %104 : !wave.mask<64>, !wave.mask<64>
      %2440 = wave.select %178, %2312, %104 : !wave.mask<64>, !wave.mask<64>
      %2441 = wave.select %178, %2313, %104 : !wave.mask<64>, !wave.mask<64>
      %2442 = wave.select %178, %2314, %104 : !wave.mask<64>, !wave.mask<64>
      %2443 = wave.select %178, %2315, %104 : !wave.mask<64>, !wave.mask<64>
      %2444 = wave.select %178, %2316, %104 : !wave.mask<64>, !wave.mask<64>
      %2445 = wave.select %178, %2317, %104 : !wave.mask<64>, !wave.mask<64>
      %2446 = wave.select %178, %2318, %104 : !wave.mask<64>, !wave.mask<64>
      %2447 = wave.select %178, %2319, %104 : !wave.mask<64>, !wave.mask<64>
      %2448 = wave.select %178, %2320, %104 : !wave.mask<64>, !wave.mask<64>
      %2449 = wave.select %178, %2321, %104 : !wave.mask<64>, !wave.mask<64>
      %2450 = wave.select %178, %2322, %104 : !wave.mask<64>, !wave.mask<64>
      %2451 = wave.select %178, %2323, %104 : !wave.mask<64>, !wave.mask<64>
      %2452 = wave.select %178, %2324, %104 : !wave.mask<64>, !wave.mask<64>
      %2453 = wave.select %178, %2325, %104 : !wave.mask<64>, !wave.mask<64>
      %2454 = wave.select %178, %2326, %104 : !wave.mask<64>, !wave.mask<64>
      %2455 = wave.select %178, %2327, %104 : !wave.mask<64>, !wave.mask<64>
      %2456 = wave.select %178, %2328, %104 : !wave.mask<64>, !wave.mask<64>
      %2457 = wave.select %178, %2329, %104 : !wave.mask<64>, !wave.mask<64>
      %2458 = wave.select %178, %2330, %104 : !wave.mask<64>, !wave.mask<64>
      %2459 = wave.select %178, %2331, %104 : !wave.mask<64>, !wave.mask<64>
      %2460 = wave.select %178, %2332, %104 : !wave.mask<64>, !wave.mask<64>
      %2461 = wave.select %178, %2333, %104 : !wave.mask<64>, !wave.mask<64>
      %2462 = wave.select %178, %2334, %104 : !wave.mask<64>, !wave.mask<64>
      %2463 = wave.select %178, %2335, %104 : !wave.mask<64>, !wave.mask<64>
      %2464 = wave.select %178, %2336, %104 : !wave.mask<64>, !wave.mask<64>
      %2465 = wave.select %178, %2337, %104 : !wave.mask<64>, !wave.mask<64>
      %2466 = wave.select %178, %2338, %104 : !wave.mask<64>, !wave.mask<64>
      %2467 = wave.select %178, %2339, %104 : !wave.mask<64>, !wave.mask<64>
      %2468 = wave.select %178, %2340, %104 : !wave.mask<64>, !wave.mask<64>
      %2469 = wave.select %178, %2341, %104 : !wave.mask<64>, !wave.mask<64>
      %2470 = wave.select %178, %2342, %104 : !wave.mask<64>, !wave.mask<64>
      %2471 = wave.select %178, %2343, %104 : !wave.mask<64>, !wave.mask<64>
      %2472 = wave.select %178, %2344, %104 : !wave.mask<64>, !wave.mask<64>
      %2473 = wave.select %178, %2345, %104 : !wave.mask<64>, !wave.mask<64>
      %2474 = wave.select %178, %2346, %104 : !wave.mask<64>, !wave.mask<64>
      %2475 = wave.select %178, %2347, %104 : !wave.mask<64>, !wave.mask<64>
      %2476 = wave.select %178, %2348, %104 : !wave.mask<64>, !wave.mask<64>
      %2477 = wave.select %178, %2349, %104 : !wave.mask<64>, !wave.mask<64>
      %2478 = wave.select %178, %2350, %104 : !wave.mask<64>, !wave.mask<64>
      %2479 = wave.select %178, %2351, %104 : !wave.mask<64>, !wave.mask<64>
      %2480 = wave.select %178, %2352, %104 : !wave.mask<64>, !wave.mask<64>
      %2481 = wave.select %178, %2353, %104 : !wave.mask<64>, !wave.mask<64>
      %2482 = wave.select %178, %2354, %104 : !wave.mask<64>, !wave.mask<64>
      %2483 = wave.select %178, %2355, %104 : !wave.mask<64>, !wave.mask<64>
      %2484 = wave.select %178, %2356, %104 : !wave.mask<64>, !wave.mask<64>
      %2485 = wave.select %178, %2357, %104 : !wave.mask<64>, !wave.mask<64>
      %2486 = wave.select %178, %2358, %104 : !wave.mask<64>, !wave.mask<64>
      %2487 = wave.select %178, %2359, %104 : !wave.mask<64>, !wave.mask<64>
      %2488 = wave.select %178, %2360, %104 : !wave.mask<64>, !wave.mask<64>
      %2489 = wave.cast fpconvert %1997 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2490 = wave.cast fpconvert %2030 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2491 = wave.cast fpconvert %2063 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2492 = wave.cast fpconvert %2096 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2493 = wave.cast fpconvert %2130 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2494 = wave.cast fpconvert %2163 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2495 = wave.cast fpconvert %2196 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2496 = wave.cast fpconvert %2229 : !wave.simd<vector<16xf32>, 64> -> !wave.simd<vector<16xbf16>, 64>
      %2497 = wave.pack %2489, %2490, %2491, %2492, %2493, %2494, %2495, %2496 : !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64>, !wave.simd<vector<16xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2498 = wave.redistribute %2497, <blocks = 1, items = 256, source_block = "0", source_item = "64*xor(2*Mod(floor(1/128*item), 2), Mod(floor(1/64*item), 2)) + xor(16*Mod(floor(1/16*Mod(item, 64)), 2), xor(8*Mod(floor(1/8*Mod(item, 64)), 2), xor(4*Mod(floor(1/4*Mod(item, 64)), 2), xor(2*Mod(floor(1/2*Mod(item, 64)), 2), xor(32*Mod(floor(1/4*slot), 2), Mod(Mod(item, 64), 2))))))", source_slot = "xor(4*Mod(floor(1/32*Mod(item, 64)), 2), xor(64*Mod(floor(1/64*slot), 2), xor(32*Mod(floor(1/32*slot), 2), xor(16*Mod(floor(1/16*slot), 2), xor(8*Mod(floor(1/8*slot), 2), xor(2*Mod(floor(1/2*slot), 2), Mod(slot, 2)))))))"> : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2499 = wave.index_expr <"s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + 8*Mod(floor(1/32*wi), 2) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + 8*Mod(floor(1/32*wi), 2) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2500 = wave.assume %2499 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2501 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2500) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2502 = wave.index_expr <"1 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2503 = wave.assume %2502 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2504 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2503) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2505 = wave.index_expr <"2 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2506 = wave.assume %2505 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2507 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2506) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2508 = wave.index_expr <"3 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2509 = wave.assume %2508 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2510 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2509) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2511 = wave.index_expr <"4 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2512 = wave.assume %2511 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2513 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2512) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2514 = wave.index_expr <"5 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2515 = wave.assume %2514 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2516 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2515) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2517 = wave.index_expr <"6 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2518 = wave.assume %2517 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2519 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2518) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2520 = wave.index_expr <"7 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2521 = wave.assume %2520 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2522 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2521) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2523 = wave.index_expr <"16 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2524 = wave.assume %2523 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2525 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2524) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2526 = wave.index_expr <"17 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2527 = wave.assume %2526 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2528 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2527) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2529 = wave.index_expr <"18 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2530 = wave.assume %2529 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2531 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2530) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2532 = wave.index_expr <"19 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2533 = wave.assume %2532 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2534 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2533) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2535 = wave.index_expr <"20 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2536 = wave.assume %2535 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2537 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2536) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2538 = wave.index_expr <"21 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2539 = wave.assume %2538 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2540 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2539) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2541 = wave.index_expr <"22 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2542 = wave.assume %2541 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2543 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2542) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2544 = wave.index_expr <"23 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2545 = wave.assume %2544 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2546 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2545) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2547 = wave.index_expr <"32 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2548 = wave.assume %2547 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2549 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2548) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2550 = wave.index_expr <"33 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2551 = wave.assume %2550 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2552 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2551) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2553 = wave.index_expr <"34 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2554 = wave.assume %2553 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2555 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2554) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2556 = wave.index_expr <"35 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2557 = wave.assume %2556 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2558 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2557) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2559 = wave.index_expr <"36 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2560 = wave.assume %2559 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2561 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2560) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2562 = wave.index_expr <"37 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2563 = wave.assume %2562 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2564 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2563) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2565 = wave.index_expr <"38 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2566 = wave.assume %2565 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2567 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2566) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2568 = wave.index_expr <"39 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2569 = wave.assume %2568 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2570 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2569) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2571 = wave.index_expr <"48 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2572 = wave.assume %2571 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2573 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2572) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2574 = wave.index_expr <"49 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2575 = wave.assume %2574 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2576 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2575) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2577 = wave.index_expr <"50 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2578 = wave.assume %2577 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2579 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2578) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2580 = wave.index_expr <"51 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2581 = wave.assume %2580 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2582 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2581) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2583 = wave.index_expr <"52 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2584 = wave.assume %2583 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2585 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2584) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2586 = wave.index_expr <"53 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2587 = wave.assume %2586 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2588 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2587) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2589 = wave.index_expr <"54 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2590 = wave.assume %2589 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2591 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2590) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2592 = wave.index_expr <"55 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2593 = wave.assume %2592 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2594 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2593) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2595 = wave.index_expr <"64 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2596 = wave.assume %2595 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2597 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2596) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2598 = wave.index_expr <"65 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2599 = wave.assume %2598 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2600 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2599) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2601 = wave.index_expr <"66 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2602 = wave.assume %2601 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2603 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2602) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2604 = wave.index_expr <"67 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2605 = wave.assume %2604 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2606 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2605) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2607 = wave.index_expr <"68 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2608 = wave.assume %2607 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2609 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2608) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2610 = wave.index_expr <"69 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2611 = wave.assume %2610 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2612 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2611) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2613 = wave.index_expr <"70 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2614 = wave.assume %2613 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2615 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2614) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2616 = wave.index_expr <"71 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2617 = wave.assume %2616 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2618 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2617) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2619 = wave.index_expr <"80 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2620 = wave.assume %2619 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2621 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2620) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2622 = wave.index_expr <"81 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2623 = wave.assume %2622 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2624 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2623) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2625 = wave.index_expr <"82 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2626 = wave.assume %2625 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2627 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2626) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2628 = wave.index_expr <"83 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2629 = wave.assume %2628 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2630 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2629) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2631 = wave.index_expr <"84 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2632 = wave.assume %2631 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2633 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2632) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2634 = wave.index_expr <"85 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2635 = wave.assume %2634 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2636 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2635) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2637 = wave.index_expr <"86 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2638 = wave.assume %2637 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2639 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2638) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2640 = wave.index_expr <"87 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2641 = wave.assume %2640 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2642 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2641) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2643 = wave.index_expr <"96 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2644 = wave.assume %2643 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2645 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2644) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2646 = wave.index_expr <"97 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2647 = wave.assume %2646 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2648 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2647) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2649 = wave.index_expr <"98 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2650 = wave.assume %2649 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2651 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2650) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2652 = wave.index_expr <"99 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2653 = wave.assume %2652 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2654 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2653) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2655 = wave.index_expr <"100 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2656 = wave.assume %2655 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2657 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2656) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2658 = wave.index_expr <"101 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2659 = wave.assume %2658 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2660 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2659) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2661 = wave.index_expr <"102 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2662 = wave.assume %2661 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2663 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2662) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2664 = wave.index_expr <"103 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2665 = wave.assume %2664 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2666 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2665) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2667 = wave.index_expr <"112 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2668 = wave.assume %2667 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2669 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2668) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2670 = wave.index_expr <"113 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2671 = wave.assume %2670 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2672 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2671) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2673 = wave.index_expr <"114 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2674 = wave.assume %2673 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2675 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2674) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2676 = wave.index_expr <"115 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2677 = wave.assume %2676 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2678 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2677) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2679 = wave.index_expr <"116 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2680 = wave.assume %2679 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2681 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2680) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2682 = wave.index_expr <"117 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2683 = wave.assume %2682 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2684 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2683) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2685 = wave.index_expr <"118 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2686 = wave.assume %2685 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2687 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2686) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2688 = wave.index_expr <"119 + s1 + s0*Mod(wi, 2) + 64*s0*Mod(floor(1/128*wi), 2) + 32*s0*Mod(floor(1/64*wi), 2) + 16*s0*Mod(floor(1/16*wi), 2) + 8*s0*Mod(floor(1/8*wi), 2) + 4*s0*Mod(floor(1/4*wi), 2) + 2*s0*Mod(floor(1/2*wi), 2) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), Mod(wi, 2))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2689 = wave.assume %2688 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2690 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2689) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2691 = wave.index_expr <"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + 8*Mod(floor(1/32*wi), 2) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + 8*Mod(floor(1/32*wi), 2) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2692 = wave.assume %2691 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2693 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2692) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2694 = wave.index_expr <"1 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(1, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2695 = wave.assume %2694 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2696 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2695) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2697 = wave.index_expr <"2 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(2, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2698 = wave.assume %2697 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2699 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2698) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2700 = wave.index_expr <"3 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(3, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2701 = wave.assume %2700 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2702 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2701) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2703 = wave.index_expr <"4 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(4, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2704 = wave.assume %2703 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2705 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2704) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2706 = wave.index_expr <"5 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(5, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2707 = wave.assume %2706 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2708 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2707) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2709 = wave.index_expr <"6 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(6, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2710 = wave.assume %2709 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2711 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2710) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2712 = wave.index_expr <"7 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(7, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2713 = wave.assume %2712 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2714 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2713) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2715 = wave.index_expr <"16 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(16, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2716 = wave.assume %2715 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2717 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2716) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2718 = wave.index_expr <"17 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(17, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2719 = wave.assume %2718 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2720 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2719) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2721 = wave.index_expr <"18 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(18, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2722 = wave.assume %2721 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2723 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2722) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2724 = wave.index_expr <"19 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(19, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2725 = wave.assume %2724 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2726 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2725) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2727 = wave.index_expr <"20 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(20, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2728 = wave.assume %2727 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2729 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2728) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2730 = wave.index_expr <"21 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(21, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2731 = wave.assume %2730 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2732 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2731) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2733 = wave.index_expr <"22 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(22, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2734 = wave.assume %2733 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2735 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2734) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2736 = wave.index_expr <"23 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(23, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2737 = wave.assume %2736 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2738 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2737) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2739 = wave.index_expr <"32 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(32, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2740 = wave.assume %2739 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2741 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2740) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2742 = wave.index_expr <"33 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(33, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2743 = wave.assume %2742 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2744 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2743) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2745 = wave.index_expr <"34 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(34, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2746 = wave.assume %2745 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2747 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2746) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2748 = wave.index_expr <"35 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(35, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2749 = wave.assume %2748 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2750 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2749) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2751 = wave.index_expr <"36 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(36, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2752 = wave.assume %2751 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2753 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2752) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2754 = wave.index_expr <"37 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(37, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2755 = wave.assume %2754 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2756 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2755) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2757 = wave.index_expr <"38 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(38, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2758 = wave.assume %2757 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2759 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2758) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2760 = wave.index_expr <"39 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(39, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2761 = wave.assume %2760 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2762 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2761) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2763 = wave.index_expr <"48 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(48, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2764 = wave.assume %2763 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2765 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2764) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2766 = wave.index_expr <"49 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(49, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2767 = wave.assume %2766 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2768 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2767) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2769 = wave.index_expr <"50 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(50, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2770 = wave.assume %2769 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2771 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2770) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2772 = wave.index_expr <"51 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(51, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2773 = wave.assume %2772 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2774 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2773) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2775 = wave.index_expr <"52 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(52, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2776 = wave.assume %2775 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2777 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2776) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2778 = wave.index_expr <"53 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(53, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2779 = wave.assume %2778 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2780 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2779) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2781 = wave.index_expr <"54 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(54, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2782 = wave.assume %2781 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2783 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2782) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2784 = wave.index_expr <"55 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(55, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2785 = wave.assume %2784 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2786 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2785) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2787 = wave.index_expr <"64 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(64, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2788 = wave.assume %2787 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2789 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2788) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2790 = wave.index_expr <"65 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(65, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2791 = wave.assume %2790 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2792 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2791) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2793 = wave.index_expr <"66 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(66, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2794 = wave.assume %2793 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2795 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2794) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2796 = wave.index_expr <"67 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(67, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2797 = wave.assume %2796 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2798 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2797) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2799 = wave.index_expr <"68 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(68, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2800 = wave.assume %2799 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2801 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2800) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2802 = wave.index_expr <"69 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(69, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2803 = wave.assume %2802 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2804 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2803) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2805 = wave.index_expr <"70 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(70, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2806 = wave.assume %2805 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2807 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2806) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2808 = wave.index_expr <"71 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(71, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2809 = wave.assume %2808 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2810 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2809) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2811 = wave.index_expr <"80 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(80, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2812 = wave.assume %2811 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2813 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2812) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2814 = wave.index_expr <"81 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(81, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2815 = wave.assume %2814 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2816 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2815) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2817 = wave.index_expr <"82 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(82, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2818 = wave.assume %2817 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2819 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2818) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2820 = wave.index_expr <"83 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(83, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2821 = wave.assume %2820 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2822 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2821) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2823 = wave.index_expr <"84 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(84, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2824 = wave.assume %2823 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2825 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2824) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2826 = wave.index_expr <"85 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(85, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2827 = wave.assume %2826 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2828 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2827) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2829 = wave.index_expr <"86 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(86, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2830 = wave.assume %2829 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2831 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2830) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2832 = wave.index_expr <"87 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(87, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2833 = wave.assume %2832 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2834 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2833) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2835 = wave.index_expr <"96 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(96, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2836 = wave.assume %2835 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2837 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2836) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2838 = wave.index_expr <"97 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(97, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2839 = wave.assume %2838 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2840 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2839) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2841 = wave.index_expr <"98 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(98, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2842 = wave.assume %2841 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2843 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2842) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2844 = wave.index_expr <"99 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(99, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2845 = wave.assume %2844 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2846 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2845) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2847 = wave.index_expr <"100 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(100, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2848 = wave.assume %2847 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2849 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2848) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2850 = wave.index_expr <"101 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(101, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2851 = wave.assume %2850 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2852 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2851) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2853 = wave.index_expr <"102 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(102, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2854 = wave.assume %2853 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2855 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2854) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2856 = wave.index_expr <"103 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(103, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2857 = wave.assume %2856 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2858 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2857) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2859 = wave.index_expr <"112 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(112, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2860 = wave.assume %2859 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2861 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2860) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2862 = wave.index_expr <"113 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(113, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2863 = wave.assume %2862 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2864 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2863) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2865 = wave.index_expr <"114 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(114, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2866 = wave.assume %2865 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2867 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2866) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2868 = wave.index_expr <"115 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(115, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2869 = wave.assume %2868 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2870 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2869) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2871 = wave.index_expr <"116 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(116, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2872 = wave.assume %2871 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2873 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2872) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2874 = wave.index_expr <"117 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(117, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2875 = wave.assume %2874 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2876 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2875) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2877 = wave.index_expr <"118 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(118, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2878 = wave.assume %2877 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2879 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2878) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2880 = wave.index_expr <"119 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(128 + Mod(wi, 2), 2*Mod(floor(1/2*wi), 2))))))) + 8*Mod(floor(1/32*wi), 2)"> assuming [#wave.pred<"s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) >= 0">, #wave.pred<"-1073741823 + s1 + s0*xor(64*Mod(floor(1/128*wi), 2), xor(32*Mod(floor(1/64*wi), 2), xor(16*Mod(floor(1/16*wi), 2), xor(8*Mod(floor(1/8*wi), 2), xor(4*Mod(floor(1/4*wi), 2), xor(2*Mod(floor(1/2*wi), 2), xor(128, Mod(wi, 2)))))))) + xor(119, 8*Mod(floor(1/32*wi), 2)) <= 0">] ["wi", "s0", "s1"](%140, %2230, %2232) : (!wave.simd<i32, 64>, i32, i32) -> !wave.simd<index, 64>
      %2881 = wave.assume %2880 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] : !wave.simd<index, 64>
      %2882 = wave.index_expr <"x"> assuming [#wave.pred<"x >= 0">, #wave.pred<"-1073741823 + x <= 0">] ["x"](%2881) : (!wave.simd<index, 64>) -> !wave.simd<index, 64>
      %2883 = waveamd.make_buffer %arg3, %c2147483647_i32 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      wave.where %2361, %2362, %2363, %2364, %2365, %2366, %2367, %2368, %2369, %2370, %2371, %2372, %2373, %2374, %2375, %2376, %2377, %2378, %2379, %2380, %2381, %2382, %2383, %2384, %2385, %2386, %2387, %2388, %2389, %2390, %2391, %2392, %2393, %2394, %2395, %2396, %2397, %2398, %2399, %2400, %2401, %2402, %2403, %2404, %2405, %2406, %2407, %2408, %2409, %2410, %2411, %2412, %2413, %2414, %2415, %2416, %2417, %2418, %2419, %2420, %2421, %2422, %2423, %2424, %2425, %2426, %2427, %2428, %2429, %2430, %2431, %2432, %2433, %2434, %2435, %2436, %2437, %2438, %2439, %2440, %2441, %2442, %2443, %2444, %2445, %2446, %2447, %2448, %2449, %2450, %2451, %2452, %2453, %2454, %2455, %2456, %2457, %2458, %2459, %2460, %2461, %2462, %2463, %2464, %2465, %2466, %2467, %2468, %2469, %2470, %2471, %2472, %2473, %2474, %2475, %2476, %2477, %2478, %2479, %2480, %2481, %2482, %2483, %2484, %2485, %2486, %2487, %2488 {
        %2884 = wave.scatter %2498 to %2883 mapping <bit_offset = <"16*offset">> bindings []() packet_bindings ["offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset", "offset"](%2501, %2504, %2507, %2510, %2513, %2516, %2519, %2522, %2525, %2528, %2531, %2534, %2537, %2540, %2543, %2546, %2549, %2552, %2555, %2558, %2561, %2564, %2567, %2570, %2573, %2576, %2579, %2582, %2585, %2588, %2591, %2594, %2597, %2600, %2603, %2606, %2609, %2612, %2615, %2618, %2621, %2624, %2627, %2630, %2633, %2636, %2639, %2642, %2645, %2648, %2651, %2654, %2657, %2660, %2663, %2666, %2669, %2672, %2675, %2678, %2681, %2684, %2687, %2690, %2693, %2696, %2699, %2702, %2705, %2708, %2711, %2714, %2717, %2720, %2723, %2726, %2729, %2732, %2735, %2738, %2741, %2744, %2747, %2750, %2753, %2756, %2759, %2762, %2765, %2768, %2771, %2774, %2777, %2780, %2783, %2786, %2789, %2792, %2795, %2798, %2801, %2804, %2807, %2810, %2813, %2816, %2819, %2822, %2825, %2828, %2831, %2834, %2837, %2840, %2843, %2846, %2849, %2852, %2855, %2858, %2861, %2864, %2867, %2870, %2873, %2876, %2879, %2882) : (!wave.simd<vector<128xbf16>, 64>, !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>, !wave.simd<index, 64>) -> !wave.mem.token
      } : !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>, !wave.mask<64>
      return
    }
  }
}
