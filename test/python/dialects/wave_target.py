# RUN: %PYTHON %s | FileCheck %s

from mlir._mlir_libs import _waveDialectsNanobind as _wave_ext
from mlir.dialects.wave_target import (
    GFX1250_MATRIX_INTRINSIC,
    MemoryStaging,
    get_matmul_target_profile,
    select_matrix_intrinsic,
)


def assert_rejected(chip, requested):
    try:
        select_matrix_intrinsic(chip, requested)
    except ValueError as exc:
        print("rejected", chip, requested, str(exc))
        return
    raise AssertionError(f"expected {chip}/{requested} rejection")


profile = get_matmul_target_profile("gfx1250")
assert profile is not None
capabilities = _wave_ext.get_target_capabilities("gfx1250")
assert capabilities is not None
assert capabilities.chip == "gfx1250"
assert profile.wave_size == 32
assert profile.local_memory_bytes == 320 * 1024
assert profile.addressable_local_memory_bytes == 320 * 1024
assert profile.local_memory_bank_count == 32
assert profile.addressable_agprs == 0
assert profile.max_waves_per_eu == 16
assert profile.static_lds_limit_bytes == 320 * 1024
assert profile.staging is MemoryStaging.BASE
assert str(profile.accumulator_bank) == "vgpr"

for input_type, kind in (
    ("f16", "wmma.f32.16x16x32.f16"),
    ("bf16", "wmma.f32.16x16x32.bf16"),
):
    mma = profile.mma(input_type)
    assert mma.kind_name == kind
    assert mma.k_tile == 32
    assert mma.operand_dwords == 8
    assert mma.accumulator_dwords == 8
    assert mma.lane_k_elements == 16
    assert str(mma.operand_bank) == "vgpr"
    assert str(mma.accumulator_bank) == "vgpr"
    print("mma", input_type, mma.kind_name, mma.operand_dwords)

assert select_matrix_intrinsic("gfx1250", "auto") == GFX1250_MATRIX_INTRINSIC
assert get_matmul_target_profile("gfx1251") is None
assert get_matmul_target_profile("gfx1100") is None
assert _wave_ext.get_mma_capabilities("gfx1251", profile.f16_mma.kind) is not None
assert _wave_ext.get_mma_capabilities("gfx1200", profile.f16_mma.kind) is None
assert _wave_ext.get_target_capabilities("gfx1250", ":") is None
assert _wave_ext.get_mma_capabilities("gfx1250", profile.f16_mma.kind, ":") is None
assert select_matrix_intrinsic("gfx1100", "auto") == "wmma"
assert select_matrix_intrinsic("gfx950", "auto") == "mfma_gfx950"
assert select_matrix_intrinsic("gfx942", "auto") == "mfma"

assert_rejected("gfx1250", "wmma")
assert_rejected("gfx1251", "auto")
assert_rejected("gfx1200", "auto")
assert_rejected("gfx1100", GFX1250_MATRIX_INTRINSIC)

print(
    "profile",
    profile.chip,
    profile.wave_size,
    profile.local_memory_bytes,
    profile.local_memory_bank_count,
    profile.staging.value,
    str(profile.accumulator_bank),
)

# CHECK: mma f16 wmma.f32.16x16x32.f16 8
# CHECK: mma bf16 wmma.f32.16x16x32.bf16 8
# CHECK: rejected gfx1250 wmma matrix intrinsic wmma is incompatible with gfx1250
# CHECK: rejected gfx1251 auto no matrix intrinsic profile for target gfx1251
# CHECK: rejected gfx1200 auto no matrix intrinsic profile for target gfx1200
# CHECK: rejected gfx1100 wmma_gfx1250 matrix intrinsic wmma_gfx1250 is incompatible with gfx1100
# CHECK: profile gfx1250 32 327680 32 base vgpr
