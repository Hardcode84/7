# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects.wave_matmul import (
    streamk_counter_elements,
    streamk_owner_for_iteration,
    streamk_scratch_elements,
    streamk_tile_contributors,
    streamk_worker_interval,
    streamk_worker_segments,
)


def check_partition(tile_count: int, k_iterations: int, workers: int) -> None:
    total = tile_count * k_iterations
    covered: list[int] = []
    partials: dict[int, list[tuple[int, int, int]]] = {}
    for worker in range(workers):
        begin, end = streamk_worker_interval(total, workers, worker)
        covered.extend(range(begin, end))
        segments = streamk_worker_segments(tile_count, k_iterations, workers, worker)
        assert sum(segment.k_end - segment.k_begin for segment in segments) == (
            end - begin
        )
        assert sum(not segment.is_whole for segment in segments) <= 2
        for segment in segments:
            if segment.is_whole:
                assert (segment.k_begin, segment.k_end) == (0, k_iterations)
                continue
            assert segment.scratch_slot in (0, 1)
            partials.setdefault(segment.tile, []).append(
                (worker, segment.k_begin, segment.k_end)
            )

    assert covered == list(range(total))
    for iteration in range(total):
        owner = streamk_owner_for_iteration(total, workers, iteration)
        begin, end = streamk_worker_interval(total, workers, owner)
        assert begin <= iteration < end

    for tile, contributions in partials.items():
        first, last = streamk_tile_contributors(tile, k_iterations, total, workers)
        assert [worker for worker, _, _ in contributions] == list(
            range(first, last + 1)
        )
        cursor = 0
        for _, begin, end in contributions:
            assert begin == cursor
            cursor = end
        assert cursor == k_iterations


for tile_count in range(1, 10):
    for k_iterations in range(1, 12):
        total = tile_count * k_iterations
        for workers in range(1, total + 1):
            check_partition(tile_count, k_iterations, workers)

assert streamk_scratch_elements(3) == 3 * 2 * 256 * 256
assert streamk_counter_elements(512, 768) == 6

print("streamk-partition ok")

# CHECK: streamk-partition ok
