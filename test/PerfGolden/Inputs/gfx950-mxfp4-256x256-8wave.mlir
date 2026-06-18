module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
func.func @wmma_f16_matmul_tiled(%arg0: !wave.ptr<#wave.global, i8>, %arg1: !wave.ptr<#wave.global, i8>, %arg2: !wave.ptr<#wave.global, f16>, %arg3: !wave.ptr<#wave.global, i8>, %arg4: !wave.ptr<#wave.global, i8>, %arg5: i32) attributes {gpu.kernel, gpu.known_block_size = array<i32: 512, 1, 1>, wave.dynamic_lds_size = 147456 : i64, wave.kernel, wave.lds_size = 0 : i64, wave.workgroup_size = array<i32: 512, 1, 1>, waveamdmachine.target_waves = 2 : i64} {
  %c12288_i32 = arith.constant 12288 : i32
  %c8192_i32 = arith.constant 8192 : i32
  %c2_i32 = arith.constant 2 : i32
  %c126_i32 = arith.constant 126 : i32
  %c16384_i32 = arith.constant 16384 : i32
  %c39_i32 = arith.constant 39 : i32
  %c1_i32 = arith.constant 1 : i32
  %c6_i32 = arith.constant 6 : i32
  %c0_i32 = arith.constant 0 : i32
  %c7936_i32 = arith.constant 7936 : i32
  %c7680_i32 = arith.constant 7680 : i32
  %c7424_i32 = arith.constant 7424 : i32
  %c7168_i32 = arith.constant 7168 : i32
  %c6912_i32 = arith.constant 6912 : i32
  %c6656_i32 = arith.constant 6656 : i32
  %c6400_i32 = arith.constant 6400 : i32
  %c6144_i32 = arith.constant 6144 : i32
  %c5888_i32 = arith.constant 5888 : i32
  %c5632_i32 = arith.constant 5632 : i32
  %c5376_i32 = arith.constant 5376 : i32
  %c5120_i32 = arith.constant 5120 : i32
  %c4864_i32 = arith.constant 4864 : i32
  %c4608_i32 = arith.constant 4608 : i32
  %c4352_i32 = arith.constant 4352 : i32
  %c4096_i32 = arith.constant 4096 : i32
  %c3840_i32 = arith.constant 3840 : i32
  %c3584_i32 = arith.constant 3584 : i32
  %c3328_i32 = arith.constant 3328 : i32
  %c3072_i32 = arith.constant 3072 : i32
  %c2816_i32 = arith.constant 2816 : i32
  %c2560_i32 = arith.constant 2560 : i32
  %c2304_i32 = arith.constant 2304 : i32
  %c2048_i32 = arith.constant 2048 : i32
  %c1792_i32 = arith.constant 1792 : i32
  %c1536_i32 = arith.constant 1536 : i32
  %c1280_i32 = arith.constant 1280 : i32
  %c1024_i32 = arith.constant 1024 : i32
  %c768_i32 = arith.constant 768 : i32
  %c512_i32 = arith.constant 512 : i32
  %c256_i32 = arith.constant 256 : i32
  %c128_i32 = arith.constant 128 : i32
  %c131072_i32 = arith.constant 131072 : i32
  %c67108864_i32 = arith.constant 67108864 : i32
  %0 = waveamd.make_buffer %arg0, %c67108864_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %1 = waveamd.make_buffer %arg1, %c67108864_i32 : !wave.ptr<#wave.global, i8>, i32 -> !wave.ptr<#waveamd.buffer, i8>
  %2 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %3 = wave.assume %2 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %4 = wave.workgroup_id 0
  %5 = wave.assume %4 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-15 + x <= 0">] : i32
  %6 = wave.workgroup_id 1
  %7 = wave.assume %6 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-15 + x <= 0">] : i32
  %8 = wave.index_expr <"4*floor(1/32*wg_n_raw + 1/64*floor(1/8*wg_m_raw) + 1/2*Mod(wg_m_raw, 8)) + Mod(Mod(2*wg_n_raw + floor(1/8*wg_m_raw) + 32*Mod(wg_m_raw, 8), 64), 4)"> ["wg_m_raw", "wg_n_raw"](%5, %7) : (i32, i32) -> index
  %9 = wave.index_expr <"floor(1/4*Mod(2*wg_n_raw + floor(1/8*wg_m_raw) + 32*Mod(wg_m_raw, 8), 64))"> ["wg_m_raw", "wg_n_raw"](%5, %7) : (i32, i32) -> index
  %10 = wave.assume %8 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-15 + x <= 0">] : index
  %11 = wave.assume %9 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-15 + x <= 0">] : index
  %12 = wave.index_expr <"1048576*wg_m + 65536*wg_n"> ["wg_m", "wg_n"](%10, %11) : (index, index) -> index
  %13 = wave.ptr_add %arg2, %12 : !wave.ptr<#wave.global, f16>, index -> !wave.ptr<#wave.global, f16>
  %14 = waveamd.make_buffer %13, %c131072_i32 : !wave.ptr<#wave.global, f16>, i32 -> !wave.ptr<#waveamd.buffer, f16>
  %15 = wave.index_expr <"8192*floor(1/64*wi)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %16 = wave.ptr_add %14, %15 : !wave.ptr<#waveamd.buffer, f16>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %17 = wave.lds_base : !wave.ptr<#wave.shared, i32>
  %18 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
  %19 = wave.index_expr <"4194304*wg_m - 4194240*floor(1/1024*wi) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_m"](%3, %10) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %20 = wave.ptr_add %0, %19 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %21 = wave.index_expr <"2097152 + 4194304*wg_m - 4194240*floor(1/2 + 1/16*floor(1/64*wi)) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_m"](%3, %10) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %22 = wave.ptr_add %0, %21 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %23 = wave.index_expr <"64 + 4194304*wg_m - 4194240*floor(1/1024*wi) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_m"](%3, %10) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %24 = wave.ptr_add %0, %23 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %25 = wave.index_expr <"2097216 + 4194304*wg_m - 4194240*floor(1/2 + 1/16*floor(1/64*wi)) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_m"](%3, %10) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %26 = wave.ptr_add %0, %25 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %27 = wave.index_expr <"4194304*wg_n - 4194240*floor(1/1024*wi) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_n"](%3, %11) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %28 = wave.ptr_add %1, %27 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %29 = wave.index_expr <"2097152 + 4194304*wg_n - 4194240*floor(1/2 + 1/16*floor(1/64*wi)) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_n"](%3, %11) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %30 = wave.ptr_add %1, %29 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %31 = wave.index_expr <"64 + 4194304*wg_n - 4194240*floor(1/1024*wi) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_n"](%3, %11) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %32 = wave.ptr_add %1, %31 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %33 = wave.index_expr <"2097216 + 4194304*wg_n - 4194240*floor(1/2 + 1/16*floor(1/64*wi)) + 262144*floor(1/64*wi) + 16384*floor(1/4*Mod(wi, 64)) + 16*xor(Mod(floor(1/8*Mod(wi, 64)), 4), Mod(Mod(wi, 64), 4))"> ["wi", "wg_n"](%3, %11) : (!wave.simd<i32, 64>, index) -> !wave.simd<index, 64>
  %34 = wave.ptr_add %1, %33 : !wave.ptr<#waveamd.buffer, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %35 = wave.index_expr <"256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %36 = wave.ptr_add %17, %35 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %37 = wave.index_expr <"2048 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %38 = wave.ptr_add %17, %37 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %39 = wave.index_expr <"4096 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %40 = wave.ptr_add %17, %39 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %41 = wave.index_expr <"6144 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %42 = wave.ptr_add %17, %41 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %43 = wave.index_expr <"8192 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %44 = wave.ptr_add %17, %43 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %45 = wave.index_expr <"10240 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %46 = wave.ptr_add %17, %45 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %47 = wave.index_expr <"12288 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %48 = wave.ptr_add %17, %47 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %49 = wave.index_expr <"14336 + 256*floor(1/64*wi_first)"> ["wi_first"](%18) : (i32) -> index
  %50 = wave.ptr_add %17, %49 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
  %51 = wave.index_expr <"1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %52 = wave.ptr_add %17, %51 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %53 = wave.index_expr <"256 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %54 = wave.ptr_add %17, %53 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %55 = wave.index_expr <"512 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %56 = wave.ptr_add %17, %55 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %57 = wave.index_expr <"768 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %58 = wave.ptr_add %17, %57 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %59 = wave.index_expr <"4096 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %60 = wave.ptr_add %17, %59 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %61 = wave.index_expr <"4352 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %62 = wave.ptr_add %17, %61 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %63 = wave.index_expr <"4608 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %64 = wave.ptr_add %17, %63 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %65 = wave.index_expr <"4864 + 1024*floor(1/128*wi) + 16*Mod(wi, 16) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %66 = wave.ptr_add %17, %65 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %67 = wave.index_expr <"8192 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %68 = wave.ptr_add %17, %67 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %69 = wave.index_expr <"8448 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %70 = wave.ptr_add %17, %69 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %71 = wave.index_expr <"8704 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %72 = wave.ptr_add %17, %71 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %73 = wave.index_expr <"8960 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %74 = wave.ptr_add %17, %73 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %75 = wave.index_expr <"9216 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %76 = wave.ptr_add %17, %75 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %77 = wave.index_expr <"9472 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %78 = wave.ptr_add %17, %77 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %79 = wave.index_expr <"9728 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %80 = wave.ptr_add %17, %79 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %81 = wave.index_expr <"9984 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %82 = wave.ptr_add %17, %81 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %83 = wave.index_expr <"12288 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %84 = wave.ptr_add %17, %83 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %85 = wave.index_expr <"12544 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %86 = wave.ptr_add %17, %85 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %87 = wave.index_expr <"12800 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %88 = wave.ptr_add %17, %87 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %89 = wave.index_expr <"13056 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %90 = wave.ptr_add %17, %89 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %91 = wave.index_expr <"13312 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %92 = wave.ptr_add %17, %91 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %93 = wave.index_expr <"13568 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %94 = wave.ptr_add %17, %93 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %95 = wave.index_expr <"13824 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %96 = wave.ptr_add %17, %95 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %97 = wave.index_expr <"14080 + 16*Mod(wi, 16) + 2048*Mod(floor(1/64*wi), 2) + 4*xor(floor(1/16*Mod(wi, 64)), Mod(floor(1/2*Mod(wi, 16)), 4))"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %98 = wave.ptr_add %17, %97 : !wave.ptr<#wave.shared, i32>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %99 = wave.ptr_add %16, %c256_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %100 = wave.ptr_add %16, %c512_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %101 = wave.ptr_add %16, %c768_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %102 = wave.ptr_add %16, %c1024_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %103 = wave.ptr_add %16, %c1280_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %104 = wave.ptr_add %16, %c1536_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %105 = wave.ptr_add %16, %c1792_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %106 = wave.ptr_add %16, %c2048_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %107 = wave.ptr_add %16, %c2304_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %108 = wave.ptr_add %16, %c2560_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %109 = wave.ptr_add %16, %c2816_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %110 = wave.ptr_add %16, %c3072_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %111 = wave.ptr_add %16, %c3328_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %112 = wave.ptr_add %16, %c3584_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %113 = wave.ptr_add %16, %c3840_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %114 = wave.ptr_add %16, %c4096_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %115 = wave.ptr_add %16, %c4352_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %116 = wave.ptr_add %16, %c4608_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %117 = wave.ptr_add %16, %c4864_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %118 = wave.ptr_add %16, %c5120_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %119 = wave.ptr_add %16, %c5376_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %120 = wave.ptr_add %16, %c5632_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %121 = wave.ptr_add %16, %c5888_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %122 = wave.ptr_add %16, %c6144_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %123 = wave.ptr_add %16, %c6400_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %124 = wave.ptr_add %16, %c6656_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %125 = wave.ptr_add %16, %c6912_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %126 = wave.ptr_add %16, %c7168_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %127 = wave.ptr_add %16, %c7424_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %128 = wave.ptr_add %16, %c7680_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %129 = wave.ptr_add %16, %c7936_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %130 = waveamd.fragment_fill %c0_i32 : i32 -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %131 = wave.token : !wave.mem.token
  %132 = waveamd.dma_load_lds %20 -> %36 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %133 = waveamd.dma_load_lds %22 -> %38 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %134 = waveamd.dma_load_lds %24 -> %40 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %135 = waveamd.dma_load_lds %26 -> %42 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %136 = waveamd.dma_load_lds %28 -> %44 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %137 = waveamd.dma_load_lds %30 -> %46 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %138 = waveamd.dma_load_lds %32 -> %48 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %139 = waveamd.dma_load_lds %34 -> %50 after %131 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %140 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
  %141 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i32>
  %142 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %143 = wave.binary shrui %3, %142 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %144 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %145 = wave.binary andi %143, %144 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %146 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %147 = wave.binary andi %3, %146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %148 = wave.binary ori %147, %145 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %149 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %150 = wave.cmpi eq %148, %149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %151 = wave.where %150 {
    %1027 = wave.index_expr <"256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"128*floor(1/128*wi_first)"> ["wi_first"](%140) : (i32) -> index
    %1029 = wave.ptr_add %141, %1028 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1030 = wave.ptr_add %arg3, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1031 = wave.token : !wave.mem.token
    %1032 = waveamd.dma_load_lds %1030 -> %1029 after %1031 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1033 = wave.index_expr <"16 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1034 = wave.index_expr <"4 + 128*floor(1/128*wi_first)"> ["wi_first"](%140) : (i32) -> index
    %1035 = wave.ptr_add %141, %1034 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1036 = wave.ptr_add %arg3, %1033 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1037 = wave.token : !wave.mem.token
    %1038 = waveamd.dma_load_lds %1036 -> %1035 after %1037 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1039 = wave.index_expr <"32 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1040 = wave.index_expr <"8 + 128*floor(1/128*wi_first)"> ["wi_first"](%140) : (i32) -> index
    %1041 = wave.ptr_add %141, %1040 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1042 = wave.ptr_add %arg3, %1039 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1043 = wave.token : !wave.mem.token
    %1044 = waveamd.dma_load_lds %1042 -> %1041 after %1043 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1045 = wave.index_expr <"48 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1046 = wave.index_expr <"12 + 128*floor(1/128*wi_first)"> ["wi_first"](%140) : (i32) -> index
    %1047 = wave.ptr_add %141, %1046 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1048 = wave.ptr_add %arg3, %1045 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1049 = wave.token : !wave.mem.token
    %1050 = waveamd.dma_load_lds %1048 -> %1047 after %1049 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1051 = wave.join %1032, %1038, %1044, %1050 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1051 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %152 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %153 = wave.binary shrui %3, %152 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %154 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %155 = wave.binary shrui %153, %154 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %156 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %157 = wave.binary andi %3, %156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %158 = wave.binary ori %157, %155 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %159 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %160 = wave.cmpi eq %158, %159 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %161 = wave.where %160 {
    %1027 = wave.index_expr <"256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"512 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1029 = wave.ptr_add %141, %1028 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1030 = wave.ptr_add %arg4, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1031 = wave.token : !wave.mem.token
    %1032 = waveamd.dma_load_lds %1030 -> %1029 after %1031 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1033 = wave.index_expr <"16 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1034 = wave.index_expr <"516 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1035 = wave.ptr_add %141, %1034 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1036 = wave.ptr_add %arg4, %1033 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1037 = wave.token : !wave.mem.token
    %1038 = waveamd.dma_load_lds %1036 -> %1035 after %1037 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1039 = wave.index_expr <"32 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1040 = wave.index_expr <"520 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1041 = wave.ptr_add %141, %1040 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1042 = wave.ptr_add %arg4, %1039 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1043 = wave.token : !wave.mem.token
    %1044 = waveamd.dma_load_lds %1042 -> %1041 after %1043 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1045 = wave.index_expr <"48 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1046 = wave.index_expr <"524 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1047 = wave.ptr_add %141, %1046 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1048 = wave.ptr_add %arg4, %1045 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1049 = wave.token : !wave.mem.token
    %1050 = waveamd.dma_load_lds %1048 -> %1047 after %1049 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1051 = wave.index_expr <"64 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1052 = wave.index_expr <"640 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1053 = wave.ptr_add %141, %1052 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1054 = wave.ptr_add %arg4, %1051 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1055 = wave.token : !wave.mem.token
    %1056 = waveamd.dma_load_lds %1054 -> %1053 after %1055 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1057 = wave.index_expr <"80 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1058 = wave.index_expr <"644 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1059 = wave.ptr_add %141, %1058 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1060 = wave.ptr_add %arg4, %1057 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1061 = wave.token : !wave.mem.token
    %1062 = waveamd.dma_load_lds %1060 -> %1059 after %1061 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1063 = wave.index_expr <"96 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1064 = wave.index_expr <"648 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1065 = wave.ptr_add %141, %1064 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1066 = wave.ptr_add %arg4, %1063 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1067 = wave.token : !wave.mem.token
    %1068 = waveamd.dma_load_lds %1066 -> %1065 after %1067 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1069 = wave.index_expr <"112 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %140) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1070 = wave.index_expr <"652 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%140) : (i32) -> index
    %1071 = wave.ptr_add %141, %1070 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1072 = wave.ptr_add %arg4, %1069 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1073 = wave.token : !wave.mem.token
    %1074 = waveamd.dma_load_lds %1072 -> %1071 after %1073 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1075 = wave.join %1032, %1038, %1044, %1050, %1056, %1062, %1068, %1074 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1075 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %162 = wave.join %151, %161 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %163 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
  %164 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i32>
  %165 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %166 = wave.binary shrui %3, %165 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %167 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %168 = wave.binary andi %166, %167 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %169 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %170 = wave.binary andi %3, %169 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %171 = wave.binary ori %170, %168 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %172 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %173 = wave.cmpi eq %171, %172 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %174 = wave.where %173 {
    %1027 = wave.index_expr <"16384 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"128*floor(1/128*wi_first)"> ["wi_first"](%163) : (i32) -> index
    %1029 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1028) : (index) -> index
    %1030 = wave.ptr_add %164, %1029 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1031 = wave.ptr_add %arg3, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1032 = wave.token : !wave.mem.token
    %1033 = waveamd.dma_load_lds %1031 -> %1030 after %1032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1034 = wave.index_expr <"16400 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1035 = wave.index_expr <"4 + 128*floor(1/128*wi_first)"> ["wi_first"](%163) : (i32) -> index
    %1036 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1035) : (index) -> index
    %1037 = wave.ptr_add %164, %1036 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1038 = wave.ptr_add %arg3, %1034 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1039 = wave.token : !wave.mem.token
    %1040 = waveamd.dma_load_lds %1038 -> %1037 after %1039 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1041 = wave.index_expr <"16416 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1042 = wave.index_expr <"8 + 128*floor(1/128*wi_first)"> ["wi_first"](%163) : (i32) -> index
    %1043 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1042) : (index) -> index
    %1044 = wave.ptr_add %164, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1045 = wave.ptr_add %arg3, %1041 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1046 = wave.token : !wave.mem.token
    %1047 = waveamd.dma_load_lds %1045 -> %1044 after %1046 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1048 = wave.index_expr <"16432 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1049 = wave.index_expr <"12 + 128*floor(1/128*wi_first)"> ["wi_first"](%163) : (i32) -> index
    %1050 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1049) : (index) -> index
    %1051 = wave.ptr_add %164, %1050 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1052 = wave.ptr_add %arg3, %1048 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1053 = wave.token : !wave.mem.token
    %1054 = waveamd.dma_load_lds %1052 -> %1051 after %1053 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1055 = wave.join %1033, %1040, %1047, %1054 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1055 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %175 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %176 = wave.binary shrui %3, %175 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %177 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %178 = wave.binary shrui %176, %177 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %179 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %180 = wave.binary andi %3, %179 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %181 = wave.binary ori %180, %178 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %182 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %183 = wave.cmpi eq %181, %182 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %184 = wave.where %183 {
    %1027 = wave.index_expr <"16384 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"512 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1029 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1028) : (index) -> index
    %1030 = wave.ptr_add %164, %1029 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1031 = wave.ptr_add %arg4, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1032 = wave.token : !wave.mem.token
    %1033 = waveamd.dma_load_lds %1031 -> %1030 after %1032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1034 = wave.index_expr <"16400 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1035 = wave.index_expr <"516 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1036 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1035) : (index) -> index
    %1037 = wave.ptr_add %164, %1036 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1038 = wave.ptr_add %arg4, %1034 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1039 = wave.token : !wave.mem.token
    %1040 = waveamd.dma_load_lds %1038 -> %1037 after %1039 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1041 = wave.index_expr <"16416 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1042 = wave.index_expr <"520 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1043 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1042) : (index) -> index
    %1044 = wave.ptr_add %164, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1045 = wave.ptr_add %arg4, %1041 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1046 = wave.token : !wave.mem.token
    %1047 = waveamd.dma_load_lds %1045 -> %1044 after %1046 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1048 = wave.index_expr <"16432 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1049 = wave.index_expr <"524 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1050 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1049) : (index) -> index
    %1051 = wave.ptr_add %164, %1050 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1052 = wave.ptr_add %arg4, %1048 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1053 = wave.token : !wave.mem.token
    %1054 = waveamd.dma_load_lds %1052 -> %1051 after %1053 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1055 = wave.index_expr <"16448 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1056 = wave.index_expr <"640 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1057 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1056) : (index) -> index
    %1058 = wave.ptr_add %164, %1057 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1059 = wave.ptr_add %arg4, %1055 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1060 = wave.token : !wave.mem.token
    %1061 = waveamd.dma_load_lds %1059 -> %1058 after %1060 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1062 = wave.index_expr <"16464 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1063 = wave.index_expr <"644 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1064 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1063) : (index) -> index
    %1065 = wave.ptr_add %164, %1064 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1066 = wave.ptr_add %arg4, %1062 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1067 = wave.token : !wave.mem.token
    %1068 = waveamd.dma_load_lds %1066 -> %1065 after %1067 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1069 = wave.index_expr <"16480 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1070 = wave.index_expr <"648 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1071 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1070) : (index) -> index
    %1072 = wave.ptr_add %164, %1071 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1073 = wave.ptr_add %arg4, %1069 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1074 = wave.token : !wave.mem.token
    %1075 = waveamd.dma_load_lds %1073 -> %1072 after %1074 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1076 = wave.index_expr <"16496 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %163) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1077 = wave.index_expr <"652 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%163) : (i32) -> index
    %1078 = wave.index_expr <"1024 + scale_dma_dest"> ["scale_dma_dest"](%1077) : (index) -> index
    %1079 = wave.ptr_add %164, %1078 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1080 = wave.ptr_add %arg4, %1076 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1081 = wave.token : !wave.mem.token
    %1082 = waveamd.dma_load_lds %1080 -> %1079 after %1081 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1083 = wave.join %1033, %1040, %1047, %1054, %1061, %1068, %1075, %1082 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1083 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %185 = wave.join %174, %184 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %186 = wave.join %162, %185 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %187 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
  %188 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i32>
  %189 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %190 = wave.binary shrui %3, %189 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %191 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %192 = wave.binary andi %190, %191 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %193 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %194 = wave.binary andi %3, %193 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %195 = wave.binary ori %194, %192 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %196 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %197 = wave.cmpi eq %195, %196 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %198 = wave.where %197 {
    %1027 = wave.index_expr <"32768 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"128*floor(1/128*wi_first)"> ["wi_first"](%187) : (i32) -> index
    %1029 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1028) : (index) -> index
    %1030 = wave.ptr_add %188, %1029 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1031 = wave.ptr_add %arg3, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1032 = wave.token : !wave.mem.token
    %1033 = waveamd.dma_load_lds %1031 -> %1030 after %1032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1034 = wave.index_expr <"32784 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1035 = wave.index_expr <"4 + 128*floor(1/128*wi_first)"> ["wi_first"](%187) : (i32) -> index
    %1036 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1035) : (index) -> index
    %1037 = wave.ptr_add %188, %1036 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1038 = wave.ptr_add %arg3, %1034 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1039 = wave.token : !wave.mem.token
    %1040 = waveamd.dma_load_lds %1038 -> %1037 after %1039 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1041 = wave.index_expr <"32800 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1042 = wave.index_expr <"8 + 128*floor(1/128*wi_first)"> ["wi_first"](%187) : (i32) -> index
    %1043 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1042) : (index) -> index
    %1044 = wave.ptr_add %188, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1045 = wave.ptr_add %arg3, %1041 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1046 = wave.token : !wave.mem.token
    %1047 = waveamd.dma_load_lds %1045 -> %1044 after %1046 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1048 = wave.index_expr <"32816 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1049 = wave.index_expr <"12 + 128*floor(1/128*wi_first)"> ["wi_first"](%187) : (i32) -> index
    %1050 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1049) : (index) -> index
    %1051 = wave.ptr_add %188, %1050 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1052 = wave.ptr_add %arg3, %1048 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1053 = wave.token : !wave.mem.token
    %1054 = waveamd.dma_load_lds %1052 -> %1051 after %1053 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1055 = wave.join %1033, %1040, %1047, %1054 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1055 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %199 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %200 = wave.binary shrui %3, %199 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %201 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %202 = wave.binary shrui %200, %201 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %203 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %204 = wave.binary andi %3, %203 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %205 = wave.binary ori %204, %202 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %206 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %207 = wave.cmpi eq %205, %206 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %208 = wave.where %207 {
    %1027 = wave.index_expr <"32768 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"512 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1029 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1028) : (index) -> index
    %1030 = wave.ptr_add %188, %1029 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1031 = wave.ptr_add %arg4, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1032 = wave.token : !wave.mem.token
    %1033 = waveamd.dma_load_lds %1031 -> %1030 after %1032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1034 = wave.index_expr <"32784 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1035 = wave.index_expr <"516 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1036 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1035) : (index) -> index
    %1037 = wave.ptr_add %188, %1036 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1038 = wave.ptr_add %arg4, %1034 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1039 = wave.token : !wave.mem.token
    %1040 = waveamd.dma_load_lds %1038 -> %1037 after %1039 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1041 = wave.index_expr <"32800 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1042 = wave.index_expr <"520 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1043 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1042) : (index) -> index
    %1044 = wave.ptr_add %188, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1045 = wave.ptr_add %arg4, %1041 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1046 = wave.token : !wave.mem.token
    %1047 = waveamd.dma_load_lds %1045 -> %1044 after %1046 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1048 = wave.index_expr <"32816 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1049 = wave.index_expr <"524 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1050 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1049) : (index) -> index
    %1051 = wave.ptr_add %188, %1050 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1052 = wave.ptr_add %arg4, %1048 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1053 = wave.token : !wave.mem.token
    %1054 = waveamd.dma_load_lds %1052 -> %1051 after %1053 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1055 = wave.index_expr <"32832 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1056 = wave.index_expr <"640 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1057 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1056) : (index) -> index
    %1058 = wave.ptr_add %188, %1057 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1059 = wave.ptr_add %arg4, %1055 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1060 = wave.token : !wave.mem.token
    %1061 = waveamd.dma_load_lds %1059 -> %1058 after %1060 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1062 = wave.index_expr <"32848 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1063 = wave.index_expr <"644 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1064 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1063) : (index) -> index
    %1065 = wave.ptr_add %188, %1064 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1066 = wave.ptr_add %arg4, %1062 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1067 = wave.token : !wave.mem.token
    %1068 = waveamd.dma_load_lds %1066 -> %1065 after %1067 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1069 = wave.index_expr <"32864 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1070 = wave.index_expr <"648 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1071 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1070) : (index) -> index
    %1072 = wave.ptr_add %188, %1071 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1073 = wave.ptr_add %arg4, %1069 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1074 = wave.token : !wave.mem.token
    %1075 = waveamd.dma_load_lds %1073 -> %1072 after %1074 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1076 = wave.index_expr <"32880 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %187) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1077 = wave.index_expr <"652 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%187) : (i32) -> index
    %1078 = wave.index_expr <"2048 + scale_dma_dest"> ["scale_dma_dest"](%1077) : (index) -> index
    %1079 = wave.ptr_add %188, %1078 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1080 = wave.ptr_add %arg4, %1076 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1081 = wave.token : !wave.mem.token
    %1082 = waveamd.dma_load_lds %1080 -> %1079 after %1081 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1083 = wave.join %1033, %1040, %1047, %1054, %1061, %1068, %1075, %1082 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1083 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %209 = wave.join %198, %208 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %210 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
  %211 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i32>
  %212 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %213 = wave.binary shrui %3, %212 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %214 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %215 = wave.binary andi %213, %214 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %216 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %217 = wave.binary andi %3, %216 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %218 = wave.binary ori %217, %215 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %219 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %220 = wave.cmpi eq %218, %219 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %221 = wave.where %220 {
    %1027 = wave.index_expr <"49152 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"128*floor(1/128*wi_first)"> ["wi_first"](%210) : (i32) -> index
    %1029 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1028) : (index) -> index
    %1030 = wave.ptr_add %211, %1029 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1031 = wave.ptr_add %arg3, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1032 = wave.token : !wave.mem.token
    %1033 = waveamd.dma_load_lds %1031 -> %1030 after %1032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1034 = wave.index_expr <"49168 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1035 = wave.index_expr <"4 + 128*floor(1/128*wi_first)"> ["wi_first"](%210) : (i32) -> index
    %1036 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1035) : (index) -> index
    %1037 = wave.ptr_add %211, %1036 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1038 = wave.ptr_add %arg3, %1034 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1039 = wave.token : !wave.mem.token
    %1040 = waveamd.dma_load_lds %1038 -> %1037 after %1039 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1041 = wave.index_expr <"49184 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1042 = wave.index_expr <"8 + 128*floor(1/128*wi_first)"> ["wi_first"](%210) : (i32) -> index
    %1043 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1042) : (index) -> index
    %1044 = wave.ptr_add %211, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1045 = wave.ptr_add %arg3, %1041 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1046 = wave.token : !wave.mem.token
    %1047 = waveamd.dma_load_lds %1045 -> %1044 after %1046 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1048 = wave.index_expr <"49200 + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first"](%3, %10, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1049 = wave.index_expr <"12 + 128*floor(1/128*wi_first)"> ["wi_first"](%210) : (i32) -> index
    %1050 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1049) : (index) -> index
    %1051 = wave.ptr_add %211, %1050 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1052 = wave.ptr_add %arg3, %1048 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1053 = wave.token : !wave.mem.token
    %1054 = waveamd.dma_load_lds %1052 -> %1051 after %1053 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1055 = wave.join %1033, %1040, %1047, %1054 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1055 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %222 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
  %223 = wave.binary shrui %3, %222 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %224 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
  %225 = wave.binary shrui %223, %224 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %226 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
  %227 = wave.binary andi %3, %226 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %228 = wave.binary ori %227, %225 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
  %229 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
  %230 = wave.cmpi eq %228, %229 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
  %231 = wave.where %230 {
    %1027 = wave.index_expr <"49152 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1028 = wave.index_expr <"512 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1029 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1028) : (index) -> index
    %1030 = wave.ptr_add %211, %1029 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1031 = wave.ptr_add %arg4, %1027 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1032 = wave.token : !wave.mem.token
    %1033 = waveamd.dma_load_lds %1031 -> %1030 after %1032 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1034 = wave.index_expr <"49168 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1035 = wave.index_expr <"516 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1036 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1035) : (index) -> index
    %1037 = wave.ptr_add %211, %1036 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1038 = wave.ptr_add %arg4, %1034 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1039 = wave.token : !wave.mem.token
    %1040 = waveamd.dma_load_lds %1038 -> %1037 after %1039 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1041 = wave.index_expr <"49184 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1042 = wave.index_expr <"520 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1043 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1042) : (index) -> index
    %1044 = wave.ptr_add %211, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1045 = wave.ptr_add %arg4, %1041 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1046 = wave.token : !wave.mem.token
    %1047 = waveamd.dma_load_lds %1045 -> %1044 after %1046 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1048 = wave.index_expr <"49200 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1049 = wave.index_expr <"524 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1050 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1049) : (index) -> index
    %1051 = wave.ptr_add %211, %1050 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1052 = wave.ptr_add %arg4, %1048 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1053 = wave.token : !wave.mem.token
    %1054 = waveamd.dma_load_lds %1052 -> %1051 after %1053 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1055 = wave.index_expr <"49216 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1056 = wave.index_expr <"640 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1057 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1056) : (index) -> index
    %1058 = wave.ptr_add %211, %1057 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1059 = wave.ptr_add %arg4, %1055 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1060 = wave.token : !wave.mem.token
    %1061 = waveamd.dma_load_lds %1059 -> %1058 after %1060 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1062 = wave.index_expr <"49232 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1063 = wave.index_expr <"644 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1064 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1063) : (index) -> index
    %1065 = wave.ptr_add %211, %1064 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1066 = wave.ptr_add %arg4, %1062 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1067 = wave.token : !wave.mem.token
    %1068 = waveamd.dma_load_lds %1066 -> %1065 after %1067 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1069 = wave.index_expr <"49248 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1070 = wave.index_expr <"648 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1071 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1070) : (index) -> index
    %1072 = wave.ptr_add %211, %1071 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1073 = wave.ptr_add %arg4, %1069 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1074 = wave.token : !wave.mem.token
    %1075 = waveamd.dma_load_lds %1073 -> %1072 after %1074 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1076 = wave.index_expr <"49264 + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first"](%3, %11, %210) : (!wave.simd<i32, 64>, index, i32) -> !wave.simd<index, 64>
    %1077 = wave.index_expr <"652 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%210) : (i32) -> index
    %1078 = wave.index_expr <"3072 + scale_dma_dest"> ["scale_dma_dest"](%1077) : (index) -> index
    %1079 = wave.ptr_add %211, %1078 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1080 = wave.ptr_add %arg4, %1076 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
    %1081 = wave.token : !wave.mem.token
    %1082 = waveamd.dma_load_lds %1080 -> %1079 after %1081 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1083 = wave.join %1033, %1040, %1047, %1054, %1061, %1068, %1075, %1082 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    wave.yield %1083 : !wave.mem.token
  } : !wave.mask<64> -> !wave.mem.token
  %232 = wave.join %221, %231 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %233 = wave.join %209, %232 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %234 = wave.ptr_add %20, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %235 = wave.ptr_add %22, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %236 = wave.ptr_add %24, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %237 = wave.ptr_add %26, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %238 = wave.ptr_add %28, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %239 = wave.ptr_add %30, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %240 = wave.ptr_add %32, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %241 = wave.ptr_add %34, %c128_i32 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
  %242 = wave.token : !wave.mem.token
  %243 = wave.ptr_add %36, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %244 = wave.ptr_add %38, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %245 = wave.ptr_add %40, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %246 = wave.ptr_add %42, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %247 = wave.ptr_add %44, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %248 = wave.ptr_add %46, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %249 = wave.ptr_add %48, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %250 = wave.ptr_add %50, %c16384_i32 : !wave.ptr<#wave.shared, i32>, i32 -> !wave.ptr<#wave.shared, i32>
  %251 = waveamd.dma_load_lds %234 -> %243 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %252 = waveamd.dma_load_lds %235 -> %244 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %253 = waveamd.dma_load_lds %236 -> %245 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %254 = waveamd.dma_load_lds %237 -> %246 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %255 = waveamd.dma_load_lds %238 -> %247 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %256 = waveamd.dma_load_lds %239 -> %248 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %257 = waveamd.dma_load_lds %240 -> %249 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %258 = waveamd.dma_load_lds %241 -> %250 after %242 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
  %259 = wave.join %251, %252, %253, %254, %255, %256, %257, %258 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %260 = wave.join %132, %133, %134, %135, %136, %137, %138, %139 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %261 = wave.barrier %260 : (!wave.mem.token) -> !wave.mem.token
  %value, %token = wave.load %52 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %262 = waveamd.fragment_pack %value : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_0, %token_1 = wave.load %54 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %263 = waveamd.fragment_pack %value_0 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_2, %token_3 = wave.load %56 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %264 = waveamd.fragment_pack %value_2 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_4, %token_5 = wave.load %58 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %265 = waveamd.fragment_pack %value_4 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_6, %token_7 = wave.load %60 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %266 = waveamd.fragment_pack %value_6 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_8, %token_9 = wave.load %62 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %267 = waveamd.fragment_pack %value_8 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_10, %token_11 = wave.load %64 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %268 = waveamd.fragment_pack %value_10 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_12, %token_13 = wave.load %66 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %269 = waveamd.fragment_pack %value_12 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_14, %token_15 = wave.load %68 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %270 = waveamd.fragment_pack %value_14 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_16, %token_17 = wave.load %70 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %271 = waveamd.fragment_pack %value_16 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_18, %token_19 = wave.load %72 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %272 = waveamd.fragment_pack %value_18 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_20, %token_21 = wave.load %74 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %273 = waveamd.fragment_pack %value_20 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_22, %token_23 = wave.load %76 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %274 = waveamd.fragment_pack %value_22 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_24, %token_25 = wave.load %78 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %275 = waveamd.fragment_pack %value_24 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_26, %token_27 = wave.load %80 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %276 = waveamd.fragment_pack %value_26 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_28, %token_29 = wave.load %82 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %277 = waveamd.fragment_pack %value_28 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_30, %token_31 = wave.load %84 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %278 = waveamd.fragment_pack %value_30 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_32, %token_33 = wave.load %86 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %279 = waveamd.fragment_pack %value_32 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_34, %token_35 = wave.load %88 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %280 = waveamd.fragment_pack %value_34 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_36, %token_37 = wave.load %90 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %281 = waveamd.fragment_pack %value_36 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_38, %token_39 = wave.load %92 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %282 = waveamd.fragment_pack %value_38 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_40, %token_41 = wave.load %94 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %283 = waveamd.fragment_pack %value_40 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_42, %token_43 = wave.load %96 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %284 = waveamd.fragment_pack %value_42 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_44, %token_45 = wave.load %98 after %261 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %285 = waveamd.fragment_pack %value_44 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %286 = wave.join %token, %token_1, %token_3, %token_5, %token_7, %token_9, %token_11, %token_13, %token_15, %token_17, %token_19, %token_21, %token_23, %token_25, %token_27, %token_29, %token_31, %token_33, %token_35, %token_37, %token_39, %token_41, %token_43, %token_45 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %287:60 = scf.for %arg6 = %c0_i32 to %c126_i32 step %c1_i32 iter_args(%arg7 = %130, %arg8 = %130, %arg9 = %130, %arg10 = %130, %arg11 = %130, %arg12 = %130, %arg13 = %130, %arg14 = %130, %arg15 = %130, %arg16 = %130, %arg17 = %130, %arg18 = %130, %arg19 = %130, %arg20 = %130, %arg21 = %130, %arg22 = %130, %arg23 = %130, %arg24 = %130, %arg25 = %130, %arg26 = %130, %arg27 = %130, %arg28 = %130, %arg29 = %130, %arg30 = %130, %arg31 = %130, %arg32 = %130, %arg33 = %130, %arg34 = %130, %arg35 = %130, %arg36 = %130, %arg37 = %130, %arg38 = %130, %arg39 = %262, %arg40 = %263, %arg41 = %264, %arg42 = %265, %arg43 = %266, %arg44 = %267, %arg45 = %268, %arg46 = %269, %arg47 = %270, %arg48 = %271, %arg49 = %272, %arg50 = %273, %arg51 = %274, %arg52 = %275, %arg53 = %276, %arg54 = %277, %arg55 = %278, %arg56 = %279, %arg57 = %280, %arg58 = %281, %arg59 = %282, %arg60 = %283, %arg61 = %284, %arg62 = %285, %arg63 = %259, %arg64 = %286, %arg65 = %186, %arg66 = %233) -> (!waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token)  : i32 {
    %1027 = wave.assume %arg6 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-126 + x <= 0">] : i32
    %1028 = wave.binary addi %1027, %c2_i32 : i32, i32 -> i32
    %1029 = wave.assume %1028 as "x" [#wave.pred<"-2 + x >= 0">, #wave.pred<"-127 + x <= 0">] : i32
    %1030 = wave.binary muli %1029, %c128_i32 : i32, i32 -> i32
    %1031 = wave.assume %1030 as "x" [#wave.pred<"-128 + x >= 0">, #wave.pred<"-16256 + x <= 0">] : i32
    %1032 = wave.ptr_add %20, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1033 = wave.ptr_add %22, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1034 = wave.ptr_add %24, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1035 = wave.ptr_add %26, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1036 = wave.ptr_add %28, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1037 = wave.ptr_add %30, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1038 = wave.ptr_add %32, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1039 = wave.ptr_add %34, %1031 : !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, i32 -> !wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>
    %1040 = wave.binary addi %1027, %c1_i32 : i32, i32 -> i32
    %1041 = wave.index_expr <"16384*Mod(i, 2)"> ["i"](%1040) : (i32) -> index
    %1042 = wave.binary addi %1027, %c2_i32 : i32, i32 -> i32
    %1043 = wave.index_expr <"16384*Mod(i, 2)"> ["i"](%1042) : (i32) -> index
    %1044 = wave.index_expr <"2048*Mod(i, 2)"> ["i"](%1027) : (i32) -> index
    %1045 = wave.barrier %arg65 : (!wave.mem.token) -> !wave.mem.token
    %1046 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
    %1047 = wave.index_expr <"4*scale_lds_offset"> ["scale_lds_offset"](%1044) : (index) -> index
    %1048 = wave.ptr_add %1046, %1047 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
    %1049 = wave.index_expr <"512*floor(1/128*wi) + 8*Mod(wi, 64)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %1050 = wave.ptr_add %1048, %1049 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value_118, %token_119 = waveamd.transpose_load %1050 after %1045 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %1051 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
    %1052 = wave.index_expr <"4*scale_lds_offset"> ["scale_lds_offset"](%1044) : (index) -> index
    %1053 = wave.ptr_add %1051, %1052 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
    %1054 = wave.index_expr <"2048 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %1055 = wave.ptr_add %1053, %1054 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value_120, %token_121 = waveamd.transpose_load %1055 after %1045 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %1056 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
    %1057 = wave.index_expr <"4*scale_lds_offset"> ["scale_lds_offset"](%1044) : (index) -> index
    %1058 = wave.ptr_add %1056, %1057 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
    %1059 = wave.index_expr <"2560 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %1060 = wave.ptr_add %1058, %1059 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value_122, %token_123 = waveamd.transpose_load %1060 after %1045 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %1061 = wave.join %token_119, %token_121, %token_123 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1062 = wave.index_expr <"1024 + scale_lds_base"> ["scale_lds_base"](%1044) : (index) -> index
    %1063 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
    %1064 = wave.index_expr <"4*scale_lds_offset"> ["scale_lds_offset"](%1062) : (index) -> index
    %1065 = wave.ptr_add %1063, %1064 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
    %1066 = wave.index_expr <"512*floor(1/128*wi) + 8*Mod(wi, 64)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %1067 = wave.ptr_add %1065, %1066 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value_124, %token_125 = waveamd.transpose_load %1067 after %1045 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %1068 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
    %1069 = wave.index_expr <"4*scale_lds_offset"> ["scale_lds_offset"](%1062) : (index) -> index
    %1070 = wave.ptr_add %1068, %1069 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
    %1071 = wave.index_expr <"2048 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %1072 = wave.ptr_add %1070, %1071 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value_126, %token_127 = waveamd.transpose_load %1072 after %1045 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %1073 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
    %1074 = wave.index_expr <"4*scale_lds_offset"> ["scale_lds_offset"](%1062) : (index) -> index
    %1075 = wave.ptr_add %1073, %1074 : !wave.ptr<#wave.shared, i8>, index -> !wave.ptr<#wave.shared, i8>
    %1076 = wave.index_expr <"2560 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
    %1077 = wave.ptr_add %1075, %1076 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
    %value_128, %token_129 = waveamd.transpose_load %1077 after %1045 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
    %1078 = wave.join %token_125, %token_127, %token_129 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1079 = wave.join %1061, %1078 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1080 = wave.binary addi %1027, %c2_i32 : i32, i32 -> i32
    %1081 = wave.assume %1080 as "x" [#wave.pred<"-2 + x >= 0">, #wave.pred<"-127 + x <= 0">] : i32
    %1082 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg47, %value_120, %arg7 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1083 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg48, %value_120, %arg8 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1084 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg49, %value_120, %arg9 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1085 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg50, %value_120, %arg10 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1086 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg47, %value_120, %arg15 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1087 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg48, %value_120, %arg16 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1088 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg49, %value_120, %arg17 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1089 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg50, %value_120, %arg18 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1090 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg47, %value_120, %arg23 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1091 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg48, %value_120, %arg24 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1092 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg49, %value_120, %arg25 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1093 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg50, %value_120, %arg26 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1094 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg47, %value_120, %arg31 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1095 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg48, %value_120, %arg32 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1096 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg49, %value_120, %arg33 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1097 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg50, %value_120, %arg34 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1098 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg55, %value_126, %1082 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1099 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg56, %value_126, %1083 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1100 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg57, %value_126, %1084 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1101 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg58, %value_126, %1085 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1102 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg55, %value_126, %1086 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1103 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg56, %value_126, %1087 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1104 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg57, %value_126, %1088 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1105 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg58, %value_126, %1089 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1106 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg55, %value_126, %1090 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1107 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg56, %value_126, %1091 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1108 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg57, %value_126, %1092 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1109 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg58, %value_126, %1093 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1110 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg55, %value_126, %1094 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1111 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg56, %value_126, %1095 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1112 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg57, %value_126, %1096 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1113 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg58, %value_126, %1097 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1114 = wave.index_expr <"2048*Mod(i, 2)"> ["i"](%1081) : (i32) -> index
    %1115 = wave.binary muli %1081, %c2_i32 : i32, i32 -> i32
    %1116 = wave.assume %1115 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
    %1117 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
    %1118 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i32>
    %1119 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
    %1120 = wave.binary shrui %3, %1119 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1121 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
    %1122 = wave.binary andi %1120, %1121 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1123 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
    %1124 = wave.binary andi %3, %1123 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1125 = wave.binary ori %1124, %1122 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1126 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
    %1127 = wave.cmpi eq %1125, %1126 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    %1128 = wave.where %1127 {
      %1267 = wave.index_expr <"16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1268 = wave.index_expr <"128*floor(1/128*wi_first)"> ["wi_first"](%1117) : (i32) -> index
      %1269 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1268, %1114) : (index, index) -> index
      %1270 = wave.ptr_add %1118, %1269 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1271 = wave.ptr_add %arg3, %1267 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1272 = waveamd.dma_load_lds %1271 -> %1270 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1273 = wave.index_expr <"16 + 16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1274 = wave.index_expr <"4 + 128*floor(1/128*wi_first)"> ["wi_first"](%1117) : (i32) -> index
      %1275 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1274, %1114) : (index, index) -> index
      %1276 = wave.ptr_add %1118, %1275 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1277 = wave.ptr_add %arg3, %1273 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1278 = waveamd.dma_load_lds %1277 -> %1276 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1279 = wave.index_expr <"32 + 16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1280 = wave.index_expr <"8 + 128*floor(1/128*wi_first)"> ["wi_first"](%1117) : (i32) -> index
      %1281 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1280, %1114) : (index, index) -> index
      %1282 = wave.ptr_add %1118, %1281 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1283 = wave.ptr_add %arg3, %1279 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1284 = waveamd.dma_load_lds %1283 -> %1282 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1285 = wave.index_expr <"48 + 16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1286 = wave.index_expr <"12 + 128*floor(1/128*wi_first)"> ["wi_first"](%1117) : (i32) -> index
      %1287 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1286, %1114) : (index, index) -> index
      %1288 = wave.ptr_add %1118, %1287 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1289 = wave.ptr_add %arg3, %1285 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1290 = waveamd.dma_load_lds %1289 -> %1288 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1291 = wave.join %1272, %1278, %1284, %1290 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      wave.yield %1291 : !wave.mem.token
    } : !wave.mask<64> -> !wave.mem.token
    %1129 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
    %1130 = wave.binary shrui %3, %1129 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1131 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
    %1132 = wave.binary shrui %1130, %1131 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1133 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
    %1134 = wave.binary andi %3, %1133 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1135 = wave.binary ori %1134, %1132 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1136 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
    %1137 = wave.cmpi eq %1135, %1136 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    %1138 = wave.where %1137 {
      %1267 = wave.index_expr <"16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1268 = wave.index_expr <"512 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1269 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1268, %1114) : (index, index) -> index
      %1270 = wave.ptr_add %1118, %1269 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1271 = wave.ptr_add %arg4, %1267 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1272 = waveamd.dma_load_lds %1271 -> %1270 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1273 = wave.index_expr <"16 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1274 = wave.index_expr <"516 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1275 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1274, %1114) : (index, index) -> index
      %1276 = wave.ptr_add %1118, %1275 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1277 = wave.ptr_add %arg4, %1273 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1278 = waveamd.dma_load_lds %1277 -> %1276 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1279 = wave.index_expr <"32 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1280 = wave.index_expr <"520 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1281 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1280, %1114) : (index, index) -> index
      %1282 = wave.ptr_add %1118, %1281 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1283 = wave.ptr_add %arg4, %1279 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1284 = waveamd.dma_load_lds %1283 -> %1282 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1285 = wave.index_expr <"48 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1286 = wave.index_expr <"524 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1287 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1286, %1114) : (index, index) -> index
      %1288 = wave.ptr_add %1118, %1287 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1289 = wave.ptr_add %arg4, %1285 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1290 = waveamd.dma_load_lds %1289 -> %1288 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1291 = wave.index_expr <"64 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1292 = wave.index_expr <"640 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1293 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1292, %1114) : (index, index) -> index
      %1294 = wave.ptr_add %1118, %1293 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1295 = wave.ptr_add %arg4, %1291 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1296 = waveamd.dma_load_lds %1295 -> %1294 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1297 = wave.index_expr <"80 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1298 = wave.index_expr <"644 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1299 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1298, %1114) : (index, index) -> index
      %1300 = wave.ptr_add %1118, %1299 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1301 = wave.ptr_add %arg4, %1297 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1302 = waveamd.dma_load_lds %1301 -> %1300 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1303 = wave.index_expr <"96 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1304 = wave.index_expr <"648 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1305 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1304, %1114) : (index, index) -> index
      %1306 = wave.ptr_add %1118, %1305 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1307 = wave.ptr_add %arg4, %1303 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1308 = waveamd.dma_load_lds %1307 -> %1306 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1309 = wave.index_expr <"112 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1117, %1116) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1310 = wave.index_expr <"652 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1117) : (i32) -> index
      %1311 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1310, %1114) : (index, index) -> index
      %1312 = wave.ptr_add %1118, %1311 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1313 = wave.ptr_add %arg4, %1309 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1314 = waveamd.dma_load_lds %1313 -> %1312 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1315 = wave.join %1272, %1278, %1284, %1290, %1296, %1302, %1308, %1314 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      wave.yield %1315 : !wave.mem.token
    } : !wave.mask<64> -> !wave.mem.token
    %1139 = wave.join %1128, %1138 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1140 = wave.binary muli %1081, %c2_i32 : i32, i32 -> i32
    %1141 = wave.binary addi %1140, %c1_i32 : i32, i32 -> i32
    %1142 = wave.assume %1141 as "x" [#wave.pred<"-1 + x >= 0">, #wave.pred<"-255 + x <= 0">] : i32
    %1143 = wave.index_expr <"1024 + scale_lds_base"> ["scale_lds_base"](%1114) : (index) -> index
    %1144 = wave.read_first %3 : !wave.simd<i32, 64> -> i32
    %1145 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i32>
    %1146 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
    %1147 = wave.binary shrui %3, %1146 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1148 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
    %1149 = wave.binary andi %1147, %1148 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1150 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
    %1151 = wave.binary andi %3, %1150 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1152 = wave.binary ori %1151, %1149 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1153 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
    %1154 = wave.cmpi eq %1152, %1153 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    %1155 = wave.where %1154 {
      %1267 = wave.index_expr <"16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1268 = wave.index_expr <"128*floor(1/128*wi_first)"> ["wi_first"](%1144) : (i32) -> index
      %1269 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1268, %1143) : (index, index) -> index
      %1270 = wave.ptr_add %1145, %1269 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1271 = wave.ptr_add %arg3, %1267 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1272 = waveamd.dma_load_lds %1271 -> %1270 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1273 = wave.index_expr <"16 + 16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1274 = wave.index_expr <"4 + 128*floor(1/128*wi_first)"> ["wi_first"](%1144) : (i32) -> index
      %1275 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1274, %1143) : (index, index) -> index
      %1276 = wave.ptr_add %1145, %1275 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1277 = wave.ptr_add %arg3, %1273 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1278 = waveamd.dma_load_lds %1277 -> %1276 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1279 = wave.index_expr <"32 + 16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1280 = wave.index_expr <"8 + 128*floor(1/128*wi_first)"> ["wi_first"](%1144) : (i32) -> index
      %1281 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1280, %1143) : (index, index) -> index
      %1282 = wave.ptr_add %1145, %1281 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1283 = wave.ptr_add %arg3, %1279 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1284 = waveamd.dma_load_lds %1283 -> %1282 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1285 = wave.index_expr <"48 + 16384*dma_scale_step + 256*wg_m + 64*floor(1/128*wi_first) + 4096*floor(1/8*Mod(wi, 64))"> ["wi", "wg_m", "wi_first", "dma_scale_step"](%3, %10, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1286 = wave.index_expr <"12 + 128*floor(1/128*wi_first)"> ["wi_first"](%1144) : (i32) -> index
      %1287 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1286, %1143) : (index, index) -> index
      %1288 = wave.ptr_add %1145, %1287 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1289 = wave.ptr_add %arg3, %1285 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1290 = waveamd.dma_load_lds %1289 -> %1288 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1291 = wave.join %1272, %1278, %1284, %1290 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      wave.yield %1291 : !wave.mem.token
    } : !wave.mask<64> -> !wave.mem.token
    %1156 = wave.splat %c6_i32 : i32 -> !wave.simd<i32, 64>
    %1157 = wave.binary shrui %3, %1156 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1158 = wave.splat %c1_i32 : i32 -> !wave.simd<i32, 64>
    %1159 = wave.binary shrui %1157, %1158 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1160 = wave.splat %c39_i32 : i32 -> !wave.simd<i32, 64>
    %1161 = wave.binary andi %3, %1160 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1162 = wave.binary ori %1161, %1159 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.simd<i32, 64>
    %1163 = wave.splat %c0_i32 : i32 -> !wave.simd<i32, 64>
    %1164 = wave.cmpi eq %1162, %1163 : !wave.simd<i32, 64>, !wave.simd<i32, 64> -> !wave.mask<64>
    %1165 = wave.where %1164 {
      %1267 = wave.index_expr <"16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1268 = wave.index_expr <"512 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1269 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1268, %1143) : (index, index) -> index
      %1270 = wave.ptr_add %1145, %1269 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1271 = wave.ptr_add %arg4, %1267 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1272 = waveamd.dma_load_lds %1271 -> %1270 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1273 = wave.index_expr <"16 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1274 = wave.index_expr <"516 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1275 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1274, %1143) : (index, index) -> index
      %1276 = wave.ptr_add %1145, %1275 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1277 = wave.ptr_add %arg4, %1273 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1278 = waveamd.dma_load_lds %1277 -> %1276 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1279 = wave.index_expr <"32 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1280 = wave.index_expr <"520 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1281 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1280, %1143) : (index, index) -> index
      %1282 = wave.ptr_add %1145, %1281 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1283 = wave.ptr_add %arg4, %1279 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1284 = waveamd.dma_load_lds %1283 -> %1282 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1285 = wave.index_expr <"48 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1286 = wave.index_expr <"524 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1287 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1286, %1143) : (index, index) -> index
      %1288 = wave.ptr_add %1145, %1287 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1289 = wave.ptr_add %arg4, %1285 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1290 = waveamd.dma_load_lds %1289 -> %1288 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1291 = wave.index_expr <"64 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1292 = wave.index_expr <"640 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1293 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1292, %1143) : (index, index) -> index
      %1294 = wave.ptr_add %1145, %1293 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1295 = wave.ptr_add %arg4, %1291 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1296 = waveamd.dma_load_lds %1295 -> %1294 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1297 = wave.index_expr <"80 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1298 = wave.index_expr <"644 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1299 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1298, %1143) : (index, index) -> index
      %1300 = wave.ptr_add %1145, %1299 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1301 = wave.ptr_add %arg4, %1297 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1302 = waveamd.dma_load_lds %1301 -> %1300 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1303 = wave.index_expr <"96 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1304 = wave.index_expr <"648 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1305 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1304, %1143) : (index, index) -> index
      %1306 = wave.ptr_add %1145, %1305 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1307 = wave.ptr_add %arg4, %1303 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1308 = waveamd.dma_load_lds %1307 -> %1306 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1309 = wave.index_expr <"112 + 16384*dma_scale_step + 256*wg_n + 4096*floor(1/8*Mod(wi, 64)) + 128*Mod(floor(1/64*wi_first), 2)"> ["wi", "wg_n", "wi_first", "dma_scale_step"](%3, %11, %1144, %1142) : (!wave.simd<i32, 64>, index, i32, i32) -> !wave.simd<index, 64>
      %1310 = wave.index_expr <"652 + 256*Mod(floor(1/64*wi_first), 2)"> ["wi_first"](%1144) : (i32) -> index
      %1311 = wave.index_expr <"scale_dma_buffer + scale_dma_dest"> ["scale_dma_dest", "scale_dma_buffer"](%1310, %1143) : (index, index) -> index
      %1312 = wave.ptr_add %1145, %1311 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
      %1313 = wave.ptr_add %arg4, %1309 : !wave.ptr<#wave.global, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.global, i8>, 64>
      %1314 = waveamd.dma_load_lds %1313 -> %1312 after %1079 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#wave.global, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
      %1315 = wave.join %1272, %1278, %1284, %1290, %1296, %1302, %1308, %1314 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
      wave.yield %1315 : !wave.mem.token
    } : !wave.mask<64> -> !wave.mem.token
    %1166 = wave.join %1155, %1165 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1167 = wave.join %1139, %1166 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1168 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg51, %value_122, %arg11 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1169 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg52, %value_122, %arg12 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1170 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg53, %value_122, %arg13 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1171 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg39, %value_118, %arg54, %value_122, %arg14 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1172 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg51, %value_122, %arg19 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1173 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg52, %value_122, %arg20 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1174 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg53, %value_122, %arg21 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1175 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg40, %value_118, %arg54, %value_122, %arg22 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1176 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg51, %value_122, %arg27 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1177 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg52, %value_122, %arg28 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1178 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg53, %value_122, %arg29 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1179 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg41, %value_118, %arg54, %value_122, %arg30 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1180 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg51, %value_122, %arg35 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1181 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg52, %value_122, %arg36 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1182 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg53, %value_122, %arg37 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1183 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg42, %value_118, %arg54, %value_122, %arg38 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1184 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg59, %value_128, %1168 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1185 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg60, %value_128, %1169 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1186 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg61, %value_128, %1170 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1187 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg43, %value_124, %arg62, %value_128, %1171 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1188 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg59, %value_128, %1172 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1189 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg60, %value_128, %1173 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1190 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg61, %value_128, %1174 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1191 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg44, %value_124, %arg62, %value_128, %1175 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1192 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg59, %value_128, %1176 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1193 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg60, %value_128, %1177 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1194 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg61, %value_128, %1178 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1195 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg45, %value_124, %arg62, %value_128, %1179 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1196 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg59, %value_128, %1180 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1197 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg60, %value_128, %1181 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1198 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg61, %value_128, %1182 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1199 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %arg46, %value_124, %arg62, %value_128, %1183 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
    %1200 = wave.ptr_add %36, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1201 = wave.ptr_add %38, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1202 = wave.ptr_add %40, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1203 = wave.ptr_add %42, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1204 = wave.ptr_add %44, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1205 = wave.ptr_add %46, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1206 = wave.ptr_add %48, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1207 = wave.ptr_add %50, %1043 : !wave.ptr<#wave.shared, i32>, index -> !wave.ptr<#wave.shared, i32>
    %1208 = waveamd.dma_load_lds %1032 -> %1200 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1209 = waveamd.dma_load_lds %1033 -> %1201 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1210 = waveamd.dma_load_lds %1034 -> %1202 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1211 = waveamd.dma_load_lds %1035 -> %1203 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1212 = waveamd.dma_load_lds %1036 -> %1204 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1213 = waveamd.dma_load_lds %1037 -> %1205 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1214 = waveamd.dma_load_lds %1038 -> %1206 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1215 = waveamd.dma_load_lds %1039 -> %1207 after %arg64 {bytes = 16 : i64} : (!wave.simd<!wave.ptr<#waveamd.buffer, i8>, 64>, !wave.ptr<#wave.shared, i32>, !wave.mem.token) -> !wave.mem.token
    %1216 = wave.join %1208, %1209, %1210, %1211, %1212, %1213, %1214, %1215 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    %1217 = wave.barrier %arg63 : (!wave.mem.token) -> !wave.mem.token
    %1218 = wave.ptr_add %52, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1219 = wave.ptr_add %54, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1220 = wave.ptr_add %56, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1221 = wave.ptr_add %58, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1222 = wave.ptr_add %60, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1223 = wave.ptr_add %62, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1224 = wave.ptr_add %64, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1225 = wave.ptr_add %66, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1226 = wave.ptr_add %68, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1227 = wave.ptr_add %70, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1228 = wave.ptr_add %72, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1229 = wave.ptr_add %74, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1230 = wave.ptr_add %76, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1231 = wave.ptr_add %78, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1232 = wave.ptr_add %80, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1233 = wave.ptr_add %82, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1234 = wave.ptr_add %84, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1235 = wave.ptr_add %86, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1236 = wave.ptr_add %88, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1237 = wave.ptr_add %90, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1238 = wave.ptr_add %92, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1239 = wave.ptr_add %94, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1240 = wave.ptr_add %96, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %1241 = wave.ptr_add %98, %1041 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, index -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
    %value_130, %token_131 = wave.load %1218 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1242 = waveamd.fragment_pack %value_130 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_132, %token_133 = wave.load %1219 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1243 = waveamd.fragment_pack %value_132 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_134, %token_135 = wave.load %1220 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1244 = waveamd.fragment_pack %value_134 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_136, %token_137 = wave.load %1221 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1245 = waveamd.fragment_pack %value_136 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_138, %token_139 = wave.load %1222 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1246 = waveamd.fragment_pack %value_138 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_140, %token_141 = wave.load %1223 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1247 = waveamd.fragment_pack %value_140 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_142, %token_143 = wave.load %1224 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1248 = waveamd.fragment_pack %value_142 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_144, %token_145 = wave.load %1225 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1249 = waveamd.fragment_pack %value_144 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
    %value_146, %token_147 = wave.load %1226 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1250 = waveamd.fragment_pack %value_146 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_148, %token_149 = wave.load %1227 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1251 = waveamd.fragment_pack %value_148 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_150, %token_151 = wave.load %1228 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1252 = waveamd.fragment_pack %value_150 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_152, %token_153 = wave.load %1229 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1253 = waveamd.fragment_pack %value_152 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_154, %token_155 = wave.load %1230 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1254 = waveamd.fragment_pack %value_154 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_156, %token_157 = wave.load %1231 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1255 = waveamd.fragment_pack %value_156 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_158, %token_159 = wave.load %1232 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1256 = waveamd.fragment_pack %value_158 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_160, %token_161 = wave.load %1233 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1257 = waveamd.fragment_pack %value_160 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_162, %token_163 = wave.load %1234 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1258 = waveamd.fragment_pack %value_162 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_164, %token_165 = wave.load %1235 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1259 = waveamd.fragment_pack %value_164 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_166, %token_167 = wave.load %1236 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1260 = waveamd.fragment_pack %value_166 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_168, %token_169 = wave.load %1237 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1261 = waveamd.fragment_pack %value_168 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_170, %token_171 = wave.load %1238 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1262 = waveamd.fragment_pack %value_170 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_172, %token_173 = wave.load %1239 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1263 = waveamd.fragment_pack %value_172 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_174, %token_175 = wave.load %1240 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1264 = waveamd.fragment_pack %value_174 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %value_176, %token_177 = wave.load %1241 after %1217 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
    %1265 = waveamd.fragment_pack %value_176 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
    %1266 = wave.join %token_131, %token_133, %token_135, %token_137, %token_139, %token_141, %token_143, %token_145, %token_147, %token_149, %token_151, %token_153, %token_155, %token_157, %token_159, %token_161, %token_163, %token_165, %token_167, %token_169, %token_171, %token_173, %token_175, %token_177 : !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
    scf.yield %1098, %1099, %1100, %1101, %1184, %1185, %1186, %1187, %1102, %1103, %1104, %1105, %1188, %1189, %1190, %1191, %1106, %1107, %1108, %1109, %1192, %1193, %1194, %1195, %1110, %1111, %1112, %1113, %1196, %1197, %1198, %1199, %1242, %1243, %1244, %1245, %1246, %1247, %1248, %1249, %1250, %1251, %1252, %1253, %1254, %1255, %1256, %1257, %1258, %1259, %1260, %1261, %1262, %1263, %1264, %1265, %1216, %1266, %arg66, %1167 : !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<2, f32, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<0, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.mem.token, !wave.mem.token, !wave.mem.token, !wave.mem.token
  }
  %288 = wave.barrier %287#58 : (!wave.mem.token) -> !wave.mem.token
  %289 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %290 = wave.index_expr <"512*floor(1/128*wi) + 8*Mod(wi, 64)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %291 = wave.ptr_add %289, %290 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_46, %token_47 = waveamd.transpose_load %291 after %288 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %292 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %293 = wave.index_expr <"2048 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %294 = wave.ptr_add %292, %293 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_48, %token_49 = waveamd.transpose_load %294 after %288 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %295 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %296 = wave.index_expr <"2560 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %297 = wave.ptr_add %295, %296 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_50, %token_51 = waveamd.transpose_load %297 after %288 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %298 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %299 = wave.ptr_add %298, %c4096_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %300 = wave.index_expr <"512*floor(1/128*wi) + 8*Mod(wi, 64)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %301 = wave.ptr_add %299, %300 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_52, %token_53 = waveamd.transpose_load %301 after %288 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %302 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %303 = wave.ptr_add %302, %c4096_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %304 = wave.index_expr <"2048 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %305 = wave.ptr_add %303, %304 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_54, %token_55 = waveamd.transpose_load %305 after %288 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %306 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %307 = wave.ptr_add %306, %c4096_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %308 = wave.index_expr <"2560 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %309 = wave.ptr_add %307, %308 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_56, %token_57 = waveamd.transpose_load %309 after %288 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %310 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#40, %value_48, %287#0 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %311 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#41, %value_48, %287#1 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %312 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#42, %value_48, %287#2 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %313 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#43, %value_48, %287#3 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %314 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#44, %value_50, %287#4 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %315 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#45, %value_50, %287#5 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %316 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#46, %value_50, %287#6 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %317 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#32, %value_46, %287#47, %value_50, %287#7 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %318 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#40, %value_48, %287#8 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %319 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#41, %value_48, %287#9 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %320 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#42, %value_48, %287#10 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %321 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#43, %value_48, %287#11 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %322 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#44, %value_50, %287#12 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %323 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#45, %value_50, %287#13 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %324 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#46, %value_50, %287#14 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %325 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#33, %value_46, %287#47, %value_50, %287#15 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %326 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#40, %value_48, %287#16 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %327 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#41, %value_48, %287#17 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %328 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#42, %value_48, %287#18 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %329 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#43, %value_48, %287#19 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %330 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#44, %value_50, %287#20 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %331 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#45, %value_50, %287#21 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %332 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#46, %value_50, %287#22 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %333 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#34, %value_46, %287#47, %value_50, %287#23 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %334 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#40, %value_48, %287#24 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %335 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#41, %value_48, %287#25 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %336 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#42, %value_48, %287#26 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %337 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#43, %value_48, %287#27 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %338 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#44, %value_50, %287#28 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %339 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#45, %value_50, %287#29 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %340 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#46, %value_50, %287#30 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %341 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#35, %value_46, %287#47, %value_50, %287#31 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %342 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#48, %value_54, %310 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %343 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#49, %value_54, %311 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %344 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#50, %value_54, %312 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %345 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#51, %value_54, %313 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %346 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#52, %value_56, %314 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %347 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#53, %value_56, %315 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %348 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#54, %value_56, %316 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %349 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#36, %value_52, %287#55, %value_56, %317 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %350 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#48, %value_54, %318 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %351 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#49, %value_54, %319 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %352 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#50, %value_54, %320 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %353 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#51, %value_54, %321 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %354 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#52, %value_56, %322 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %355 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#53, %value_56, %323 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %356 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#54, %value_56, %324 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %357 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#37, %value_52, %287#55, %value_56, %325 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %358 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#48, %value_54, %326 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %359 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#49, %value_54, %327 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %360 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#50, %value_54, %328 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %361 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#51, %value_54, %329 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %362 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#52, %value_56, %330 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %363 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#53, %value_56, %331 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %364 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#54, %value_56, %332 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %365 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#38, %value_52, %287#55, %value_56, %333 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %366 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#48, %value_54, %334 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %367 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#49, %value_54, %335 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %368 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#50, %value_54, %336 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %369 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#51, %value_54, %337 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %370 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#52, %value_56, %338 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %371 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#53, %value_56, %339 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %372 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#54, %value_56, %340 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %373 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %287#39, %value_52, %287#55, %value_56, %341 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %374 = wave.barrier %287#56 : (!wave.mem.token) -> !wave.mem.token
  %375 = wave.ptr_add %52, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %376 = wave.ptr_add %54, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %377 = wave.ptr_add %56, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %378 = wave.ptr_add %58, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %379 = wave.ptr_add %60, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %380 = wave.ptr_add %62, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %381 = wave.ptr_add %64, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %382 = wave.ptr_add %66, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %383 = wave.ptr_add %68, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %384 = wave.ptr_add %70, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %385 = wave.ptr_add %72, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %386 = wave.ptr_add %74, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %387 = wave.ptr_add %76, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %388 = wave.ptr_add %78, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %389 = wave.ptr_add %80, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %390 = wave.ptr_add %82, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %391 = wave.ptr_add %84, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %392 = wave.ptr_add %86, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %393 = wave.ptr_add %88, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %394 = wave.ptr_add %90, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %395 = wave.ptr_add %92, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %396 = wave.ptr_add %94, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %397 = wave.ptr_add %96, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %398 = wave.ptr_add %98, %c16384_i32 : !wave.simd<!wave.ptr<#wave.shared, i32>, 64>, i32 -> !wave.simd<!wave.ptr<#wave.shared, i32>, 64>
  %value_58, %token_59 = wave.load %375 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %399 = waveamd.fragment_pack %value_58 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_60, %token_61 = wave.load %376 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %400 = waveamd.fragment_pack %value_60 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_62, %token_63 = wave.load %377 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %401 = waveamd.fragment_pack %value_62 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_64, %token_65 = wave.load %378 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %402 = waveamd.fragment_pack %value_64 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_66, %token_67 = wave.load %379 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %403 = waveamd.fragment_pack %value_66 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_68, %token_69 = wave.load %380 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %404 = waveamd.fragment_pack %value_68 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_70, %token_71 = wave.load %381 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %405 = waveamd.fragment_pack %value_70 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_72, %token_73 = wave.load %382 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %406 = waveamd.fragment_pack %value_72 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<0, i8, 16, 16, 64, 4>
  %value_74, %token_75 = wave.load %383 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %407 = waveamd.fragment_pack %value_74 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_76, %token_77 = wave.load %384 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %408 = waveamd.fragment_pack %value_76 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_78, %token_79 = wave.load %385 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %409 = waveamd.fragment_pack %value_78 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_80, %token_81 = wave.load %386 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %410 = waveamd.fragment_pack %value_80 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_82, %token_83 = wave.load %387 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %411 = waveamd.fragment_pack %value_82 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_84, %token_85 = wave.load %388 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %412 = waveamd.fragment_pack %value_84 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_86, %token_87 = wave.load %389 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %413 = waveamd.fragment_pack %value_86 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_88, %token_89 = wave.load %390 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %414 = waveamd.fragment_pack %value_88 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_90, %token_91 = wave.load %391 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %415 = waveamd.fragment_pack %value_90 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_92, %token_93 = wave.load %392 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %416 = waveamd.fragment_pack %value_92 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_94, %token_95 = wave.load %393 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %417 = waveamd.fragment_pack %value_94 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_96, %token_97 = wave.load %394 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %418 = waveamd.fragment_pack %value_96 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_98, %token_99 = wave.load %395 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %419 = waveamd.fragment_pack %value_98 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_100, %token_101 = wave.load %396 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %420 = waveamd.fragment_pack %value_100 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_102, %token_103 = wave.load %397 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %421 = waveamd.fragment_pack %value_102 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %value_104, %token_105 = wave.load %398 after %374 : (!wave.simd<!wave.ptr<#wave.shared, i32>, 64>, !wave.mem.token) -> (!wave.simd<vector<4xi32>, 64>, !wave.mem.token)
  %422 = waveamd.fragment_pack %value_104 : !wave.simd<vector<4xi32>, 64> -> !waveamd.fragment<1, i8, 16, 16, 64, 4>
  %423 = wave.barrier %287#59 : (!wave.mem.token) -> !wave.mem.token
  %424 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %425 = wave.ptr_add %424, %c8192_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %426 = wave.index_expr <"512*floor(1/128*wi) + 8*Mod(wi, 64)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %427 = wave.ptr_add %425, %426 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_106, %token_107 = waveamd.transpose_load %427 after %423 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %428 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %429 = wave.ptr_add %428, %c8192_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %430 = wave.index_expr <"2048 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %431 = wave.ptr_add %429, %430 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_108, %token_109 = waveamd.transpose_load %431 after %423 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %432 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %433 = wave.ptr_add %432, %c8192_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %434 = wave.index_expr <"2560 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %435 = wave.ptr_add %433, %434 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_110, %token_111 = waveamd.transpose_load %435 after %423 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %436 = wave.join %token_107, %token_109, %token_111 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %437 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %438 = wave.ptr_add %437, %c12288_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %439 = wave.index_expr <"512*floor(1/128*wi) + 8*Mod(wi, 64)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %440 = wave.ptr_add %438, %439 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_112, %token_113 = waveamd.transpose_load %440 after %423 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %441 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %442 = wave.ptr_add %441, %c12288_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %443 = wave.index_expr <"2048 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %444 = wave.ptr_add %442, %443 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_114, %token_115 = waveamd.transpose_load %444 after %423 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %445 = wave.lds_base {offset = 131072 : i64} : !wave.ptr<#wave.shared, i8>
  %446 = wave.ptr_add %445, %c12288_i32 : !wave.ptr<#wave.shared, i8>, i32 -> !wave.ptr<#wave.shared, i8>
  %447 = wave.index_expr <"2560 + 8*Mod(wi, 64) + 1024*Mod(floor(1/64*wi), 2)"> ["wi"](%3) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %448 = wave.ptr_add %446, %447 : !wave.ptr<#wave.shared, i8>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#wave.shared, i8>, 64>
  %value_116, %token_117 = waveamd.transpose_load %448 after %423 : (!wave.simd<!wave.ptr<#wave.shared, i8>, 64>, !wave.mem.token) -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
  %449 = wave.join %token_113, %token_115, %token_117 : !wave.mem.token, !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %450 = wave.join %436, %449 : !wave.mem.token, !wave.mem.token -> !wave.mem.token
  %451 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %407, %value_108, %342 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %452 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %408, %value_108, %343 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %453 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %409, %value_108, %344 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %454 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %410, %value_108, %345 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %455 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %407, %value_108, %350 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %456 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %408, %value_108, %351 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %457 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %409, %value_108, %352 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %458 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %410, %value_108, %353 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %459 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %407, %value_108, %358 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %460 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %408, %value_108, %359 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %461 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %409, %value_108, %360 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %462 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %410, %value_108, %361 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %463 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %407, %value_108, %366 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %464 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %408, %value_108, %367 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %465 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %409, %value_108, %368 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %466 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %410, %value_108, %369 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %467 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %415, %value_114, %451 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %468 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %416, %value_114, %452 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %469 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %417, %value_114, %453 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %470 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %418, %value_114, %454 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %471 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %415, %value_114, %455 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %472 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %416, %value_114, %456 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %473 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %417, %value_114, %457 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %474 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %418, %value_114, %458 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %475 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %415, %value_114, %459 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %476 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %416, %value_114, %460 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %477 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %417, %value_114, %461 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %478 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %418, %value_114, %462 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %479 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %415, %value_114, %463 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %480 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %416, %value_114, %464 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %481 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %417, %value_114, %465 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %482 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %418, %value_114, %466 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  wave.wait %450 : !wave.mem.token
  %483 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %484 = wave.assume %483 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %485 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%484) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %486 = wave.assume %485 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %487 = wave.ptr_add %16, %486 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %488 = waveamd.fragment_unpack %467 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %489 = wave.extract %488[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %490 = wave.cast fpconvert %489 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %491 = wave.extract %488[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %492 = wave.cast fpconvert %491 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %493 = wave.extract %488[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %494 = wave.cast fpconvert %493 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %495 = wave.extract %488[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %496 = wave.cast fpconvert %495 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %497 = wave.pack %490, %492, %494, %496 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %498 = wave.store %497 -> %487 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %499 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %500 = wave.assume %499 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %501 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%500) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %502 = wave.assume %501 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %503 = wave.ptr_add %99, %502 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %504 = waveamd.fragment_unpack %468 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %505 = wave.extract %504[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %506 = wave.cast fpconvert %505 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %507 = wave.extract %504[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %508 = wave.cast fpconvert %507 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %509 = wave.extract %504[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %510 = wave.cast fpconvert %509 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %511 = wave.extract %504[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %512 = wave.cast fpconvert %511 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %513 = wave.pack %506, %508, %510, %512 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %514 = wave.store %513 -> %503 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %515 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %516 = wave.assume %515 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %517 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%516) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %518 = wave.assume %517 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %519 = wave.ptr_add %100, %518 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %520 = waveamd.fragment_unpack %469 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %521 = wave.extract %520[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %522 = wave.cast fpconvert %521 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %523 = wave.extract %520[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %524 = wave.cast fpconvert %523 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %525 = wave.extract %520[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %526 = wave.cast fpconvert %525 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %527 = wave.extract %520[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %528 = wave.cast fpconvert %527 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %529 = wave.pack %522, %524, %526, %528 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %530 = wave.store %529 -> %519 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %531 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %532 = wave.assume %531 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %533 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%532) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %534 = wave.assume %533 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %535 = wave.ptr_add %101, %534 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %536 = waveamd.fragment_unpack %470 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %537 = wave.extract %536[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %538 = wave.cast fpconvert %537 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %539 = wave.extract %536[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %540 = wave.cast fpconvert %539 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %541 = wave.extract %536[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %542 = wave.cast fpconvert %541 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %543 = wave.extract %536[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %544 = wave.cast fpconvert %543 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %545 = wave.pack %538, %540, %542, %544 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %546 = wave.store %545 -> %535 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %547 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %548 = wave.assume %547 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %549 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%548) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %550 = wave.assume %549 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %551 = wave.ptr_add %106, %550 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %552 = waveamd.fragment_unpack %471 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %553 = wave.extract %552[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %554 = wave.cast fpconvert %553 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %555 = wave.extract %552[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %556 = wave.cast fpconvert %555 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %557 = wave.extract %552[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %558 = wave.cast fpconvert %557 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %559 = wave.extract %552[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %560 = wave.cast fpconvert %559 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %561 = wave.pack %554, %556, %558, %560 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %562 = wave.store %561 -> %551 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %563 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %564 = wave.assume %563 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %565 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%564) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %566 = wave.assume %565 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %567 = wave.ptr_add %107, %566 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %568 = waveamd.fragment_unpack %472 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %569 = wave.extract %568[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %570 = wave.cast fpconvert %569 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %571 = wave.extract %568[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %572 = wave.cast fpconvert %571 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %573 = wave.extract %568[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %574 = wave.cast fpconvert %573 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %575 = wave.extract %568[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %576 = wave.cast fpconvert %575 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %577 = wave.pack %570, %572, %574, %576 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %578 = wave.store %577 -> %567 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %579 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %580 = wave.assume %579 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %581 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%580) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %582 = wave.assume %581 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %583 = wave.ptr_add %108, %582 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %584 = waveamd.fragment_unpack %473 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %585 = wave.extract %584[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %586 = wave.cast fpconvert %585 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %587 = wave.extract %584[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %588 = wave.cast fpconvert %587 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %589 = wave.extract %584[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %590 = wave.cast fpconvert %589 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %591 = wave.extract %584[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %592 = wave.cast fpconvert %591 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %593 = wave.pack %586, %588, %590, %592 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %594 = wave.store %593 -> %583 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %595 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %596 = wave.assume %595 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %597 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%596) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %598 = wave.assume %597 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %599 = wave.ptr_add %109, %598 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %600 = waveamd.fragment_unpack %474 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %601 = wave.extract %600[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %602 = wave.cast fpconvert %601 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %603 = wave.extract %600[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %604 = wave.cast fpconvert %603 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %605 = wave.extract %600[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %606 = wave.cast fpconvert %605 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %607 = wave.extract %600[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %608 = wave.cast fpconvert %607 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %609 = wave.pack %602, %604, %606, %608 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %610 = wave.store %609 -> %599 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %611 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %612 = wave.assume %611 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %613 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%612) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %614 = wave.assume %613 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %615 = wave.ptr_add %114, %614 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %616 = waveamd.fragment_unpack %475 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %617 = wave.extract %616[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %618 = wave.cast fpconvert %617 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %619 = wave.extract %616[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %620 = wave.cast fpconvert %619 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %621 = wave.extract %616[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %622 = wave.cast fpconvert %621 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %623 = wave.extract %616[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %624 = wave.cast fpconvert %623 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %625 = wave.pack %618, %620, %622, %624 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %626 = wave.store %625 -> %615 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %627 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %628 = wave.assume %627 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %629 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%628) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %630 = wave.assume %629 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %631 = wave.ptr_add %115, %630 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %632 = waveamd.fragment_unpack %476 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %633 = wave.extract %632[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %634 = wave.cast fpconvert %633 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %635 = wave.extract %632[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %636 = wave.cast fpconvert %635 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %637 = wave.extract %632[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %638 = wave.cast fpconvert %637 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %639 = wave.extract %632[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %640 = wave.cast fpconvert %639 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %641 = wave.pack %634, %636, %638, %640 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %642 = wave.store %641 -> %631 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %643 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %644 = wave.assume %643 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %645 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%644) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %646 = wave.assume %645 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %647 = wave.ptr_add %116, %646 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %648 = waveamd.fragment_unpack %477 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %649 = wave.extract %648[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %650 = wave.cast fpconvert %649 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %651 = wave.extract %648[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %652 = wave.cast fpconvert %651 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %653 = wave.extract %648[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %654 = wave.cast fpconvert %653 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %655 = wave.extract %648[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %656 = wave.cast fpconvert %655 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %657 = wave.pack %650, %652, %654, %656 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %658 = wave.store %657 -> %647 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %659 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %660 = wave.assume %659 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %661 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%660) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %662 = wave.assume %661 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %663 = wave.ptr_add %117, %662 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %664 = waveamd.fragment_unpack %478 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %665 = wave.extract %664[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %666 = wave.cast fpconvert %665 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %667 = wave.extract %664[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %668 = wave.cast fpconvert %667 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %669 = wave.extract %664[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %670 = wave.cast fpconvert %669 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %671 = wave.extract %664[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %672 = wave.cast fpconvert %671 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %673 = wave.pack %666, %668, %670, %672 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %674 = wave.store %673 -> %663 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %675 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %676 = wave.assume %675 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %677 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%676) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %678 = wave.assume %677 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %679 = wave.ptr_add %122, %678 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %680 = waveamd.fragment_unpack %479 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %681 = wave.extract %680[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %682 = wave.cast fpconvert %681 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %683 = wave.extract %680[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %684 = wave.cast fpconvert %683 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %685 = wave.extract %680[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %686 = wave.cast fpconvert %685 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %687 = wave.extract %680[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %688 = wave.cast fpconvert %687 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %689 = wave.pack %682, %684, %686, %688 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %690 = wave.store %689 -> %679 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %691 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %692 = wave.assume %691 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %693 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%692) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %694 = wave.assume %693 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %695 = wave.ptr_add %123, %694 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %696 = waveamd.fragment_unpack %480 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %697 = wave.extract %696[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %698 = wave.cast fpconvert %697 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %699 = wave.extract %696[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %700 = wave.cast fpconvert %699 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %701 = wave.extract %696[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %702 = wave.cast fpconvert %701 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %703 = wave.extract %696[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %704 = wave.cast fpconvert %703 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %705 = wave.pack %698, %700, %702, %704 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %706 = wave.store %705 -> %695 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %707 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %708 = wave.assume %707 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %709 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%708) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %710 = wave.assume %709 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %711 = wave.ptr_add %124, %710 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %712 = waveamd.fragment_unpack %481 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %713 = wave.extract %712[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %714 = wave.cast fpconvert %713 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %715 = wave.extract %712[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %716 = wave.cast fpconvert %715 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %717 = wave.extract %712[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %718 = wave.cast fpconvert %717 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %719 = wave.extract %712[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %720 = wave.cast fpconvert %719 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %721 = wave.pack %714, %716, %718, %720 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %722 = wave.store %721 -> %711 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %723 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %724 = wave.assume %723 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %725 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%724) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %726 = wave.assume %725 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %727 = wave.ptr_add %125, %726 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %728 = waveamd.fragment_unpack %482 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %729 = wave.extract %728[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %730 = wave.cast fpconvert %729 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %731 = wave.extract %728[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %732 = wave.cast fpconvert %731 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %733 = wave.extract %728[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %734 = wave.cast fpconvert %733 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %735 = wave.extract %728[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %736 = wave.cast fpconvert %735 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %737 = wave.pack %730, %732, %734, %736 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %738 = wave.store %737 -> %727 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %739 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %411, %value_110, %346 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %740 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %412, %value_110, %347 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %741 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %413, %value_110, %348 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %742 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %399, %value_106, %414, %value_110, %349 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %743 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %411, %value_110, %354 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %744 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %412, %value_110, %355 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %745 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %413, %value_110, %356 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %746 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %400, %value_106, %414, %value_110, %357 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %747 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %411, %value_110, %362 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %748 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %412, %value_110, %363 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %749 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %413, %value_110, %364 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %750 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %401, %value_106, %414, %value_110, %365 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %751 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %411, %value_110, %370 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %752 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %412, %value_110, %371 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %753 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %413, %value_110, %372 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %754 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %402, %value_106, %414, %value_110, %373 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %755 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %419, %value_116, %739 : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %756 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %420, %value_116, %740 {scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %757 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %421, %value_116, %741 {scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %758 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %403, %value_112, %422, %value_116, %742 {scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %759 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %419, %value_116, %743 {scale_idx_a = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %760 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %420, %value_116, %744 {scale_idx_a = 1 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %761 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %421, %value_116, %745 {scale_idx_a = 1 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %762 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %404, %value_112, %422, %value_116, %746 {scale_idx_a = 1 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %763 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %419, %value_116, %747 {scale_idx_a = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %764 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %420, %value_116, %748 {scale_idx_a = 2 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %765 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %421, %value_116, %749 {scale_idx_a = 2 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %766 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %405, %value_112, %422, %value_116, %750 {scale_idx_a = 2 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %767 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %419, %value_116, %751 {scale_idx_a = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %768 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %420, %value_116, %752 {scale_idx_a = 3 : i64, scale_idx_b = 1 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %769 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %421, %value_116, %753 {scale_idx_a = 3 : i64, scale_idx_b = 2 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %770 = waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4" %406, %value_112, %422, %value_116, %754 {scale_idx_a = 3 : i64, scale_idx_b = 3 : i64} : !waveamd.fragment<0, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<1, i8, 16, 16, 64, 4>, !wave.simd<vector<8xi8>, 64>, !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !waveamd.fragment<2, f32, 16, 16, 64, 4>
  %771 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %772 = wave.assume %771 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %773 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%772) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %774 = wave.assume %773 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %775 = wave.ptr_add %102, %774 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %776 = waveamd.fragment_unpack %755 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %777 = wave.extract %776[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %778 = wave.cast fpconvert %777 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %779 = wave.extract %776[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %780 = wave.cast fpconvert %779 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %781 = wave.extract %776[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %782 = wave.cast fpconvert %781 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %783 = wave.extract %776[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %784 = wave.cast fpconvert %783 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %785 = wave.pack %778, %780, %782, %784 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %786 = wave.store %785 -> %775 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %787 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %788 = wave.assume %787 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %789 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%788) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %790 = wave.assume %789 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %791 = wave.ptr_add %103, %790 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %792 = waveamd.fragment_unpack %756 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %793 = wave.extract %792[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %794 = wave.cast fpconvert %793 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %795 = wave.extract %792[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %796 = wave.cast fpconvert %795 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %797 = wave.extract %792[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %798 = wave.cast fpconvert %797 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %799 = wave.extract %792[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %800 = wave.cast fpconvert %799 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %801 = wave.pack %794, %796, %798, %800 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %802 = wave.store %801 -> %791 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %803 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %804 = wave.assume %803 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %805 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%804) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %806 = wave.assume %805 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %807 = wave.ptr_add %104, %806 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %808 = waveamd.fragment_unpack %757 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %809 = wave.extract %808[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %810 = wave.cast fpconvert %809 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %811 = wave.extract %808[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %812 = wave.cast fpconvert %811 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %813 = wave.extract %808[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %814 = wave.cast fpconvert %813 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %815 = wave.extract %808[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %816 = wave.cast fpconvert %815 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %817 = wave.pack %810, %812, %814, %816 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %818 = wave.store %817 -> %807 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %819 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %820 = wave.assume %819 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %821 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%820) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %822 = wave.assume %821 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %823 = wave.ptr_add %105, %822 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %824 = waveamd.fragment_unpack %758 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %825 = wave.extract %824[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %826 = wave.cast fpconvert %825 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %827 = wave.extract %824[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %828 = wave.cast fpconvert %827 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %829 = wave.extract %824[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %830 = wave.cast fpconvert %829 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %831 = wave.extract %824[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %832 = wave.cast fpconvert %831 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %833 = wave.pack %826, %828, %830, %832 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %834 = wave.store %833 -> %823 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %835 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %836 = wave.assume %835 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %837 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%836) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %838 = wave.assume %837 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %839 = wave.ptr_add %110, %838 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %840 = waveamd.fragment_unpack %759 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %841 = wave.extract %840[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %842 = wave.cast fpconvert %841 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %843 = wave.extract %840[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %844 = wave.cast fpconvert %843 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %845 = wave.extract %840[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %846 = wave.cast fpconvert %845 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %847 = wave.extract %840[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %848 = wave.cast fpconvert %847 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %849 = wave.pack %842, %844, %846, %848 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %850 = wave.store %849 -> %839 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %851 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %852 = wave.assume %851 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %853 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%852) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %854 = wave.assume %853 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %855 = wave.ptr_add %111, %854 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %856 = waveamd.fragment_unpack %760 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %857 = wave.extract %856[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %858 = wave.cast fpconvert %857 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %859 = wave.extract %856[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %860 = wave.cast fpconvert %859 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %861 = wave.extract %856[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %862 = wave.cast fpconvert %861 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %863 = wave.extract %856[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %864 = wave.cast fpconvert %863 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %865 = wave.pack %858, %860, %862, %864 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %866 = wave.store %865 -> %855 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %867 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %868 = wave.assume %867 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %869 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%868) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %870 = wave.assume %869 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %871 = wave.ptr_add %112, %870 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %872 = waveamd.fragment_unpack %761 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %873 = wave.extract %872[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %874 = wave.cast fpconvert %873 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %875 = wave.extract %872[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %876 = wave.cast fpconvert %875 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %877 = wave.extract %872[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %878 = wave.cast fpconvert %877 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %879 = wave.extract %872[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %880 = wave.cast fpconvert %879 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %881 = wave.pack %874, %876, %878, %880 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %882 = wave.store %881 -> %871 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %883 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %884 = wave.assume %883 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %885 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%884) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %886 = wave.assume %885 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %887 = wave.ptr_add %113, %886 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %888 = waveamd.fragment_unpack %762 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %889 = wave.extract %888[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %890 = wave.cast fpconvert %889 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %891 = wave.extract %888[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %892 = wave.cast fpconvert %891 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %893 = wave.extract %888[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %894 = wave.cast fpconvert %893 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %895 = wave.extract %888[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %896 = wave.cast fpconvert %895 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %897 = wave.pack %890, %892, %894, %896 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %898 = wave.store %897 -> %887 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %899 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %900 = wave.assume %899 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %901 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%900) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %902 = wave.assume %901 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %903 = wave.ptr_add %118, %902 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %904 = waveamd.fragment_unpack %763 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %905 = wave.extract %904[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %906 = wave.cast fpconvert %905 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %907 = wave.extract %904[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %908 = wave.cast fpconvert %907 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %909 = wave.extract %904[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %910 = wave.cast fpconvert %909 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %911 = wave.extract %904[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %912 = wave.cast fpconvert %911 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %913 = wave.pack %906, %908, %910, %912 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %914 = wave.store %913 -> %903 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %915 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %916 = wave.assume %915 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %917 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%916) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %918 = wave.assume %917 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %919 = wave.ptr_add %119, %918 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %920 = waveamd.fragment_unpack %764 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %921 = wave.extract %920[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %922 = wave.cast fpconvert %921 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %923 = wave.extract %920[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %924 = wave.cast fpconvert %923 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %925 = wave.extract %920[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %926 = wave.cast fpconvert %925 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %927 = wave.extract %920[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %928 = wave.cast fpconvert %927 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %929 = wave.pack %922, %924, %926, %928 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %930 = wave.store %929 -> %919 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %931 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %932 = wave.assume %931 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %933 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%932) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %934 = wave.assume %933 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %935 = wave.ptr_add %120, %934 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %936 = waveamd.fragment_unpack %765 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %937 = wave.extract %936[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %938 = wave.cast fpconvert %937 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %939 = wave.extract %936[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %940 = wave.cast fpconvert %939 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %941 = wave.extract %936[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %942 = wave.cast fpconvert %941 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %943 = wave.extract %936[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %944 = wave.cast fpconvert %943 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %945 = wave.pack %938, %940, %942, %944 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %946 = wave.store %945 -> %935 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %947 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %948 = wave.assume %947 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %949 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%948) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %950 = wave.assume %949 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %951 = wave.ptr_add %121, %950 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %952 = waveamd.fragment_unpack %766 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %953 = wave.extract %952[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %954 = wave.cast fpconvert %953 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %955 = wave.extract %952[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %956 = wave.cast fpconvert %955 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %957 = wave.extract %952[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %958 = wave.cast fpconvert %957 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %959 = wave.extract %952[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %960 = wave.cast fpconvert %959 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %961 = wave.pack %954, %956, %958, %960 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %962 = wave.store %961 -> %951 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %963 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %964 = wave.assume %963 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %965 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%964) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %966 = wave.assume %965 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %967 = wave.ptr_add %126, %966 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %968 = waveamd.fragment_unpack %767 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %969 = wave.extract %968[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %970 = wave.cast fpconvert %969 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %971 = wave.extract %968[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %972 = wave.cast fpconvert %971 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %973 = wave.extract %968[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %974 = wave.cast fpconvert %973 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %975 = wave.extract %968[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %976 = wave.cast fpconvert %975 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %977 = wave.pack %970, %972, %974, %976 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %978 = wave.store %977 -> %967 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %979 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %980 = wave.assume %979 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %981 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%980) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %982 = wave.assume %981 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %983 = wave.ptr_add %127, %982 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %984 = waveamd.fragment_unpack %768 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %985 = wave.extract %984[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %986 = wave.cast fpconvert %985 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %987 = wave.extract %984[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %988 = wave.cast fpconvert %987 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %989 = wave.extract %984[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %990 = wave.cast fpconvert %989 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %991 = wave.extract %984[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %992 = wave.cast fpconvert %991 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %993 = wave.pack %986, %988, %990, %992 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %994 = wave.store %993 -> %983 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %995 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %996 = wave.assume %995 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %997 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%996) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %998 = wave.assume %997 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %999 = wave.ptr_add %128, %998 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %1000 = waveamd.fragment_unpack %769 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %1001 = wave.extract %1000[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1002 = wave.cast fpconvert %1001 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1003 = wave.extract %1000[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1004 = wave.cast fpconvert %1003 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1005 = wave.extract %1000[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1006 = wave.cast fpconvert %1005 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1007 = wave.extract %1000[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1008 = wave.cast fpconvert %1007 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1009 = wave.pack %1002, %1004, %1006, %1008 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %1010 = wave.store %1009 -> %999 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  %1011 = wave.workitem_id 0 : !wave.simd<i32, 64>
  %1012 = wave.assume %1011 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-511 + x <= 0">] : !wave.simd<i32, 64>
  %1013 = wave.index_expr <"4*Mod(__wave_dsl_frag_wi, 64)"> ["__wave_dsl_frag_wi"](%1012) : (!wave.simd<i32, 64>) -> !wave.simd<index, 64>
  %1014 = wave.assume %1013 as "x" [#wave.pred<"x >= 0">, #wave.pred<"-252 + x <= 0">] : !wave.simd<index, 64>
  %1015 = wave.ptr_add %129, %1014 : !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>, !wave.simd<index, 64> -> !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>
  %1016 = waveamd.fragment_unpack %770 : !waveamd.fragment<2, f32, 16, 16, 64, 4> -> !wave.simd<vector<4xf32>, 64>
  %1017 = wave.extract %1016[0] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1018 = wave.cast fpconvert %1017 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1019 = wave.extract %1016[1] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1020 = wave.cast fpconvert %1019 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1021 = wave.extract %1016[2] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1022 = wave.cast fpconvert %1021 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1023 = wave.extract %1016[3] : !wave.simd<vector<4xf32>, 64> -> !wave.simd<f32, 64>
  %1024 = wave.cast fpconvert %1023 : !wave.simd<f32, 64> -> !wave.simd<f16, 64>
  %1025 = wave.pack %1018, %1020, %1022, %1024 : !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64>, !wave.simd<f16, 64> -> !wave.simd<vector<4xf16>, 64>
  %1026 = wave.store %1025 -> %1015 : (!wave.simd<vector<4xf16>, 64>, !wave.simd<!wave.ptr<#waveamd.buffer, f16>, 64>) -> !wave.mem.token
  return
}
}
