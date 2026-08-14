module attributes {gpu.container_module, tlx_wave.new_converter = true, tlx_wave.num_ctas = 1 : i32, tlx_wave.num_warps = 4 : i32, tlx_wave.source_target = "hip:gfx950", tlx_wave.threads_per_warp = 64 : i32, waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  gpu.module @kernels {
    func.func @_a4w4_kernel(%arg0: !wave.ptr<#wave.global, i8>, %arg1: !wave.ptr<#wave.global, i8>, %arg2: !wave.ptr<#wave.global, bf16>, %arg3: !wave.ptr<#wave.global, i8>, %arg4: !wave.ptr<#wave.global, i8>, %arg5: i32, %arg6: i32, %arg7: i32, %arg8: i32, %arg9: i32, %arg10: i32, %arg11: i32, %arg12: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 256, 1, 1>, tlx_wave.converter.stage = "structural-emission", tlx_wave.num_warps = 4 : i32, tlx_wave.ttgir.noinline = false, tlx_wave.wave_size = 64 : i32, wave.kernel, wave.waves_per_workgroup = 4 : i64, wave.workgroup_size = array<i32: 256, 1, 1>, waveamdmachine.target_waves = 1 : i64} {
      %0 = wave.workitem_id 0 : !wave.simd<i32, 64>
      %1 = wave.assume %0 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : !wave.simd<i32, 64>
      %2 = wave.assume %arg5 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %3 = wave.assume %2 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %4 = wave.assume %arg6 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %5 = wave.assume %4 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %6 = wave.assume %arg7 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %7 = wave.assume %6 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %8 = wave.assume %arg8 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %9 = wave.assume %8 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %10 = wave.assume %arg9 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %11 = wave.assume %10 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %12 = wave.assume %arg10 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %13 = wave.assume %12 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %14 = wave.assume %arg11 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %15 = wave.assume %14 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %16 = wave.assume %arg12 as "x" [#wave.pred<"2147483648 + x >= 0">, #wave.pred<"-2147483647 + x <= 0">] : i32
      %17 = wave.assume %16 as "x" [#wave.pred<"Mod(x, 16) == 0">] : i32
      %c0_i32 = arith.constant 0 : i32
      %c32_i32 = arith.constant 32 : i32
      %c8_i32 = arith.constant 8 : i32
      %c1_i32 = arith.constant 1 : i32
      %c4_i32 = arith.constant 4 : i32
      %c128_i32 = arith.constant 128 : i32
      %c256_i32 = arith.constant 256 : i32
      %c3_i32 = arith.constant 3 : i32
      %c2_i32 = arith.constant 2 : i32
      %c31_i32 = arith.constant 31 : i32
      %18 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %c16_i32 = arith.constant 16 : i32
      %19 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %c255_i32 = arith.constant 255 : i32
      %20 = wave.constant 0.000000e+00 : f32 -> !wave.simd<f32, 64>
      %21 = wave.pack %20, %20, %20, %20 : !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64>, !wave.simd<f32, 64> -> !wave.simd<vector<4xf32>, 64>
      %22 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %23 = wave.constant 128 : i32 -> !wave.simd<i32, 64>
      %24 = wave.workgroup_id 0
      %25 = wave.binary addi %3, %c255_i32 : i32, i32 -> i32
      %26 = wave.binary divsi %25, %c256_i32 : i32, i32 -> i32
      %27 = wave.binary addi %5, %c255_i32 : i32, i32 -> i32
      %28 = wave.binary divsi %27, %c256_i32 : i32, i32 -> i32
      %29 = wave.binary remsi %24, %c8_i32 : i32, i32 -> i32
      %30 = wave.binary divsi %24, %c8_i32 : i32, i32 -> i32
      %31 = arith.cmpi slt, %29, %c8_i32 : i32
      %32 = scf.if %31 -> (i32) {
        %3513 = wave.binary muli %29, %c32_i32 : i32, i32 -> i32
        %3514 = wave.binary addi %3513, %30 : i32, i32 -> i32
        scf.yield %3514 : i32
      } else {
        %3513 = wave.binary subi %29, %c8_i32 : i32, i32 -> i32
        %3514 = wave.binary muli %3513, %c31_i32 : i32, i32 -> i32
        %3515 = wave.binary addi %3514, %c256_i32 : i32, i32 -> i32
        %3516 = wave.binary addi %3515, %30 : i32, i32 -> i32
        scf.yield %3516 : i32
      }
      %33 = wave.binary muli %28, %c4_i32 : i32, i32 -> i32
      %34 = wave.binary divsi %32, %33 : i32, i32 -> i32
      %35 = wave.binary muli %34, %c4_i32 : i32, i32 -> i32
      %36 = wave.binary subi %26, %35 : i32, i32 -> i32
      %37 = arith.cmpi slt, %36, %c4_i32 : i32
      %38 = wave.select %37, %36, %c4_i32 : i32
      %39 = arith.cmpi sgt, %38, %c0_i32 : i32
      %40 = wave.assume %38 as "x" [#wave.pred<"-1 + x >= 0">] : i32
      %41 = wave.binary remsi %32, %33 : i32, i32 -> i32
      %42 = wave.binary remsi %41, %40 : i32, i32 -> i32
      %43 = wave.binary addi %35, %42 : i32, i32 -> i32
      %44 = wave.binary divsi %41, %40 : i32, i32 -> i32
      %45 = wave.alloc() {align = 16 : i64, bytesize = 67552 : i64} : !wave.ptr<#wave.shared, i8>
      %46 = wave.alloc() {align = 16 : i64, bytesize = 33760 : i64} : !wave.ptr<#wave.shared, i8>
      %47 = wave.alloc() {align = 16 : i64, bytesize = 33760 : i64} : !wave.ptr<#wave.shared, i8>
      %48 = wave.alloc() {align = 16 : i64, bytesize = 2048 : i64} : !wave.ptr<#wave.shared, i8>
      %49 = wave.alloc() {align = 16 : i64, bytesize = 1024 : i64} : !wave.ptr<#wave.shared, i8>
      %50 = wave.cluster_workgroup_id x
      %51 = wave.index_expr <"8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %52 = wave.cast intconvert %51 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %53 = wave.index_expr <"1 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %54 = wave.cast intconvert %53 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %55 = wave.index_expr <"2 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %56 = wave.cast intconvert %55 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %57 = wave.index_expr <"3 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %58 = wave.cast intconvert %57 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %59 = wave.index_expr <"4 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %60 = wave.cast intconvert %59 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %61 = wave.index_expr <"5 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %62 = wave.cast intconvert %61 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %63 = wave.index_expr <"6 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %64 = wave.cast intconvert %63 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %65 = wave.index_expr <"7 + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %66 = wave.cast intconvert %65 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %67 = wave.cluster_workgroup_id x
      %68 = wave.index_expr <"4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %69 = wave.cast intconvert %68 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %70 = wave.index_expr <"16 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %71 = wave.cast intconvert %70 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %72 = wave.index_expr <"32 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %73 = wave.cast intconvert %72 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %74 = wave.index_expr <"48 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %75 = wave.cast intconvert %74 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %76 = wave.index_expr <"64 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %77 = wave.cast intconvert %76 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %78 = wave.index_expr <"80 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %79 = wave.cast intconvert %78 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %80 = wave.index_expr <"96 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %81 = wave.cast intconvert %80 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %82 = wave.index_expr <"112 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %83 = wave.cast intconvert %82 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %84 = wave.index_expr <"128 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %85 = wave.cast intconvert %84 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %86 = wave.index_expr <"144 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %87 = wave.cast intconvert %86 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %88 = wave.index_expr <"160 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %89 = wave.cast intconvert %88 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %90 = wave.index_expr <"176 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %91 = wave.cast intconvert %90 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %92 = wave.index_expr <"192 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %93 = wave.cast intconvert %92 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %94 = wave.index_expr <"208 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %95 = wave.cast intconvert %94 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %96 = wave.index_expr <"224 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %97 = wave.cast intconvert %96 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %98 = wave.index_expr <"240 + 4*floor(1/64*item) + floor(1/16*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %99 = wave.cast intconvert %98 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %100 = wave.cluster_workgroup_id x
      %101 = wave.index_expr <"4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %102 = wave.cast intconvert %101 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %103 = wave.index_expr <"1 + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %104 = wave.cast intconvert %103 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %105 = wave.index_expr <"2 + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %106 = wave.cast intconvert %105 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %107 = wave.index_expr <"3 + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %108 = wave.cast intconvert %107 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %109 = wave.cluster_workgroup_id x
      %110 = wave.index_expr <"8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %111 = wave.cast intconvert %110 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %112 = wave.index_expr <"1 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %113 = wave.cast intconvert %112 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %114 = wave.index_expr <"2 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %115 = wave.cast intconvert %114 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %116 = wave.index_expr <"3 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %117 = wave.cast intconvert %116 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %118 = wave.index_expr <"4 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %119 = wave.cast intconvert %118 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %120 = wave.index_expr <"5 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %121 = wave.cast intconvert %120 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %122 = wave.index_expr <"6 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %123 = wave.cast intconvert %122 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %124 = wave.index_expr <"7 + 8*Mod(item, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %125 = wave.cast intconvert %124 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %126 = wave.cluster_workgroup_id x
      %127 = wave.index_expr <"floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %128 = wave.cast intconvert %127 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %129 = wave.index_expr <"4 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %130 = wave.cast intconvert %129 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %131 = wave.index_expr <"8 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %132 = wave.cast intconvert %131 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %133 = wave.index_expr <"12 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %134 = wave.cast intconvert %133 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %135 = wave.index_expr <"128 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %136 = wave.cast intconvert %135 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %137 = wave.index_expr <"132 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %138 = wave.cast intconvert %137 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %139 = wave.index_expr <"136 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %140 = wave.cast intconvert %139 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %141 = wave.index_expr <"140 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %142 = wave.cast intconvert %141 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %143 = wave.pack %128, %130, %132, %134, %136, %138, %140, %142 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %144 = wave.redistribute %143, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "4*floor(1/4*slot) + 2*floor(1/2*Mod(slot, 4)) + Mod(slot, 2)"> : !wave.simd<vector<8xi32>, 64> -> !wave.simd<vector<8xi32>, 64>
      %145 = wave.extract %144[0] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %146 = wave.extract %144[1] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %147 = wave.extract %144[2] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %148 = wave.extract %144[3] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %149 = wave.extract %144[4] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %150 = wave.extract %144[5] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %151 = wave.extract %144[6] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %152 = wave.extract %144[7] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %153 = wave.splat %9 : i32 -> !wave.simd<i32, 64>
      %154 = wave.binary muli %145, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %155 = wave.binary muli %146, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %156 = wave.binary muli %147, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %157 = wave.binary muli %148, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %158 = wave.binary muli %149, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %159 = wave.binary muli %150, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %160 = wave.binary muli %151, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %161 = wave.binary muli %152, %153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %162 = wave.cluster_workgroup_id x
      %163 = wave.index_expr <"16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %164 = wave.cast intconvert %163 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %165 = wave.index_expr <"1 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %166 = wave.cast intconvert %165 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %167 = wave.index_expr <"2 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %168 = wave.cast intconvert %167 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %169 = wave.index_expr <"3 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %170 = wave.cast intconvert %169 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %171 = wave.index_expr <"4 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %172 = wave.cast intconvert %171 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %173 = wave.index_expr <"5 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %174 = wave.cast intconvert %173 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %175 = wave.index_expr <"6 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %176 = wave.cast intconvert %175 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %177 = wave.index_expr <"7 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %178 = wave.cast intconvert %177 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %179 = wave.index_expr <"8 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %180 = wave.cast intconvert %179 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %181 = wave.index_expr <"9 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %182 = wave.cast intconvert %181 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %183 = wave.index_expr <"10 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %184 = wave.cast intconvert %183 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %185 = wave.index_expr <"11 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %186 = wave.cast intconvert %185 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %187 = wave.index_expr <"12 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %188 = wave.cast intconvert %187 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %189 = wave.index_expr <"13 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %190 = wave.cast intconvert %189 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %191 = wave.index_expr <"14 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %192 = wave.cast intconvert %191 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %193 = wave.index_expr <"15 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %194 = wave.cast intconvert %193 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %195 = wave.cluster_workgroup_id x
      %196 = wave.index_expr <"16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %197 = wave.cast intconvert %196 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %198 = wave.index_expr <"1 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %199 = wave.cast intconvert %198 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %200 = wave.index_expr <"2 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %201 = wave.cast intconvert %200 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %202 = wave.index_expr <"3 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %203 = wave.cast intconvert %202 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %204 = wave.index_expr <"4 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %205 = wave.cast intconvert %204 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %206 = wave.index_expr <"5 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %207 = wave.cast intconvert %206 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %208 = wave.index_expr <"6 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %209 = wave.cast intconvert %208 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %210 = wave.index_expr <"7 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %211 = wave.cast intconvert %210 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %212 = wave.index_expr <"8 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %213 = wave.cast intconvert %212 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %214 = wave.index_expr <"9 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %215 = wave.cast intconvert %214 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %216 = wave.index_expr <"10 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %217 = wave.cast intconvert %216 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %218 = wave.index_expr <"11 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %219 = wave.cast intconvert %218 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %220 = wave.index_expr <"12 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %221 = wave.cast intconvert %220 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %222 = wave.index_expr <"13 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %223 = wave.cast intconvert %222 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %224 = wave.index_expr <"14 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %225 = wave.cast intconvert %224 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %226 = wave.index_expr <"15 + 16*Mod(item, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2)"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %227 = wave.cast intconvert %226 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %228 = wave.pack %164, %166, %168, %170, %172, %174, %176, %178, %180, %182, %184, %186, %188, %190, %192, %194 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<16xi32>, 64>
      %229 = wave.redistribute %228, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<16xi32>, 64> -> !wave.simd<vector<16xi32>, 64>
      %230 = wave.extract %229[0] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %231 = wave.extract %229[1] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %232 = wave.extract %229[2] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %233 = wave.extract %229[3] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %234 = wave.extract %229[4] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %235 = wave.extract %229[5] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %236 = wave.extract %229[6] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %237 = wave.extract %229[7] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %238 = wave.extract %229[8] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %239 = wave.extract %229[9] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %240 = wave.extract %229[10] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %241 = wave.extract %229[11] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %242 = wave.extract %229[12] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %243 = wave.extract %229[13] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %244 = wave.extract %229[14] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %245 = wave.extract %229[15] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %246 = wave.pack %197, %199, %201, %203, %205, %207, %209, %211, %213, %215, %217, %219, %221, %223, %225, %227 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<16xi32>, 64>
      %247 = wave.redistribute %246, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<16xi32>, 64> -> !wave.simd<vector<16xi32>, 64>
      %248 = wave.extract %247[0] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %249 = wave.extract %247[1] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %250 = wave.extract %247[2] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %251 = wave.extract %247[3] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %252 = wave.extract %247[4] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %253 = wave.extract %247[5] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %254 = wave.extract %247[6] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %255 = wave.extract %247[7] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %256 = wave.extract %247[8] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %257 = wave.extract %247[9] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %258 = wave.extract %247[10] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %259 = wave.extract %247[11] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %260 = wave.extract %247[12] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %261 = wave.extract %247[13] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %262 = wave.extract %247[14] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %263 = wave.extract %247[15] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %264 = wave.pack %154, %155, %156, %157, %158, %159, %160, %161 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %265 = wave.redistribute %264, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "floor(1/16*slot)"> : !wave.simd<vector<8xi32>, 64> -> !wave.simd<vector<128xi32>, 64>
      %266 = wave.extract %265[0] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %267 = wave.extract %265[1] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %268 = wave.extract %265[2] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %269 = wave.extract %265[3] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %270 = wave.extract %265[4] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %271 = wave.extract %265[5] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %272 = wave.extract %265[6] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %273 = wave.extract %265[7] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %274 = wave.extract %265[8] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %275 = wave.extract %265[9] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %276 = wave.extract %265[10] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %277 = wave.extract %265[11] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %278 = wave.extract %265[12] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %279 = wave.extract %265[13] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %280 = wave.extract %265[14] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %281 = wave.extract %265[15] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %282 = wave.extract %265[16] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %283 = wave.extract %265[17] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %284 = wave.extract %265[18] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %285 = wave.extract %265[19] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %286 = wave.extract %265[20] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %287 = wave.extract %265[21] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %288 = wave.extract %265[22] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %289 = wave.extract %265[23] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %290 = wave.extract %265[24] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %291 = wave.extract %265[25] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %292 = wave.extract %265[26] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %293 = wave.extract %265[27] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %294 = wave.extract %265[28] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %295 = wave.extract %265[29] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %296 = wave.extract %265[30] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %297 = wave.extract %265[31] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %298 = wave.extract %265[32] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %299 = wave.extract %265[33] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %300 = wave.extract %265[34] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %301 = wave.extract %265[35] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %302 = wave.extract %265[36] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %303 = wave.extract %265[37] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %304 = wave.extract %265[38] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %305 = wave.extract %265[39] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %306 = wave.extract %265[40] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %307 = wave.extract %265[41] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %308 = wave.extract %265[42] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %309 = wave.extract %265[43] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %310 = wave.extract %265[44] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %311 = wave.extract %265[45] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %312 = wave.extract %265[46] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %313 = wave.extract %265[47] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %314 = wave.extract %265[48] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %315 = wave.extract %265[49] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %316 = wave.extract %265[50] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %317 = wave.extract %265[51] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %318 = wave.extract %265[52] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %319 = wave.extract %265[53] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %320 = wave.extract %265[54] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %321 = wave.extract %265[55] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %322 = wave.extract %265[56] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %323 = wave.extract %265[57] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %324 = wave.extract %265[58] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %325 = wave.extract %265[59] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %326 = wave.extract %265[60] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %327 = wave.extract %265[61] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %328 = wave.extract %265[62] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %329 = wave.extract %265[63] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %330 = wave.extract %265[64] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %331 = wave.extract %265[65] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %332 = wave.extract %265[66] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %333 = wave.extract %265[67] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %334 = wave.extract %265[68] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %335 = wave.extract %265[69] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %336 = wave.extract %265[70] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %337 = wave.extract %265[71] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %338 = wave.extract %265[72] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %339 = wave.extract %265[73] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %340 = wave.extract %265[74] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %341 = wave.extract %265[75] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %342 = wave.extract %265[76] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %343 = wave.extract %265[77] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %344 = wave.extract %265[78] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %345 = wave.extract %265[79] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %346 = wave.extract %265[80] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %347 = wave.extract %265[81] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %348 = wave.extract %265[82] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %349 = wave.extract %265[83] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %350 = wave.extract %265[84] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %351 = wave.extract %265[85] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %352 = wave.extract %265[86] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %353 = wave.extract %265[87] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %354 = wave.extract %265[88] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %355 = wave.extract %265[89] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %356 = wave.extract %265[90] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %357 = wave.extract %265[91] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %358 = wave.extract %265[92] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %359 = wave.extract %265[93] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %360 = wave.extract %265[94] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %361 = wave.extract %265[95] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %362 = wave.extract %265[96] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %363 = wave.extract %265[97] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %364 = wave.extract %265[98] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %365 = wave.extract %265[99] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %366 = wave.extract %265[100] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %367 = wave.extract %265[101] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %368 = wave.extract %265[102] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %369 = wave.extract %265[103] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %370 = wave.extract %265[104] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %371 = wave.extract %265[105] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %372 = wave.extract %265[106] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %373 = wave.extract %265[107] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %374 = wave.extract %265[108] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %375 = wave.extract %265[109] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %376 = wave.extract %265[110] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %377 = wave.extract %265[111] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %378 = wave.extract %265[112] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %379 = wave.extract %265[113] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %380 = wave.extract %265[114] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %381 = wave.extract %265[115] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %382 = wave.extract %265[116] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %383 = wave.extract %265[117] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %384 = wave.extract %265[118] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %385 = wave.extract %265[119] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %386 = wave.extract %265[120] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %387 = wave.extract %265[121] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %388 = wave.extract %265[122] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %389 = wave.extract %265[123] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %390 = wave.extract %265[124] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %391 = wave.extract %265[125] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %392 = wave.extract %265[126] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %393 = wave.extract %265[127] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %394 = wave.pack %230, %231, %232, %233, %234, %235, %236, %237, %238, %239, %240, %241, %242, %243, %244, %245 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<16xi32>, 64>
      %395 = wave.redistribute %394, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "2*floor(1/2*Mod(slot, 16)) + Mod(slot, 2)"> : !wave.simd<vector<16xi32>, 64> -> !wave.simd<vector<128xi32>, 64>
      %396 = wave.extract %395[0] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %397 = wave.extract %395[1] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %398 = wave.extract %395[2] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %399 = wave.extract %395[3] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %400 = wave.extract %395[4] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %401 = wave.extract %395[5] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %402 = wave.extract %395[6] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %403 = wave.extract %395[7] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %404 = wave.extract %395[8] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %405 = wave.extract %395[9] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %406 = wave.extract %395[10] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %407 = wave.extract %395[11] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %408 = wave.extract %395[12] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %409 = wave.extract %395[13] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %410 = wave.extract %395[14] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %411 = wave.extract %395[15] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %412 = wave.extract %395[16] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %413 = wave.extract %395[17] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %414 = wave.extract %395[18] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %415 = wave.extract %395[19] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %416 = wave.extract %395[20] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %417 = wave.extract %395[21] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %418 = wave.extract %395[22] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %419 = wave.extract %395[23] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %420 = wave.extract %395[24] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %421 = wave.extract %395[25] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %422 = wave.extract %395[26] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %423 = wave.extract %395[27] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %424 = wave.extract %395[28] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %425 = wave.extract %395[29] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %426 = wave.extract %395[30] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %427 = wave.extract %395[31] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %428 = wave.extract %395[32] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %429 = wave.extract %395[33] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %430 = wave.extract %395[34] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %431 = wave.extract %395[35] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %432 = wave.extract %395[36] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %433 = wave.extract %395[37] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %434 = wave.extract %395[38] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %435 = wave.extract %395[39] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %436 = wave.extract %395[40] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %437 = wave.extract %395[41] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %438 = wave.extract %395[42] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %439 = wave.extract %395[43] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %440 = wave.extract %395[44] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %441 = wave.extract %395[45] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %442 = wave.extract %395[46] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %443 = wave.extract %395[47] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %444 = wave.extract %395[48] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %445 = wave.extract %395[49] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %446 = wave.extract %395[50] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %447 = wave.extract %395[51] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %448 = wave.extract %395[52] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %449 = wave.extract %395[53] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %450 = wave.extract %395[54] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %451 = wave.extract %395[55] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %452 = wave.extract %395[56] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %453 = wave.extract %395[57] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %454 = wave.extract %395[58] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %455 = wave.extract %395[59] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %456 = wave.extract %395[60] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %457 = wave.extract %395[61] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %458 = wave.extract %395[62] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %459 = wave.extract %395[63] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %460 = wave.extract %395[64] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %461 = wave.extract %395[65] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %462 = wave.extract %395[66] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %463 = wave.extract %395[67] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %464 = wave.extract %395[68] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %465 = wave.extract %395[69] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %466 = wave.extract %395[70] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %467 = wave.extract %395[71] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %468 = wave.extract %395[72] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %469 = wave.extract %395[73] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %470 = wave.extract %395[74] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %471 = wave.extract %395[75] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %472 = wave.extract %395[76] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %473 = wave.extract %395[77] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %474 = wave.extract %395[78] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %475 = wave.extract %395[79] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %476 = wave.extract %395[80] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %477 = wave.extract %395[81] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %478 = wave.extract %395[82] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %479 = wave.extract %395[83] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %480 = wave.extract %395[84] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %481 = wave.extract %395[85] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %482 = wave.extract %395[86] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %483 = wave.extract %395[87] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %484 = wave.extract %395[88] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %485 = wave.extract %395[89] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %486 = wave.extract %395[90] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %487 = wave.extract %395[91] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %488 = wave.extract %395[92] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %489 = wave.extract %395[93] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %490 = wave.extract %395[94] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %491 = wave.extract %395[95] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %492 = wave.extract %395[96] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %493 = wave.extract %395[97] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %494 = wave.extract %395[98] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %495 = wave.extract %395[99] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %496 = wave.extract %395[100] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %497 = wave.extract %395[101] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %498 = wave.extract %395[102] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %499 = wave.extract %395[103] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %500 = wave.extract %395[104] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %501 = wave.extract %395[105] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %502 = wave.extract %395[106] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %503 = wave.extract %395[107] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %504 = wave.extract %395[108] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %505 = wave.extract %395[109] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %506 = wave.extract %395[110] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %507 = wave.extract %395[111] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %508 = wave.extract %395[112] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %509 = wave.extract %395[113] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %510 = wave.extract %395[114] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %511 = wave.extract %395[115] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %512 = wave.extract %395[116] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %513 = wave.extract %395[117] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %514 = wave.extract %395[118] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %515 = wave.extract %395[119] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %516 = wave.extract %395[120] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %517 = wave.extract %395[121] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %518 = wave.extract %395[122] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %519 = wave.extract %395[123] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %520 = wave.extract %395[124] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %521 = wave.extract %395[125] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %522 = wave.extract %395[126] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %523 = wave.extract %395[127] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %524 = wave.binary addi %266, %396 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %525 = wave.binary addi %267, %397 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %526 = wave.binary addi %268, %398 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %527 = wave.binary addi %269, %399 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %528 = wave.binary addi %270, %400 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %529 = wave.binary addi %271, %401 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %530 = wave.binary addi %272, %402 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %531 = wave.binary addi %273, %403 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %532 = wave.binary addi %274, %404 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %533 = wave.binary addi %275, %405 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %534 = wave.binary addi %276, %406 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %535 = wave.binary addi %277, %407 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %536 = wave.binary addi %278, %408 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %537 = wave.binary addi %279, %409 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %538 = wave.binary addi %280, %410 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %539 = wave.binary addi %281, %411 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %540 = wave.binary addi %282, %412 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %541 = wave.binary addi %283, %413 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %542 = wave.binary addi %284, %414 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %543 = wave.binary addi %285, %415 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %544 = wave.binary addi %286, %416 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %545 = wave.binary addi %287, %417 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %546 = wave.binary addi %288, %418 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %547 = wave.binary addi %289, %419 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %548 = wave.binary addi %290, %420 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %549 = wave.binary addi %291, %421 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %550 = wave.binary addi %292, %422 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %551 = wave.binary addi %293, %423 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %552 = wave.binary addi %294, %424 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %553 = wave.binary addi %295, %425 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %554 = wave.binary addi %296, %426 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %555 = wave.binary addi %297, %427 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %556 = wave.binary addi %298, %428 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %557 = wave.binary addi %299, %429 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %558 = wave.binary addi %300, %430 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %559 = wave.binary addi %301, %431 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %560 = wave.binary addi %302, %432 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %561 = wave.binary addi %303, %433 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %562 = wave.binary addi %304, %434 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %563 = wave.binary addi %305, %435 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %564 = wave.binary addi %306, %436 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %565 = wave.binary addi %307, %437 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %566 = wave.binary addi %308, %438 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %567 = wave.binary addi %309, %439 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %568 = wave.binary addi %310, %440 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %569 = wave.binary addi %311, %441 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %570 = wave.binary addi %312, %442 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %571 = wave.binary addi %313, %443 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %572 = wave.binary addi %314, %444 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %573 = wave.binary addi %315, %445 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %574 = wave.binary addi %316, %446 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %575 = wave.binary addi %317, %447 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %576 = wave.binary addi %318, %448 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %577 = wave.binary addi %319, %449 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %578 = wave.binary addi %320, %450 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %579 = wave.binary addi %321, %451 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %580 = wave.binary addi %322, %452 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %581 = wave.binary addi %323, %453 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %582 = wave.binary addi %324, %454 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %583 = wave.binary addi %325, %455 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %584 = wave.binary addi %326, %456 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %585 = wave.binary addi %327, %457 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %586 = wave.binary addi %328, %458 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %587 = wave.binary addi %329, %459 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %588 = wave.binary addi %330, %460 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %589 = wave.binary addi %331, %461 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %590 = wave.binary addi %332, %462 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %591 = wave.binary addi %333, %463 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %592 = wave.binary addi %334, %464 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %593 = wave.binary addi %335, %465 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %594 = wave.binary addi %336, %466 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %595 = wave.binary addi %337, %467 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %596 = wave.binary addi %338, %468 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %597 = wave.binary addi %339, %469 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %598 = wave.binary addi %340, %470 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %599 = wave.binary addi %341, %471 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %600 = wave.binary addi %342, %472 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %601 = wave.binary addi %343, %473 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %602 = wave.binary addi %344, %474 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %603 = wave.binary addi %345, %475 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %604 = wave.binary addi %346, %476 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %605 = wave.binary addi %347, %477 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %606 = wave.binary addi %348, %478 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %607 = wave.binary addi %349, %479 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %608 = wave.binary addi %350, %480 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %609 = wave.binary addi %351, %481 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %610 = wave.binary addi %352, %482 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %611 = wave.binary addi %353, %483 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %612 = wave.binary addi %354, %484 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %613 = wave.binary addi %355, %485 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %614 = wave.binary addi %356, %486 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %615 = wave.binary addi %357, %487 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %616 = wave.binary addi %358, %488 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %617 = wave.binary addi %359, %489 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %618 = wave.binary addi %360, %490 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %619 = wave.binary addi %361, %491 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %620 = wave.binary addi %362, %492 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %621 = wave.binary addi %363, %493 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %622 = wave.binary addi %364, %494 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %623 = wave.binary addi %365, %495 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %624 = wave.binary addi %366, %496 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %625 = wave.binary addi %367, %497 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %626 = wave.binary addi %368, %498 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %627 = wave.binary addi %369, %499 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %628 = wave.binary addi %370, %500 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %629 = wave.binary addi %371, %501 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %630 = wave.binary addi %372, %502 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %631 = wave.binary addi %373, %503 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %632 = wave.binary addi %374, %504 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %633 = wave.binary addi %375, %505 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %634 = wave.binary addi %376, %506 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %635 = wave.binary addi %377, %507 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %636 = wave.binary addi %378, %508 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %637 = wave.binary addi %379, %509 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %638 = wave.binary addi %380, %510 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %639 = wave.binary addi %381, %511 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %640 = wave.binary addi %382, %512 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %641 = wave.binary addi %383, %513 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %642 = wave.binary addi %384, %514 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %643 = wave.binary addi %385, %515 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %644 = wave.binary addi %386, %516 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %645 = wave.binary addi %387, %517 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %646 = wave.binary addi %388, %518 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %647 = wave.binary addi %389, %519 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %648 = wave.binary addi %390, %520 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %649 = wave.binary addi %391, %521 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %650 = wave.binary addi %392, %522 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %651 = wave.binary addi %393, %523 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %652 = wave.binary addi %524, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %653 = wave.binary addi %525, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %654 = wave.binary addi %526, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %655 = wave.binary addi %527, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %656 = wave.binary addi %528, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %657 = wave.binary addi %529, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %658 = wave.binary addi %530, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %659 = wave.binary addi %531, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %660 = wave.binary addi %532, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %661 = wave.binary addi %533, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %662 = wave.binary addi %534, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %663 = wave.binary addi %535, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %664 = wave.binary addi %536, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %665 = wave.binary addi %537, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %666 = wave.binary addi %538, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %667 = wave.binary addi %539, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %668 = wave.binary addi %540, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %669 = wave.binary addi %541, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %670 = wave.binary addi %542, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %671 = wave.binary addi %543, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %672 = wave.binary addi %544, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %673 = wave.binary addi %545, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %674 = wave.binary addi %546, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %675 = wave.binary addi %547, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %676 = wave.binary addi %548, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %677 = wave.binary addi %549, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %678 = wave.binary addi %550, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %679 = wave.binary addi %551, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %680 = wave.binary addi %552, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %681 = wave.binary addi %553, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %682 = wave.binary addi %554, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %683 = wave.binary addi %555, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %684 = wave.binary addi %556, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %685 = wave.binary addi %557, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %686 = wave.binary addi %558, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %687 = wave.binary addi %559, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %688 = wave.binary addi %560, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %689 = wave.binary addi %561, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %690 = wave.binary addi %562, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %691 = wave.binary addi %563, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %692 = wave.binary addi %564, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %693 = wave.binary addi %565, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %694 = wave.binary addi %566, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %695 = wave.binary addi %567, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %696 = wave.binary addi %568, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %697 = wave.binary addi %569, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %698 = wave.binary addi %570, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %699 = wave.binary addi %571, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %700 = wave.binary addi %572, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %701 = wave.binary addi %573, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %702 = wave.binary addi %574, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %703 = wave.binary addi %575, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %704 = wave.binary addi %576, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %705 = wave.binary addi %577, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %706 = wave.binary addi %578, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %707 = wave.binary addi %579, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %708 = wave.binary addi %580, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %709 = wave.binary addi %581, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %710 = wave.binary addi %582, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %711 = wave.binary addi %583, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %712 = wave.binary addi %584, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %713 = wave.binary addi %585, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %714 = wave.binary addi %586, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %715 = wave.binary addi %587, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %716 = wave.binary addi %588, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %717 = wave.binary addi %589, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %718 = wave.binary addi %590, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %719 = wave.binary addi %591, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %720 = wave.binary addi %592, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %721 = wave.binary addi %593, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %722 = wave.binary addi %594, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %723 = wave.binary addi %595, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %724 = wave.binary addi %596, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %725 = wave.binary addi %597, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %726 = wave.binary addi %598, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %727 = wave.binary addi %599, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %728 = wave.binary addi %600, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %729 = wave.binary addi %601, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %730 = wave.binary addi %602, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %731 = wave.binary addi %603, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %732 = wave.binary addi %604, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %733 = wave.binary addi %605, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %734 = wave.binary addi %606, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %735 = wave.binary addi %607, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %736 = wave.binary addi %608, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %737 = wave.binary addi %609, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %738 = wave.binary addi %610, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %739 = wave.binary addi %611, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %740 = wave.binary addi %612, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %741 = wave.binary addi %613, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %742 = wave.binary addi %614, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %743 = wave.binary addi %615, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %744 = wave.binary addi %616, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %745 = wave.binary addi %617, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %746 = wave.binary addi %618, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %747 = wave.binary addi %619, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %748 = wave.binary addi %620, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %749 = wave.binary addi %621, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %750 = wave.binary addi %622, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %751 = wave.binary addi %623, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %752 = wave.binary addi %624, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %753 = wave.binary addi %625, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %754 = wave.binary addi %626, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %755 = wave.binary addi %627, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %756 = wave.binary addi %628, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %757 = wave.binary addi %629, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %758 = wave.binary addi %630, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %759 = wave.binary addi %631, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %760 = wave.binary addi %632, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %761 = wave.binary addi %633, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %762 = wave.binary addi %634, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %763 = wave.binary addi %635, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %764 = wave.binary addi %636, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %765 = wave.binary addi %637, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %766 = wave.binary addi %638, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %767 = wave.binary addi %639, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %768 = wave.binary addi %640, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %769 = wave.binary addi %641, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %770 = wave.binary addi %642, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %771 = wave.binary addi %643, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %772 = wave.binary addi %644, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %773 = wave.binary addi %645, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %774 = wave.binary addi %646, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %775 = wave.binary addi %647, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %776 = wave.binary addi %648, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %777 = wave.binary addi %649, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %778 = wave.binary addi %650, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %779 = wave.binary addi %651, %23 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %780 = wave.binary muli %43, %c256_i32 : i32, i32 -> i32
      %781 = wave.binary muli %780, %9 : i32, i32 -> i32
      %782 = wave.cluster_workgroup_id x
      %783 = wave.index_expr <"floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %784 = wave.cast intconvert %783 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %785 = wave.index_expr <"4 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %786 = wave.cast intconvert %785 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %787 = wave.index_expr <"8 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %788 = wave.cast intconvert %787 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %789 = wave.index_expr <"12 + floor(1/64*item) + 16*floor(1/8*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %790 = wave.cast intconvert %789 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %791 = wave.pack %784, %786, %788, %790 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<4xi32>, 64>
      %792 = wave.redistribute %791, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<4xi32>, 64> -> !wave.simd<vector<4xi32>, 64>
      %793 = wave.extract %792[0] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %794 = wave.extract %792[1] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %795 = wave.extract %792[2] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %796 = wave.extract %792[3] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %797 = wave.splat %11 : i32 -> !wave.simd<i32, 64>
      %798 = wave.binary muli %793, %797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %799 = wave.binary muli %794, %797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %800 = wave.binary muli %795, %797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %801 = wave.binary muli %796, %797 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %802 = wave.pack %798, %799, %800, %801 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<4xi32>, 64>
      %803 = wave.redistribute %802, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "floor(1/16*slot)"> : !wave.simd<vector<4xi32>, 64> -> !wave.simd<vector<64xi32>, 64>
      %804 = wave.extract %803[0] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %805 = wave.extract %803[1] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %806 = wave.extract %803[2] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %807 = wave.extract %803[3] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %808 = wave.extract %803[4] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %809 = wave.extract %803[5] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %810 = wave.extract %803[6] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %811 = wave.extract %803[7] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %812 = wave.extract %803[8] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %813 = wave.extract %803[9] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %814 = wave.extract %803[10] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %815 = wave.extract %803[11] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %816 = wave.extract %803[12] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %817 = wave.extract %803[13] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %818 = wave.extract %803[14] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %819 = wave.extract %803[15] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %820 = wave.extract %803[16] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %821 = wave.extract %803[17] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %822 = wave.extract %803[18] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %823 = wave.extract %803[19] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %824 = wave.extract %803[20] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %825 = wave.extract %803[21] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %826 = wave.extract %803[22] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %827 = wave.extract %803[23] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %828 = wave.extract %803[24] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %829 = wave.extract %803[25] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %830 = wave.extract %803[26] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %831 = wave.extract %803[27] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %832 = wave.extract %803[28] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %833 = wave.extract %803[29] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %834 = wave.extract %803[30] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %835 = wave.extract %803[31] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %836 = wave.extract %803[32] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %837 = wave.extract %803[33] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %838 = wave.extract %803[34] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %839 = wave.extract %803[35] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %840 = wave.extract %803[36] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %841 = wave.extract %803[37] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %842 = wave.extract %803[38] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %843 = wave.extract %803[39] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %844 = wave.extract %803[40] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %845 = wave.extract %803[41] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %846 = wave.extract %803[42] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %847 = wave.extract %803[43] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %848 = wave.extract %803[44] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %849 = wave.extract %803[45] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %850 = wave.extract %803[46] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %851 = wave.extract %803[47] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %852 = wave.extract %803[48] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %853 = wave.extract %803[49] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %854 = wave.extract %803[50] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %855 = wave.extract %803[51] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %856 = wave.extract %803[52] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %857 = wave.extract %803[53] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %858 = wave.extract %803[54] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %859 = wave.extract %803[55] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %860 = wave.extract %803[56] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %861 = wave.extract %803[57] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %862 = wave.extract %803[58] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %863 = wave.extract %803[59] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %864 = wave.extract %803[60] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %865 = wave.extract %803[61] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %866 = wave.extract %803[62] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %867 = wave.extract %803[63] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %868 = wave.pack %248, %249, %250, %251, %252, %253, %254, %255, %256, %257, %258, %259, %260, %261, %262, %263 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<16xi32>, 64>
      %869 = wave.redistribute %868, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "2*floor(1/2*Mod(slot, 16)) + Mod(slot, 2)"> : !wave.simd<vector<16xi32>, 64> -> !wave.simd<vector<64xi32>, 64>
      %870 = wave.extract %869[0] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %871 = wave.extract %869[1] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %872 = wave.extract %869[2] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %873 = wave.extract %869[3] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %874 = wave.extract %869[4] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %875 = wave.extract %869[5] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %876 = wave.extract %869[6] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %877 = wave.extract %869[7] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %878 = wave.extract %869[8] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %879 = wave.extract %869[9] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %880 = wave.extract %869[10] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %881 = wave.extract %869[11] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %882 = wave.extract %869[12] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %883 = wave.extract %869[13] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %884 = wave.extract %869[14] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %885 = wave.extract %869[15] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %886 = wave.extract %869[16] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %887 = wave.extract %869[17] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %888 = wave.extract %869[18] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %889 = wave.extract %869[19] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %890 = wave.extract %869[20] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %891 = wave.extract %869[21] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %892 = wave.extract %869[22] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %893 = wave.extract %869[23] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %894 = wave.extract %869[24] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %895 = wave.extract %869[25] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %896 = wave.extract %869[26] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %897 = wave.extract %869[27] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %898 = wave.extract %869[28] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %899 = wave.extract %869[29] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %900 = wave.extract %869[30] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %901 = wave.extract %869[31] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %902 = wave.extract %869[32] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %903 = wave.extract %869[33] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %904 = wave.extract %869[34] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %905 = wave.extract %869[35] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %906 = wave.extract %869[36] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %907 = wave.extract %869[37] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %908 = wave.extract %869[38] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %909 = wave.extract %869[39] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %910 = wave.extract %869[40] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %911 = wave.extract %869[41] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %912 = wave.extract %869[42] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %913 = wave.extract %869[43] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %914 = wave.extract %869[44] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %915 = wave.extract %869[45] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %916 = wave.extract %869[46] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %917 = wave.extract %869[47] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %918 = wave.extract %869[48] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %919 = wave.extract %869[49] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %920 = wave.extract %869[50] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %921 = wave.extract %869[51] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %922 = wave.extract %869[52] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %923 = wave.extract %869[53] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %924 = wave.extract %869[54] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %925 = wave.extract %869[55] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %926 = wave.extract %869[56] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %927 = wave.extract %869[57] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %928 = wave.extract %869[58] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %929 = wave.extract %869[59] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %930 = wave.extract %869[60] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %931 = wave.extract %869[61] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %932 = wave.extract %869[62] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %933 = wave.extract %869[63] : !wave.simd<vector<64xi32>, 64> -> !wave.simd<i32, 64>
      %934 = wave.binary addi %804, %870 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %935 = wave.binary addi %805, %871 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %936 = wave.binary addi %806, %872 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %937 = wave.binary addi %807, %873 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %938 = wave.binary addi %808, %874 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %939 = wave.binary addi %809, %875 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %940 = wave.binary addi %810, %876 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %941 = wave.binary addi %811, %877 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %942 = wave.binary addi %812, %878 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %943 = wave.binary addi %813, %879 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %944 = wave.binary addi %814, %880 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %945 = wave.binary addi %815, %881 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %946 = wave.binary addi %816, %882 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %947 = wave.binary addi %817, %883 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %948 = wave.binary addi %818, %884 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %949 = wave.binary addi %819, %885 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %950 = wave.binary addi %820, %886 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %951 = wave.binary addi %821, %887 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %952 = wave.binary addi %822, %888 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %953 = wave.binary addi %823, %889 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %954 = wave.binary addi %824, %890 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %955 = wave.binary addi %825, %891 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %956 = wave.binary addi %826, %892 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %957 = wave.binary addi %827, %893 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %958 = wave.binary addi %828, %894 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %959 = wave.binary addi %829, %895 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %960 = wave.binary addi %830, %896 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %961 = wave.binary addi %831, %897 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %962 = wave.binary addi %832, %898 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %963 = wave.binary addi %833, %899 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %964 = wave.binary addi %834, %900 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %965 = wave.binary addi %835, %901 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %966 = wave.binary addi %836, %902 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %967 = wave.binary addi %837, %903 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %968 = wave.binary addi %838, %904 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %969 = wave.binary addi %839, %905 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %970 = wave.binary addi %840, %906 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %971 = wave.binary addi %841, %907 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %972 = wave.binary addi %842, %908 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %973 = wave.binary addi %843, %909 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %974 = wave.binary addi %844, %910 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %975 = wave.binary addi %845, %911 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %976 = wave.binary addi %846, %912 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %977 = wave.binary addi %847, %913 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %978 = wave.binary addi %848, %914 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %979 = wave.binary addi %849, %915 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %980 = wave.binary addi %850, %916 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %981 = wave.binary addi %851, %917 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %982 = wave.binary addi %852, %918 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %983 = wave.binary addi %853, %919 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %984 = wave.binary addi %854, %920 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %985 = wave.binary addi %855, %921 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %986 = wave.binary addi %856, %922 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %987 = wave.binary addi %857, %923 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %988 = wave.binary addi %858, %924 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %989 = wave.binary addi %859, %925 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %990 = wave.binary addi %860, %926 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %991 = wave.binary addi %861, %927 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %992 = wave.binary addi %862, %928 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %993 = wave.binary addi %863, %929 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %994 = wave.binary addi %864, %930 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %995 = wave.binary addi %865, %931 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %996 = wave.binary addi %866, %932 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %997 = wave.binary addi %867, %933 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %998 = wave.binary muli %11, %c128_i32 : i32, i32 -> i32
      %999 = wave.splat %998 : i32 -> !wave.simd<i32, 64>
      %1000 = wave.binary addi %934, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1001 = wave.binary addi %935, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1002 = wave.binary addi %936, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1003 = wave.binary addi %937, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1004 = wave.binary addi %938, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1005 = wave.binary addi %939, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1006 = wave.binary addi %940, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1007 = wave.binary addi %941, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1008 = wave.binary addi %942, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1009 = wave.binary addi %943, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1010 = wave.binary addi %944, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1011 = wave.binary addi %945, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1012 = wave.binary addi %946, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1013 = wave.binary addi %947, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1014 = wave.binary addi %948, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1015 = wave.binary addi %949, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1016 = wave.binary addi %950, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1017 = wave.binary addi %951, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1018 = wave.binary addi %952, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1019 = wave.binary addi %953, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1020 = wave.binary addi %954, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1021 = wave.binary addi %955, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1022 = wave.binary addi %956, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1023 = wave.binary addi %957, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1024 = wave.binary addi %958, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1025 = wave.binary addi %959, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1026 = wave.binary addi %960, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1027 = wave.binary addi %961, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1028 = wave.binary addi %962, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1029 = wave.binary addi %963, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1030 = wave.binary addi %964, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1031 = wave.binary addi %965, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1032 = wave.binary addi %966, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1033 = wave.binary addi %967, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1034 = wave.binary addi %968, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1035 = wave.binary addi %969, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1036 = wave.binary addi %970, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1037 = wave.binary addi %971, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1038 = wave.binary addi %972, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1039 = wave.binary addi %973, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1040 = wave.binary addi %974, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1041 = wave.binary addi %975, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1042 = wave.binary addi %976, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1043 = wave.binary addi %977, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1044 = wave.binary addi %978, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1045 = wave.binary addi %979, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1046 = wave.binary addi %980, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1047 = wave.binary addi %981, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1048 = wave.binary addi %982, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1049 = wave.binary addi %983, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1050 = wave.binary addi %984, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1051 = wave.binary addi %985, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1052 = wave.binary addi %986, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1053 = wave.binary addi %987, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1054 = wave.binary addi %988, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1055 = wave.binary addi %989, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1056 = wave.binary addi %990, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1057 = wave.binary addi %991, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1058 = wave.binary addi %992, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1059 = wave.binary addi %993, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1060 = wave.binary addi %994, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1061 = wave.binary addi %995, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1062 = wave.binary addi %996, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1063 = wave.binary addi %997, %999 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1064 = wave.binary addi %934, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1065 = wave.binary addi %935, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1066 = wave.binary addi %936, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1067 = wave.binary addi %937, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1068 = wave.binary addi %938, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1069 = wave.binary addi %939, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1070 = wave.binary addi %940, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1071 = wave.binary addi %941, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1072 = wave.binary addi %942, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1073 = wave.binary addi %943, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1074 = wave.binary addi %944, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1075 = wave.binary addi %945, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1076 = wave.binary addi %946, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1077 = wave.binary addi %947, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1078 = wave.binary addi %948, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1079 = wave.binary addi %949, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1080 = wave.binary addi %950, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1081 = wave.binary addi %951, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1082 = wave.binary addi %952, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1083 = wave.binary addi %953, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1084 = wave.binary addi %954, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1085 = wave.binary addi %955, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1086 = wave.binary addi %956, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1087 = wave.binary addi %957, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1088 = wave.binary addi %958, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1089 = wave.binary addi %959, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1090 = wave.binary addi %960, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1091 = wave.binary addi %961, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1092 = wave.binary addi %962, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1093 = wave.binary addi %963, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1094 = wave.binary addi %964, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1095 = wave.binary addi %965, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1096 = wave.binary addi %966, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1097 = wave.binary addi %967, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1098 = wave.binary addi %968, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1099 = wave.binary addi %969, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1100 = wave.binary addi %970, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1101 = wave.binary addi %971, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1102 = wave.binary addi %972, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1103 = wave.binary addi %973, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1104 = wave.binary addi %974, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1105 = wave.binary addi %975, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1106 = wave.binary addi %976, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1107 = wave.binary addi %977, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1108 = wave.binary addi %978, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1109 = wave.binary addi %979, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1110 = wave.binary addi %980, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1111 = wave.binary addi %981, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1112 = wave.binary addi %982, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1113 = wave.binary addi %983, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1114 = wave.binary addi %984, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1115 = wave.binary addi %985, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1116 = wave.binary addi %986, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1117 = wave.binary addi %987, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1118 = wave.binary addi %988, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1119 = wave.binary addi %989, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1120 = wave.binary addi %990, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1121 = wave.binary addi %991, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1122 = wave.binary addi %992, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1123 = wave.binary addi %993, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1124 = wave.binary addi %994, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1125 = wave.binary addi %995, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1126 = wave.binary addi %996, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1127 = wave.binary addi %997, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1128 = wave.binary addi %1000, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1129 = wave.binary addi %1001, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1130 = wave.binary addi %1002, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1131 = wave.binary addi %1003, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1132 = wave.binary addi %1004, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1133 = wave.binary addi %1005, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1134 = wave.binary addi %1006, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1135 = wave.binary addi %1007, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1136 = wave.binary addi %1008, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1137 = wave.binary addi %1009, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1138 = wave.binary addi %1010, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1139 = wave.binary addi %1011, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1140 = wave.binary addi %1012, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1141 = wave.binary addi %1013, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1142 = wave.binary addi %1014, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1143 = wave.binary addi %1015, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1144 = wave.binary addi %1016, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1145 = wave.binary addi %1017, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1146 = wave.binary addi %1018, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1147 = wave.binary addi %1019, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1148 = wave.binary addi %1020, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1149 = wave.binary addi %1021, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1150 = wave.binary addi %1022, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1151 = wave.binary addi %1023, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1152 = wave.binary addi %1024, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1153 = wave.binary addi %1025, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1154 = wave.binary addi %1026, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1155 = wave.binary addi %1027, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1156 = wave.binary addi %1028, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1157 = wave.binary addi %1029, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1158 = wave.binary addi %1030, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1159 = wave.binary addi %1031, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1160 = wave.binary addi %1032, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1161 = wave.binary addi %1033, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1162 = wave.binary addi %1034, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1163 = wave.binary addi %1035, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1164 = wave.binary addi %1036, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1165 = wave.binary addi %1037, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1166 = wave.binary addi %1038, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1167 = wave.binary addi %1039, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1168 = wave.binary addi %1040, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1169 = wave.binary addi %1041, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1170 = wave.binary addi %1042, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1171 = wave.binary addi %1043, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1172 = wave.binary addi %1044, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1173 = wave.binary addi %1045, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1174 = wave.binary addi %1046, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1175 = wave.binary addi %1047, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1176 = wave.binary addi %1048, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1177 = wave.binary addi %1049, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1178 = wave.binary addi %1050, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1179 = wave.binary addi %1051, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1180 = wave.binary addi %1052, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1181 = wave.binary addi %1053, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1182 = wave.binary addi %1054, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1183 = wave.binary addi %1055, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1184 = wave.binary addi %1056, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1185 = wave.binary addi %1057, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1186 = wave.binary addi %1058, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1187 = wave.binary addi %1059, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1188 = wave.binary addi %1060, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1189 = wave.binary addi %1061, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1190 = wave.binary addi %1062, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1191 = wave.binary addi %1063, %22 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1192 = wave.binary muli %44, %c256_i32 : i32, i32 -> i32
      %1193 = wave.binary muli %1192, %11 : i32, i32 -> i32
      %1194 = wave.splat %780 : i32 -> !wave.simd<i32, 64>
      %1195 = wave.binary addi %1194, %52 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1196 = wave.binary addi %1194, %54 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1197 = wave.binary addi %1194, %56 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1198 = wave.binary addi %1194, %58 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1199 = wave.binary addi %1194, %60 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1200 = wave.binary addi %1194, %62 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1201 = wave.binary addi %1194, %64 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1202 = wave.binary addi %1194, %66 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1203 = wave.pack %1195, %1196, %1197, %1198, %1199, %1200, %1201, %1202 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %1204 = wave.redistribute %1203, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<8xi32>, 64> -> !wave.simd<vector<8xi32>, 64>
      %1205 = wave.extract %1204[0] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1206 = wave.extract %1204[1] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1207 = wave.extract %1204[2] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1208 = wave.extract %1204[3] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1209 = wave.extract %1204[4] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1210 = wave.extract %1204[5] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1211 = wave.extract %1204[6] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1212 = wave.extract %1204[7] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1213 = wave.cluster_workgroup_id x
      %1214 = wave.index_expr <"2*floor(1/64*item) + floor(1/32*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1215 = wave.cast intconvert %1214 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %1216 = wave.cluster_workgroup_id x
      %1217 = wave.index_expr <"2*floor(1/64*item) + floor(1/32*Mod(item, 64))"> ["item"](%1) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
      %1218 = wave.cast intconvert %1217 : !wave.simd<index, 64> -> !wave.simd<i32, 64>
      %1219 = wave.redistribute %1215, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "0"> : !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1220 = wave.redistribute %1218, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "0"> : !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1221 = wave.splat %15 : i32 -> !wave.simd<i32, 64>
      %1222 = wave.binary muli %1219, %1221 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1223 = wave.pack %1205, %1206, %1207, %1208, %1209, %1210, %1211, %1212 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %1224 = wave.redistribute %1223, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<8xi32>, 64> -> !wave.simd<vector<8xi32>, 64>
      %1225 = wave.extract %1224[0] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1226 = wave.extract %1224[1] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1227 = wave.extract %1224[2] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1228 = wave.extract %1224[3] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1229 = wave.extract %1224[4] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1230 = wave.extract %1224[5] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1231 = wave.extract %1224[6] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1232 = wave.extract %1224[7] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1233 = wave.redistribute %1222, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "0"> : !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %1234 = wave.extract %1233[0] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1235 = wave.extract %1233[1] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1236 = wave.extract %1233[2] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1237 = wave.extract %1233[3] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1238 = wave.extract %1233[4] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1239 = wave.extract %1233[5] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1240 = wave.extract %1233[6] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1241 = wave.extract %1233[7] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %1242 = wave.binary addi %1225, %1234 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1243 = wave.binary addi %1226, %1235 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1244 = wave.binary addi %1227, %1236 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1245 = wave.binary addi %1228, %1237 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1246 = wave.binary addi %1229, %1238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1247 = wave.binary addi %1230, %1239 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1248 = wave.binary addi %1231, %1240 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1249 = wave.binary addi %1232, %1241 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1250 = wave.binary muli %15, %c8_i32 : i32, i32 -> i32
      %1251 = wave.splat %1250 : i32 -> !wave.simd<i32, 64>
      %1252 = wave.binary addi %1242, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1253 = wave.binary addi %1243, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1254 = wave.binary addi %1244, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1255 = wave.binary addi %1245, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1256 = wave.binary addi %1246, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1257 = wave.binary addi %1247, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1258 = wave.binary addi %1248, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1259 = wave.binary addi %1249, %1251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1260 = wave.splat %1192 : i32 -> !wave.simd<i32, 64>
      %1261 = wave.splat %1192 : i32 -> !wave.simd<i32, 64>
      %1262 = wave.binary addi %1260, %102 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1263 = wave.binary addi %1260, %104 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1264 = wave.binary addi %1260, %106 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1265 = wave.binary addi %1260, %108 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1266 = wave.binary addi %1261, %111 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1267 = wave.binary addi %1261, %113 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1268 = wave.binary addi %1261, %115 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1269 = wave.binary addi %1261, %117 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1270 = wave.binary addi %1261, %119 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1271 = wave.binary addi %1261, %121 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1272 = wave.binary addi %1261, %123 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1273 = wave.binary addi %1261, %125 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1274 = wave.pack %1262, %1263, %1264, %1265 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<4xi32>, 64>
      %1275 = wave.redistribute %1274, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<4xi32>, 64> -> !wave.simd<vector<4xi32>, 64>
      %1276 = wave.extract %1275[0] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1277 = wave.extract %1275[1] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1278 = wave.extract %1275[2] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1279 = wave.extract %1275[3] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1280 = wave.splat %17 : i32 -> !wave.simd<i32, 64>
      %1281 = wave.binary muli %1220, %1280 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1282 = wave.pack %1276, %1277, %1278, %1279 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<4xi32>, 64>
      %1283 = wave.redistribute %1282, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<4xi32>, 64> -> !wave.simd<vector<4xi32>, 64>
      %1284 = wave.extract %1283[0] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1285 = wave.extract %1283[1] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1286 = wave.extract %1283[2] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1287 = wave.extract %1283[3] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1288 = wave.redistribute %1281, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "0"> : !wave.simd<i32, 64> -> !wave.simd<vector<4xi32>, 64>
      %1289 = wave.extract %1288[0] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1290 = wave.extract %1288[1] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1291 = wave.extract %1288[2] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1292 = wave.extract %1288[3] : !wave.simd<vector<4xi32>, 64> -> !wave.simd<i32, 64>
      %1293 = wave.binary addi %1284, %1289 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1294 = wave.binary addi %1285, %1290 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1295 = wave.binary addi %1286, %1291 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1296 = wave.binary addi %1287, %1292 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1297 = wave.binary addi %1293, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1298 = wave.binary addi %1294, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1299 = wave.binary addi %1295, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1300 = wave.binary addi %1296, %18 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1301 = wave.binary muli %17, %c8_i32 : i32, i32 -> i32
      %1302 = wave.splat %1301 : i32 -> !wave.simd<i32, 64>
      %1303 = wave.binary addi %1293, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1304 = wave.binary addi %1294, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1305 = wave.binary addi %1295, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1306 = wave.binary addi %1296, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1307 = wave.binary addi %1297, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1308 = wave.binary addi %1298, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1309 = wave.binary addi %1299, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1310 = wave.binary addi %1300, %1302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %1311 = wave.binary divsi %7, %c256_i32 : i32, i32 -> i32
      %1312 = arith.cmpi sgt, %1311, %c3_i32 : i32
      %1313 = wave.assume %1311 as "x" [#wave.pred<"-4 + x >= 0">] : i32
      %1314 = wave.index_expr <"33792*slot"> assuming [#wave.pred<"1">, #wave.pred<"slot >= 0">, #wave.pred<"-2 + slot < 0">] ["slot"](%c0_i32) : (i32) -> index
      %1315 = wave.ptr_add %45, %1314 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %1316 = wave.ptr_add %arg0, %781 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %1317 = wave.token : !wave.mem.token
      %c2147483647_i32 = arith.constant 2147483647 : i32
      %1318 = waveamd.make_buffer %1316, %c2147483647_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value, %token = wave.gather %1318 mapping <bit_offset = <"8*Mod(t8*floor(1/64*item) + 128*t8*floor(1/64*slot) + 16*t8*floor(1/8*Mod(item, 64)) + 8*t8*floor(1/2*Mod(floor(1/16*slot), 4)) + 4*t8*Mod(floor(1/16*slot), 2) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t8"](%1, %9) after %1317 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<128xi8>, 64>, !wave.mem.token)
      %1319 = wave.scatter %value to %1315 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token : (!wave.simd<vector<128xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1320 = wave.index_expr <"16896*slot"> assuming [#wave.pred<"1">, #wave.pred<"slot >= 0">, #wave.pred<"-2 + slot < 0">] ["slot"](%c0_i32) : (i32) -> index
      %1321 = wave.ptr_add %46, %1320 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %1322 = wave.ptr_add %arg1, %1193 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
      %1323 = wave.token : !wave.mem.token
      %c2147483647_i32_0 = arith.constant 2147483647 : i32
      %1324 = waveamd.make_buffer %1322, %c2147483647_i32_0 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_1, %token_2 = wave.gather %1324 mapping <bit_offset = <"8*Mod(t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9"](%1, %11) after %1323 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
      %1325 = wave.scatter %value_1 to %1321 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_2 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %c2147483647_i32_3 = arith.constant 2147483647 : i32
      %1326 = waveamd.make_buffer %arg3, %c2147483647_i32_3 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_4, %token_5 = wave.gather %1326 mapping <bit_offset = <"8*Mod(slot + t85 + 2*t11*floor(1/64*item) + t11*floor(1/32*Mod(item, 64)) + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t11", "t85"](%1, %15, %780) : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1327 = wave.extract %value_4[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1328 = wave.extract %value_4[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1329 = wave.extract %value_4[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1330 = wave.extract %value_4[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1331 = wave.extract %value_4[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1332 = wave.extract %value_4[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1333 = wave.extract %value_4[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1334 = wave.extract %value_4[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %c2147483647_i32_6 = arith.constant 2147483647 : i32
      %1335 = waveamd.make_buffer %arg4, %c2147483647_i32_6 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_7, %token_8 = wave.gather %1335 mapping <bit_offset = <"8*Mod(slot + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t99"](%1, %17, %1192) : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %1336 = wave.extract %value_7[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1337 = wave.extract %value_7[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1338 = wave.extract %value_7[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1339 = wave.extract %value_7[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1340 = wave.join %1319, %1325 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1341 = wave.index_expr <"16896*slot"> assuming [#wave.pred<"1">, #wave.pred<"slot >= 0">, #wave.pred<"-2 + slot < 0">] ["slot"](%c0_i32) : (i32) -> index
      %1342 = wave.ptr_add %47, %1341 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %1343 = wave.token : !wave.mem.token
      %c2147483647_i32_9 = arith.constant 2147483647 : i32
      %1344 = waveamd.make_buffer %1322, %c2147483647_i32_9 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_10, %token_11 = wave.gather %1344 mapping <bit_offset = <"8*Mod(t94 + t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9", "t94"](%1, %11, %998) after %1343 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
      %1345 = wave.scatter %value_10 to %1342 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_11 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %c2147483647_i32_12 = arith.constant 2147483647 : i32
      %1346 = waveamd.make_buffer %arg4, %c2147483647_i32_12 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_13, %token_14 = wave.gather %1346 mapping <bit_offset = <"8*Mod(128 + slot + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t99"](%1, %17, %1192) : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %1347 = wave.extract %value_13[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1348 = wave.extract %value_13[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1349 = wave.extract %value_13[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1350 = wave.extract %value_13[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1351 = wave.join %1345 : !wave.mem.token -> !wave.mem.token
      %1352 = wave.index_expr <"33792*slot"> assuming [#wave.pred<"1">, #wave.pred<"slot >= 0">, #wave.pred<"-2 + slot < 0">] ["slot"](%c1_i32) : (i32) -> index
      %1353 = wave.ptr_add %45, %1352 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %1354 = wave.issue_token %1319, %1325, %token_5, %token_8, %1345, %token_14 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1355 = wave.barrier : () -> !wave.mem.token
      %1356 = wave.after %1355, %1354 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1357 = wave.issue_token %1356 : !wave.mem.token -> !wave.mem.token
      %c2147483647_i32_15 = arith.constant 2147483647 : i32
      %1358 = waveamd.make_buffer %1316, %c2147483647_i32_15 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_16, %token_17 = wave.gather %1358 mapping <bit_offset = <"8*Mod(128 + t8*floor(1/64*item) + 128*t8*floor(1/64*slot) + 16*t8*floor(1/8*Mod(item, 64)) + 8*t8*floor(1/2*Mod(floor(1/16*slot), 4)) + 4*t8*Mod(floor(1/16*slot), 2) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t8"](%1, %9) after %1357 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<128xi8>, 64>, !wave.mem.token)
      %1359 = wave.scatter %value_16 to %1353 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_17 : (!wave.simd<vector<128xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1360 = wave.index_expr <"16896*slot"> assuming [#wave.pred<"1">, #wave.pred<"slot >= 0">, #wave.pred<"-2 + slot < 0">] ["slot"](%c1_i32) : (i32) -> index
      %1361 = wave.ptr_add %46, %1360 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %c2147483647_i32_18 = arith.constant 2147483647 : i32
      %1362 = waveamd.make_buffer %1322, %c2147483647_i32_18 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_19, %token_20 = wave.gather %1362 mapping <bit_offset = <"8*Mod(128 + t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9"](%1, %11) after %1357 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
      %1363 = wave.scatter %value_19 to %1361 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_20 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %c2147483647_i32_21 = arith.constant 2147483647 : i32
      %1364 = waveamd.make_buffer %arg3, %c2147483647_i32_21 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_22, %token_23 = wave.gather %1364 mapping <bit_offset = <"8*Mod(slot + t113 + t85 + 2*t11*floor(1/64*item) + t11*floor(1/32*Mod(item, 64)) + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t11", "t113", "t85"](%1, %15, %1250, %780) after %1357 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, i32, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1365 = wave.extract %value_22[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1366 = wave.extract %value_22[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1367 = wave.extract %value_22[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1368 = wave.extract %value_22[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1369 = wave.extract %value_22[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1370 = wave.extract %value_22[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1371 = wave.extract %value_22[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1372 = wave.extract %value_22[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %c2147483647_i32_24 = arith.constant 2147483647 : i32
      %1373 = waveamd.make_buffer %arg4, %c2147483647_i32_24 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_25, %token_26 = wave.gather %1373 mapping <bit_offset = <"8*Mod(slot + t127 + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t127", "t99"](%1, %17, %1301, %1192) after %1357 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, i32, !wave.mem.token) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %1374 = wave.extract %value_25[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1375 = wave.extract %value_25[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1376 = wave.extract %value_25[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1377 = wave.extract %value_25[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1378 = wave.join %1359, %1363 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1379 = wave.index_expr <"16896*slot"> assuming [#wave.pred<"1">, #wave.pred<"slot >= 0">, #wave.pred<"-2 + slot < 0">] ["slot"](%c1_i32) : (i32) -> index
      %1380 = wave.ptr_add %47, %1379 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %c2147483647_i32_27 = arith.constant 2147483647 : i32
      %1381 = waveamd.make_buffer %1322, %c2147483647_i32_27 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_28, %token_29 = wave.gather %1381 mapping <bit_offset = <"8*Mod(128 + t94 + t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9", "t94"](%1, %11, %998) after %1357 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
      %1382 = wave.scatter %value_28 to %1380 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_29 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %c2147483647_i32_30 = arith.constant 2147483647 : i32
      %1383 = waveamd.make_buffer %arg4, %c2147483647_i32_30 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
      %value_31, %token_32 = wave.gather %1383 mapping <bit_offset = <"8*Mod(128 + slot + t127 + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t127", "t99"](%1, %17, %1301, %1192) after %1357 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, i32, !wave.mem.token) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
      %1384 = wave.extract %value_31[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1385 = wave.extract %value_31[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1386 = wave.extract %value_31[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1387 = wave.extract %value_31[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
      %1388 = wave.join %1382 : !wave.mem.token -> !wave.mem.token
      %1389 = wave.binary addi %781, %c256_i32 : i32, i32 -> i32
      %1390 = wave.binary addi %1193, %c256_i32 : i32, i32 -> i32
      %1391 = wave.binary muli %15, %c16_i32 : i32, i32 -> i32
      %1392 = wave.binary muli %17, %c16_i32 : i32, i32 -> i32
      %1393 = wave.issue_token %1351, %1378, %1388 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1394 = wave.after %1340, %1393 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1395 = wave.issue_token %1359, %1363, %token_23, %token_26, %1382, %token_32 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1396 = wave.barrier %1394 : (!wave.mem.token) -> !wave.mem.token
      %1397 = wave.after %1396, %1395 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1398 = wave.issue_token %1397 : !wave.mem.token -> !wave.mem.token
      %1399 = wave.join %1394, %1398 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_33, %token_34 = wave.gather %1315 mapping <bit_offset = <"8*(128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_35, %token_36 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_37, %token_38 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_39, %token_40 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_41, %token_42 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_43, %token_44 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_45, %token_46 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_47, %token_48 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_49, %token_50 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_51, %token_52 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_53, %token_54 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_55, %token_56 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_57, %token_58 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_59, %token_60 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_61, %token_62 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_63, %token_64 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1399 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1400 = wave.join %token_34, %token_36, %token_38, %token_40, %token_42, %token_44, %token_46, %token_48, %token_50, %token_52, %token_54, %token_56, %token_58, %token_60, %token_62, %token_64 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1401 = wave.join %1394, %1398 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_65, %token_66 = wave.gather %1321 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_67, %token_68 = wave.gather %1321 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_69, %token_70 = wave.gather %1321 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_71, %token_72 = wave.gather %1321 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_73, %token_74 = wave.gather %1321 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_75, %token_76 = wave.gather %1321 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_77, %token_78 = wave.gather %1321 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_79, %token_80 = wave.gather %1321 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1401 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1402 = wave.join %token_66, %token_68, %token_70, %token_72, %token_74, %token_76, %token_78, %token_80 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1403 = wave.index_expr <"0"> assuming [#wave.pred<"1">] []() : () -> index
      %1404 = wave.ptr_add %48, %1403 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %1405 = wave.pack %1327, %1328, %1329, %1330, %1331, %1332, %1333, %1334 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1406 = wave.scatter %1405 to %1404 mapping <bit_offset = <"8*(slot + 512*floor(1/64*item) + 16*floor(1/2*Mod(item, 64)) + 8*Mod(item, 2))">> bindings ["item"](%1) after %1398 : (!wave.simd<vector<8xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1407 = wave.index_expr <"0"> assuming [#wave.pred<"1">] []() : () -> index
      %1408 = wave.ptr_add %49, %1407 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
      %1409 = wave.pack %1336, %1337, %1338, %1339 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1410 = wave.scatter %1409 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %1398 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1411 = wave.issue_token %1406, %1410 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1412 = wave.barrier %1394, %1400, %1402 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1413 = wave.after %1412, %1411 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1414 = wave.issue_token %1413 : !wave.mem.token -> !wave.mem.token
      %value_81, %token_82 = wave.gather %1404 mapping <bit_offset = <"8*(16*floor(1/128*item) + 256*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 1024*Mod(slot, 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1414 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1415 = wave.extract %value_81[0] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1416 = wave.extract %value_81[1] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1417 = wave.extract %value_81[2] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1418 = wave.extract %value_81[3] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1419 = wave.extract %value_81[4] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1420 = wave.extract %value_81[5] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1421 = wave.extract %value_81[6] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1422 = wave.extract %value_81[7] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1423 = wave.extract %value_81[8] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1424 = wave.extract %value_81[9] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1425 = wave.extract %value_81[10] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1426 = wave.extract %value_81[11] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1427 = wave.extract %value_81[12] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1428 = wave.extract %value_81[13] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1429 = wave.extract %value_81[14] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1430 = wave.extract %value_81[15] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %value_83, %token_84 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1414 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1431 = wave.extract %value_83[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1432 = wave.extract %value_83[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1433 = wave.extract %value_83[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1434 = wave.extract %value_83[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1435 = wave.extract %value_83[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1436 = wave.extract %value_83[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1437 = wave.extract %value_83[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1438 = wave.extract %value_83[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1439 = wave.binary subi %1313, %c2_i32 : i32, i32 -> i32
      %1440 = wave.join %1413, %token_82, %token_84 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1441:140 = scf.for %arg13 = %c0_i32 to %1439 step %c2_i32 iter_args(%arg14 = %1389, %arg15 = %1390, %arg16 = %1391, %arg17 = %1392, %arg18 = %1347, %arg19 = %1348, %arg20 = %1349, %arg21 = %1350, %arg22 = %1365, %arg23 = %1366, %arg24 = %1367, %arg25 = %1368, %arg26 = %1369, %arg27 = %1370, %arg28 = %1371, %arg29 = %1372, %arg30 = %1374, %arg31 = %1375, %arg32 = %1376, %arg33 = %1377, %arg34 = %1384, %arg35 = %1385, %arg36 = %1386, %arg37 = %1387, %arg38 = %1415, %arg39 = %1416, %arg40 = %1417, %arg41 = %1418, %arg42 = %1419, %arg43 = %1420, %arg44 = %1421, %arg45 = %1422, %arg46 = %1423, %arg47 = %1424, %arg48 = %1425, %arg49 = %1426, %arg50 = %1427, %arg51 = %1428, %arg52 = %1429, %arg53 = %1430, %arg54 = %1431, %arg55 = %1432, %arg56 = %1433, %arg57 = %1434, %arg58 = %1435, %arg59 = %1436, %arg60 = %1437, %arg61 = %1438, %arg62 = %21, %arg63 = %21, %arg64 = %21, %arg65 = %21, %arg66 = %21, %arg67 = %21, %arg68 = %21, %arg69 = %21, %arg70 = %21, %arg71 = %21, %arg72 = %21, %arg73 = %21, %arg74 = %21, %arg75 = %21, %arg76 = %21, %arg77 = %21, %arg78 = %21, %arg79 = %21, %arg80 = %21, %arg81 = %21, %arg82 = %21, %arg83 = %21, %arg84 = %21, %arg85 = %21, %arg86 = %21, %arg87 = %21, %arg88 = %21, %arg89 = %21, %arg90 = %21, %arg91 = %21, %arg92 = %21, %arg93 = %21, %arg94 = %value_33, %arg95 = %value_35, %arg96 = %value_37, %arg97 = %value_39, %arg98 = %value_41, %arg99 = %value_43, %arg100 = %value_45, %arg101 = %value_47, %arg102 = %value_49, %arg103 = %value_51, %arg104 = %value_53, %arg105 = %value_55, %arg106 = %value_57, %arg107 = %value_59, %arg108 = %value_61, %arg109 = %value_63, %arg110 = %value_65, %arg111 = %value_67, %arg112 = %value_69, %arg113 = %value_71, %arg114 = %value_73, %arg115 = %value_75, %arg116 = %value_77, %arg117 = %value_79, %arg118 = %21, %arg119 = %21, %arg120 = %21, %arg121 = %21, %arg122 = %21, %arg123 = %21, %arg124 = %21, %arg125 = %21, %arg126 = %21, %arg127 = %21, %arg128 = %21, %arg129 = %21, %arg130 = %21, %arg131 = %21, %arg132 = %21, %arg133 = %21, %arg134 = %21, %arg135 = %21, %arg136 = %21, %arg137 = %21, %arg138 = %21, %arg139 = %21, %arg140 = %21, %arg141 = %21, %arg142 = %21, %arg143 = %21, %arg144 = %21, %arg145 = %21, %arg146 = %21, %arg147 = %21, %arg148 = %21, %arg149 = %21, %arg150 = %1351, %arg151 = %1378, %arg152 = %1388, %arg153 = %1440) -> (i32, i32, i32, i32, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
        %3513 = wave.assume %arg13 as "x" [#wave.pred<"Mod(x, 2) == 0">] : i32
        %3514 = wave.assume %3513 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-2147483646 + x <= 0">] : i32
        %3515 = waveamd.fragment_pack %arg94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3516 = waveamd.fragment_pack %arg95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3517 = waveamd.fragment_pack %arg96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3518 = waveamd.fragment_pack %arg97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3519 = waveamd.fragment_pack %arg98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3520 = waveamd.fragment_pack %arg99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3521 = waveamd.fragment_pack %arg100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3522 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3523 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3524 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3525 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3526 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3527 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3528 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3529 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3530 = waveamd.fragment_pack %arg109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3531 = waveamd.fragment_pack %arg110 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3532 = waveamd.fragment_pack %arg111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3533 = waveamd.fragment_pack %arg112 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3534 = waveamd.fragment_pack %arg113 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3535 = waveamd.fragment_pack %arg114 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3536 = waveamd.fragment_pack %arg115 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3537 = waveamd.fragment_pack %arg116 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3538 = waveamd.fragment_pack %arg117 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3539 = waveamd.fragment_pack %arg62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3540 = waveamd.fragment_pack %arg63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3541 = waveamd.fragment_pack %arg64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3542 = waveamd.fragment_pack %arg65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3543 = waveamd.fragment_pack %arg66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3544 = waveamd.fragment_pack %arg67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3545 = waveamd.fragment_pack %arg68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3546 = waveamd.fragment_pack %arg69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3547 = waveamd.fragment_pack %arg70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3548 = waveamd.fragment_pack %arg71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3549 = waveamd.fragment_pack %arg72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3550 = waveamd.fragment_pack %arg73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3551 = waveamd.fragment_pack %arg74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3552 = waveamd.fragment_pack %arg75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3553 = waveamd.fragment_pack %arg76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3554 = waveamd.fragment_pack %arg77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3555 = waveamd.fragment_pack %arg78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3556 = waveamd.fragment_pack %arg79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3557 = waveamd.fragment_pack %arg80 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3558 = waveamd.fragment_pack %arg81 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3559 = waveamd.fragment_pack %arg82 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3560 = waveamd.fragment_pack %arg83 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3561 = waveamd.fragment_pack %arg84 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3562 = waveamd.fragment_pack %arg85 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3563 = waveamd.fragment_pack %arg86 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3564 = waveamd.fragment_pack %arg87 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3565 = waveamd.fragment_pack %arg88 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3566 = waveamd.fragment_pack %arg89 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3567 = waveamd.fragment_pack %arg90 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3568 = waveamd.fragment_pack %arg91 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3569 = waveamd.fragment_pack %arg92 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3570 = waveamd.fragment_pack %arg93 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3571 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %3572 = wave.pack %arg38, %arg39, %arg40, %arg41 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3573 = wave.pack %arg42, %arg43, %arg44, %arg45 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3574 = wave.pack %arg46, %arg47, %arg48, %arg49 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3575 = wave.pack %arg50, %arg51, %arg52, %arg53 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3576 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %3577 = wave.pack %arg54, %arg55, %arg56, %arg57 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3578 = wave.pack %arg58, %arg59, %arg60, %arg61 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3579 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3515, %3572, %3539 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3580 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3516, %3572, %3579 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3581 = waveamd.fragment_unpack %3580 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3582 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3515, %3572, %3540 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3583 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3516, %3572, %3582 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3584 = waveamd.fragment_unpack %3583 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3585 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3515, %3572, %3541 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3586 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3516, %3572, %3585 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3587 = waveamd.fragment_unpack %3586 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3588 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3515, %3572, %3542 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3589 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3516, %3572, %3588 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3590 = waveamd.fragment_unpack %3589 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3591 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3517, %3572, %3543 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3592 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3518, %3572, %3591 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3593 = waveamd.fragment_unpack %3592 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3594 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3517, %3572, %3544 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3595 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3518, %3572, %3594 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3596 = waveamd.fragment_unpack %3595 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3597 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3517, %3572, %3545 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3598 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3518, %3572, %3597 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3599 = waveamd.fragment_unpack %3598 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3600 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3517, %3572, %3546 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3601 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3518, %3572, %3600 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3602 = waveamd.fragment_unpack %3601 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3603 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3519, %3573, %3547 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3604 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3520, %3573, %3603 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3605 = waveamd.fragment_unpack %3604 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3606 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3519, %3573, %3548 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3607 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3520, %3573, %3606 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3608 = waveamd.fragment_unpack %3607 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3609 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3519, %3573, %3549 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3610 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3520, %3573, %3609 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3611 = waveamd.fragment_unpack %3610 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3612 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3519, %3573, %3550 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3613 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3520, %3573, %3612 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3614 = waveamd.fragment_unpack %3613 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3615 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3521, %3573, %3551 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3616 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3522, %3573, %3615 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3617 = waveamd.fragment_unpack %3616 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3618 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3521, %3573, %3552 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3619 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3522, %3573, %3618 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3620 = waveamd.fragment_unpack %3619 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3621 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3521, %3573, %3553 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3622 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3522, %3573, %3621 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3623 = waveamd.fragment_unpack %3622 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3624 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3521, %3573, %3554 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3625 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3522, %3573, %3624 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3626 = waveamd.fragment_unpack %3625 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3627 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3523, %3574, %3555 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3628 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3524, %3574, %3627 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3629 = waveamd.fragment_unpack %3628 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3630 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3523, %3574, %3556 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3631 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3524, %3574, %3630 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3632 = waveamd.fragment_unpack %3631 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3633 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3523, %3574, %3557 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3634 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3524, %3574, %3633 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3635 = waveamd.fragment_unpack %3634 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3636 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3523, %3574, %3558 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3637 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3524, %3574, %3636 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3638 = waveamd.fragment_unpack %3637 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3639 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3525, %3574, %3559 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3640 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3526, %3574, %3639 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3641 = waveamd.fragment_unpack %3640 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3642 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3525, %3574, %3560 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3643 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3526, %3574, %3642 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3644 = waveamd.fragment_unpack %3643 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3645 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3525, %3574, %3561 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3646 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3526, %3574, %3645 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3647 = waveamd.fragment_unpack %3646 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3648 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3525, %3574, %3562 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3649 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3526, %3574, %3648 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3650 = waveamd.fragment_unpack %3649 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3651 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3527, %3575, %3563 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3652 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3528, %3575, %3651 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3653 = waveamd.fragment_unpack %3652 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3654 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3527, %3575, %3564 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3655 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3528, %3575, %3654 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3656 = waveamd.fragment_unpack %3655 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3657 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3527, %3575, %3565 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3658 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3528, %3575, %3657 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3659 = waveamd.fragment_unpack %3658 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3660 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3527, %3575, %3566 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3661 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3528, %3575, %3660 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3662 = waveamd.fragment_unpack %3661 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3663 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3531, %3577, %3529, %3575, %3567 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3664 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3532, %3577, %3530, %3575, %3663 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3665 = waveamd.fragment_unpack %3664 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3666 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3533, %3577, %3529, %3575, %3568 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3667 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3534, %3577, %3530, %3575, %3666 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3668 = waveamd.fragment_unpack %3667 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3669 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3535, %3578, %3529, %3575, %3569 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3670 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3536, %3578, %3530, %3575, %3669 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3671 = waveamd.fragment_unpack %3670 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3672 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3537, %3578, %3529, %3575, %3570 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3673 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3538, %3578, %3530, %3575, %3672 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3674 = waveamd.fragment_unpack %3673 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3675 = wave.issue_token %arg151, %arg152 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3676 = wave.after %arg150, %1351, %3675 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3677 = wave.barrier %3676, %arg153 : (!wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %3678 = wave.issue_token %3677 : !wave.mem.token -> !wave.mem.token
        %3679 = wave.join %3676, %3678 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_175, %token_176 = wave.gather %1342 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_177, %token_178 = wave.gather %1342 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_179, %token_180 = wave.gather %1342 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_181, %token_182 = wave.gather %1342 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_183, %token_184 = wave.gather %1342 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_185, %token_186 = wave.gather %1342 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_187, %token_188 = wave.gather %1342 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_189, %token_190 = wave.gather %1342 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3679 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3680 = wave.join %token_176, %token_178, %token_180, %token_182, %token_184, %token_186, %token_188, %token_190 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3681 = wave.pack %arg18, %arg19, %arg20, %arg21 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3682 = wave.scatter %3681 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %3678 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %3683 = wave.issue_token %3682 : !wave.mem.token -> !wave.mem.token
        %3684 = wave.barrier %3676, %3680, %3677 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %3685 = wave.after %3684, %3683 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3686 = wave.issue_token %3685 : !wave.mem.token -> !wave.mem.token
        %value_191, %token_192 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3686 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %3687 = wave.extract %value_191[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3688 = wave.extract %value_191[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3689 = wave.extract %value_191[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3690 = wave.extract %value_191[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3691 = wave.extract %value_191[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3692 = wave.extract %value_191[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3693 = wave.extract %value_191[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3694 = wave.extract %value_191[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3695 = wave.ptr_add %arg0, %arg14 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %c2147483647_i32_193 = arith.constant 2147483647 : i32
        %3696 = waveamd.make_buffer %3695, %c2147483647_i32_193 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_194, %token_195 = wave.gather %3696 mapping <bit_offset = <"8*Mod(t8*floor(1/64*item) + 128*t8*floor(1/64*slot) + 16*t8*floor(1/8*Mod(item, 64)) + 8*t8*floor(1/2*Mod(floor(1/16*slot), 4)) + 4*t8*Mod(floor(1/16*slot), 2) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t8"](%1, %9) after %3686 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<128xi8>, 64>, !wave.mem.token)
        %3697 = wave.scatter %value_194 to %1315 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_195 : (!wave.simd<vector<128xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %3698 = wave.ptr_add %arg1, %arg15 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %c2147483647_i32_196 = arith.constant 2147483647 : i32
        %3699 = waveamd.make_buffer %3698, %c2147483647_i32_196 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_197, %token_198 = wave.gather %3699 mapping <bit_offset = <"8*Mod(t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9"](%1, %11) after %3686 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
        %3700 = wave.scatter %value_197 to %1321 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_198 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %3701 = wave.ptr_add %arg3, %arg16 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %c2147483647_i32_199 = arith.constant 2147483647 : i32
        %3702 = waveamd.make_buffer %3701, %c2147483647_i32_199 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_200, %token_201 = wave.gather %3702 mapping <bit_offset = <"8*Mod(slot + t85 + 2*t11*floor(1/64*item) + t11*floor(1/32*Mod(item, 64)) + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t11", "t85"](%1, %15, %780) after %3686 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %3703 = wave.extract %value_200[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3704 = wave.extract %value_200[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3705 = wave.extract %value_200[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3706 = wave.extract %value_200[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3707 = wave.extract %value_200[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3708 = wave.extract %value_200[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3709 = wave.extract %value_200[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3710 = wave.extract %value_200[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3711 = wave.ptr_add %arg4, %arg17 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#wave.global, i8>
        %c2147483647_i32_202 = arith.constant 2147483647 : i32
        %3712 = waveamd.make_buffer %3711, %c2147483647_i32_202 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_203, %token_204 = wave.gather %3712 mapping <bit_offset = <"8*Mod(slot + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t99"](%1, %17, %1192) after %3686 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %3713 = wave.extract %value_203[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3714 = wave.extract %value_203[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3715 = wave.extract %value_203[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3716 = wave.extract %value_203[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3717 = wave.join %3697, %3700 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3718 = waveamd.fragment_pack %arg94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3719 = waveamd.fragment_pack %arg95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3720 = waveamd.fragment_pack %arg96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3721 = waveamd.fragment_pack %arg97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3722 = waveamd.fragment_pack %arg98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3723 = waveamd.fragment_pack %arg99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3724 = waveamd.fragment_pack %arg100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3725 = waveamd.fragment_pack %arg101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3726 = waveamd.fragment_pack %arg102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3727 = waveamd.fragment_pack %arg103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3728 = waveamd.fragment_pack %arg104 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3729 = waveamd.fragment_pack %arg105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3730 = waveamd.fragment_pack %arg106 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3731 = waveamd.fragment_pack %arg107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3732 = waveamd.fragment_pack %arg108 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3733 = waveamd.fragment_pack %arg109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3734 = waveamd.fragment_pack %value_175 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3735 = waveamd.fragment_pack %value_177 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3736 = waveamd.fragment_pack %value_179 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3737 = waveamd.fragment_pack %value_181 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3738 = waveamd.fragment_pack %value_183 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3739 = waveamd.fragment_pack %value_185 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3740 = waveamd.fragment_pack %value_187 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3741 = waveamd.fragment_pack %value_189 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3742 = waveamd.fragment_pack %arg118 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3743 = waveamd.fragment_pack %arg119 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3744 = waveamd.fragment_pack %arg120 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3745 = waveamd.fragment_pack %arg121 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3746 = waveamd.fragment_pack %arg122 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3747 = waveamd.fragment_pack %arg123 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3748 = waveamd.fragment_pack %arg124 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3749 = waveamd.fragment_pack %arg125 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3750 = waveamd.fragment_pack %arg126 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3751 = waveamd.fragment_pack %arg127 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3752 = waveamd.fragment_pack %arg128 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3753 = waveamd.fragment_pack %arg129 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3754 = waveamd.fragment_pack %arg130 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3755 = waveamd.fragment_pack %arg131 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3756 = waveamd.fragment_pack %arg132 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3757 = waveamd.fragment_pack %arg133 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3758 = waveamd.fragment_pack %arg134 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3759 = waveamd.fragment_pack %arg135 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3760 = waveamd.fragment_pack %arg136 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3761 = waveamd.fragment_pack %arg137 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3762 = waveamd.fragment_pack %arg138 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3763 = waveamd.fragment_pack %arg139 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3764 = waveamd.fragment_pack %arg140 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3765 = waveamd.fragment_pack %arg141 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3766 = waveamd.fragment_pack %arg142 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3767 = waveamd.fragment_pack %arg143 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3768 = waveamd.fragment_pack %arg144 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3769 = waveamd.fragment_pack %arg145 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3770 = waveamd.fragment_pack %arg146 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3771 = waveamd.fragment_pack %arg147 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3772 = waveamd.fragment_pack %arg148 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3773 = waveamd.fragment_pack %arg149 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3774 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %3775 = wave.pack %arg38, %arg39, %arg40, %arg41 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3776 = wave.pack %arg42, %arg43, %arg44, %arg45 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3777 = wave.pack %arg46, %arg47, %arg48, %arg49 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3778 = wave.pack %arg50, %arg51, %arg52, %arg53 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3779 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %3780 = wave.pack %3687, %3688, %3689, %3690 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3781 = wave.pack %3691, %3692, %3693, %3694 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3782 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3718, %3775, %3742 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3783 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3719, %3775, %3782 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3784 = waveamd.fragment_unpack %3783 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3785 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3718, %3775, %3743 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3786 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3719, %3775, %3785 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3787 = waveamd.fragment_unpack %3786 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3788 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3718, %3775, %3744 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3789 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3719, %3775, %3788 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3790 = waveamd.fragment_unpack %3789 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3791 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3718, %3775, %3745 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3792 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3719, %3775, %3791 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3793 = waveamd.fragment_unpack %3792 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3794 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3720, %3775, %3746 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3795 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3721, %3775, %3794 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3796 = waveamd.fragment_unpack %3795 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3797 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3720, %3775, %3747 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3798 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3721, %3775, %3797 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3799 = waveamd.fragment_unpack %3798 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3800 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3720, %3775, %3748 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3801 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3721, %3775, %3800 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3802 = waveamd.fragment_unpack %3801 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3803 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3720, %3775, %3749 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3804 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3721, %3775, %3803 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3805 = waveamd.fragment_unpack %3804 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3806 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3722, %3776, %3750 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3807 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3723, %3776, %3806 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3808 = waveamd.fragment_unpack %3807 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3809 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3722, %3776, %3751 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3810 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3723, %3776, %3809 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3811 = waveamd.fragment_unpack %3810 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3812 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3722, %3776, %3752 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3813 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3723, %3776, %3812 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3814 = waveamd.fragment_unpack %3813 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3815 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3722, %3776, %3753 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3816 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3723, %3776, %3815 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3817 = waveamd.fragment_unpack %3816 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3818 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3724, %3776, %3754 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3819 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3725, %3776, %3818 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3820 = waveamd.fragment_unpack %3819 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3821 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3724, %3776, %3755 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3822 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3725, %3776, %3821 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3823 = waveamd.fragment_unpack %3822 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3824 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3724, %3776, %3756 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3825 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3725, %3776, %3824 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3826 = waveamd.fragment_unpack %3825 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3827 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3724, %3776, %3757 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3828 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3725, %3776, %3827 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3829 = waveamd.fragment_unpack %3828 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3830 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3726, %3777, %3758 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3831 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3727, %3777, %3830 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3832 = waveamd.fragment_unpack %3831 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3833 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3726, %3777, %3759 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3834 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3727, %3777, %3833 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3835 = waveamd.fragment_unpack %3834 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3836 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3726, %3777, %3760 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3837 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3727, %3777, %3836 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3838 = waveamd.fragment_unpack %3837 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3839 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3726, %3777, %3761 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3840 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3727, %3777, %3839 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3841 = waveamd.fragment_unpack %3840 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3842 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3728, %3777, %3762 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3843 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3729, %3777, %3842 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3844 = waveamd.fragment_unpack %3843 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3845 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3728, %3777, %3763 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3846 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3729, %3777, %3845 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3847 = waveamd.fragment_unpack %3846 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3848 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3728, %3777, %3764 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3849 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3729, %3777, %3848 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3850 = waveamd.fragment_unpack %3849 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3851 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3728, %3777, %3765 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3852 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3729, %3777, %3851 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3853 = waveamd.fragment_unpack %3852 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3854 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3730, %3778, %3766 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3855 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3731, %3778, %3854 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3856 = waveamd.fragment_unpack %3855 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3857 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3730, %3778, %3767 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3858 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3731, %3778, %3857 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3859 = waveamd.fragment_unpack %3858 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3860 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3730, %3778, %3768 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3861 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3731, %3778, %3860 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3862 = waveamd.fragment_unpack %3861 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3863 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3730, %3778, %3769 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3864 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3731, %3778, %3863 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3865 = waveamd.fragment_unpack %3864 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3866 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3734, %3780, %3732, %3778, %3770 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3867 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3735, %3780, %3733, %3778, %3866 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3868 = waveamd.fragment_unpack %3867 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3869 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3736, %3780, %3732, %3778, %3771 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3870 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3737, %3780, %3733, %3778, %3869 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3871 = waveamd.fragment_unpack %3870 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3872 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3738, %3781, %3732, %3778, %3772 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3873 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3739, %3781, %3733, %3778, %3872 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3874 = waveamd.fragment_unpack %3873 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3875 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3740, %3781, %3732, %3778, %3773 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3876 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3741, %3781, %3733, %3778, %3875 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3877 = waveamd.fragment_unpack %3876 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3878 = wave.issue_token %arg152, %3717 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3879 = wave.after %arg151, %1378, %3878 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3880 = wave.issue_token %3697, %3700, %token_201, %token_204 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3881 = wave.barrier %3879, %token_192, %3685 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %3882 = wave.after %3881, %3880 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3883 = wave.issue_token %3882 : !wave.mem.token -> !wave.mem.token
        %3884 = wave.join %3879, %3883 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_205, %token_206 = wave.gather %1353 mapping <bit_offset = <"8*(128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_207, %token_208 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_209, %token_210 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_211, %token_212 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_213, %token_214 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_215, %token_216 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_217, %token_218 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_219, %token_220 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_221, %token_222 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_223, %token_224 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_225, %token_226 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_227, %token_228 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_229, %token_230 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_231, %token_232 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_233, %token_234 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_235, %token_236 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3884 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3885 = wave.join %token_206, %token_208, %token_210, %token_212, %token_214, %token_216, %token_218, %token_220, %token_222, %token_224, %token_226, %token_228, %token_230, %token_232, %token_234, %token_236 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3886 = wave.join %3879, %3883 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_237, %token_238 = wave.gather %1361 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_239, %token_240 = wave.gather %1361 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_241, %token_242 = wave.gather %1361 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_243, %token_244 = wave.gather %1361 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_245, %token_246 = wave.gather %1361 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_247, %token_248 = wave.gather %1361 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_249, %token_250 = wave.gather %1361 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_251, %token_252 = wave.gather %1361 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %3886 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3887 = wave.join %token_238, %token_240, %token_242, %token_244, %token_246, %token_248, %token_250, %token_252 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3888 = wave.pack %arg22, %arg23, %arg24, %arg25, %arg26, %arg27, %arg28, %arg29 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %3889 = wave.scatter %3888 to %1404 mapping <bit_offset = <"8*(slot + 512*floor(1/64*item) + 16*floor(1/2*Mod(item, 64)) + 8*Mod(item, 2))">> bindings ["item"](%1) after %3883 : (!wave.simd<vector<8xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %3890 = wave.pack %arg30, %arg31, %arg32, %arg33 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3891 = wave.scatter %3890 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %3883 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %3892 = wave.issue_token %3889, %3891 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3893 = wave.barrier %3879, %3885, %3887, %3882 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %3894 = wave.after %3893, %3892 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %3895 = wave.issue_token %3894 : !wave.mem.token -> !wave.mem.token
        %value_253, %token_254 = wave.gather %1404 mapping <bit_offset = <"8*(16*floor(1/128*item) + 256*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 1024*Mod(slot, 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3895 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %3896 = wave.extract %value_253[0] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3897 = wave.extract %value_253[1] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3898 = wave.extract %value_253[2] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3899 = wave.extract %value_253[3] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3900 = wave.extract %value_253[4] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3901 = wave.extract %value_253[5] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3902 = wave.extract %value_253[6] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3903 = wave.extract %value_253[7] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3904 = wave.extract %value_253[8] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3905 = wave.extract %value_253[9] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3906 = wave.extract %value_253[10] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3907 = wave.extract %value_253[11] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3908 = wave.extract %value_253[12] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3909 = wave.extract %value_253[13] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3910 = wave.extract %value_253[14] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %3911 = wave.extract %value_253[15] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %value_255, %token_256 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %3895 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %3912 = wave.extract %value_255[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3913 = wave.extract %value_255[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3914 = wave.extract %value_255[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3915 = wave.extract %value_255[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3916 = wave.extract %value_255[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3917 = wave.extract %value_255[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3918 = wave.extract %value_255[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %3919 = wave.extract %value_255[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %c2147483647_i32_257 = arith.constant 2147483647 : i32
        %3920 = waveamd.make_buffer %3698, %c2147483647_i32_257 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_258, %token_259 = wave.gather %3920 mapping <bit_offset = <"8*Mod(t94 + t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9", "t94"](%1, %11, %998) after %3895 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
        %3921 = wave.scatter %value_258 to %1342 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_259 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %c2147483647_i32_260 = arith.constant 2147483647 : i32
        %3922 = waveamd.make_buffer %3711, %c2147483647_i32_260 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_261, %token_262 = wave.gather %3922 mapping <bit_offset = <"8*Mod(128 + slot + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t99"](%1, %17, %1192) after %3895 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %3923 = wave.extract %value_261[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3924 = wave.extract %value_261[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3925 = wave.extract %value_261[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3926 = wave.extract %value_261[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %3927 = wave.join %3921 : !wave.mem.token -> !wave.mem.token
        %3928 = waveamd.fragment_pack %value_205 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3929 = waveamd.fragment_pack %value_207 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3930 = waveamd.fragment_pack %value_209 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3931 = waveamd.fragment_pack %value_211 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3932 = waveamd.fragment_pack %value_213 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3933 = waveamd.fragment_pack %value_215 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3934 = waveamd.fragment_pack %value_217 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3935 = waveamd.fragment_pack %value_219 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3936 = waveamd.fragment_pack %value_221 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3937 = waveamd.fragment_pack %value_223 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3938 = waveamd.fragment_pack %value_225 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3939 = waveamd.fragment_pack %value_227 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3940 = waveamd.fragment_pack %value_229 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3941 = waveamd.fragment_pack %value_231 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3942 = waveamd.fragment_pack %value_233 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3943 = waveamd.fragment_pack %value_235 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %3944 = waveamd.fragment_pack %value_237 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3945 = waveamd.fragment_pack %value_239 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3946 = waveamd.fragment_pack %value_241 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3947 = waveamd.fragment_pack %value_243 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3948 = waveamd.fragment_pack %value_245 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3949 = waveamd.fragment_pack %value_247 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3950 = waveamd.fragment_pack %value_249 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3951 = waveamd.fragment_pack %value_251 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %3952 = waveamd.fragment_pack %3581 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3953 = waveamd.fragment_pack %3584 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3954 = waveamd.fragment_pack %3587 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3955 = waveamd.fragment_pack %3590 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3956 = waveamd.fragment_pack %3593 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3957 = waveamd.fragment_pack %3596 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3958 = waveamd.fragment_pack %3599 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3959 = waveamd.fragment_pack %3602 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3960 = waveamd.fragment_pack %3605 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3961 = waveamd.fragment_pack %3608 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3962 = waveamd.fragment_pack %3611 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3963 = waveamd.fragment_pack %3614 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3964 = waveamd.fragment_pack %3617 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3965 = waveamd.fragment_pack %3620 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3966 = waveamd.fragment_pack %3623 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3967 = waveamd.fragment_pack %3626 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3968 = waveamd.fragment_pack %3629 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3969 = waveamd.fragment_pack %3632 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3970 = waveamd.fragment_pack %3635 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3971 = waveamd.fragment_pack %3638 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3972 = waveamd.fragment_pack %3641 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3973 = waveamd.fragment_pack %3644 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3974 = waveamd.fragment_pack %3647 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3975 = waveamd.fragment_pack %3650 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3976 = waveamd.fragment_pack %3653 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3977 = waveamd.fragment_pack %3656 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3978 = waveamd.fragment_pack %3659 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3979 = waveamd.fragment_pack %3662 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3980 = waveamd.fragment_pack %3665 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3981 = waveamd.fragment_pack %3668 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3982 = waveamd.fragment_pack %3671 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3983 = waveamd.fragment_pack %3674 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3984 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %3985 = wave.pack %3896, %3897, %3898, %3899 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3986 = wave.pack %3900, %3901, %3902, %3903 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3987 = wave.pack %3904, %3905, %3906, %3907 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3988 = wave.pack %3908, %3909, %3910, %3911 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3989 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %3990 = wave.pack %3912, %3913, %3914, %3915 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3991 = wave.pack %3916, %3917, %3918, %3919 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %3992 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3928, %3985, %3952 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3993 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3929, %3985, %3992 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3994 = waveamd.fragment_unpack %3993 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3995 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3928, %3985, %3953 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3996 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3929, %3985, %3995 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3997 = waveamd.fragment_unpack %3996 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %3998 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3928, %3985, %3954 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %3999 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3929, %3985, %3998 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4000 = waveamd.fragment_unpack %3999 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4001 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3928, %3985, %3955 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4002 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3929, %3985, %4001 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4003 = waveamd.fragment_unpack %4002 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4004 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3930, %3985, %3956 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4005 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3931, %3985, %4004 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4006 = waveamd.fragment_unpack %4005 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4007 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3930, %3985, %3957 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4008 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3931, %3985, %4007 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4009 = waveamd.fragment_unpack %4008 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4010 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3930, %3985, %3958 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4011 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3931, %3985, %4010 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4012 = waveamd.fragment_unpack %4011 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4013 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3930, %3985, %3959 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4014 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3931, %3985, %4013 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4015 = waveamd.fragment_unpack %4014 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4016 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3932, %3986, %3960 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4017 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3933, %3986, %4016 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4018 = waveamd.fragment_unpack %4017 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4019 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3932, %3986, %3961 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4020 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3933, %3986, %4019 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4021 = waveamd.fragment_unpack %4020 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4022 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3932, %3986, %3962 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4023 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3933, %3986, %4022 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4024 = waveamd.fragment_unpack %4023 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4025 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3932, %3986, %3963 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4026 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3933, %3986, %4025 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4027 = waveamd.fragment_unpack %4026 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4028 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3934, %3986, %3964 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4029 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3935, %3986, %4028 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4030 = waveamd.fragment_unpack %4029 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4031 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3934, %3986, %3965 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4032 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3935, %3986, %4031 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4033 = waveamd.fragment_unpack %4032 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4034 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3934, %3986, %3966 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4035 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3935, %3986, %4034 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4036 = waveamd.fragment_unpack %4035 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4037 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3934, %3986, %3967 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4038 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3935, %3986, %4037 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4039 = waveamd.fragment_unpack %4038 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4040 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3936, %3987, %3968 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4041 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3937, %3987, %4040 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4042 = waveamd.fragment_unpack %4041 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4043 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3936, %3987, %3969 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4044 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3937, %3987, %4043 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4045 = waveamd.fragment_unpack %4044 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4046 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3936, %3987, %3970 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4047 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3937, %3987, %4046 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4048 = waveamd.fragment_unpack %4047 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4049 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3936, %3987, %3971 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4050 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3937, %3987, %4049 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4051 = waveamd.fragment_unpack %4050 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4052 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3938, %3987, %3972 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4053 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3939, %3987, %4052 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4054 = waveamd.fragment_unpack %4053 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4055 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3938, %3987, %3973 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4056 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3939, %3987, %4055 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4057 = waveamd.fragment_unpack %4056 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4058 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3938, %3987, %3974 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4059 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3939, %3987, %4058 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4060 = waveamd.fragment_unpack %4059 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4061 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3938, %3987, %3975 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4062 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3939, %3987, %4061 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4063 = waveamd.fragment_unpack %4062 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4064 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3940, %3988, %3976 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4065 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3941, %3988, %4064 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4066 = waveamd.fragment_unpack %4065 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4067 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3940, %3988, %3977 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4068 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3941, %3988, %4067 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4069 = waveamd.fragment_unpack %4068 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4070 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3940, %3988, %3978 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4071 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3941, %3988, %4070 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4072 = waveamd.fragment_unpack %4071 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4073 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3940, %3988, %3979 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4074 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3941, %3988, %4073 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4075 = waveamd.fragment_unpack %4074 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4076 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3944, %3990, %3942, %3988, %3980 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4077 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3945, %3990, %3943, %3988, %4076 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4078 = waveamd.fragment_unpack %4077 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4079 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3946, %3990, %3942, %3988, %3981 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4080 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3947, %3990, %3943, %3988, %4079 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4081 = waveamd.fragment_unpack %4080 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4082 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3948, %3991, %3942, %3988, %3982 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4083 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3949, %3991, %3943, %3988, %4082 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4084 = waveamd.fragment_unpack %4083 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4085 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3950, %3991, %3942, %3988, %3983 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4086 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %3951, %3991, %3943, %3988, %4085 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4087 = waveamd.fragment_unpack %4086 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4088 = wave.issue_token %3717, %3927 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4089 = wave.after %arg152, %1388, %4088 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4090 = wave.issue_token %3921, %token_262 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4091 = wave.barrier %4089, %token_254, %token_256, %3894 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %4092 = wave.after %4091, %4090 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4093 = wave.issue_token %4092 : !wave.mem.token -> !wave.mem.token
        %4094 = wave.join %4089, %4093 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_263, %token_264 = wave.gather %1380 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_265, %token_266 = wave.gather %1380 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_267, %token_268 = wave.gather %1380 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_269, %token_270 = wave.gather %1380 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_271, %token_272 = wave.gather %1380 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_273, %token_274 = wave.gather %1380 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_275, %token_276 = wave.gather %1380 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_277, %token_278 = wave.gather %1380 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4094 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %4095 = wave.join %token_264, %token_266, %token_268, %token_270, %token_272, %token_274, %token_276, %token_278 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4096 = wave.pack %arg34, %arg35, %arg36, %arg37 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4097 = wave.scatter %4096 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %4093 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %4098 = wave.issue_token %4097 : !wave.mem.token -> !wave.mem.token
        %4099 = wave.barrier %4089, %4095, %4092 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %4100 = wave.after %4099, %4098 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4101 = wave.issue_token %4100 : !wave.mem.token -> !wave.mem.token
        %value_279, %token_280 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4101 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %4102 = wave.extract %value_279[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4103 = wave.extract %value_279[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4104 = wave.extract %value_279[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4105 = wave.extract %value_279[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4106 = wave.extract %value_279[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4107 = wave.extract %value_279[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4108 = wave.extract %value_279[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4109 = wave.extract %value_279[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %c2147483647_i32_281 = arith.constant 2147483647 : i32
        %4110 = waveamd.make_buffer %3695, %c2147483647_i32_281 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_282, %token_283 = wave.gather %4110 mapping <bit_offset = <"8*Mod(128 + t8*floor(1/64*item) + 128*t8*floor(1/64*slot) + 16*t8*floor(1/8*Mod(item, 64)) + 8*t8*floor(1/2*Mod(floor(1/16*slot), 4)) + 4*t8*Mod(floor(1/16*slot), 2) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t8"](%1, %9) after %4101 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<128xi8>, 64>, !wave.mem.token)
        %4111 = wave.scatter %value_282 to %1353 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_283 : (!wave.simd<vector<128xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %c2147483647_i32_284 = arith.constant 2147483647 : i32
        %4112 = waveamd.make_buffer %3698, %c2147483647_i32_284 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_285, %token_286 = wave.gather %4112 mapping <bit_offset = <"8*Mod(128 + t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9"](%1, %11) after %4101 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
        %4113 = wave.scatter %value_285 to %1361 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_286 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %c2147483647_i32_287 = arith.constant 2147483647 : i32
        %4114 = waveamd.make_buffer %3701, %c2147483647_i32_287 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_288, %token_289 = wave.gather %4114 mapping <bit_offset = <"8*Mod(slot + t113 + t85 + 2*t11*floor(1/64*item) + t11*floor(1/32*Mod(item, 64)) + 8*Mod(item, 2) + 128*Mod(floor(1/16*Mod(item, 64)), 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t11", "t113", "t85"](%1, %15, %1250, %780) after %4101 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, i32, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %4115 = wave.extract %value_288[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4116 = wave.extract %value_288[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4117 = wave.extract %value_288[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4118 = wave.extract %value_288[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4119 = wave.extract %value_288[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4120 = wave.extract %value_288[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4121 = wave.extract %value_288[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4122 = wave.extract %value_288[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %c2147483647_i32_290 = arith.constant 2147483647 : i32
        %4123 = waveamd.make_buffer %3711, %c2147483647_i32_290 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_291, %token_292 = wave.gather %4123 mapping <bit_offset = <"8*Mod(slot + t127 + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t127", "t99"](%1, %17, %1301, %1192) after %4101 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, i32, !wave.mem.token) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %4124 = wave.extract %value_291[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4125 = wave.extract %value_291[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4126 = wave.extract %value_291[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4127 = wave.extract %value_291[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4128 = wave.join %4111, %4113 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4129 = waveamd.fragment_pack %value_205 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4130 = waveamd.fragment_pack %value_207 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4131 = waveamd.fragment_pack %value_209 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4132 = waveamd.fragment_pack %value_211 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4133 = waveamd.fragment_pack %value_213 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4134 = waveamd.fragment_pack %value_215 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4135 = waveamd.fragment_pack %value_217 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4136 = waveamd.fragment_pack %value_219 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4137 = waveamd.fragment_pack %value_221 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4138 = waveamd.fragment_pack %value_223 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4139 = waveamd.fragment_pack %value_225 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4140 = waveamd.fragment_pack %value_227 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4141 = waveamd.fragment_pack %value_229 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4142 = waveamd.fragment_pack %value_231 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4143 = waveamd.fragment_pack %value_233 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4144 = waveamd.fragment_pack %value_235 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
        %4145 = waveamd.fragment_pack %value_263 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4146 = waveamd.fragment_pack %value_265 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4147 = waveamd.fragment_pack %value_267 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4148 = waveamd.fragment_pack %value_269 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4149 = waveamd.fragment_pack %value_271 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4150 = waveamd.fragment_pack %value_273 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4151 = waveamd.fragment_pack %value_275 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4152 = waveamd.fragment_pack %value_277 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
        %4153 = waveamd.fragment_pack %3784 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4154 = waveamd.fragment_pack %3787 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4155 = waveamd.fragment_pack %3790 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4156 = waveamd.fragment_pack %3793 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4157 = waveamd.fragment_pack %3796 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4158 = waveamd.fragment_pack %3799 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4159 = waveamd.fragment_pack %3802 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4160 = waveamd.fragment_pack %3805 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4161 = waveamd.fragment_pack %3808 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4162 = waveamd.fragment_pack %3811 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4163 = waveamd.fragment_pack %3814 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4164 = waveamd.fragment_pack %3817 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4165 = waveamd.fragment_pack %3820 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4166 = waveamd.fragment_pack %3823 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4167 = waveamd.fragment_pack %3826 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4168 = waveamd.fragment_pack %3829 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4169 = waveamd.fragment_pack %3832 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4170 = waveamd.fragment_pack %3835 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4171 = waveamd.fragment_pack %3838 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4172 = waveamd.fragment_pack %3841 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4173 = waveamd.fragment_pack %3844 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4174 = waveamd.fragment_pack %3847 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4175 = waveamd.fragment_pack %3850 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4176 = waveamd.fragment_pack %3853 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4177 = waveamd.fragment_pack %3856 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4178 = waveamd.fragment_pack %3859 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4179 = waveamd.fragment_pack %3862 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4180 = waveamd.fragment_pack %3865 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4181 = waveamd.fragment_pack %3868 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4182 = waveamd.fragment_pack %3871 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4183 = waveamd.fragment_pack %3874 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4184 = waveamd.fragment_pack %3877 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4185 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %4186 = wave.pack %3896, %3897, %3898, %3899 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4187 = wave.pack %3900, %3901, %3902, %3903 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4188 = wave.pack %3904, %3905, %3906, %3907 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4189 = wave.pack %3908, %3909, %3910, %3911 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4190 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
        %4191 = wave.pack %4102, %4103, %4104, %4105 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4192 = wave.pack %4106, %4107, %4108, %4109 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4193 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4129, %4186, %4153 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4194 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4130, %4186, %4193 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4195 = waveamd.fragment_unpack %4194 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4196 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4129, %4186, %4154 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4197 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4130, %4186, %4196 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4198 = waveamd.fragment_unpack %4197 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4199 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4129, %4186, %4155 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4200 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4130, %4186, %4199 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4201 = waveamd.fragment_unpack %4200 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4202 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4129, %4186, %4156 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4203 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4130, %4186, %4202 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4204 = waveamd.fragment_unpack %4203 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4205 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4131, %4186, %4157 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4206 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4132, %4186, %4205 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4207 = waveamd.fragment_unpack %4206 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4208 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4131, %4186, %4158 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4209 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4132, %4186, %4208 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4210 = waveamd.fragment_unpack %4209 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4211 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4131, %4186, %4159 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4212 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4132, %4186, %4211 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4213 = waveamd.fragment_unpack %4212 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4214 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4131, %4186, %4160 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4215 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4132, %4186, %4214 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4216 = waveamd.fragment_unpack %4215 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4217 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4133, %4187, %4161 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4218 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4134, %4187, %4217 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4219 = waveamd.fragment_unpack %4218 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4220 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4133, %4187, %4162 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4221 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4134, %4187, %4220 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4222 = waveamd.fragment_unpack %4221 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4223 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4133, %4187, %4163 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4224 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4134, %4187, %4223 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4225 = waveamd.fragment_unpack %4224 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4226 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4133, %4187, %4164 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4227 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4134, %4187, %4226 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4228 = waveamd.fragment_unpack %4227 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4229 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4135, %4187, %4165 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4230 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4136, %4187, %4229 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4231 = waveamd.fragment_unpack %4230 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4232 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4135, %4187, %4166 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4233 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4136, %4187, %4232 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4234 = waveamd.fragment_unpack %4233 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4235 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4135, %4187, %4167 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4236 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4136, %4187, %4235 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4237 = waveamd.fragment_unpack %4236 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4238 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4135, %4187, %4168 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4239 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4136, %4187, %4238 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4240 = waveamd.fragment_unpack %4239 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4241 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4137, %4188, %4169 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4242 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4138, %4188, %4241 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4243 = waveamd.fragment_unpack %4242 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4244 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4137, %4188, %4170 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4245 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4138, %4188, %4244 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4246 = waveamd.fragment_unpack %4245 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4247 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4137, %4188, %4171 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4248 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4138, %4188, %4247 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4249 = waveamd.fragment_unpack %4248 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4250 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4137, %4188, %4172 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4251 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4138, %4188, %4250 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4252 = waveamd.fragment_unpack %4251 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4253 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4139, %4188, %4173 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4254 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4140, %4188, %4253 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4255 = waveamd.fragment_unpack %4254 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4256 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4139, %4188, %4174 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4257 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4140, %4188, %4256 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4258 = waveamd.fragment_unpack %4257 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4259 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4139, %4188, %4175 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4260 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4140, %4188, %4259 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4261 = waveamd.fragment_unpack %4260 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4262 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4139, %4188, %4176 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4263 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4140, %4188, %4262 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4264 = waveamd.fragment_unpack %4263 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4265 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4141, %4189, %4177 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4266 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4142, %4189, %4265 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4267 = waveamd.fragment_unpack %4266 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4268 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4141, %4189, %4178 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4269 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4142, %4189, %4268 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4270 = waveamd.fragment_unpack %4269 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4271 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4141, %4189, %4179 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4272 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4142, %4189, %4271 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4273 = waveamd.fragment_unpack %4272 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4274 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4141, %4189, %4180 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4275 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4142, %4189, %4274 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4276 = waveamd.fragment_unpack %4275 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4277 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4145, %4191, %4143, %4189, %4181 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4278 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4146, %4191, %4144, %4189, %4277 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4279 = waveamd.fragment_unpack %4278 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4280 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4147, %4191, %4143, %4189, %4182 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4281 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4148, %4191, %4144, %4189, %4280 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4282 = waveamd.fragment_unpack %4281 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4283 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4149, %4192, %4143, %4189, %4183 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4284 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4150, %4192, %4144, %4189, %4283 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4285 = waveamd.fragment_unpack %4284 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4286 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4151, %4192, %4143, %4189, %4184 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4287 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %4152, %4192, %4144, %4189, %4286 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
        %4288 = waveamd.fragment_unpack %4287 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
        %4289 = wave.issue_token %3927, %4128 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4290 = wave.after %3717, %4289 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4291 = wave.issue_token %4111, %4113, %token_289, %token_292 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4292 = wave.barrier %4290, %token_280, %4100 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %4293 = wave.after %4292, %4291 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4294 = wave.issue_token %4293 : !wave.mem.token -> !wave.mem.token
        %4295 = wave.join %4290, %4294 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_293, %token_294 = wave.gather %1315 mapping <bit_offset = <"8*(128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_295, %token_296 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_297, %token_298 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_299, %token_300 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_301, %token_302 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_303, %token_304 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_305, %token_306 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_307, %token_308 = wave.gather %1315 mapping <bit_offset = <"8*(16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_309, %token_310 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_311, %token_312 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_313, %token_314 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_315, %token_316 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_317, %token_318 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_319, %token_320 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_321, %token_322 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_323, %token_324 = wave.gather %1315 mapping <bit_offset = <"8*(16896 + 16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4295 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %4296 = wave.join %token_294, %token_296, %token_298, %token_300, %token_302, %token_304, %token_306, %token_308, %token_310, %token_312, %token_314, %token_316, %token_318, %token_320, %token_322, %token_324 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4297 = wave.join %4290, %4294 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %value_325, %token_326 = wave.gather %1321 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_327, %token_328 = wave.gather %1321 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_329, %token_330 = wave.gather %1321 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_331, %token_332 = wave.gather %1321 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_333, %token_334 = wave.gather %1321 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_335, %token_336 = wave.gather %1321 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_337, %token_338 = wave.gather %1321 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %value_339, %token_340 = wave.gather %1321 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %4297 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %4298 = wave.join %token_326, %token_328, %token_330, %token_332, %token_334, %token_336, %token_338, %token_340 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4299 = wave.pack %3703, %3704, %3705, %3706, %3707, %3708, %3709, %3710 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
        %4300 = wave.scatter %4299 to %1404 mapping <bit_offset = <"8*(slot + 512*floor(1/64*item) + 16*floor(1/2*Mod(item, 64)) + 8*Mod(item, 2))">> bindings ["item"](%1) after %4294 : (!wave.simd<vector<8xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %4301 = wave.pack %3713, %3714, %3715, %3716 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
        %4302 = wave.scatter %4301 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %4294 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %4303 = wave.issue_token %4300, %4302 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4304 = wave.barrier %4290, %4296, %4298, %4293 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
        %4305 = wave.after %4304, %4303 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4306 = wave.issue_token %4305 : !wave.mem.token -> !wave.mem.token
        %value_341, %token_342 = wave.gather %1404 mapping <bit_offset = <"8*(16*floor(1/128*item) + 256*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 1024*Mod(slot, 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4306 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
        %4307 = wave.extract %value_341[0] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4308 = wave.extract %value_341[1] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4309 = wave.extract %value_341[2] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4310 = wave.extract %value_341[3] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4311 = wave.extract %value_341[4] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4312 = wave.extract %value_341[5] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4313 = wave.extract %value_341[6] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4314 = wave.extract %value_341[7] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4315 = wave.extract %value_341[8] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4316 = wave.extract %value_341[9] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4317 = wave.extract %value_341[10] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4318 = wave.extract %value_341[11] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4319 = wave.extract %value_341[12] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4320 = wave.extract %value_341[13] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4321 = wave.extract %value_341[14] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %4322 = wave.extract %value_341[15] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
        %value_343, %token_344 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %4306 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
        %4323 = wave.extract %value_343[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4324 = wave.extract %value_343[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4325 = wave.extract %value_343[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4326 = wave.extract %value_343[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4327 = wave.extract %value_343[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4328 = wave.extract %value_343[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4329 = wave.extract %value_343[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %4330 = wave.extract %value_343[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
        %c2147483647_i32_345 = arith.constant 2147483647 : i32
        %4331 = waveamd.make_buffer %3698, %c2147483647_i32_345 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_346, %token_347 = wave.gather %4331 mapping <bit_offset = <"8*Mod(128 + t94 + t9*floor(1/64*item) + 4*t9*floor(1/16*slot) + 16*t9*floor(1/8*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/4*Mod(item, 64)), 2) + 32*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t9", "t94"](%1, %11, %998) after %4306 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> (!wave.simd<vector<64xi8>, 64>, !wave.mem.token)
        %4332 = wave.scatter %value_346 to %1380 mapping <bit_offset = <"8*(1056*floor(1/64*item) + 4224*floor(1/16*slot) + 32*floor(1/2*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 16*Mod(item, 2) + Mod(slot, 2))">> bindings ["item"](%1) after %token_347 : (!wave.simd<vector<64xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
        %c2147483647_i32_348 = arith.constant 2147483647 : i32
        %4333 = waveamd.make_buffer %3711, %c2147483647_i32_348 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
        %value_349, %token_350 = wave.gather %4333 mapping <bit_offset = <"8*Mod(128 + slot + t127 + t99 + 2*t12*floor(1/64*item) + t12*floor(1/32*Mod(item, 64)) + 4*Mod(item, 2) + 64*Mod(floor(1/16*Mod(item, 64)), 2) + 32*Mod(floor(1/8*Mod(item, 64)), 2) + 16*Mod(floor(1/4*Mod(item, 64)), 2) + 8*Mod(floor(1/2*Mod(item, 64)), 2), 4294967296)">> bindings ["item", "t12", "t127", "t99"](%1, %17, %1301, %1192) after %4306 : (!wave.ptr<#waveamd.buffer, i8>, !wave.simd<i32, 64>, i32, i32, i32, !wave.mem.token) -> (!wave.simd<vector<4xi8>, 64>, !wave.mem.token)
        %4334 = wave.extract %value_349[0] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4335 = wave.extract %value_349[1] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4336 = wave.extract %value_349[2] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4337 = wave.extract %value_349[3] : !wave.simd<vector<4xi8>, 64> -> !wave.simd<i8, 64>
        %4338 = wave.join %4332 : !wave.mem.token -> !wave.mem.token
        %4339 = wave.binary addi %arg14, %c256_i32 : i32, i32 -> i32
        %4340 = wave.binary addi %arg15, %c256_i32 : i32, i32 -> i32
        %4341 = wave.binary addi %arg16, %1391 : i32, i32 -> i32
        %4342 = wave.binary addi %arg17, %1392 : i32, i32 -> i32
        %4343 = wave.join %arg150, %3927 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4344 = wave.join %arg151, %4128 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4345 = wave.join %arg152, %4338 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
        %4346 = wave.join %4305, %token_342, %token_344 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
        scf.yield %4339, %4340, %4341, %4342, %3923, %3924, %3925, %3926, %4115, %4116, %4117, %4118, %4119, %4120, %4121, %4122, %4124, %4125, %4126, %4127, %4334, %4335, %4336, %4337, %4307, %4308, %4309, %4310, %4311, %4312, %4313, %4314, %4315, %4316, %4317, %4318, %4319, %4320, %4321, %4322, %4323, %4324, %4325, %4326, %4327, %4328, %4329, %4330, %3994, %3997, %4000, %4003, %4006, %4009, %4012, %4015, %4018, %4021, %4024, %4027, %4030, %4033, %4036, %4039, %4042, %4045, %4048, %4051, %4054, %4057, %4060, %4063, %4066, %4069, %4072, %4075, %4078, %4081, %4084, %4087, %value_293, %value_295, %value_297, %value_299, %value_301, %value_303, %value_305, %value_307, %value_309, %value_311, %value_313, %value_315, %value_317, %value_319, %value_321, %value_323, %value_325, %value_327, %value_329, %value_331, %value_333, %value_335, %value_337, %value_339, %4195, %4198, %4201, %4204, %4207, %4210, %4213, %4216, %4219, %4222, %4225, %4228, %4231, %4234, %4237, %4240, %4243, %4246, %4249, %4252, %4255, %4258, %4261, %4264, %4267, %4270, %4273, %4276, %4279, %4282, %4285, %4288, %4343, %4344, %4345, %4346 : i32, i32, i32, i32, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<16xi8>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token
      }
      %1442 = waveamd.fragment_pack %1441#80 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1443 = waveamd.fragment_pack %1441#81 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1444 = waveamd.fragment_pack %1441#82 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1445 = waveamd.fragment_pack %1441#83 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1446 = waveamd.fragment_pack %1441#84 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1447 = waveamd.fragment_pack %1441#85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1448 = waveamd.fragment_pack %1441#86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1449 = waveamd.fragment_pack %1441#87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1450 = waveamd.fragment_pack %1441#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1451 = waveamd.fragment_pack %1441#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1452 = waveamd.fragment_pack %1441#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1453 = waveamd.fragment_pack %1441#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1454 = waveamd.fragment_pack %1441#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1455 = waveamd.fragment_pack %1441#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1456 = waveamd.fragment_pack %1441#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1457 = waveamd.fragment_pack %1441#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1458 = waveamd.fragment_pack %1441#96 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1459 = waveamd.fragment_pack %1441#97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1460 = waveamd.fragment_pack %1441#98 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1461 = waveamd.fragment_pack %1441#99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1462 = waveamd.fragment_pack %1441#100 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1463 = waveamd.fragment_pack %1441#101 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1464 = waveamd.fragment_pack %1441#102 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1465 = waveamd.fragment_pack %1441#103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1466 = waveamd.fragment_pack %1441#48 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1467 = waveamd.fragment_pack %1441#49 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1468 = waveamd.fragment_pack %1441#50 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1469 = waveamd.fragment_pack %1441#51 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1470 = waveamd.fragment_pack %1441#52 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1471 = waveamd.fragment_pack %1441#53 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1472 = waveamd.fragment_pack %1441#54 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1473 = waveamd.fragment_pack %1441#55 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1474 = waveamd.fragment_pack %1441#56 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1475 = waveamd.fragment_pack %1441#57 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1476 = waveamd.fragment_pack %1441#58 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1477 = waveamd.fragment_pack %1441#59 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1478 = waveamd.fragment_pack %1441#60 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1479 = waveamd.fragment_pack %1441#61 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1480 = waveamd.fragment_pack %1441#62 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1481 = waveamd.fragment_pack %1441#63 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1482 = waveamd.fragment_pack %1441#64 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1483 = waveamd.fragment_pack %1441#65 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1484 = waveamd.fragment_pack %1441#66 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1485 = waveamd.fragment_pack %1441#67 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1486 = waveamd.fragment_pack %1441#68 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1487 = waveamd.fragment_pack %1441#69 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1488 = waveamd.fragment_pack %1441#70 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1489 = waveamd.fragment_pack %1441#71 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1490 = waveamd.fragment_pack %1441#72 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1491 = waveamd.fragment_pack %1441#73 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1492 = waveamd.fragment_pack %1441#74 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1493 = waveamd.fragment_pack %1441#75 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1494 = waveamd.fragment_pack %1441#76 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1495 = waveamd.fragment_pack %1441#77 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1496 = waveamd.fragment_pack %1441#78 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1497 = waveamd.fragment_pack %1441#79 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1498 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %1499 = wave.pack %1441#24, %1441#25, %1441#26, %1441#27 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1500 = wave.pack %1441#28, %1441#29, %1441#30, %1441#31 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1501 = wave.pack %1441#32, %1441#33, %1441#34, %1441#35 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1502 = wave.pack %1441#36, %1441#37, %1441#38, %1441#39 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1503 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %1504 = wave.pack %1441#40, %1441#41, %1441#42, %1441#43 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1505 = wave.pack %1441#44, %1441#45, %1441#46, %1441#47 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1506 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1442, %1499, %1466 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1507 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1443, %1499, %1506 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1508 = waveamd.fragment_unpack %1507 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1509 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1442, %1499, %1467 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1510 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1443, %1499, %1509 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1511 = waveamd.fragment_unpack %1510 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1512 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1442, %1499, %1468 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1513 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1443, %1499, %1512 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1514 = waveamd.fragment_unpack %1513 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1515 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1442, %1499, %1469 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1516 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1443, %1499, %1515 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1517 = waveamd.fragment_unpack %1516 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1518 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1444, %1499, %1470 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1519 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1445, %1499, %1518 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1520 = waveamd.fragment_unpack %1519 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1521 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1444, %1499, %1471 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1522 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1445, %1499, %1521 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1523 = waveamd.fragment_unpack %1522 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1524 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1444, %1499, %1472 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1525 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1445, %1499, %1524 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1526 = waveamd.fragment_unpack %1525 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1527 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1444, %1499, %1473 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1528 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1445, %1499, %1527 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1529 = waveamd.fragment_unpack %1528 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1530 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1446, %1500, %1474 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1531 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1447, %1500, %1530 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1532 = waveamd.fragment_unpack %1531 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1533 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1446, %1500, %1475 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1534 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1447, %1500, %1533 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1535 = waveamd.fragment_unpack %1534 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1536 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1446, %1500, %1476 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1537 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1447, %1500, %1536 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1538 = waveamd.fragment_unpack %1537 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1539 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1446, %1500, %1477 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1540 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1447, %1500, %1539 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1541 = waveamd.fragment_unpack %1540 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1542 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1448, %1500, %1478 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1543 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1449, %1500, %1542 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1544 = waveamd.fragment_unpack %1543 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1545 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1448, %1500, %1479 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1546 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1449, %1500, %1545 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1547 = waveamd.fragment_unpack %1546 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1548 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1448, %1500, %1480 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1549 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1449, %1500, %1548 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1550 = waveamd.fragment_unpack %1549 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1551 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1448, %1500, %1481 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1552 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1449, %1500, %1551 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1553 = waveamd.fragment_unpack %1552 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1554 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1450, %1501, %1482 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1555 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1451, %1501, %1554 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1556 = waveamd.fragment_unpack %1555 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1557 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1450, %1501, %1483 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1558 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1451, %1501, %1557 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1559 = waveamd.fragment_unpack %1558 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1560 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1450, %1501, %1484 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1561 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1451, %1501, %1560 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1562 = waveamd.fragment_unpack %1561 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1563 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1450, %1501, %1485 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1564 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1451, %1501, %1563 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1565 = waveamd.fragment_unpack %1564 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1566 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1452, %1501, %1486 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1567 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1453, %1501, %1566 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1568 = waveamd.fragment_unpack %1567 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1569 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1452, %1501, %1487 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1570 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1453, %1501, %1569 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1571 = waveamd.fragment_unpack %1570 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1572 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1452, %1501, %1488 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1573 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1453, %1501, %1572 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1574 = waveamd.fragment_unpack %1573 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1575 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1452, %1501, %1489 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1576 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1453, %1501, %1575 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1577 = waveamd.fragment_unpack %1576 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1578 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1454, %1502, %1490 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1579 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1455, %1502, %1578 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1580 = waveamd.fragment_unpack %1579 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1581 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1454, %1502, %1491 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1582 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1455, %1502, %1581 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1583 = waveamd.fragment_unpack %1582 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1584 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1454, %1502, %1492 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1585 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1455, %1502, %1584 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1586 = waveamd.fragment_unpack %1585 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1587 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1454, %1502, %1493 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1588 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1455, %1502, %1587 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1589 = waveamd.fragment_unpack %1588 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1590 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1458, %1504, %1456, %1502, %1494 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1591 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1459, %1504, %1457, %1502, %1590 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1592 = waveamd.fragment_unpack %1591 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1593 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1460, %1504, %1456, %1502, %1495 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1594 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1461, %1504, %1457, %1502, %1593 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1595 = waveamd.fragment_unpack %1594 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1596 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1462, %1505, %1456, %1502, %1496 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1597 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1463, %1505, %1457, %1502, %1596 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1598 = waveamd.fragment_unpack %1597 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1599 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1464, %1505, %1456, %1502, %1497 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1600 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1465, %1505, %1457, %1502, %1599 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1601 = waveamd.fragment_unpack %1600 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1602 = wave.issue_token %1441#137, %1441#138 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1603 = wave.after %1441#136, %1602 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1604 = wave.barrier %1603, %token_82, %token_84, %1441#139 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1605 = wave.after %1604, %1414 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1606 = wave.issue_token %1605 : !wave.mem.token -> !wave.mem.token
      %1607 = wave.join %1603, %1606 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_85, %token_86 = wave.gather %1342 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_87, %token_88 = wave.gather %1342 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_89, %token_90 = wave.gather %1342 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_91, %token_92 = wave.gather %1342 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_93, %token_94 = wave.gather %1342 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_95, %token_96 = wave.gather %1342 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_97, %token_98 = wave.gather %1342 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_99, %token_100 = wave.gather %1342 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1607 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1608 = wave.join %token_86, %token_88, %token_90, %token_92, %token_94, %token_96, %token_98, %token_100 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1609 = wave.pack %1441#4, %1441#5, %1441#6, %1441#7 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1610 = wave.scatter %1609 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %1606 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1611 = wave.issue_token %1610 : !wave.mem.token -> !wave.mem.token
      %1612 = wave.barrier %1603, %1608, %1605 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1613 = wave.after %1612, %1611 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1614 = wave.issue_token %1613 : !wave.mem.token -> !wave.mem.token
      %value_101, %token_102 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1614 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1615 = wave.extract %value_101[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1616 = wave.extract %value_101[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1617 = wave.extract %value_101[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1618 = wave.extract %value_101[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1619 = wave.extract %value_101[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1620 = wave.extract %value_101[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1621 = wave.extract %value_101[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1622 = wave.extract %value_101[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1623 = waveamd.fragment_pack %1441#80 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1624 = waveamd.fragment_pack %1441#81 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1625 = waveamd.fragment_pack %1441#82 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1626 = waveamd.fragment_pack %1441#83 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1627 = waveamd.fragment_pack %1441#84 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1628 = waveamd.fragment_pack %1441#85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1629 = waveamd.fragment_pack %1441#86 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1630 = waveamd.fragment_pack %1441#87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1631 = waveamd.fragment_pack %1441#88 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1632 = waveamd.fragment_pack %1441#89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1633 = waveamd.fragment_pack %1441#90 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1634 = waveamd.fragment_pack %1441#91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1635 = waveamd.fragment_pack %1441#92 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1636 = waveamd.fragment_pack %1441#93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1637 = waveamd.fragment_pack %1441#94 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1638 = waveamd.fragment_pack %1441#95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1639 = waveamd.fragment_pack %value_85 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1640 = waveamd.fragment_pack %value_87 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1641 = waveamd.fragment_pack %value_89 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1642 = waveamd.fragment_pack %value_91 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1643 = waveamd.fragment_pack %value_93 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1644 = waveamd.fragment_pack %value_95 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1645 = waveamd.fragment_pack %value_97 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1646 = waveamd.fragment_pack %value_99 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1647 = waveamd.fragment_pack %1441#104 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1648 = waveamd.fragment_pack %1441#105 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1649 = waveamd.fragment_pack %1441#106 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1650 = waveamd.fragment_pack %1441#107 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1651 = waveamd.fragment_pack %1441#108 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1652 = waveamd.fragment_pack %1441#109 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1653 = waveamd.fragment_pack %1441#110 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1654 = waveamd.fragment_pack %1441#111 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1655 = waveamd.fragment_pack %1441#112 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1656 = waveamd.fragment_pack %1441#113 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1657 = waveamd.fragment_pack %1441#114 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1658 = waveamd.fragment_pack %1441#115 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1659 = waveamd.fragment_pack %1441#116 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1660 = waveamd.fragment_pack %1441#117 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1661 = waveamd.fragment_pack %1441#118 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1662 = waveamd.fragment_pack %1441#119 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1663 = waveamd.fragment_pack %1441#120 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1664 = waveamd.fragment_pack %1441#121 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1665 = waveamd.fragment_pack %1441#122 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1666 = waveamd.fragment_pack %1441#123 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1667 = waveamd.fragment_pack %1441#124 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1668 = waveamd.fragment_pack %1441#125 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1669 = waveamd.fragment_pack %1441#126 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1670 = waveamd.fragment_pack %1441#127 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1671 = waveamd.fragment_pack %1441#128 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1672 = waveamd.fragment_pack %1441#129 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1673 = waveamd.fragment_pack %1441#130 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1674 = waveamd.fragment_pack %1441#131 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1675 = waveamd.fragment_pack %1441#132 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1676 = waveamd.fragment_pack %1441#133 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1677 = waveamd.fragment_pack %1441#134 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1678 = waveamd.fragment_pack %1441#135 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1679 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %1680 = wave.pack %1441#24, %1441#25, %1441#26, %1441#27 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1681 = wave.pack %1441#28, %1441#29, %1441#30, %1441#31 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1682 = wave.pack %1441#32, %1441#33, %1441#34, %1441#35 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1683 = wave.pack %1441#36, %1441#37, %1441#38, %1441#39 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1684 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %1685 = wave.pack %1615, %1616, %1617, %1618 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1686 = wave.pack %1619, %1620, %1621, %1622 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1687 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1623, %1680, %1647 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1688 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1624, %1680, %1687 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1689 = waveamd.fragment_unpack %1688 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1690 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1623, %1680, %1648 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1691 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1624, %1680, %1690 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1692 = waveamd.fragment_unpack %1691 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1693 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1623, %1680, %1649 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1694 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1624, %1680, %1693 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1695 = waveamd.fragment_unpack %1694 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1696 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1623, %1680, %1650 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1697 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1624, %1680, %1696 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1698 = waveamd.fragment_unpack %1697 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1699 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1625, %1680, %1651 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1700 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1626, %1680, %1699 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1701 = waveamd.fragment_unpack %1700 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1702 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1625, %1680, %1652 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1703 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1626, %1680, %1702 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1704 = waveamd.fragment_unpack %1703 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1705 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1625, %1680, %1653 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1706 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1626, %1680, %1705 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1707 = waveamd.fragment_unpack %1706 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1708 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1625, %1680, %1654 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1709 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1626, %1680, %1708 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1710 = waveamd.fragment_unpack %1709 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1711 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1627, %1681, %1655 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1712 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1628, %1681, %1711 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1713 = waveamd.fragment_unpack %1712 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1714 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1627, %1681, %1656 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1715 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1628, %1681, %1714 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1716 = waveamd.fragment_unpack %1715 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1717 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1627, %1681, %1657 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1718 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1628, %1681, %1717 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1719 = waveamd.fragment_unpack %1718 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1720 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1627, %1681, %1658 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1721 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1628, %1681, %1720 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1722 = waveamd.fragment_unpack %1721 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1723 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1629, %1681, %1659 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1724 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1630, %1681, %1723 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1725 = waveamd.fragment_unpack %1724 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1726 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1629, %1681, %1660 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1727 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1630, %1681, %1726 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1728 = waveamd.fragment_unpack %1727 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1729 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1629, %1681, %1661 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1730 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1630, %1681, %1729 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1731 = waveamd.fragment_unpack %1730 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1732 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1629, %1681, %1662 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1733 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1630, %1681, %1732 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1734 = waveamd.fragment_unpack %1733 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1735 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1631, %1682, %1663 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1736 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1632, %1682, %1735 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1737 = waveamd.fragment_unpack %1736 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1738 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1631, %1682, %1664 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1739 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1632, %1682, %1738 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1740 = waveamd.fragment_unpack %1739 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1741 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1631, %1682, %1665 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1742 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1632, %1682, %1741 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1743 = waveamd.fragment_unpack %1742 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1744 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1631, %1682, %1666 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1745 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1632, %1682, %1744 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1746 = waveamd.fragment_unpack %1745 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1747 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1633, %1682, %1667 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1748 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1634, %1682, %1747 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1749 = waveamd.fragment_unpack %1748 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1750 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1633, %1682, %1668 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1751 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1634, %1682, %1750 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1752 = waveamd.fragment_unpack %1751 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1753 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1633, %1682, %1669 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1754 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1634, %1682, %1753 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1755 = waveamd.fragment_unpack %1754 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1756 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1633, %1682, %1670 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1757 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1634, %1682, %1756 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1758 = waveamd.fragment_unpack %1757 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1759 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1635, %1683, %1671 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1760 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1636, %1683, %1759 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1761 = waveamd.fragment_unpack %1760 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1762 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1635, %1683, %1672 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1763 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1636, %1683, %1762 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1764 = waveamd.fragment_unpack %1763 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1765 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1635, %1683, %1673 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1766 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1636, %1683, %1765 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1767 = waveamd.fragment_unpack %1766 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1768 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1635, %1683, %1674 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1636, %1683, %1768 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1770 = waveamd.fragment_unpack %1769 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1771 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1639, %1685, %1637, %1683, %1675 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1772 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1640, %1685, %1638, %1683, %1771 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1773 = waveamd.fragment_unpack %1772 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1774 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1641, %1685, %1637, %1683, %1676 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1775 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1642, %1685, %1638, %1683, %1774 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1776 = waveamd.fragment_unpack %1775 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1777 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1643, %1686, %1637, %1683, %1677 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1778 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1644, %1686, %1638, %1683, %1777 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1779 = waveamd.fragment_unpack %1778 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1780 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1645, %1686, %1637, %1683, %1678 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1781 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1646, %1686, %1638, %1683, %1780 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1782 = waveamd.fragment_unpack %1781 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1783 = wave.issue_token %1441#138 : !wave.mem.token -> !wave.mem.token
      %1784 = wave.after %1441#137, %1783 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1785 = wave.barrier %1784, %token_102, %1613 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1786 = wave.after %1785, %1614 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1787 = wave.issue_token %1786 : !wave.mem.token -> !wave.mem.token
      %1788 = wave.join %1784, %1787 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_103, %token_104 = wave.gather %1353 mapping <bit_offset = <"8*(128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_105, %token_106 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_107, %token_108 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_109, %token_110 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_111, %token_112 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_113, %token_114 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_115, %token_116 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_117, %token_118 = wave.gather %1353 mapping <bit_offset = <"8*(16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_119, %token_120 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 128*floor(1/128*item) + 16896*floor(1/128*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/64*slot), 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_121, %token_122 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(1/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/4 + 1/64*slot), 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_123, %token_124 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(1/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(1/2 + 1/64*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_125, %token_126 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(3/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 512*Mod(floor(3/4 + 1/64*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_127, %token_128 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(1/2 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/32*slot), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/64*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_129, %token_130 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(5/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 256*Mod(floor(1/2 + 1/32*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_131, %token_132 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(3/4 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 512*xor(1, Mod(floor(1/2 + 1/64*slot), 2)) + 256*xor(1, Mod(floor(1/32*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_133, %token_134 = wave.gather %1353 mapping <bit_offset = <"8*(16896 + 16896*floor(7/8 + 1/128*slot) + 128*floor(1/128*item) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 256*xor(1, Mod(floor(1/2 + 1/32*slot), 2)) + 512*xor(1, Mod(floor(3/4 + 1/64*slot), 2)) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1788 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1789 = wave.join %token_104, %token_106, %token_108, %token_110, %token_112, %token_114, %token_116, %token_118, %token_120, %token_122, %token_124, %token_126, %token_128, %token_130, %token_132, %token_134 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1790 = wave.join %1784, %1787 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_135, %token_136 = wave.gather %1361 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_137, %token_138 = wave.gather %1361 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_139, %token_140 = wave.gather %1361 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_141, %token_142 = wave.gather %1361 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_143, %token_144 = wave.gather %1361 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_145, %token_146 = wave.gather %1361 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_147, %token_148 = wave.gather %1361 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_149, %token_150 = wave.gather %1361 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1790 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1791 = wave.join %token_136, %token_138, %token_140, %token_142, %token_144, %token_146, %token_148, %token_150 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1792 = wave.pack %1441#8, %1441#9, %1441#10, %1441#11, %1441#12, %1441#13, %1441#14, %1441#15 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<8xi8>, 64>
      %1793 = wave.scatter %1792 to %1404 mapping <bit_offset = <"8*(slot + 512*floor(1/64*item) + 16*floor(1/2*Mod(item, 64)) + 8*Mod(item, 2))">> bindings ["item"](%1) after %1787 : (!wave.simd<vector<8xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1794 = wave.pack %1441#16, %1441#17, %1441#18, %1441#19 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1795 = wave.scatter %1794 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %1787 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1796 = wave.issue_token %1793, %1795 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1797 = wave.barrier %1784, %1789, %1791, %1786 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1798 = wave.after %1797, %1796 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1799 = wave.issue_token %1798 : !wave.mem.token -> !wave.mem.token
      %value_151, %token_152 = wave.gather %1404 mapping <bit_offset = <"8*(16*floor(1/128*item) + 256*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 1024*Mod(slot, 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1799 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1800 = wave.extract %value_151[0] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1801 = wave.extract %value_151[1] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1802 = wave.extract %value_151[2] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1803 = wave.extract %value_151[3] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1804 = wave.extract %value_151[4] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1805 = wave.extract %value_151[5] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1806 = wave.extract %value_151[6] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1807 = wave.extract %value_151[7] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1808 = wave.extract %value_151[8] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1809 = wave.extract %value_151[9] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1810 = wave.extract %value_151[10] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1811 = wave.extract %value_151[11] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1812 = wave.extract %value_151[12] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1813 = wave.extract %value_151[13] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1814 = wave.extract %value_151[14] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %1815 = wave.extract %value_151[15] : !wave.simd<vector<16xi8>, 64> -> !wave.simd<i8, 64>
      %value_153, %token_154 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1799 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1816 = wave.extract %value_153[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1817 = wave.extract %value_153[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1818 = wave.extract %value_153[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1819 = wave.extract %value_153[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1820 = wave.extract %value_153[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1821 = wave.extract %value_153[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1822 = wave.extract %value_153[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1823 = wave.extract %value_153[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1824 = waveamd.fragment_pack %value_103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1825 = waveamd.fragment_pack %value_105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1826 = waveamd.fragment_pack %value_107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1827 = waveamd.fragment_pack %value_109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1828 = waveamd.fragment_pack %value_111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1829 = waveamd.fragment_pack %value_113 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1830 = waveamd.fragment_pack %value_115 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1831 = waveamd.fragment_pack %value_117 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1832 = waveamd.fragment_pack %value_119 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1833 = waveamd.fragment_pack %value_121 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1834 = waveamd.fragment_pack %value_123 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1835 = waveamd.fragment_pack %value_125 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1836 = waveamd.fragment_pack %value_127 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1837 = waveamd.fragment_pack %value_129 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1838 = waveamd.fragment_pack %value_131 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1839 = waveamd.fragment_pack %value_133 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %1840 = waveamd.fragment_pack %value_135 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1841 = waveamd.fragment_pack %value_137 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1842 = waveamd.fragment_pack %value_139 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1843 = waveamd.fragment_pack %value_141 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1844 = waveamd.fragment_pack %value_143 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1845 = waveamd.fragment_pack %value_145 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1846 = waveamd.fragment_pack %value_147 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1847 = waveamd.fragment_pack %value_149 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %1848 = waveamd.fragment_pack %1508 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1849 = waveamd.fragment_pack %1511 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1850 = waveamd.fragment_pack %1514 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1851 = waveamd.fragment_pack %1517 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1852 = waveamd.fragment_pack %1520 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1853 = waveamd.fragment_pack %1523 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1854 = waveamd.fragment_pack %1526 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1855 = waveamd.fragment_pack %1529 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1856 = waveamd.fragment_pack %1532 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1857 = waveamd.fragment_pack %1535 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1858 = waveamd.fragment_pack %1538 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1859 = waveamd.fragment_pack %1541 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1860 = waveamd.fragment_pack %1544 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1861 = waveamd.fragment_pack %1547 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1862 = waveamd.fragment_pack %1550 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1863 = waveamd.fragment_pack %1553 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1864 = waveamd.fragment_pack %1556 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1865 = waveamd.fragment_pack %1559 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1866 = waveamd.fragment_pack %1562 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1867 = waveamd.fragment_pack %1565 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1868 = waveamd.fragment_pack %1568 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1869 = waveamd.fragment_pack %1571 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1870 = waveamd.fragment_pack %1574 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1871 = waveamd.fragment_pack %1577 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1872 = waveamd.fragment_pack %1580 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1873 = waveamd.fragment_pack %1583 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1874 = waveamd.fragment_pack %1586 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1875 = waveamd.fragment_pack %1589 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1876 = waveamd.fragment_pack %1592 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1877 = waveamd.fragment_pack %1595 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1878 = waveamd.fragment_pack %1598 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1879 = waveamd.fragment_pack %1601 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1880 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %1881 = wave.pack %1800, %1801, %1802, %1803 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1882 = wave.pack %1804, %1805, %1806, %1807 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1883 = wave.pack %1808, %1809, %1810, %1811 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1884 = wave.pack %1812, %1813, %1814, %1815 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1885 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %1886 = wave.pack %1816, %1817, %1818, %1819 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1887 = wave.pack %1820, %1821, %1822, %1823 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1888 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1824, %1881, %1848 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1889 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1825, %1881, %1888 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1890 = waveamd.fragment_unpack %1889 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1891 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1824, %1881, %1849 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1892 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1825, %1881, %1891 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1893 = waveamd.fragment_unpack %1892 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1894 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1824, %1881, %1850 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1895 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1825, %1881, %1894 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1896 = waveamd.fragment_unpack %1895 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1897 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1824, %1881, %1851 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1898 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1825, %1881, %1897 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1899 = waveamd.fragment_unpack %1898 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1900 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1826, %1881, %1852 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1901 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1827, %1881, %1900 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1902 = waveamd.fragment_unpack %1901 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1903 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1826, %1881, %1853 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1904 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1827, %1881, %1903 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1905 = waveamd.fragment_unpack %1904 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1906 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1826, %1881, %1854 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1907 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1827, %1881, %1906 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1908 = waveamd.fragment_unpack %1907 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1909 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1826, %1881, %1855 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1910 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1827, %1881, %1909 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1911 = waveamd.fragment_unpack %1910 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1912 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1828, %1882, %1856 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1913 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1829, %1882, %1912 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1914 = waveamd.fragment_unpack %1913 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1915 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1828, %1882, %1857 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1916 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1829, %1882, %1915 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1917 = waveamd.fragment_unpack %1916 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1918 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1828, %1882, %1858 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1919 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1829, %1882, %1918 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1920 = waveamd.fragment_unpack %1919 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1921 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1828, %1882, %1859 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1922 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1829, %1882, %1921 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1923 = waveamd.fragment_unpack %1922 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1924 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1830, %1882, %1860 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1925 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1831, %1882, %1924 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1926 = waveamd.fragment_unpack %1925 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1927 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1830, %1882, %1861 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1928 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1831, %1882, %1927 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1929 = waveamd.fragment_unpack %1928 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1930 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1830, %1882, %1862 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1931 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1831, %1882, %1930 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1932 = waveamd.fragment_unpack %1931 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1933 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1830, %1882, %1863 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1934 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1831, %1882, %1933 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1935 = waveamd.fragment_unpack %1934 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1936 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1832, %1883, %1864 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1937 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1833, %1883, %1936 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1938 = waveamd.fragment_unpack %1937 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1939 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1832, %1883, %1865 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1940 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1833, %1883, %1939 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1941 = waveamd.fragment_unpack %1940 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1942 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1832, %1883, %1866 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1943 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1833, %1883, %1942 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1944 = waveamd.fragment_unpack %1943 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1945 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1832, %1883, %1867 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1946 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1833, %1883, %1945 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1947 = waveamd.fragment_unpack %1946 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1948 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1834, %1883, %1868 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1949 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1835, %1883, %1948 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1950 = waveamd.fragment_unpack %1949 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1951 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1834, %1883, %1869 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1952 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1835, %1883, %1951 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1953 = waveamd.fragment_unpack %1952 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1954 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1834, %1883, %1870 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1955 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1835, %1883, %1954 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1956 = waveamd.fragment_unpack %1955 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1957 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1834, %1883, %1871 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1958 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1835, %1883, %1957 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1959 = waveamd.fragment_unpack %1958 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1960 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1836, %1884, %1872 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1961 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1837, %1884, %1960 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1962 = waveamd.fragment_unpack %1961 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1963 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1836, %1884, %1873 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1964 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1837, %1884, %1963 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1965 = waveamd.fragment_unpack %1964 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1966 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1836, %1884, %1874 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1967 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1837, %1884, %1966 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1968 = waveamd.fragment_unpack %1967 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1969 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1836, %1884, %1875 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1970 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1837, %1884, %1969 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1971 = waveamd.fragment_unpack %1970 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1972 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1840, %1886, %1838, %1884, %1876 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1973 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1841, %1886, %1839, %1884, %1972 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1974 = waveamd.fragment_unpack %1973 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1975 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1842, %1886, %1838, %1884, %1877 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1976 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1843, %1886, %1839, %1884, %1975 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1977 = waveamd.fragment_unpack %1976 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1978 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1844, %1887, %1838, %1884, %1878 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1979 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1845, %1887, %1839, %1884, %1978 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1980 = waveamd.fragment_unpack %1979 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1981 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1846, %1887, %1838, %1884, %1879 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1982 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %1847, %1887, %1839, %1884, %1981 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %1983 = waveamd.fragment_unpack %1982 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %1984 = wave.after %1441#138 : !wave.mem.token -> !wave.mem.token
      %1985 = wave.barrier %1984, %token_152, %token_154, %1798 : (!wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1986 = wave.after %1985, %1799 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1987 = wave.issue_token %1986 : !wave.mem.token -> !wave.mem.token
      %1988 = wave.join %1984, %1987 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %value_155, %token_156 = wave.gather %1380 mapping <bit_offset = <"8*(256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_157, %token_158 = wave.gather %1380 mapping <bit_offset = <"8*(256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_159, %token_160 = wave.gather %1380 mapping <bit_offset = <"8*(256 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_161, %token_162 = wave.gather %1380 mapping <bit_offset = <"8*(256 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_163, %token_164 = wave.gather %1380 mapping <bit_offset = <"8*(512 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_165, %token_166 = wave.gather %1380 mapping <bit_offset = <"8*(512 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_167, %token_168 = wave.gather %1380 mapping <bit_offset = <"8*(768 + 256*floor(1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 64*Mod(floor(1/16*slot), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %value_169, %token_170 = wave.gather %1380 mapping <bit_offset = <"8*(768 + 256*floor(1/2 + 1/32*slot) + 16*floor(1/16*Mod(item, 64)) + 2*floor(1/2*Mod(slot, 16)) + 1056*Mod(item, 2) + Mod(slot, 2) + 128*Mod(floor(1/64*item), 2) + 8448*Mod(floor(1/8*Mod(item, 64)), 2) + 4224*Mod(floor(1/4*Mod(item, 64)), 2) + 2112*Mod(floor(1/2*Mod(item, 64)), 2) + 64*xor(1, Mod(floor(1/16*slot), 2)))">> bindings ["item"](%1) after %1988 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
      %1989 = wave.join %token_156, %token_158, %token_160, %token_162, %token_164, %token_166, %token_168, %token_170 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1990 = wave.pack %1441#20, %1441#21, %1441#22, %1441#23 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %1991 = wave.scatter %1990 to %1408 mapping <bit_offset = <"8*(slot + 256*floor(1/64*item) + 8*floor(1/2*Mod(item, 64)) + 4*Mod(item, 2))">> bindings ["item"](%1) after %1987 : (!wave.simd<vector<4xi8>, 64>, !wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> !wave.mem.token
      %1992 = wave.issue_token %1991 : !wave.mem.token -> !wave.mem.token
      %1993 = wave.barrier %1984, %1989, %1986 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %1994 = wave.after %1993, %1992 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %1995 = wave.issue_token %1994 : !wave.mem.token -> !wave.mem.token
      %value_171, %token_172 = wave.gather %1408 mapping <bit_offset = <"8*(128*floor(1/16*Mod(item, 64)) + 32*floor(1/2*slot) + Mod(item, 2) + 512*Mod(slot, 2) + 16*Mod(floor(1/64*item), 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(item, 64)), 2))">> bindings ["item"](%1) after %1995 : (!wave.ptr<#wave.shared, i8>, !wave.simd<i32, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
      %1996 = wave.extract %value_171[0] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1997 = wave.extract %value_171[1] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1998 = wave.extract %value_171[2] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %1999 = wave.extract %value_171[3] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %2000 = wave.extract %value_171[4] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %2001 = wave.extract %value_171[5] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %2002 = wave.extract %value_171[6] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %2003 = wave.extract %value_171[7] : !wave.simd<vector<8xi8>, 64> -> !wave.simd<i8, 64>
      %2004 = wave.splat %13 : i32 -> !wave.simd<i32, 64>
      %2005 = wave.binary muli %2004, %69 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2006 = wave.binary muli %2004, %71 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2007 = wave.binary muli %2004, %73 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2008 = wave.binary muli %2004, %75 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2009 = wave.binary muli %2004, %77 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2010 = wave.binary muli %2004, %79 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2011 = wave.binary muli %2004, %81 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2012 = wave.binary muli %2004, %83 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2013 = wave.binary muli %2004, %85 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2014 = wave.binary muli %2004, %87 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2015 = wave.binary muli %2004, %89 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2016 = wave.binary muli %2004, %91 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2017 = wave.binary muli %2004, %93 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2018 = wave.binary muli %2004, %95 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2019 = wave.binary muli %2004, %97 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2020 = wave.binary muli %2004, %99 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2021 = wave.pack %2005, %2006, %2007, %2008, %2009, %2010, %2011, %2012, %2013, %2014, %2015, %2016, %2017, %2018, %2019, %2020 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<16xi32>, 64>
      %2022 = wave.redistribute %2021, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<16xi32>, 64> -> !wave.simd<vector<16xi32>, 64>
      %2023 = wave.extract %2022[0] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2024 = wave.extract %2022[1] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2025 = wave.extract %2022[2] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2026 = wave.extract %2022[3] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2027 = wave.extract %2022[4] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2028 = wave.extract %2022[5] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2029 = wave.extract %2022[6] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2030 = wave.extract %2022[7] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2031 = wave.extract %2022[8] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2032 = wave.extract %2022[9] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2033 = wave.extract %2022[10] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2034 = wave.extract %2022[11] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2035 = wave.extract %2022[12] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2036 = wave.extract %2022[13] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2037 = wave.extract %2022[14] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2038 = wave.extract %2022[15] : !wave.simd<vector<16xi32>, 64> -> !wave.simd<i32, 64>
      %2039 = wave.pack %1266, %1267, %1268, %1269, %1270, %1271, %1272, %1273 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %2040 = wave.redistribute %2039, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "slot"> : !wave.simd<vector<8xi32>, 64> -> !wave.simd<vector<8xi32>, 64>
      %2041 = wave.extract %2040[0] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2042 = wave.extract %2040[1] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2043 = wave.extract %2040[2] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2044 = wave.extract %2040[3] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2045 = wave.extract %2040[4] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2046 = wave.extract %2040[5] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2047 = wave.extract %2040[6] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2048 = wave.extract %2040[7] : !wave.simd<vector<8xi32>, 64> -> !wave.simd<i32, 64>
      %2049 = wave.pack %2023, %2024, %2025, %2026, %2027, %2028, %2029, %2030, %2031, %2032, %2033, %2034, %2035, %2036, %2037, %2038 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<16xi32>, 64>
      %2050 = wave.redistribute %2049, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "floor(1/8*slot)"> : !wave.simd<vector<16xi32>, 64> -> !wave.simd<vector<128xi32>, 64>
      %2051 = wave.extract %2050[0] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2052 = wave.extract %2050[1] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2053 = wave.extract %2050[2] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2054 = wave.extract %2050[3] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2055 = wave.extract %2050[4] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2056 = wave.extract %2050[5] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2057 = wave.extract %2050[6] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2058 = wave.extract %2050[7] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2059 = wave.extract %2050[8] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2060 = wave.extract %2050[9] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2061 = wave.extract %2050[10] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2062 = wave.extract %2050[11] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2063 = wave.extract %2050[12] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2064 = wave.extract %2050[13] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2065 = wave.extract %2050[14] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2066 = wave.extract %2050[15] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2067 = wave.extract %2050[16] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2068 = wave.extract %2050[17] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2069 = wave.extract %2050[18] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2070 = wave.extract %2050[19] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2071 = wave.extract %2050[20] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2072 = wave.extract %2050[21] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2073 = wave.extract %2050[22] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2074 = wave.extract %2050[23] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2075 = wave.extract %2050[24] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2076 = wave.extract %2050[25] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2077 = wave.extract %2050[26] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2078 = wave.extract %2050[27] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2079 = wave.extract %2050[28] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2080 = wave.extract %2050[29] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2081 = wave.extract %2050[30] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2082 = wave.extract %2050[31] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2083 = wave.extract %2050[32] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2084 = wave.extract %2050[33] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2085 = wave.extract %2050[34] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2086 = wave.extract %2050[35] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2087 = wave.extract %2050[36] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2088 = wave.extract %2050[37] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2089 = wave.extract %2050[38] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2090 = wave.extract %2050[39] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2091 = wave.extract %2050[40] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2092 = wave.extract %2050[41] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2093 = wave.extract %2050[42] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2094 = wave.extract %2050[43] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2095 = wave.extract %2050[44] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2096 = wave.extract %2050[45] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2097 = wave.extract %2050[46] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2098 = wave.extract %2050[47] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2099 = wave.extract %2050[48] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2100 = wave.extract %2050[49] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2101 = wave.extract %2050[50] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2102 = wave.extract %2050[51] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2103 = wave.extract %2050[52] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2104 = wave.extract %2050[53] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2105 = wave.extract %2050[54] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2106 = wave.extract %2050[55] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2107 = wave.extract %2050[56] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2108 = wave.extract %2050[57] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2109 = wave.extract %2050[58] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2110 = wave.extract %2050[59] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2111 = wave.extract %2050[60] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2112 = wave.extract %2050[61] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2113 = wave.extract %2050[62] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2114 = wave.extract %2050[63] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2115 = wave.extract %2050[64] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2116 = wave.extract %2050[65] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2117 = wave.extract %2050[66] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2118 = wave.extract %2050[67] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2119 = wave.extract %2050[68] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2120 = wave.extract %2050[69] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2121 = wave.extract %2050[70] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2122 = wave.extract %2050[71] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2123 = wave.extract %2050[72] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2124 = wave.extract %2050[73] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2125 = wave.extract %2050[74] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2126 = wave.extract %2050[75] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2127 = wave.extract %2050[76] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2128 = wave.extract %2050[77] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2129 = wave.extract %2050[78] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2130 = wave.extract %2050[79] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2131 = wave.extract %2050[80] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2132 = wave.extract %2050[81] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2133 = wave.extract %2050[82] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2134 = wave.extract %2050[83] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2135 = wave.extract %2050[84] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2136 = wave.extract %2050[85] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2137 = wave.extract %2050[86] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2138 = wave.extract %2050[87] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2139 = wave.extract %2050[88] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2140 = wave.extract %2050[89] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2141 = wave.extract %2050[90] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2142 = wave.extract %2050[91] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2143 = wave.extract %2050[92] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2144 = wave.extract %2050[93] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2145 = wave.extract %2050[94] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2146 = wave.extract %2050[95] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2147 = wave.extract %2050[96] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2148 = wave.extract %2050[97] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2149 = wave.extract %2050[98] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2150 = wave.extract %2050[99] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2151 = wave.extract %2050[100] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2152 = wave.extract %2050[101] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2153 = wave.extract %2050[102] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2154 = wave.extract %2050[103] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2155 = wave.extract %2050[104] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2156 = wave.extract %2050[105] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2157 = wave.extract %2050[106] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2158 = wave.extract %2050[107] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2159 = wave.extract %2050[108] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2160 = wave.extract %2050[109] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2161 = wave.extract %2050[110] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2162 = wave.extract %2050[111] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2163 = wave.extract %2050[112] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2164 = wave.extract %2050[113] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2165 = wave.extract %2050[114] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2166 = wave.extract %2050[115] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2167 = wave.extract %2050[116] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2168 = wave.extract %2050[117] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2169 = wave.extract %2050[118] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2170 = wave.extract %2050[119] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2171 = wave.extract %2050[120] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2172 = wave.extract %2050[121] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2173 = wave.extract %2050[122] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2174 = wave.extract %2050[123] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2175 = wave.extract %2050[124] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2176 = wave.extract %2050[125] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2177 = wave.extract %2050[126] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2178 = wave.extract %2050[127] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2179 = wave.pack %2041, %2042, %2043, %2044, %2045, %2046, %2047, %2048 : !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<vector<8xi32>, 64>
      %2180 = wave.redistribute %2179, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "2*floor(1/2*Mod(slot, 8)) + Mod(slot, 2)"> : !wave.simd<vector<8xi32>, 64> -> !wave.simd<vector<128xi32>, 64>
      %2181 = wave.extract %2180[0] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2182 = wave.extract %2180[1] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2183 = wave.extract %2180[2] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2184 = wave.extract %2180[3] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2185 = wave.extract %2180[4] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2186 = wave.extract %2180[5] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2187 = wave.extract %2180[6] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2188 = wave.extract %2180[7] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2189 = wave.extract %2180[8] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2190 = wave.extract %2180[9] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2191 = wave.extract %2180[10] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2192 = wave.extract %2180[11] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2193 = wave.extract %2180[12] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2194 = wave.extract %2180[13] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2195 = wave.extract %2180[14] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2196 = wave.extract %2180[15] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2197 = wave.extract %2180[16] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2198 = wave.extract %2180[17] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2199 = wave.extract %2180[18] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2200 = wave.extract %2180[19] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2201 = wave.extract %2180[20] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2202 = wave.extract %2180[21] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2203 = wave.extract %2180[22] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2204 = wave.extract %2180[23] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2205 = wave.extract %2180[24] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2206 = wave.extract %2180[25] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2207 = wave.extract %2180[26] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2208 = wave.extract %2180[27] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2209 = wave.extract %2180[28] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2210 = wave.extract %2180[29] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2211 = wave.extract %2180[30] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2212 = wave.extract %2180[31] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2213 = wave.extract %2180[32] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2214 = wave.extract %2180[33] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2215 = wave.extract %2180[34] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2216 = wave.extract %2180[35] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2217 = wave.extract %2180[36] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2218 = wave.extract %2180[37] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2219 = wave.extract %2180[38] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2220 = wave.extract %2180[39] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2221 = wave.extract %2180[40] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2222 = wave.extract %2180[41] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2223 = wave.extract %2180[42] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2224 = wave.extract %2180[43] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2225 = wave.extract %2180[44] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2226 = wave.extract %2180[45] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2227 = wave.extract %2180[46] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2228 = wave.extract %2180[47] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2229 = wave.extract %2180[48] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2230 = wave.extract %2180[49] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2231 = wave.extract %2180[50] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2232 = wave.extract %2180[51] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2233 = wave.extract %2180[52] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2234 = wave.extract %2180[53] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2235 = wave.extract %2180[54] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2236 = wave.extract %2180[55] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2237 = wave.extract %2180[56] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2238 = wave.extract %2180[57] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2239 = wave.extract %2180[58] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2240 = wave.extract %2180[59] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2241 = wave.extract %2180[60] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2242 = wave.extract %2180[61] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2243 = wave.extract %2180[62] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2244 = wave.extract %2180[63] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2245 = wave.extract %2180[64] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2246 = wave.extract %2180[65] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2247 = wave.extract %2180[66] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2248 = wave.extract %2180[67] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2249 = wave.extract %2180[68] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2250 = wave.extract %2180[69] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2251 = wave.extract %2180[70] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2252 = wave.extract %2180[71] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2253 = wave.extract %2180[72] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2254 = wave.extract %2180[73] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2255 = wave.extract %2180[74] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2256 = wave.extract %2180[75] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2257 = wave.extract %2180[76] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2258 = wave.extract %2180[77] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2259 = wave.extract %2180[78] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2260 = wave.extract %2180[79] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2261 = wave.extract %2180[80] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2262 = wave.extract %2180[81] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2263 = wave.extract %2180[82] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2264 = wave.extract %2180[83] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2265 = wave.extract %2180[84] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2266 = wave.extract %2180[85] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2267 = wave.extract %2180[86] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2268 = wave.extract %2180[87] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2269 = wave.extract %2180[88] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2270 = wave.extract %2180[89] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2271 = wave.extract %2180[90] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2272 = wave.extract %2180[91] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2273 = wave.extract %2180[92] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2274 = wave.extract %2180[93] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2275 = wave.extract %2180[94] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2276 = wave.extract %2180[95] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2277 = wave.extract %2180[96] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2278 = wave.extract %2180[97] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2279 = wave.extract %2180[98] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2280 = wave.extract %2180[99] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2281 = wave.extract %2180[100] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2282 = wave.extract %2180[101] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2283 = wave.extract %2180[102] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2284 = wave.extract %2180[103] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2285 = wave.extract %2180[104] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2286 = wave.extract %2180[105] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2287 = wave.extract %2180[106] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2288 = wave.extract %2180[107] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2289 = wave.extract %2180[108] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2290 = wave.extract %2180[109] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2291 = wave.extract %2180[110] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2292 = wave.extract %2180[111] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2293 = wave.extract %2180[112] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2294 = wave.extract %2180[113] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2295 = wave.extract %2180[114] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2296 = wave.extract %2180[115] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2297 = wave.extract %2180[116] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2298 = wave.extract %2180[117] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2299 = wave.extract %2180[118] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2300 = wave.extract %2180[119] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2301 = wave.extract %2180[120] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2302 = wave.extract %2180[121] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2303 = wave.extract %2180[122] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2304 = wave.extract %2180[123] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2305 = wave.extract %2180[124] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2306 = wave.extract %2180[125] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2307 = wave.extract %2180[126] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2308 = wave.extract %2180[127] : !wave.simd<vector<128xi32>, 64> -> !wave.simd<i32, 64>
      %2309 = wave.binary addi %2051, %2181 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2310 = wave.binary addi %2052, %2182 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2311 = wave.binary addi %2053, %2183 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2312 = wave.binary addi %2054, %2184 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2313 = wave.binary addi %2055, %2185 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2314 = wave.binary addi %2056, %2186 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2315 = wave.binary addi %2057, %2187 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2316 = wave.binary addi %2058, %2188 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2317 = wave.binary addi %2059, %2189 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2318 = wave.binary addi %2060, %2190 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2319 = wave.binary addi %2061, %2191 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2320 = wave.binary addi %2062, %2192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2321 = wave.binary addi %2063, %2193 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2322 = wave.binary addi %2064, %2194 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2323 = wave.binary addi %2065, %2195 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2324 = wave.binary addi %2066, %2196 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2325 = wave.binary addi %2067, %2197 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2326 = wave.binary addi %2068, %2198 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2327 = wave.binary addi %2069, %2199 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2328 = wave.binary addi %2070, %2200 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2329 = wave.binary addi %2071, %2201 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2330 = wave.binary addi %2072, %2202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2331 = wave.binary addi %2073, %2203 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2332 = wave.binary addi %2074, %2204 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2333 = wave.binary addi %2075, %2205 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2334 = wave.binary addi %2076, %2206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2335 = wave.binary addi %2077, %2207 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2336 = wave.binary addi %2078, %2208 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2337 = wave.binary addi %2079, %2209 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2338 = wave.binary addi %2080, %2210 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2339 = wave.binary addi %2081, %2211 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2340 = wave.binary addi %2082, %2212 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2341 = wave.binary addi %2083, %2213 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2342 = wave.binary addi %2084, %2214 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2343 = wave.binary addi %2085, %2215 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2344 = wave.binary addi %2086, %2216 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2345 = wave.binary addi %2087, %2217 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2346 = wave.binary addi %2088, %2218 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2347 = wave.binary addi %2089, %2219 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2348 = wave.binary addi %2090, %2220 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2349 = wave.binary addi %2091, %2221 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2350 = wave.binary addi %2092, %2222 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2351 = wave.binary addi %2093, %2223 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2352 = wave.binary addi %2094, %2224 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2353 = wave.binary addi %2095, %2225 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2354 = wave.binary addi %2096, %2226 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2355 = wave.binary addi %2097, %2227 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2356 = wave.binary addi %2098, %2228 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2357 = wave.binary addi %2099, %2229 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2358 = wave.binary addi %2100, %2230 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2359 = wave.binary addi %2101, %2231 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2360 = wave.binary addi %2102, %2232 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2361 = wave.binary addi %2103, %2233 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2362 = wave.binary addi %2104, %2234 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2363 = wave.binary addi %2105, %2235 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2364 = wave.binary addi %2106, %2236 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2365 = wave.binary addi %2107, %2237 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2366 = wave.binary addi %2108, %2238 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2367 = wave.binary addi %2109, %2239 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2368 = wave.binary addi %2110, %2240 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2369 = wave.binary addi %2111, %2241 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2370 = wave.binary addi %2112, %2242 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2371 = wave.binary addi %2113, %2243 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2372 = wave.binary addi %2114, %2244 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2373 = wave.binary addi %2115, %2245 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2374 = wave.binary addi %2116, %2246 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2375 = wave.binary addi %2117, %2247 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2376 = wave.binary addi %2118, %2248 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2377 = wave.binary addi %2119, %2249 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2378 = wave.binary addi %2120, %2250 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2379 = wave.binary addi %2121, %2251 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2380 = wave.binary addi %2122, %2252 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2381 = wave.binary addi %2123, %2253 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2382 = wave.binary addi %2124, %2254 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2383 = wave.binary addi %2125, %2255 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2384 = wave.binary addi %2126, %2256 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2385 = wave.binary addi %2127, %2257 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2386 = wave.binary addi %2128, %2258 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2387 = wave.binary addi %2129, %2259 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2388 = wave.binary addi %2130, %2260 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2389 = wave.binary addi %2131, %2261 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2390 = wave.binary addi %2132, %2262 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2391 = wave.binary addi %2133, %2263 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2392 = wave.binary addi %2134, %2264 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2393 = wave.binary addi %2135, %2265 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2394 = wave.binary addi %2136, %2266 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2395 = wave.binary addi %2137, %2267 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2396 = wave.binary addi %2138, %2268 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2397 = wave.binary addi %2139, %2269 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2398 = wave.binary addi %2140, %2270 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2399 = wave.binary addi %2141, %2271 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2400 = wave.binary addi %2142, %2272 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2401 = wave.binary addi %2143, %2273 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2402 = wave.binary addi %2144, %2274 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2403 = wave.binary addi %2145, %2275 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2404 = wave.binary addi %2146, %2276 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2405 = wave.binary addi %2147, %2277 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2406 = wave.binary addi %2148, %2278 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2407 = wave.binary addi %2149, %2279 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2408 = wave.binary addi %2150, %2280 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2409 = wave.binary addi %2151, %2281 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2410 = wave.binary addi %2152, %2282 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2411 = wave.binary addi %2153, %2283 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2412 = wave.binary addi %2154, %2284 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2413 = wave.binary addi %2155, %2285 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2414 = wave.binary addi %2156, %2286 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2415 = wave.binary addi %2157, %2287 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2416 = wave.binary addi %2158, %2288 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2417 = wave.binary addi %2159, %2289 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2418 = wave.binary addi %2160, %2290 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2419 = wave.binary addi %2161, %2291 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2420 = wave.binary addi %2162, %2292 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2421 = wave.binary addi %2163, %2293 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2422 = wave.binary addi %2164, %2294 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2423 = wave.binary addi %2165, %2295 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2424 = wave.binary addi %2166, %2296 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2425 = wave.binary addi %2167, %2297 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2426 = wave.binary addi %2168, %2298 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2427 = wave.binary addi %2169, %2299 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2428 = wave.binary addi %2170, %2300 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2429 = wave.binary addi %2171, %2301 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2430 = wave.binary addi %2172, %2302 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2431 = wave.binary addi %2173, %2303 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2432 = wave.binary addi %2174, %2304 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2433 = wave.binary addi %2175, %2305 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2434 = wave.binary addi %2176, %2306 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2435 = wave.binary addi %2177, %2307 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2436 = wave.binary addi %2178, %2308 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2437 = wave.binary addi %2309, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2438 = wave.binary addi %2310, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2439 = wave.binary addi %2311, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2440 = wave.binary addi %2312, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2441 = wave.binary addi %2313, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2442 = wave.binary addi %2314, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2443 = wave.binary addi %2315, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2444 = wave.binary addi %2316, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2445 = wave.binary addi %2317, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2446 = wave.binary addi %2318, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2447 = wave.binary addi %2319, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2448 = wave.binary addi %2320, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2449 = wave.binary addi %2321, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2450 = wave.binary addi %2322, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2451 = wave.binary addi %2323, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2452 = wave.binary addi %2324, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2453 = wave.binary addi %2325, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2454 = wave.binary addi %2326, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2455 = wave.binary addi %2327, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2456 = wave.binary addi %2328, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2457 = wave.binary addi %2329, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2458 = wave.binary addi %2330, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2459 = wave.binary addi %2331, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2460 = wave.binary addi %2332, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2461 = wave.binary addi %2333, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2462 = wave.binary addi %2334, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2463 = wave.binary addi %2335, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2464 = wave.binary addi %2336, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2465 = wave.binary addi %2337, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2466 = wave.binary addi %2338, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2467 = wave.binary addi %2339, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2468 = wave.binary addi %2340, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2469 = wave.binary addi %2341, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2470 = wave.binary addi %2342, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2471 = wave.binary addi %2343, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2472 = wave.binary addi %2344, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2473 = wave.binary addi %2345, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2474 = wave.binary addi %2346, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2475 = wave.binary addi %2347, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2476 = wave.binary addi %2348, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2477 = wave.binary addi %2349, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2478 = wave.binary addi %2350, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2479 = wave.binary addi %2351, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2480 = wave.binary addi %2352, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2481 = wave.binary addi %2353, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2482 = wave.binary addi %2354, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2483 = wave.binary addi %2355, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2484 = wave.binary addi %2356, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2485 = wave.binary addi %2357, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2486 = wave.binary addi %2358, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2487 = wave.binary addi %2359, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2488 = wave.binary addi %2360, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2489 = wave.binary addi %2361, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2490 = wave.binary addi %2362, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2491 = wave.binary addi %2363, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2492 = wave.binary addi %2364, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2493 = wave.binary addi %2365, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2494 = wave.binary addi %2366, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2495 = wave.binary addi %2367, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2496 = wave.binary addi %2368, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2497 = wave.binary addi %2369, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2498 = wave.binary addi %2370, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2499 = wave.binary addi %2371, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2500 = wave.binary addi %2372, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2501 = wave.binary addi %2373, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2502 = wave.binary addi %2374, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2503 = wave.binary addi %2375, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2504 = wave.binary addi %2376, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2505 = wave.binary addi %2377, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2506 = wave.binary addi %2378, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2507 = wave.binary addi %2379, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2508 = wave.binary addi %2380, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2509 = wave.binary addi %2381, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2510 = wave.binary addi %2382, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2511 = wave.binary addi %2383, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2512 = wave.binary addi %2384, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2513 = wave.binary addi %2385, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2514 = wave.binary addi %2386, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2515 = wave.binary addi %2387, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2516 = wave.binary addi %2388, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2517 = wave.binary addi %2389, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2518 = wave.binary addi %2390, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2519 = wave.binary addi %2391, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2520 = wave.binary addi %2392, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2521 = wave.binary addi %2393, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2522 = wave.binary addi %2394, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2523 = wave.binary addi %2395, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2524 = wave.binary addi %2396, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2525 = wave.binary addi %2397, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2526 = wave.binary addi %2398, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2527 = wave.binary addi %2399, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2528 = wave.binary addi %2400, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2529 = wave.binary addi %2401, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2530 = wave.binary addi %2402, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2531 = wave.binary addi %2403, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2532 = wave.binary addi %2404, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2533 = wave.binary addi %2405, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2534 = wave.binary addi %2406, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2535 = wave.binary addi %2407, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2536 = wave.binary addi %2408, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2537 = wave.binary addi %2409, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2538 = wave.binary addi %2410, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2539 = wave.binary addi %2411, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2540 = wave.binary addi %2412, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2541 = wave.binary addi %2413, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2542 = wave.binary addi %2414, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2543 = wave.binary addi %2415, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2544 = wave.binary addi %2416, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2545 = wave.binary addi %2417, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2546 = wave.binary addi %2418, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2547 = wave.binary addi %2419, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2548 = wave.binary addi %2420, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2549 = wave.binary addi %2421, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2550 = wave.binary addi %2422, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2551 = wave.binary addi %2423, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2552 = wave.binary addi %2424, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2553 = wave.binary addi %2425, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2554 = wave.binary addi %2426, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2555 = wave.binary addi %2427, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2556 = wave.binary addi %2428, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2557 = wave.binary addi %2429, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2558 = wave.binary addi %2430, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2559 = wave.binary addi %2431, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2560 = wave.binary addi %2432, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2561 = wave.binary addi %2433, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2562 = wave.binary addi %2434, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2563 = wave.binary addi %2435, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2564 = wave.binary addi %2436, %19 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
      %2565 = wave.binary muli %780, %13 : i32, i32 -> i32
      %2566 = wave.pack %1890, %1893, %1896, %1899, %1902, %1905, %1908, %1911, %1914, %1917, %1920, %1923, %1926, %1929, %1932, %1935, %1938, %1941, %1944, %1947, %1950, %1953, %1956, %1959, %1962, %1965, %1968, %1971, %1974, %1977, %1980, %1983 : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<128xf32>, 64>
      %2567 = wave.redistribute %2566, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "4*floor(1/4*slot) + 2*floor(1/2*Mod(slot, 4)) + Mod(slot, 2)"> : !wave.simd<vector<128xf32>, 64> -> !wave.simd<vector<128xf32>, 64>
      %2568 = wave.extract %2567[0] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2569 = wave.extract %2567[1] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2570 = wave.extract %2567[2] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2571 = wave.extract %2567[3] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2572 = wave.extract %2567[4] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2573 = wave.extract %2567[5] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2574 = wave.extract %2567[6] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2575 = wave.extract %2567[7] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2576 = wave.extract %2567[8] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2577 = wave.extract %2567[9] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2578 = wave.extract %2567[10] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2579 = wave.extract %2567[11] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2580 = wave.extract %2567[12] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2581 = wave.extract %2567[13] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2582 = wave.extract %2567[14] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2583 = wave.extract %2567[15] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2584 = wave.extract %2567[16] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2585 = wave.extract %2567[17] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2586 = wave.extract %2567[18] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2587 = wave.extract %2567[19] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2588 = wave.extract %2567[20] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2589 = wave.extract %2567[21] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2590 = wave.extract %2567[22] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2591 = wave.extract %2567[23] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2592 = wave.extract %2567[24] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2593 = wave.extract %2567[25] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2594 = wave.extract %2567[26] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2595 = wave.extract %2567[27] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2596 = wave.extract %2567[28] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2597 = wave.extract %2567[29] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2598 = wave.extract %2567[30] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2599 = wave.extract %2567[31] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2600 = wave.extract %2567[32] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2601 = wave.extract %2567[33] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2602 = wave.extract %2567[34] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2603 = wave.extract %2567[35] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2604 = wave.extract %2567[36] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2605 = wave.extract %2567[37] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2606 = wave.extract %2567[38] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2607 = wave.extract %2567[39] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2608 = wave.extract %2567[40] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2609 = wave.extract %2567[41] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2610 = wave.extract %2567[42] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2611 = wave.extract %2567[43] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2612 = wave.extract %2567[44] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2613 = wave.extract %2567[45] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2614 = wave.extract %2567[46] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2615 = wave.extract %2567[47] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2616 = wave.extract %2567[48] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2617 = wave.extract %2567[49] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2618 = wave.extract %2567[50] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2619 = wave.extract %2567[51] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2620 = wave.extract %2567[52] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2621 = wave.extract %2567[53] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2622 = wave.extract %2567[54] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2623 = wave.extract %2567[55] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2624 = wave.extract %2567[56] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2625 = wave.extract %2567[57] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2626 = wave.extract %2567[58] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2627 = wave.extract %2567[59] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2628 = wave.extract %2567[60] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2629 = wave.extract %2567[61] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2630 = wave.extract %2567[62] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2631 = wave.extract %2567[63] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2632 = wave.extract %2567[64] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2633 = wave.extract %2567[65] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2634 = wave.extract %2567[66] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2635 = wave.extract %2567[67] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2636 = wave.extract %2567[68] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2637 = wave.extract %2567[69] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2638 = wave.extract %2567[70] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2639 = wave.extract %2567[71] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2640 = wave.extract %2567[72] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2641 = wave.extract %2567[73] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2642 = wave.extract %2567[74] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2643 = wave.extract %2567[75] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2644 = wave.extract %2567[76] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2645 = wave.extract %2567[77] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2646 = wave.extract %2567[78] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2647 = wave.extract %2567[79] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2648 = wave.extract %2567[80] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2649 = wave.extract %2567[81] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2650 = wave.extract %2567[82] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2651 = wave.extract %2567[83] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2652 = wave.extract %2567[84] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2653 = wave.extract %2567[85] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2654 = wave.extract %2567[86] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2655 = wave.extract %2567[87] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2656 = wave.extract %2567[88] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2657 = wave.extract %2567[89] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2658 = wave.extract %2567[90] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2659 = wave.extract %2567[91] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2660 = wave.extract %2567[92] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2661 = wave.extract %2567[93] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2662 = wave.extract %2567[94] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2663 = wave.extract %2567[95] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2664 = wave.extract %2567[96] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2665 = wave.extract %2567[97] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2666 = wave.extract %2567[98] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2667 = wave.extract %2567[99] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2668 = wave.extract %2567[100] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2669 = wave.extract %2567[101] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2670 = wave.extract %2567[102] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2671 = wave.extract %2567[103] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2672 = wave.extract %2567[104] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2673 = wave.extract %2567[105] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2674 = wave.extract %2567[106] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2675 = wave.extract %2567[107] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2676 = wave.extract %2567[108] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2677 = wave.extract %2567[109] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2678 = wave.extract %2567[110] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2679 = wave.extract %2567[111] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2680 = wave.extract %2567[112] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2681 = wave.extract %2567[113] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2682 = wave.extract %2567[114] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2683 = wave.extract %2567[115] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2684 = wave.extract %2567[116] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2685 = wave.extract %2567[117] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2686 = wave.extract %2567[118] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2687 = wave.extract %2567[119] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2688 = wave.extract %2567[120] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2689 = wave.extract %2567[121] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2690 = wave.extract %2567[122] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2691 = wave.extract %2567[123] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2692 = wave.extract %2567[124] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2693 = wave.extract %2567[125] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2694 = wave.extract %2567[126] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2695 = wave.extract %2567[127] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %2696 = wave.cast fpconvert %2568 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2697 = wave.cast fpconvert %2569 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2698 = wave.cast fpconvert %2570 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2699 = wave.cast fpconvert %2571 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2700 = wave.cast fpconvert %2572 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2701 = wave.cast fpconvert %2573 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2702 = wave.cast fpconvert %2574 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2703 = wave.cast fpconvert %2575 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2704 = wave.cast fpconvert %2576 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2705 = wave.cast fpconvert %2577 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2706 = wave.cast fpconvert %2578 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2707 = wave.cast fpconvert %2579 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2708 = wave.cast fpconvert %2580 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2709 = wave.cast fpconvert %2581 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2710 = wave.cast fpconvert %2582 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2711 = wave.cast fpconvert %2583 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2712 = wave.cast fpconvert %2584 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2713 = wave.cast fpconvert %2585 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2714 = wave.cast fpconvert %2586 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2715 = wave.cast fpconvert %2587 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2716 = wave.cast fpconvert %2588 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2717 = wave.cast fpconvert %2589 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2718 = wave.cast fpconvert %2590 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2719 = wave.cast fpconvert %2591 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2720 = wave.cast fpconvert %2592 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2721 = wave.cast fpconvert %2593 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2722 = wave.cast fpconvert %2594 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2723 = wave.cast fpconvert %2595 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2724 = wave.cast fpconvert %2596 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2725 = wave.cast fpconvert %2597 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2726 = wave.cast fpconvert %2598 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2727 = wave.cast fpconvert %2599 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2728 = wave.cast fpconvert %2600 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2729 = wave.cast fpconvert %2601 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2730 = wave.cast fpconvert %2602 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2731 = wave.cast fpconvert %2603 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2732 = wave.cast fpconvert %2604 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2733 = wave.cast fpconvert %2605 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2734 = wave.cast fpconvert %2606 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2735 = wave.cast fpconvert %2607 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2736 = wave.cast fpconvert %2608 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2737 = wave.cast fpconvert %2609 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2738 = wave.cast fpconvert %2610 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2739 = wave.cast fpconvert %2611 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2740 = wave.cast fpconvert %2612 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2741 = wave.cast fpconvert %2613 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2742 = wave.cast fpconvert %2614 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2743 = wave.cast fpconvert %2615 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2744 = wave.cast fpconvert %2616 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2745 = wave.cast fpconvert %2617 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2746 = wave.cast fpconvert %2618 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2747 = wave.cast fpconvert %2619 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2748 = wave.cast fpconvert %2620 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2749 = wave.cast fpconvert %2621 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2750 = wave.cast fpconvert %2622 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2751 = wave.cast fpconvert %2623 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2752 = wave.cast fpconvert %2624 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2753 = wave.cast fpconvert %2625 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2754 = wave.cast fpconvert %2626 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2755 = wave.cast fpconvert %2627 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2756 = wave.cast fpconvert %2628 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2757 = wave.cast fpconvert %2629 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2758 = wave.cast fpconvert %2630 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2759 = wave.cast fpconvert %2631 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2760 = wave.cast fpconvert %2632 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2761 = wave.cast fpconvert %2633 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2762 = wave.cast fpconvert %2634 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2763 = wave.cast fpconvert %2635 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2764 = wave.cast fpconvert %2636 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2765 = wave.cast fpconvert %2637 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2766 = wave.cast fpconvert %2638 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2767 = wave.cast fpconvert %2639 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2768 = wave.cast fpconvert %2640 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2769 = wave.cast fpconvert %2641 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2770 = wave.cast fpconvert %2642 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2771 = wave.cast fpconvert %2643 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2772 = wave.cast fpconvert %2644 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2773 = wave.cast fpconvert %2645 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2774 = wave.cast fpconvert %2646 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2775 = wave.cast fpconvert %2647 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2776 = wave.cast fpconvert %2648 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2777 = wave.cast fpconvert %2649 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2778 = wave.cast fpconvert %2650 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2779 = wave.cast fpconvert %2651 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2780 = wave.cast fpconvert %2652 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2781 = wave.cast fpconvert %2653 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2782 = wave.cast fpconvert %2654 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2783 = wave.cast fpconvert %2655 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2784 = wave.cast fpconvert %2656 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2785 = wave.cast fpconvert %2657 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2786 = wave.cast fpconvert %2658 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2787 = wave.cast fpconvert %2659 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2788 = wave.cast fpconvert %2660 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2789 = wave.cast fpconvert %2661 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2790 = wave.cast fpconvert %2662 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2791 = wave.cast fpconvert %2663 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2792 = wave.cast fpconvert %2664 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2793 = wave.cast fpconvert %2665 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2794 = wave.cast fpconvert %2666 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2795 = wave.cast fpconvert %2667 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2796 = wave.cast fpconvert %2668 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2797 = wave.cast fpconvert %2669 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2798 = wave.cast fpconvert %2670 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2799 = wave.cast fpconvert %2671 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2800 = wave.cast fpconvert %2672 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2801 = wave.cast fpconvert %2673 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2802 = wave.cast fpconvert %2674 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2803 = wave.cast fpconvert %2675 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2804 = wave.cast fpconvert %2676 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2805 = wave.cast fpconvert %2677 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2806 = wave.cast fpconvert %2678 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2807 = wave.cast fpconvert %2679 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2808 = wave.cast fpconvert %2680 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2809 = wave.cast fpconvert %2681 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2810 = wave.cast fpconvert %2682 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2811 = wave.cast fpconvert %2683 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2812 = wave.cast fpconvert %2684 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2813 = wave.cast fpconvert %2685 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2814 = wave.cast fpconvert %2686 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2815 = wave.cast fpconvert %2687 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2816 = wave.cast fpconvert %2688 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2817 = wave.cast fpconvert %2689 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2818 = wave.cast fpconvert %2690 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2819 = wave.cast fpconvert %2691 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2820 = wave.cast fpconvert %2692 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2821 = wave.cast fpconvert %2693 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2822 = wave.cast fpconvert %2694 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2823 = wave.cast fpconvert %2695 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %2824 = wave.pack %2696, %2697, %2698, %2699, %2700, %2701, %2702, %2703, %2704, %2705, %2706, %2707, %2708, %2709, %2710, %2711, %2712, %2713, %2714, %2715, %2716, %2717, %2718, %2719, %2720, %2721, %2722, %2723, %2724, %2725, %2726, %2727, %2728, %2729, %2730, %2731, %2732, %2733, %2734, %2735, %2736, %2737, %2738, %2739, %2740, %2741, %2742, %2743, %2744, %2745, %2746, %2747, %2748, %2749, %2750, %2751, %2752, %2753, %2754, %2755, %2756, %2757, %2758, %2759, %2760, %2761, %2762, %2763, %2764, %2765, %2766, %2767, %2768, %2769, %2770, %2771, %2772, %2773, %2774, %2775, %2776, %2777, %2778, %2779, %2780, %2781, %2782, %2783, %2784, %2785, %2786, %2787, %2788, %2789, %2790, %2791, %2792, %2793, %2794, %2795, %2796, %2797, %2798, %2799, %2800, %2801, %2802, %2803, %2804, %2805, %2806, %2807, %2808, %2809, %2810, %2811, %2812, %2813, %2814, %2815, %2816, %2817, %2818, %2819, %2820, %2821, %2822, %2823 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2825 = wave.redistribute %2824, <blocks = 1, items = 256, source_block = "0", source_item = "Mod(4*floor(1/64*item) + floor(1/16*Mod(item, 64)) + 128*floor(1/8*slot) + 16*floor(1/4*Mod(slot, 8)) + 32*Mod(item, 2) + 64*Mod(floor(1/2*Mod(item, 64)), 2), 256)", source_slot = "16*floor(1/16*slot) + Mod(slot, 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(slot, 8)), 2)"> : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2826 = wave.extract %2825[0] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2827 = wave.extract %2825[1] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2828 = wave.extract %2825[2] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2829 = wave.extract %2825[3] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2830 = wave.extract %2825[4] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2831 = wave.extract %2825[5] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2832 = wave.extract %2825[6] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2833 = wave.extract %2825[7] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2834 = wave.extract %2825[8] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2835 = wave.extract %2825[9] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2836 = wave.extract %2825[10] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2837 = wave.extract %2825[11] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2838 = wave.extract %2825[12] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2839 = wave.extract %2825[13] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2840 = wave.extract %2825[14] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2841 = wave.extract %2825[15] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2842 = wave.extract %2825[16] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2843 = wave.extract %2825[17] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2844 = wave.extract %2825[18] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2845 = wave.extract %2825[19] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2846 = wave.extract %2825[20] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2847 = wave.extract %2825[21] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2848 = wave.extract %2825[22] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2849 = wave.extract %2825[23] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2850 = wave.extract %2825[24] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2851 = wave.extract %2825[25] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2852 = wave.extract %2825[26] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2853 = wave.extract %2825[27] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2854 = wave.extract %2825[28] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2855 = wave.extract %2825[29] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2856 = wave.extract %2825[30] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2857 = wave.extract %2825[31] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2858 = wave.extract %2825[32] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2859 = wave.extract %2825[33] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2860 = wave.extract %2825[34] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2861 = wave.extract %2825[35] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2862 = wave.extract %2825[36] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2863 = wave.extract %2825[37] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2864 = wave.extract %2825[38] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2865 = wave.extract %2825[39] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2866 = wave.extract %2825[40] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2867 = wave.extract %2825[41] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2868 = wave.extract %2825[42] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2869 = wave.extract %2825[43] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2870 = wave.extract %2825[44] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2871 = wave.extract %2825[45] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2872 = wave.extract %2825[46] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2873 = wave.extract %2825[47] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2874 = wave.extract %2825[48] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2875 = wave.extract %2825[49] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2876 = wave.extract %2825[50] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2877 = wave.extract %2825[51] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2878 = wave.extract %2825[52] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2879 = wave.extract %2825[53] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2880 = wave.extract %2825[54] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2881 = wave.extract %2825[55] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2882 = wave.extract %2825[56] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2883 = wave.extract %2825[57] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2884 = wave.extract %2825[58] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2885 = wave.extract %2825[59] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2886 = wave.extract %2825[60] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2887 = wave.extract %2825[61] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2888 = wave.extract %2825[62] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2889 = wave.extract %2825[63] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2890 = wave.extract %2825[64] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2891 = wave.extract %2825[65] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2892 = wave.extract %2825[66] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2893 = wave.extract %2825[67] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2894 = wave.extract %2825[68] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2895 = wave.extract %2825[69] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2896 = wave.extract %2825[70] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2897 = wave.extract %2825[71] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2898 = wave.extract %2825[72] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2899 = wave.extract %2825[73] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2900 = wave.extract %2825[74] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2901 = wave.extract %2825[75] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2902 = wave.extract %2825[76] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2903 = wave.extract %2825[77] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2904 = wave.extract %2825[78] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2905 = wave.extract %2825[79] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2906 = wave.extract %2825[80] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2907 = wave.extract %2825[81] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2908 = wave.extract %2825[82] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2909 = wave.extract %2825[83] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2910 = wave.extract %2825[84] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2911 = wave.extract %2825[85] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2912 = wave.extract %2825[86] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2913 = wave.extract %2825[87] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2914 = wave.extract %2825[88] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2915 = wave.extract %2825[89] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2916 = wave.extract %2825[90] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2917 = wave.extract %2825[91] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2918 = wave.extract %2825[92] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2919 = wave.extract %2825[93] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2920 = wave.extract %2825[94] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2921 = wave.extract %2825[95] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2922 = wave.extract %2825[96] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2923 = wave.extract %2825[97] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2924 = wave.extract %2825[98] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2925 = wave.extract %2825[99] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2926 = wave.extract %2825[100] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2927 = wave.extract %2825[101] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2928 = wave.extract %2825[102] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2929 = wave.extract %2825[103] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2930 = wave.extract %2825[104] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2931 = wave.extract %2825[105] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2932 = wave.extract %2825[106] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2933 = wave.extract %2825[107] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2934 = wave.extract %2825[108] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2935 = wave.extract %2825[109] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2936 = wave.extract %2825[110] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2937 = wave.extract %2825[111] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2938 = wave.extract %2825[112] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2939 = wave.extract %2825[113] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2940 = wave.extract %2825[114] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2941 = wave.extract %2825[115] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2942 = wave.extract %2825[116] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2943 = wave.extract %2825[117] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2944 = wave.extract %2825[118] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2945 = wave.extract %2825[119] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2946 = wave.extract %2825[120] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2947 = wave.extract %2825[121] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2948 = wave.extract %2825[122] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2949 = wave.extract %2825[123] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2950 = wave.extract %2825[124] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2951 = wave.extract %2825[125] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2952 = wave.extract %2825[126] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2953 = wave.extract %2825[127] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %2954 = wave.ptr_add %arg2, %2565 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#wave.global, bf16>
      %c2147483647_i32_173 = arith.constant 2147483647 : i32
      %2955 = waveamd.make_buffer %2954, %c2147483647_i32_173 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %2956 = wave.pack %2826, %2827, %2828, %2829, %2830, %2831, %2832, %2833, %2834, %2835, %2836, %2837, %2838, %2839, %2840, %2841, %2842, %2843, %2844, %2845, %2846, %2847, %2848, %2849, %2850, %2851, %2852, %2853, %2854, %2855, %2856, %2857, %2858, %2859, %2860, %2861, %2862, %2863, %2864, %2865, %2866, %2867, %2868, %2869, %2870, %2871, %2872, %2873, %2874, %2875, %2876, %2877, %2878, %2879, %2880, %2881, %2882, %2883, %2884, %2885, %2886, %2887, %2888, %2889, %2890, %2891, %2892, %2893, %2894, %2895, %2896, %2897, %2898, %2899, %2900, %2901, %2902, %2903, %2904, %2905, %2906, %2907, %2908, %2909, %2910, %2911, %2912, %2913, %2914, %2915, %2916, %2917, %2918, %2919, %2920, %2921, %2922, %2923, %2924, %2925, %2926, %2927, %2928, %2929, %2930, %2931, %2932, %2933, %2934, %2935, %2936, %2937, %2938, %2939, %2940, %2941, %2942, %2943, %2944, %2945, %2946, %2947, %2948, %2949, %2950, %2951, %2952, %2953 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<128xbf16>, 64>
      %2957 = wave.scatter %2956 to %2955 mapping <bit_offset = <"8*Mod(2*(t99 + 4*t10*floor(1/64*item) + t10*floor(1/16*Mod(item, 64)) + 16*t10*floor(1/8*slot) + 2*floor(1/2*Mod(slot, 8)) + 8*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)), 4294967296)">> bindings ["item", "t10", "t99"](%1, %13, %1192) after %1995 : (!wave.simd<vector<128xbf16>, 64>, !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> !wave.mem.token
      %2958 = waveamd.fragment_pack %value_103 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2959 = waveamd.fragment_pack %value_105 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2960 = waveamd.fragment_pack %value_107 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2961 = waveamd.fragment_pack %value_109 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2962 = waveamd.fragment_pack %value_111 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2963 = waveamd.fragment_pack %value_113 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2964 = waveamd.fragment_pack %value_115 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2965 = waveamd.fragment_pack %value_117 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2966 = waveamd.fragment_pack %value_119 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2967 = waveamd.fragment_pack %value_121 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2968 = waveamd.fragment_pack %value_123 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2969 = waveamd.fragment_pack %value_125 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2970 = waveamd.fragment_pack %value_127 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2971 = waveamd.fragment_pack %value_129 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2972 = waveamd.fragment_pack %value_131 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2973 = waveamd.fragment_pack %value_133 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
      %2974 = waveamd.fragment_pack %value_155 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2975 = waveamd.fragment_pack %value_157 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2976 = waveamd.fragment_pack %value_159 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2977 = waveamd.fragment_pack %value_161 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2978 = waveamd.fragment_pack %value_163 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2979 = waveamd.fragment_pack %value_165 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2980 = waveamd.fragment_pack %value_167 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2981 = waveamd.fragment_pack %value_169 : !wave.simd<vector<16xi8>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
      %2982 = waveamd.fragment_pack %1689 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2983 = waveamd.fragment_pack %1692 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2984 = waveamd.fragment_pack %1695 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2985 = waveamd.fragment_pack %1698 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2986 = waveamd.fragment_pack %1701 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2987 = waveamd.fragment_pack %1704 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2988 = waveamd.fragment_pack %1707 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2989 = waveamd.fragment_pack %1710 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2990 = waveamd.fragment_pack %1713 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2991 = waveamd.fragment_pack %1716 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2992 = waveamd.fragment_pack %1719 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2993 = waveamd.fragment_pack %1722 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2994 = waveamd.fragment_pack %1725 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2995 = waveamd.fragment_pack %1728 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2996 = waveamd.fragment_pack %1731 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2997 = waveamd.fragment_pack %1734 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2998 = waveamd.fragment_pack %1737 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %2999 = waveamd.fragment_pack %1740 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3000 = waveamd.fragment_pack %1743 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3001 = waveamd.fragment_pack %1746 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3002 = waveamd.fragment_pack %1749 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3003 = waveamd.fragment_pack %1752 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3004 = waveamd.fragment_pack %1755 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3005 = waveamd.fragment_pack %1758 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3006 = waveamd.fragment_pack %1761 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3007 = waveamd.fragment_pack %1764 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3008 = waveamd.fragment_pack %1767 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3009 = waveamd.fragment_pack %1770 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3010 = waveamd.fragment_pack %1773 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3011 = waveamd.fragment_pack %1776 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3012 = waveamd.fragment_pack %1779 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3013 = waveamd.fragment_pack %1782 : !wave.simd<vector<4xf32>, 64> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3014 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %3015 = wave.pack %1800, %1801, %1802, %1803 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %3016 = wave.pack %1804, %1805, %1806, %1807 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %3017 = wave.pack %1808, %1809, %1810, %1811 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %3018 = wave.pack %1812, %1813, %1814, %1815 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %3019 = wave.constant 0 : i8 -> !wave.simd<i8, 64>
      %3020 = wave.pack %1996, %1997, %1998, %1999 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %3021 = wave.pack %2000, %2001, %2002, %2003 : !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64>, !wave.simd<i8, 64> -> !wave.simd<vector<4xi8>, 64>
      %3022 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2958, %3015, %2982 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3023 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2959, %3015, %3022 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3024 = waveamd.fragment_unpack %3023 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3025 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2958, %3015, %2983 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3026 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2959, %3015, %3025 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3027 = waveamd.fragment_unpack %3026 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3028 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2958, %3015, %2984 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3029 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2959, %3015, %3028 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3030 = waveamd.fragment_unpack %3029 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3031 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2958, %3015, %2985 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3032 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2959, %3015, %3031 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3033 = waveamd.fragment_unpack %3032 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3034 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2960, %3015, %2986 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3035 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2961, %3015, %3034 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3036 = waveamd.fragment_unpack %3035 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3037 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2960, %3015, %2987 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3038 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2961, %3015, %3037 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3039 = waveamd.fragment_unpack %3038 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3040 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2960, %3015, %2988 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3041 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2961, %3015, %3040 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3042 = waveamd.fragment_unpack %3041 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3043 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2960, %3015, %2989 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3044 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2961, %3015, %3043 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3045 = waveamd.fragment_unpack %3044 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3046 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2962, %3016, %2990 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3047 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2963, %3016, %3046 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3048 = waveamd.fragment_unpack %3047 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3049 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2962, %3016, %2991 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3050 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2963, %3016, %3049 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3051 = waveamd.fragment_unpack %3050 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3052 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2962, %3016, %2992 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3053 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2963, %3016, %3052 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3054 = waveamd.fragment_unpack %3053 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3055 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2962, %3016, %2993 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3056 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2963, %3016, %3055 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3057 = waveamd.fragment_unpack %3056 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3058 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2964, %3016, %2994 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3059 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2965, %3016, %3058 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3060 = waveamd.fragment_unpack %3059 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3061 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2964, %3016, %2995 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3062 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2965, %3016, %3061 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3063 = waveamd.fragment_unpack %3062 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3064 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2964, %3016, %2996 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3065 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2965, %3016, %3064 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3066 = waveamd.fragment_unpack %3065 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3067 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2964, %3016, %2997 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3068 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2965, %3016, %3067 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3069 = waveamd.fragment_unpack %3068 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3070 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2966, %3017, %2998 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3071 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2967, %3017, %3070 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3072 = waveamd.fragment_unpack %3071 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3073 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2966, %3017, %2999 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3074 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2967, %3017, %3073 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3075 = waveamd.fragment_unpack %3074 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3076 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2966, %3017, %3000 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3077 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2967, %3017, %3076 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3078 = waveamd.fragment_unpack %3077 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3079 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2966, %3017, %3001 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3080 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2967, %3017, %3079 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3081 = waveamd.fragment_unpack %3080 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3082 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2968, %3017, %3002 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3083 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2969, %3017, %3082 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3084 = waveamd.fragment_unpack %3083 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3085 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2968, %3017, %3003 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3086 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2969, %3017, %3085 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3087 = waveamd.fragment_unpack %3086 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3088 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2968, %3017, %3004 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3089 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2969, %3017, %3088 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3090 = waveamd.fragment_unpack %3089 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3091 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2968, %3017, %3005 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3092 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2969, %3017, %3091 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3093 = waveamd.fragment_unpack %3092 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3094 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2970, %3018, %3006 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3095 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2971, %3018, %3094 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3096 = waveamd.fragment_unpack %3095 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3097 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2970, %3018, %3007 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3098 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2971, %3018, %3097 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3099 = waveamd.fragment_unpack %3098 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3100 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2970, %3018, %3008 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3101 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2971, %3018, %3100 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3102 = waveamd.fragment_unpack %3101 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3103 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2970, %3018, %3009 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3104 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2971, %3018, %3103 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3105 = waveamd.fragment_unpack %3104 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3106 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2974, %3020, %2972, %3018, %3010 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3107 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2975, %3020, %2973, %3018, %3106 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3108 = waveamd.fragment_unpack %3107 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3109 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2976, %3020, %2972, %3018, %3011 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3110 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2977, %3020, %2973, %3018, %3109 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3111 = waveamd.fragment_unpack %3110 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3112 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2978, %3021, %2972, %3018, %3012 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3113 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2979, %3021, %2973, %3018, %3112 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3114 = waveamd.fragment_unpack %3113 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3115 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2980, %3021, %2972, %3018, %3013 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3116 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %2981, %3021, %2973, %3018, %3115 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<4xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
      %3117 = waveamd.fragment_unpack %3116 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
      %3118 = wave.pack %3024, %3027, %3030, %3033, %3036, %3039, %3042, %3045, %3048, %3051, %3054, %3057, %3060, %3063, %3066, %3069, %3072, %3075, %3078, %3081, %3084, %3087, %3090, %3093, %3096, %3099, %3102, %3105, %3108, %3111, %3114, %3117 : !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64>, !wave.simd<vector<4xf32>, 64> -> !wave.simd<vector<128xf32>, 64>
      %3119 = wave.redistribute %3118, <blocks = 1, items = 256, source_block = "0", source_item = "64*floor(1/64*item) + 2*floor(1/2*Mod(item, 64)) + Mod(item, 2)", source_slot = "4*floor(1/4*slot) + 2*floor(1/2*Mod(slot, 4)) + Mod(slot, 2)"> : !wave.simd<vector<128xf32>, 64> -> !wave.simd<vector<128xf32>, 64>
      %3120 = wave.extract %3119[0] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3121 = wave.extract %3119[1] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3122 = wave.extract %3119[2] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3123 = wave.extract %3119[3] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3124 = wave.extract %3119[4] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3125 = wave.extract %3119[5] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3126 = wave.extract %3119[6] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3127 = wave.extract %3119[7] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3128 = wave.extract %3119[8] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3129 = wave.extract %3119[9] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3130 = wave.extract %3119[10] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3131 = wave.extract %3119[11] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3132 = wave.extract %3119[12] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3133 = wave.extract %3119[13] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3134 = wave.extract %3119[14] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3135 = wave.extract %3119[15] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3136 = wave.extract %3119[16] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3137 = wave.extract %3119[17] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3138 = wave.extract %3119[18] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3139 = wave.extract %3119[19] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3140 = wave.extract %3119[20] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3141 = wave.extract %3119[21] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3142 = wave.extract %3119[22] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3143 = wave.extract %3119[23] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3144 = wave.extract %3119[24] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3145 = wave.extract %3119[25] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3146 = wave.extract %3119[26] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3147 = wave.extract %3119[27] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3148 = wave.extract %3119[28] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3149 = wave.extract %3119[29] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3150 = wave.extract %3119[30] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3151 = wave.extract %3119[31] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3152 = wave.extract %3119[32] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3153 = wave.extract %3119[33] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3154 = wave.extract %3119[34] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3155 = wave.extract %3119[35] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3156 = wave.extract %3119[36] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3157 = wave.extract %3119[37] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3158 = wave.extract %3119[38] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3159 = wave.extract %3119[39] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3160 = wave.extract %3119[40] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3161 = wave.extract %3119[41] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3162 = wave.extract %3119[42] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3163 = wave.extract %3119[43] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3164 = wave.extract %3119[44] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3165 = wave.extract %3119[45] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3166 = wave.extract %3119[46] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3167 = wave.extract %3119[47] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3168 = wave.extract %3119[48] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3169 = wave.extract %3119[49] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3170 = wave.extract %3119[50] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3171 = wave.extract %3119[51] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3172 = wave.extract %3119[52] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3173 = wave.extract %3119[53] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3174 = wave.extract %3119[54] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3175 = wave.extract %3119[55] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3176 = wave.extract %3119[56] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3177 = wave.extract %3119[57] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3178 = wave.extract %3119[58] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3179 = wave.extract %3119[59] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3180 = wave.extract %3119[60] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3181 = wave.extract %3119[61] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3182 = wave.extract %3119[62] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3183 = wave.extract %3119[63] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3184 = wave.extract %3119[64] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3185 = wave.extract %3119[65] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3186 = wave.extract %3119[66] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3187 = wave.extract %3119[67] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3188 = wave.extract %3119[68] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3189 = wave.extract %3119[69] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3190 = wave.extract %3119[70] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3191 = wave.extract %3119[71] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3192 = wave.extract %3119[72] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3193 = wave.extract %3119[73] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3194 = wave.extract %3119[74] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3195 = wave.extract %3119[75] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3196 = wave.extract %3119[76] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3197 = wave.extract %3119[77] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3198 = wave.extract %3119[78] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3199 = wave.extract %3119[79] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3200 = wave.extract %3119[80] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3201 = wave.extract %3119[81] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3202 = wave.extract %3119[82] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3203 = wave.extract %3119[83] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3204 = wave.extract %3119[84] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3205 = wave.extract %3119[85] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3206 = wave.extract %3119[86] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3207 = wave.extract %3119[87] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3208 = wave.extract %3119[88] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3209 = wave.extract %3119[89] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3210 = wave.extract %3119[90] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3211 = wave.extract %3119[91] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3212 = wave.extract %3119[92] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3213 = wave.extract %3119[93] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3214 = wave.extract %3119[94] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3215 = wave.extract %3119[95] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3216 = wave.extract %3119[96] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3217 = wave.extract %3119[97] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3218 = wave.extract %3119[98] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3219 = wave.extract %3119[99] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3220 = wave.extract %3119[100] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3221 = wave.extract %3119[101] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3222 = wave.extract %3119[102] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3223 = wave.extract %3119[103] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3224 = wave.extract %3119[104] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3225 = wave.extract %3119[105] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3226 = wave.extract %3119[106] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3227 = wave.extract %3119[107] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3228 = wave.extract %3119[108] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3229 = wave.extract %3119[109] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3230 = wave.extract %3119[110] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3231 = wave.extract %3119[111] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3232 = wave.extract %3119[112] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3233 = wave.extract %3119[113] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3234 = wave.extract %3119[114] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3235 = wave.extract %3119[115] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3236 = wave.extract %3119[116] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3237 = wave.extract %3119[117] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3238 = wave.extract %3119[118] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3239 = wave.extract %3119[119] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3240 = wave.extract %3119[120] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3241 = wave.extract %3119[121] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3242 = wave.extract %3119[122] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3243 = wave.extract %3119[123] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3244 = wave.extract %3119[124] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3245 = wave.extract %3119[125] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3246 = wave.extract %3119[126] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3247 = wave.extract %3119[127] : !wave.simd<vector<128xf32>, 64> -> !wave.simd<f32, 64>
      %3248 = wave.cast fpconvert %3120 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3249 = wave.cast fpconvert %3121 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3250 = wave.cast fpconvert %3122 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3251 = wave.cast fpconvert %3123 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3252 = wave.cast fpconvert %3124 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3253 = wave.cast fpconvert %3125 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3254 = wave.cast fpconvert %3126 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3255 = wave.cast fpconvert %3127 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3256 = wave.cast fpconvert %3128 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3257 = wave.cast fpconvert %3129 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3258 = wave.cast fpconvert %3130 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3259 = wave.cast fpconvert %3131 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3260 = wave.cast fpconvert %3132 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3261 = wave.cast fpconvert %3133 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3262 = wave.cast fpconvert %3134 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3263 = wave.cast fpconvert %3135 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3264 = wave.cast fpconvert %3136 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3265 = wave.cast fpconvert %3137 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3266 = wave.cast fpconvert %3138 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3267 = wave.cast fpconvert %3139 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3268 = wave.cast fpconvert %3140 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3269 = wave.cast fpconvert %3141 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3270 = wave.cast fpconvert %3142 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3271 = wave.cast fpconvert %3143 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3272 = wave.cast fpconvert %3144 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3273 = wave.cast fpconvert %3145 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3274 = wave.cast fpconvert %3146 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3275 = wave.cast fpconvert %3147 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3276 = wave.cast fpconvert %3148 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3277 = wave.cast fpconvert %3149 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3278 = wave.cast fpconvert %3150 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3279 = wave.cast fpconvert %3151 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3280 = wave.cast fpconvert %3152 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3281 = wave.cast fpconvert %3153 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3282 = wave.cast fpconvert %3154 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3283 = wave.cast fpconvert %3155 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3284 = wave.cast fpconvert %3156 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3285 = wave.cast fpconvert %3157 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3286 = wave.cast fpconvert %3158 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3287 = wave.cast fpconvert %3159 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3288 = wave.cast fpconvert %3160 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3289 = wave.cast fpconvert %3161 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3290 = wave.cast fpconvert %3162 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3291 = wave.cast fpconvert %3163 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3292 = wave.cast fpconvert %3164 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3293 = wave.cast fpconvert %3165 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3294 = wave.cast fpconvert %3166 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3295 = wave.cast fpconvert %3167 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3296 = wave.cast fpconvert %3168 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3297 = wave.cast fpconvert %3169 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3298 = wave.cast fpconvert %3170 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3299 = wave.cast fpconvert %3171 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3300 = wave.cast fpconvert %3172 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3301 = wave.cast fpconvert %3173 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3302 = wave.cast fpconvert %3174 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3303 = wave.cast fpconvert %3175 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3304 = wave.cast fpconvert %3176 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3305 = wave.cast fpconvert %3177 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3306 = wave.cast fpconvert %3178 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3307 = wave.cast fpconvert %3179 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3308 = wave.cast fpconvert %3180 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3309 = wave.cast fpconvert %3181 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3310 = wave.cast fpconvert %3182 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3311 = wave.cast fpconvert %3183 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3312 = wave.cast fpconvert %3184 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3313 = wave.cast fpconvert %3185 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3314 = wave.cast fpconvert %3186 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3315 = wave.cast fpconvert %3187 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3316 = wave.cast fpconvert %3188 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3317 = wave.cast fpconvert %3189 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3318 = wave.cast fpconvert %3190 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3319 = wave.cast fpconvert %3191 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3320 = wave.cast fpconvert %3192 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3321 = wave.cast fpconvert %3193 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3322 = wave.cast fpconvert %3194 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3323 = wave.cast fpconvert %3195 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3324 = wave.cast fpconvert %3196 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3325 = wave.cast fpconvert %3197 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3326 = wave.cast fpconvert %3198 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3327 = wave.cast fpconvert %3199 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3328 = wave.cast fpconvert %3200 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3329 = wave.cast fpconvert %3201 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3330 = wave.cast fpconvert %3202 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3331 = wave.cast fpconvert %3203 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3332 = wave.cast fpconvert %3204 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3333 = wave.cast fpconvert %3205 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3334 = wave.cast fpconvert %3206 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3335 = wave.cast fpconvert %3207 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3336 = wave.cast fpconvert %3208 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3337 = wave.cast fpconvert %3209 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3338 = wave.cast fpconvert %3210 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3339 = wave.cast fpconvert %3211 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3340 = wave.cast fpconvert %3212 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3341 = wave.cast fpconvert %3213 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3342 = wave.cast fpconvert %3214 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3343 = wave.cast fpconvert %3215 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3344 = wave.cast fpconvert %3216 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3345 = wave.cast fpconvert %3217 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3346 = wave.cast fpconvert %3218 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3347 = wave.cast fpconvert %3219 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3348 = wave.cast fpconvert %3220 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3349 = wave.cast fpconvert %3221 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3350 = wave.cast fpconvert %3222 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3351 = wave.cast fpconvert %3223 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3352 = wave.cast fpconvert %3224 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3353 = wave.cast fpconvert %3225 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3354 = wave.cast fpconvert %3226 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3355 = wave.cast fpconvert %3227 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3356 = wave.cast fpconvert %3228 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3357 = wave.cast fpconvert %3229 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3358 = wave.cast fpconvert %3230 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3359 = wave.cast fpconvert %3231 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3360 = wave.cast fpconvert %3232 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3361 = wave.cast fpconvert %3233 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3362 = wave.cast fpconvert %3234 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3363 = wave.cast fpconvert %3235 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3364 = wave.cast fpconvert %3236 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3365 = wave.cast fpconvert %3237 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3366 = wave.cast fpconvert %3238 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3367 = wave.cast fpconvert %3239 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3368 = wave.cast fpconvert %3240 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3369 = wave.cast fpconvert %3241 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3370 = wave.cast fpconvert %3242 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3371 = wave.cast fpconvert %3243 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3372 = wave.cast fpconvert %3244 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3373 = wave.cast fpconvert %3245 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3374 = wave.cast fpconvert %3246 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3375 = wave.cast fpconvert %3247 : !wave.simd<f32, 64> -> !wave.simd<bf16, 64>
      %3376 = wave.issue_token %2957 : !wave.mem.token -> !wave.mem.token
      %3377 = wave.barrier %1984, %token_172, %1994 : (!wave.mem.token, !wave.mem.token, !wave.mem.token) -> !wave.mem.token
      %3378 = wave.after %3377, %3376 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
      %3379 = wave.issue_token %3378 : !wave.mem.token -> !wave.mem.token
      %3380 = wave.pack %3248, %3249, %3250, %3251, %3252, %3253, %3254, %3255, %3256, %3257, %3258, %3259, %3260, %3261, %3262, %3263, %3264, %3265, %3266, %3267, %3268, %3269, %3270, %3271, %3272, %3273, %3274, %3275, %3276, %3277, %3278, %3279, %3280, %3281, %3282, %3283, %3284, %3285, %3286, %3287, %3288, %3289, %3290, %3291, %3292, %3293, %3294, %3295, %3296, %3297, %3298, %3299, %3300, %3301, %3302, %3303, %3304, %3305, %3306, %3307, %3308, %3309, %3310, %3311, %3312, %3313, %3314, %3315, %3316, %3317, %3318, %3319, %3320, %3321, %3322, %3323, %3324, %3325, %3326, %3327, %3328, %3329, %3330, %3331, %3332, %3333, %3334, %3335, %3336, %3337, %3338, %3339, %3340, %3341, %3342, %3343, %3344, %3345, %3346, %3347, %3348, %3349, %3350, %3351, %3352, %3353, %3354, %3355, %3356, %3357, %3358, %3359, %3360, %3361, %3362, %3363, %3364, %3365, %3366, %3367, %3368, %3369, %3370, %3371, %3372, %3373, %3374, %3375 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<128xbf16>, 64>
      %3381 = wave.redistribute %3380, <blocks = 1, items = 256, source_block = "0", source_item = "Mod(4*floor(1/64*item) + floor(1/16*Mod(item, 64)) + 128*floor(1/8*slot) + 16*floor(1/4*Mod(slot, 8)) + 32*Mod(item, 2) + 64*Mod(floor(1/2*Mod(item, 64)), 2), 256)", source_slot = "16*floor(1/16*slot) + Mod(slot, 2) + 8*Mod(floor(1/8*Mod(item, 64)), 2) + 4*Mod(floor(1/4*Mod(item, 64)), 2) + 2*Mod(floor(1/2*Mod(slot, 8)), 2)"> : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<vector<128xbf16>, 64>
      %3382 = wave.extract %3381[0] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3383 = wave.extract %3381[1] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3384 = wave.extract %3381[2] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3385 = wave.extract %3381[3] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3386 = wave.extract %3381[4] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3387 = wave.extract %3381[5] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3388 = wave.extract %3381[6] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3389 = wave.extract %3381[7] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3390 = wave.extract %3381[8] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3391 = wave.extract %3381[9] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3392 = wave.extract %3381[10] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3393 = wave.extract %3381[11] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3394 = wave.extract %3381[12] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3395 = wave.extract %3381[13] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3396 = wave.extract %3381[14] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3397 = wave.extract %3381[15] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3398 = wave.extract %3381[16] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3399 = wave.extract %3381[17] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3400 = wave.extract %3381[18] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3401 = wave.extract %3381[19] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3402 = wave.extract %3381[20] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3403 = wave.extract %3381[21] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3404 = wave.extract %3381[22] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3405 = wave.extract %3381[23] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3406 = wave.extract %3381[24] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3407 = wave.extract %3381[25] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3408 = wave.extract %3381[26] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3409 = wave.extract %3381[27] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3410 = wave.extract %3381[28] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3411 = wave.extract %3381[29] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3412 = wave.extract %3381[30] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3413 = wave.extract %3381[31] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3414 = wave.extract %3381[32] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3415 = wave.extract %3381[33] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3416 = wave.extract %3381[34] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3417 = wave.extract %3381[35] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3418 = wave.extract %3381[36] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3419 = wave.extract %3381[37] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3420 = wave.extract %3381[38] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3421 = wave.extract %3381[39] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3422 = wave.extract %3381[40] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3423 = wave.extract %3381[41] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3424 = wave.extract %3381[42] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3425 = wave.extract %3381[43] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3426 = wave.extract %3381[44] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3427 = wave.extract %3381[45] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3428 = wave.extract %3381[46] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3429 = wave.extract %3381[47] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3430 = wave.extract %3381[48] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3431 = wave.extract %3381[49] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3432 = wave.extract %3381[50] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3433 = wave.extract %3381[51] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3434 = wave.extract %3381[52] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3435 = wave.extract %3381[53] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3436 = wave.extract %3381[54] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3437 = wave.extract %3381[55] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3438 = wave.extract %3381[56] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3439 = wave.extract %3381[57] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3440 = wave.extract %3381[58] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3441 = wave.extract %3381[59] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3442 = wave.extract %3381[60] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3443 = wave.extract %3381[61] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3444 = wave.extract %3381[62] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3445 = wave.extract %3381[63] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3446 = wave.extract %3381[64] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3447 = wave.extract %3381[65] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3448 = wave.extract %3381[66] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3449 = wave.extract %3381[67] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3450 = wave.extract %3381[68] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3451 = wave.extract %3381[69] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3452 = wave.extract %3381[70] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3453 = wave.extract %3381[71] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3454 = wave.extract %3381[72] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3455 = wave.extract %3381[73] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3456 = wave.extract %3381[74] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3457 = wave.extract %3381[75] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3458 = wave.extract %3381[76] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3459 = wave.extract %3381[77] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3460 = wave.extract %3381[78] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3461 = wave.extract %3381[79] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3462 = wave.extract %3381[80] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3463 = wave.extract %3381[81] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3464 = wave.extract %3381[82] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3465 = wave.extract %3381[83] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3466 = wave.extract %3381[84] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3467 = wave.extract %3381[85] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3468 = wave.extract %3381[86] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3469 = wave.extract %3381[87] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3470 = wave.extract %3381[88] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3471 = wave.extract %3381[89] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3472 = wave.extract %3381[90] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3473 = wave.extract %3381[91] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3474 = wave.extract %3381[92] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3475 = wave.extract %3381[93] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3476 = wave.extract %3381[94] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3477 = wave.extract %3381[95] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3478 = wave.extract %3381[96] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3479 = wave.extract %3381[97] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3480 = wave.extract %3381[98] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3481 = wave.extract %3381[99] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3482 = wave.extract %3381[100] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3483 = wave.extract %3381[101] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3484 = wave.extract %3381[102] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3485 = wave.extract %3381[103] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3486 = wave.extract %3381[104] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3487 = wave.extract %3381[105] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3488 = wave.extract %3381[106] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3489 = wave.extract %3381[107] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3490 = wave.extract %3381[108] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3491 = wave.extract %3381[109] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3492 = wave.extract %3381[110] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3493 = wave.extract %3381[111] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3494 = wave.extract %3381[112] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3495 = wave.extract %3381[113] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3496 = wave.extract %3381[114] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3497 = wave.extract %3381[115] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3498 = wave.extract %3381[116] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3499 = wave.extract %3381[117] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3500 = wave.extract %3381[118] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3501 = wave.extract %3381[119] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3502 = wave.extract %3381[120] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3503 = wave.extract %3381[121] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3504 = wave.extract %3381[122] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3505 = wave.extract %3381[123] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3506 = wave.extract %3381[124] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3507 = wave.extract %3381[125] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3508 = wave.extract %3381[126] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %3509 = wave.extract %3381[127] : !wave.simd<vector<128xbf16>, 64> -> !wave.simd<bf16, 64>
      %c2147483647_i32_174 = arith.constant 2147483647 : i32
      %3510 = waveamd.make_buffer %2954, %c2147483647_i32_174 : !wave.ptr<#wave.global, bf16>, i32 -> !wave.ptr<#waveamd.buffer, bf16>
      %3511 = wave.pack %3382, %3383, %3384, %3385, %3386, %3387, %3388, %3389, %3390, %3391, %3392, %3393, %3394, %3395, %3396, %3397, %3398, %3399, %3400, %3401, %3402, %3403, %3404, %3405, %3406, %3407, %3408, %3409, %3410, %3411, %3412, %3413, %3414, %3415, %3416, %3417, %3418, %3419, %3420, %3421, %3422, %3423, %3424, %3425, %3426, %3427, %3428, %3429, %3430, %3431, %3432, %3433, %3434, %3435, %3436, %3437, %3438, %3439, %3440, %3441, %3442, %3443, %3444, %3445, %3446, %3447, %3448, %3449, %3450, %3451, %3452, %3453, %3454, %3455, %3456, %3457, %3458, %3459, %3460, %3461, %3462, %3463, %3464, %3465, %3466, %3467, %3468, %3469, %3470, %3471, %3472, %3473, %3474, %3475, %3476, %3477, %3478, %3479, %3480, %3481, %3482, %3483, %3484, %3485, %3486, %3487, %3488, %3489, %3490, %3491, %3492, %3493, %3494, %3495, %3496, %3497, %3498, %3499, %3500, %3501, %3502, %3503, %3504, %3505, %3506, %3507, %3508, %3509 : !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64>, !wave.simd<bf16, 64> -> !wave.simd<vector<128xbf16>, 64>
      %3512 = wave.scatter %3511 to %3510 mapping <bit_offset = <"8*Mod(2*(128 + t99 + 4*t10*floor(1/64*item) + t10*floor(1/16*Mod(item, 64)) + 16*t10*floor(1/8*slot) + 2*floor(1/2*Mod(slot, 8)) + 8*Mod(item, 2) + Mod(slot, 2) + 64*Mod(floor(1/8*Mod(item, 64)), 2) + 32*Mod(floor(1/4*Mod(item, 64)), 2) + 16*Mod(floor(1/2*Mod(item, 64)), 2)), 4294967296)">> bindings ["item", "t10", "t99"](%1, %13, %1192) after %3379 : (!wave.simd<vector<128xbf16>, 64>, !wave.ptr<#waveamd.buffer, bf16>, !wave.simd<i32, 64>, i32, i32, !wave.mem.token) -> !wave.mem.token
      return
    }
  }
}
