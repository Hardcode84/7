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

module = build_flash_attention_f32_module(
    block_m=16,
    block_n=16,
    head_dim=16,
    random_seed=11,
    seq_n=32,
)
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
print("fa-mfma ok")
print(
    "fa-single mma",
    single_text.count("waveamd.mma"),
    "casts",
    single_text.count("wave.cast"),
)
print(module)

# CHECK: fa-ref 256 512 512 256
# CHECK: fa-mfma ok
# CHECK: fa-single mma 4 casts {{[1-9][0-9]*}}
# CHECK: func.func @flash_attention_f32
# CHECK: waveamd.mma
# CHECK: waveamd.fragment_unpack
# CHECK: wave.fmul
# CHECK: wave.fadd
# CHECK: wave.fmax
# CHECK: wave.fsub
# CHECK: wave.fexp2
# CHECK: scf.for
# CHECK-SAME: iter_args
# CHECK: wave.frcp
