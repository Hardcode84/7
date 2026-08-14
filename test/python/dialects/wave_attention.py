# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_attention import (
    build_flash_attention_f32_module,
    compute_flash_attention_f32_reference,
    generate_flash_attention_f32_inputs,
)

q0, k0, v0 = generate_flash_attention_f32_inputs(16, 16, 16, random_seed=11, seq_n=32)
q1, k1, v1 = generate_flash_attention_f32_inputs(16, 16, 16, random_seed=11, seq_n=32)
q2, _, _ = generate_flash_attention_f32_inputs(16, 16, 16, random_seed=12, seq_n=32)
assert (q0, k0, v0) == (q1, k1, v1)
assert q0 != q2
ref = compute_flash_attention_f32_reference(16, 16, 16, random_seed=11, seq_n=32)
print("fa-ref", len(q0), len(k0), len(v0), len(ref))
assert len(compute_flash_attention_f32_reference(16, 16, 32, seq_n=16)) == 512
assert len(compute_flash_attention_f32_reference(16, 16, 64, seq_n=16)) == 1024
assert len(compute_flash_attention_f32_reference(8, 8, 32, seq_n=8)) == 256

module = build_flash_attention_f32_module(
    block_m=16,
    block_n=16,
    head_dim=16,
    random_seed=11,
    seq_n=32,
)
module_text = str(module)
assert module_text.count("waveamd.mma") == 4
assert module_text.count("waveamd.make_buffer") == 4
assert module_text.count("wave.assume ") == 1
assert "iter_args" in module_text
unrolled = build_flash_attention_f32_module(
    block_m=16,
    block_n=16,
    head_dim=16,
    random_seed=11,
    seq_n=32,
    tile_loop_unroll=2,
)
assert "wavemeta.unrolled_for" in str(unrolled)
mfma = build_flash_attention_f32_module(
    block_m=16,
    block_n=16,
    head_dim=32,
    seq_n=16,
    matrix_intrinsic="mfma_gfx950",
)
assert "mfma.f32.16x16x32.f16" in str(mfma)
single = build_flash_attention_f32_module(
    block_m=16,
    block_n=16,
    head_dim=32,
    random_seed=11,
    seq_n=16,
)
single_text = str(single)
assert single_text.count("waveamd.mma") == 4
assert single_text.count("wave.cast") > 0
small = build_flash_attention_f32_module(
    block_m=8,
    block_n=8,
    head_dim=32,
    random_seed=11,
    seq_n=8,
)
small_text = str(small)
assert small_text.count("waveamd.mma") == 4
assert small_text.count("waveamd.make_buffer") == 4
small_multi = build_flash_attention_f32_module(
    block_m=8,
    block_n=8,
    head_dim=32,
    random_seed=11,
    seq_n=16,
)
small_multi_text = str(small_multi)
assert small_multi_text.count("waveamd.mma") == 8
assert "iter_args" in small_multi_text
print("fa-mfma ok")
print("fa-unrolled ok")
print("fa-buffer ok")
print("fa-multi mma", module_text.count("waveamd.mma"), "iter_args ok")
print(
    "fa-single mma",
    single_text.count("waveamd.mma"),
    "casts",
    single_text.count("wave.cast"),
)
print("fa-small mma", small_text.count("waveamd.mma"))
print("fa-small-multi mma", small_multi_text.count("waveamd.mma"), "iter_args ok")
print(module_text)

# CHECK: fa-ref 256 512 512 256
# CHECK: fa-mfma ok
# CHECK: fa-unrolled ok
# CHECK: fa-buffer ok
# CHECK: fa-multi mma 4 iter_args ok
# CHECK: fa-single mma 4 casts {{[1-9][0-9]*}}
# CHECK: fa-small mma 4
# CHECK: fa-small-multi mma 8 iter_args ok
# CHECK: func.func @flash_attention_f32
# CHECK: waveamd.make_buffer
# CHECK: waveamd.mma
# CHECK: waveamd.fragment_unpack
# CHECK: wave.fmul
# CHECK: wave.fadd
# CHECK: wave.fmax
# CHECK: wave.fsub
# CHECK: wave.fexp2
# CHECK: wave.frcp
