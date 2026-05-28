# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_attention import (
    build_flash_attention_f32_module,
    compute_flash_attention_f32_reference,
    generate_flash_attention_f32_inputs,
)

q0, k0, v0 = generate_flash_attention_f32_inputs(4, 8, 8, random_seed=11, seq_n=16)
q1, k1, v1 = generate_flash_attention_f32_inputs(4, 8, 8, random_seed=11, seq_n=16)
q2, _, _ = generate_flash_attention_f32_inputs(4, 8, 8, random_seed=12, seq_n=16)
assert (q0, k0, v0) == (q1, k1, v1)
assert q0 != q2
ref = compute_flash_attention_f32_reference(4, 8, 8, random_seed=11, seq_n=16)
print("fa-ref", len(q0), len(k0), len(v0), len(ref))
assert len(compute_flash_attention_f32_reference(1, 4, 64, seq_n=8)) == 64
assert len(compute_flash_attention_f32_reference(1, 2, 128, seq_n=4)) == 128

module = build_flash_attention_f32_module(
    block_m=4,
    block_n=8,
    head_dim=8,
    random_seed=11,
    seq_n=16,
)
str(build_flash_attention_f32_module(block_m=1, block_n=1, head_dim=64, seq_n=1))
str(build_flash_attention_f32_module(block_m=1, block_n=1, head_dim=128, seq_n=1))
print("fa-multiwave ok")
print(module)

# CHECK: fa-ref 32 128 128 32
# CHECK: fa-multiwave ok
# CHECK-LABEL: func.func @flash_attention_f32
# CHECK: wave.fmul
# CHECK: wave.fadd
# CHECK: wave.fmax
# CHECK: wave.fsub
# CHECK: wave.fexp2
# CHECK: wave.frcp
