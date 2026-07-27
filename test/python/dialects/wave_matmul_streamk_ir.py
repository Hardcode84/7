# RUN: %PYTHON %s | FileCheck %s

from collections import Counter

from mlir.dialects.wave_matmul import build_gfx950_f16_streamk_matmul_module


def operations(operation):
    for region in operation.regions:
        for block in region.blocks:
            for child in block.operations:
                yield child.operation
                yield from operations(child.operation)


def build(m: int, n: int, k: int, workers: int):
    return build_gfx950_f16_streamk_matmul_module(
        m,
        n,
        k,
        workers=workers,
        cta_swizzle_xcds=1,
        cta_group_m=1,
        skip_specialize=True,
    )


def operation_counts(module) -> Counter[str]:
    return Counter(operation.name for operation in operations(module.operation))


def expect_error(
    expected: str,
    m: int,
    n: int,
    k: int,
    workers: int,
) -> None:
    try:
        build(m, n, k, workers)
    except ValueError as exc:
        assert expected in str(exc), str(exc)
        return
    raise AssertionError(f"expected error containing {expected!r}")


aligned = build(512, 512, 256, 2)
aligned_ops = list(operations(aligned.operation))
aligned_counts = Counter(operation.name for operation in aligned_ops)
assert aligned_counts["waveamd.make_buffer"] == 3
assert aligned_counts["waveamd.global_atomic_add_acq_rel"] == 0
aligned_kernel = next(
    operation for operation in aligned_ops if operation.name == "func.func"
)
aligned_args = aligned_kernel.regions[0].blocks[0].arguments
assert not list(aligned_args[3].uses)
assert not list(aligned_args[4].uses)

split = build(512, 512, 256, 3)
split_ops = list(operations(split.operation))
split_counts = Counter(operation.name for operation in split_ops)
assert split_counts["waveamd.make_buffer"] == 4
atomics = [
    operation
    for operation in split_ops
    if operation.name == "waveamd.global_atomic_add_acq_rel"
]
assert [atomic.operands[2].owner.name for atomic in atomics] == [
    "wave.barrier",
    "wave.load",
    "wave.barrier",
]
assert atomics[0].operands[2].owner.operation.operands[0].owner.name == "wave.join"
assert atomics[1].operands[2].owner.operation.operands[1].owner.name == "wave.barrier"
assert atomics[2].operands[2].owner.operation.operands[0].owner.name == "wave.join"

outer_loop = next(
    operation
    for operation in split_ops
    if operation.name == "scf.for"
    and len(operation.operands) == 4
    and str(operation.operands[-1].type) == "!wave.mem.token"
)
outer_block = outer_loop.regions[0].blocks[0]
assert str(outer_block.arguments[-1].type) == "!wave.mem.token"
assert list(outer_block.arguments[-1].uses)
assert outer_block.operations[-1].operation.name == "scf.yield"
assert outer_block.operations[-1].operation.operands[0].owner.name == "wave.where"

larger_split = build(768, 512, 512, 5)
assert operation_counts(larger_split) == split_counts

expect_error("BM * wave_m_tiles", 272, 512, 256, 3)
expect_error("BN * wave_n_tiles", 512, 272, 256, 3)
expect_error("wave_k_tiles", 512, 512, 96, 3)
expect_error("workers must be", 512, 512, 256, 0)
expect_error("work index exceeds", 256 * 32768, 256 * 32768, 256, 1)
expect_error("Stream-K A buffer", 256 * 32768, 256, 256, 3)
expect_error("Stream-K B buffer", 256, 256 * 32768, 256, 3)
expect_error("Stream-K C buffer", 65536, 65536, 64, 3)

print("streamk-ir ok")

# CHECK: streamk-ir ok
