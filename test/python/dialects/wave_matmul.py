# RUN: %PYTHON %s | FileCheck %s

import mlir.dialects.wave_matmul as wm
from mlir.dialects import wave_dsl as dsl
from mlir.dialects.wave_matmul import (
    build_wmma_f16_matmul_module,
    compute_wmma_f16_matmul_reference_buffer,
    generate_mxfp4_packed_matmul_inputs,
    generate_mxfp4_scale_inputs,
    generate_wmma_f16_matmul_inputs,
    shuffle_mxfp4_b_aiter,
    shuffle_mxfp4_scales_aiter,
)


def assert_raises(error_type, message, callback):
    try:
        callback()
    except error_type as exc:
        assert str(exc) == message
        return
    raise AssertionError(f"expected {error_type.__name__}: {message}")


def operation_blocks(operation):
    for region in operation.regions:
        for block in region.blocks:
            yield block
            for child in block.operations:
                yield from operation_blocks(child)


def normalized_mma_pairs(mmas):
    a_ids = {}
    b_ids = {}
    pairs = []
    for mma in mmas:
        a, b = mma.operands[:2]
        if a not in a_ids:
            a_ids[a] = len(a_ids)
        if b not in b_ids:
            b_ids[b] = len(b_ids)
        pairs.append((a_ids[a], b_ids[b]))
    return pairs


def serpentine_mma_pairs(a_count, b_count):
    pairs = []
    for j in range(b_count):
        rows = range(a_count) if j % 2 == 0 else reversed(range(a_count))
        pairs.extend((i, j) for i in rows)
    return pairs


def normalized_mma_groups(module, group_size):
    groups = []
    for block in operation_blocks(module.operation):
        mmas = [op for op in block.operations if op.name == "waveamd.mma"]
        if not mmas:
            continue
        assert len(mmas) % group_size == 0
        for begin in range(0, len(mmas), group_size):
            groups.append(normalized_mma_pairs(mmas[begin : begin + group_size]))
    return groups


def assert_serpentine_subpanel(module, a_count, b_count):
    serpentine = serpentine_mma_pairs(a_count, b_count)
    row_major = [(i, j) for i in range(a_count) for j in range(b_count)]
    groups = normalized_mma_groups(module, a_count * b_count)

    range_boundary = b_count
    assert groups == [
        row_major,
        serpentine,
        row_major,
        serpentine,
        row_major[:range_boundary] + serpentine[range_boundary:],
        serpentine,
    ]


def assert_output_store_cache(module, kind, count):
    assert str(module).count(f"#waveamd.store_cache<{kind}>") == count


def assert_external_assumption_count(module, count):
    # Workitem definitions are raw; their launch range and input-specific
    # contracts are explicit wave.assume operations.
    actual = str(module).count("wave.assume ")
    assert actual == count, (actual, count)


def cached_output_stores(module, kind):
    marker = f"#waveamd.store_cache<{kind}>"
    return [
        str(op)
        for block in operation_blocks(module.operation)
        for op in block.operations
        if op.name == "wave.store" and marker in str(op)
    ]


def build_dense_mfma_output(output_layout="automatic"):
    return build_wmma_f16_matmul_module(
        M=32,
        N=16,
        K=64,
        BM=1,
        BN=1,
        wave_m_tiles=2,
        wave_n_tiles=1,
        wave_k_tiles=2,
        use_buffer=True,
        matrix_intrinsic="mfma_gfx950",
        output_type="f16",
        output_layout=output_layout,
        output_store_cache="cs",
        skip_specialize=True,
        include_host=False,
    )


subpanel_schedule = wm.PhasedDmaSchedule(
    issue_group_size=1,
    initial_delay_cycles=0,
    loop_delay_cycles=0,
    loop_overlap_cycles=0,
    delayed_waves=0,
    fetch_alignment=4,
    fetch_phase=0,
    subpanel_pipeline=True,
)
spatial_schedule = wm.PhasedDmaSchedule(
    issue_group_size=7,
    initial_delay_cycles=0,
    loop_delay_cycles=0,
    loop_overlap_cycles=0,
    delayed_waves=0,
    fetch_alignment=32,
    fetch_phase=12,
    spatial_subpanel_pipeline=True,
)


def build_spatial_subpanel(**overrides):
    args = {
        "M": 256,
        "N": 256,
        "K": 256,
        "BM": 2,
        "BN": 4,
        "wave_m_tiles": 8,
        "wave_n_tiles": 4,
        "wave_k_tiles": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "output_type": "f16",
        "phased_dma_schedule": spatial_schedule,
        "include_host": False,
    }
    args.update(overrides)
    return build_wmma_f16_matmul_module(**args)


def build_aiter_mxfp4(**overrides):
    args = {
        "M": 32,
        "N": 128,
        "K": 256,
        "BM": 1,
        "BN": 4,
        "wave_m_tiles": 2,
        "wave_n_tiles": 2,
        "wave_k_tiles": 2,
        "use_buffer": True,
        "use_dma_lds": True,
        "matrix_intrinsic": "mfma_gfx950",
        "input_type": "mxfp4",
        "output_type": "f16",
        "mxfp4_input_layout": "aiter",
        "include_host": False,
    }
    args.update(overrides)
    return build_wmma_f16_matmul_module(**args)


assert_raises(
    ValueError,
    "DMA subpanel pipelines are mutually exclusive",
    lambda: wm.PhasedDmaSchedule(
        issue_group_size=1,
        initial_delay_cycles=0,
        loop_delay_cycles=0,
        loop_overlap_cycles=0,
        delayed_waves=0,
        fetch_alignment=4,
        fetch_phase=0,
        subpanel_pipeline=True,
        spatial_subpanel_pipeline=True,
    ),
)
assert_raises(
    ValueError,
    "DMA subpanel pipeline requires two K32 phases",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=32,
        wave_k_tiles=1,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        phased_dma_schedule=subpanel_schedule,
    ),
)
assert_raises(
    ValueError,
    "DMA subpanel pipeline does not support packed MXFP4",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=256,
        wave_k_tiles=2,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        input_type="mxfp4",
        phased_dma_schedule=subpanel_schedule,
    ),
)
assert_raises(
    ValueError,
    "DMA subpanel pipeline requires at least two M tiles per wave",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=128,
        wave_m_tiles=1,
        wave_n_tiles=1,
        wave_k_tiles=2,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        phased_dma_schedule=subpanel_schedule,
    ),
)
assert_raises(
    ValueError,
    "AITER input layout does not support coalesced output",
    lambda: build_aiter_mxfp4(coalesced_mfma_output=True),
)
for invalid_layout in ("tile-packed", "column-major"):
    assert_raises(
        ValueError,
        "AITER input layout requires row-major output",
        lambda invalid_layout=invalid_layout: build_aiter_mxfp4(
            output_layout=invalid_layout
        ),
    )
assert_raises(
    ValueError,
    "output_layout must be one of automatic, tile-packed, row-major, "
    "column-major; got invalid",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=32,
        output_layout="invalid",
        include_host=False,
    ),
)
assert_raises(
    ValueError,
    "AITER input layout requires the DMA scale path",
    lambda: build_aiter_mxfp4(mxfp4_scale_path="regs"),
)
assert_raises(
    ValueError,
    "buffer range needs 4294967296 bytes; 32-bit buffer range holds at most "
    "4294967295",
    lambda: build_aiter_mxfp4(M=33554432),
)
assert_raises(
    ValueError,
    "streamed AITER K phases require uniform A DMA ownership",
    lambda: build_aiter_mxfp4(K=1024, wave_k_tiles=4),
)
assert_raises(
    ValueError,
    "AITER wave M/N tile pairs must be powers of two",
    lambda: build_aiter_mxfp4(
        M=192,
        N=128,
        K=1024,
        BM=2,
        BN=2,
        wave_m_tiles=6,
        wave_k_tiles=4,
    ),
)
assert_raises(
    ValueError,
    "streamed AITER K phases require at least two panels",
    lambda: build_aiter_mxfp4(
        M=64,
        K=512,
        wave_m_tiles=4,
        wave_k_tiles=4,
    ),
)
aiter_packed_scale_module = build_aiter_mxfp4(K=512)
assert str(aiter_packed_scale_module) == str(
    build_aiter_mxfp4(K=512, output_layout="row-major")
)
aiter_packed_scale_ops = [
    op
    for block in operation_blocks(aiter_packed_scale_module.operation)
    for op in block.operations
]
aiter_scale_dmas = [
    op
    for op in aiter_packed_scale_ops
    if op.name == "waveamd.dma_load_lds" and "zero_fill_inactive" not in str(op)
]
assert len(aiter_scale_dmas) == 6
assert all(
    "#waveamd.buffer" in str(op) and "bytes = 16" in str(op) and len(op.operands) == 3
    for op in aiter_scale_dmas
)
aiter_scale_loads = [
    str(op)
    for op in aiter_packed_scale_ops
    if op.name == "wave.load" and "vector<4xi8>" in str(op)
]
assert len(aiter_scale_loads) == 6
assert all("#wave.shared" in op and " after " in op for op in aiter_scale_loads)
assert any(
    op.name == "wave.barrier" and len(op.operands) == 3 for op in aiter_packed_scale_ops
)
assert "wave.lds_size = 24576 : i64" in str(aiter_packed_scale_module)
aiter_output_stores = [
    op
    for op in aiter_packed_scale_ops
    if op.name == "wave.store" and "!wave.ptr<#waveamd.buffer, f16>" in str(op)
]
assert len(aiter_output_stores) == 16
scale_read_token = aiter_output_stores[0].operands[-1]
assert all(store.operands[-1] == scale_read_token for store in aiter_output_stores)
scale_read_join = scale_read_token.owner
assert scale_read_join.name == "wave.join"
assert all(
    operand.owner.name == "wave.load" for operand in scale_read_join.operation.operands
)
assert "512*floor(1/16*Mod(__wave_dsl_dense_store_wi, 64))" in str(
    aiter_packed_scale_module
)
aiter_pipeline_module = build_aiter_mxfp4(
    M=128,
    N=256,
    K=2048,
    BM=1,
    BN=4,
    wave_m_tiles=8,
    wave_n_tiles=4,
    wave_k_tiles=4,
)
aiter_pipeline_loops = [
    op
    for block in operation_blocks(aiter_pipeline_module.operation)
    for op in block.operations
    if op.name == "scf.for" and len(op.results) == 42
]
assert len(aiter_pipeline_loops) == 1
assert any(
    op.name == "wave.barrier" and len(op.operands) == 8
    for block in operation_blocks(aiter_pipeline_loops[0])
    for op in block.operations
)
aiter_partial_scale_module = build_aiter_mxfp4(
    M=64,
    N=64,
    K=1536,
    BM=2,
    BN=2,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=6,
)
aiter_partial_scale_text = str(aiter_partial_scale_module)
assert "16*Mod(Mod(__wave_dsl_aiter_stage_wi, 64), 48)" in aiter_partial_scale_text
assert '<"512*floor(1/64*__wave_dsl_aiter_stage_wi_first)">' in aiter_partial_scale_text
assert (
    '<"256*(1 + 2*floor(1/64*__wave_dsl_aiter_stage_wi_first))">'
    in aiter_partial_scale_text
)
aiter_split_owner_text = str(
    build_aiter_mxfp4(
        M=128,
        N=128,
        K=512,
        BM=2,
        BN=2,
    )
)
assert "512*floor(1/128*__wave_dsl_aiter_stage_wi)" in aiter_split_owner_text
assert "512*Mod(floor(1/64*__wave_dsl_aiter_stage_wi), 2)" in aiter_split_owner_text
print("mxfp4-aiter-packed-scale-dma ok")
print("subpanel-validation ok")

assert_raises(
    ValueError,
    "DMA spatial subpanel pipeline requires eight waves",
    lambda: build_spatial_subpanel(N=128, BN=2),
)
assert_raises(
    ValueError,
    "DMA spatial subpanel pipeline requires two K32 phases",
    lambda: build_spatial_subpanel(wave_k_tiles=1),
)
assert_raises(
    ValueError,
    "DMA spatial subpanel pipeline does not support packed MXFP4",
    lambda: build_spatial_subpanel(input_type="mxfp4"),
)
assert_raises(
    ValueError,
    "DMA spatial subpanel pipeline does not support coalesced output",
    lambda: build_spatial_subpanel(
        BM=2,
        BN=2,
        wave_n_tiles=8,
        coalesced_mfma_output=True,
    ),
)
assert_raises(
    ValueError,
    "DMA spatial subpanel pipeline requires even wave tiles",
    lambda: build_spatial_subpanel(M=224, wave_m_tiles=7),
)
assert_raises(
    ValueError,
    "DMA spatial subpanel pipeline requires four DMA slots per operand",
    lambda: build_spatial_subpanel(M=512, N=128, BM=4, BN=2),
)
module_spatial_subpanel = build_spatial_subpanel()
spatial_text = str(module_spatial_subpanel)
spatial_loops = [
    op
    for block in operation_blocks(module_spatial_subpanel.operation)
    for op in block.operations
    if op.name == "scf.for"
]
assert len(spatial_loops) == 1
spatial_loop_ops = [
    op for block in operation_blocks(spatial_loops[0]) for op in block.operations
]
assert sum(op.name == "waveamd.mma" for op in spatial_loop_ops) == 128
assert sum(op.name == "waveamd.dma_load_lds" for op in spatial_loop_ops) == 16
assert sum(op.name == "wave.barrier" for op in spatial_loop_ops) == 16
assert spatial_text.count("scf.if ") == 2
print("spatial-subpanel ok")

for k, expected in (
    (64, (0, 64, 8, 3, 0)),
    (128, (0, 128, 16, 7, 0)),
):
    short_module = build_spatial_subpanel(K=k)
    names = [
        op.name
        for block in operation_blocks(short_module.operation)
        for op in block.operations
    ]
    assert (
        tuple(
            names.count(name)
            for name in (
                "scf.for",
                "waveamd.mma",
                "waveamd.dma_load_lds",
                "wave.barrier",
                "scf.if",
            )
        )
        == expected
    )
print("spatial-subpanel-short-k ok")

module_regular_subpanel = build_wmma_f16_matmul_module(
    M=64,
    N=64,
    K=128,
    BM=2,
    BN=2,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    phased_dma_schedule=subpanel_schedule,
    include_host=False,
)
assert "waveamd.dma_load_lds" in str(module_regular_subpanel)
assert_external_assumption_count(module_regular_subpanel, 3)
print("regular-subpanel ok")

module_cta_remap = build_wmma_f16_matmul_module(
    M=128,
    N=128,
    K=16,
    cta_swizzle_xcds=8,
    cta_group_m=4,
    skip_specialize=True,
    include_host=False,
)
cta_remap_text = str(module_cta_remap)
assert_external_assumption_count(module_cta_remap, 4)
assert cta_remap_text.count('["wg_m_raw", "wg_n_raw"]') == 2
dsl.specialize_wavemeta(module_cta_remap)
print("cta-remap-symbolic-ranges ok")

module_rectangular_subpanel = build_wmma_f16_matmul_module(
    M=32,
    N=48,
    K=128,
    BM=1,
    BN=1,
    wave_m_tiles=2,
    wave_n_tiles=3,
    wave_k_tiles=2,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    phased_dma_schedule=subpanel_schedule,
    include_host=False,
)
assert_serpentine_subpanel(module_rectangular_subpanel, 2, 3)
print("rectangular-subpanel-serpentine ok")

for output_store_cache in ("wb", "cg", "cs", "wt"):
    module_fragment_cache = build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=32,
        output_store_cache=output_store_cache,
        include_host=False,
    )
    assert_output_store_cache(module_fragment_cache, output_store_cache, 8)
module_default_cache = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=32,
    include_host=False,
)
assert "#waveamd.store_cache<" not in str(module_default_cache)
assert_raises(
    ValueError,
    "output_store_cache must be 'none' or 'wb' or 'cg' or 'cs' or 'wt'; got invalid",
    lambda: build_wmma_f16_matmul_module(
        M=16,
        N=16,
        K=32,
        output_store_cache="invalid",
        include_host=False,
    ),
)
module_f16_cache = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=32,
    output_type="f16",
    output_store_cache="cg",
    include_host=False,
)
assert_output_store_cache(module_f16_cache, "cg", 8)
assert_external_assumption_count(module_f16_cache, 4)
print("output-store-cache ok")

dense_automatic = build_dense_mfma_output()
dense_row_major = build_dense_mfma_output("row-major")
dense_column_major = build_dense_mfma_output("column-major")
assert str(dense_automatic) == str(dense_row_major)
row_major_stores = cached_output_stores(dense_row_major, "cs")
column_major_stores = cached_output_stores(dense_column_major, "cs")
assert len(row_major_stores) == 8
assert all("!wave.simd<f16, 64>" in store for store in row_major_stores)
assert len(column_major_stores) == 2
assert all("!wave.simd<vector<4xf16>, 64>" in store for store in column_major_stores)
row_major_text = str(dense_row_major)
column_major_text = str(dense_column_major)
assert (
    'wave.index_expr <"64*floor(1/16*Mod(__wave_dsl_dense_store_wi, 64)) '
    '+ Mod(Mod(__wave_dsl_dense_store_wi, 64), 16)">' in row_major_text
)
assert (
    'wave.index_expr <"4*floor(1/16*Mod(__wave_dsl_dense_store_wi, 64)) '
    '+ 32*Mod(Mod(__wave_dsl_dense_store_wi, 64), 16)">' in column_major_text
)
print("dense-output-layouts ok")

module_symbolic_mma_index = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=1,
    matrix_intrinsic="mfma",
    skip_specialize=True,
    include_host=False,
)
symbolic_mma_index_text = str(module_symbolic_mma_index)
assert "__wave_dsl_mma_i" in symbolic_mma_index_text
assert "__wave_dsl_mma_j" in symbolic_mma_index_text
assert "__wave_dsl_mma_wave_n" in symbolic_mma_index_text
dsl.specialize_wavemeta(module_symbolic_mma_index)
assert "__wave_dsl_mma_" not in str(module_symbolic_mma_index)
print("symbolic-mma-index ok")

assert_raises(
    ValueError,
    "coalesced MFMA output requires gfx950 f16 MFMA",
    lambda: build_wmma_f16_matmul_module(
        M=128,
        N=128,
        K=32,
        wave_m_tiles=8,
        wave_n_tiles=8,
        output_type="f16",
        coalesced_mfma_output=True,
    ),
)
for invalid_layout in ("tile-packed", "row-major"):
    assert_raises(
        ValueError,
        "coalesced MFMA output requires column-major output",
        lambda invalid_layout=invalid_layout: build_wmma_f16_matmul_module(
            M=256,
            N=256,
            K=64,
            BM=2,
            BN=2,
            wave_m_tiles=8,
            wave_n_tiles=8,
            wave_k_tiles=2,
            use_buffer=True,
            use_dma_lds=True,
            matrix_intrinsic="mfma_gfx950",
            output_type="f16",
            output_layout=invalid_layout,
            coalesced_mfma_output=True,
            include_host=False,
        ),
    )
module_coalesced = build_wmma_f16_matmul_module(
    M=256,
    N=256,
    K=64,
    BM=2,
    BN=2,
    wave_m_tiles=8,
    wave_n_tiles=8,
    wave_k_tiles=2,
    use_buffer=True,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    output_type="f16",
    output_store_cache="cs",
    coalesced_mfma_output=True,
    skip_specialize=True,
    include_host=False,
)
coalesced_symbolic_text = str(module_coalesced)
assert "__wave_dsl_mma_i" in coalesced_symbolic_text
assert "__wave_dsl_mma_j" in coalesced_symbolic_text
assert "__wave_dsl_mma_wave_m" in coalesced_symbolic_text
dsl.specialize_wavemeta(module_coalesced)
coalesced_text = str(module_coalesced)
assert "__wave_dsl_mma_" not in coalesced_text
assert_external_assumption_count(module_coalesced, 3)
assert coalesced_text.count("wave.pack") == 32
assert coalesced_text.count("!wave.simd<vector<8xf16>, 64>") >= 32
assert "!waveamd.fragment<0, f16, 16, 16, 64, 4>" in coalesced_text
assert "!waveamd.fragment<1, f16, 16, 16, 64, 4>" in coalesced_text
assert_output_store_cache(module_coalesced, "cs", 32)
print("coalesced-mfma-output ok")

module_lds_coalesced_cache = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=256,
    BM=1,
    BN=1,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    use_buffer=True,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
    output_type="f16",
    output_layout="tile-packed",
    output_store_cache="wt",
    include_host=False,
)
assert_output_store_cache(module_lds_coalesced_cache, "wt", 4)
assert_external_assumption_count(module_lds_coalesced_cache, 3)
print("lds-coalesced-output-store-cache ok")

module_symbolic_mxfp4_step = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=1024,
    BM=1,
    BN=1,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    use_buffer=True,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
    output_type="f16",
    skip_specialize=True,
    include_host=False,
)
symbolic_mxfp4_step_text = str(module_symbolic_mxfp4_step)
assert (
    'wave.index_expr <"2*__wave_dsl_mxfp4_step"> ["__wave_dsl_mxfp4_step"]'
    in symbolic_mxfp4_step_text
)
assert (
    'wave.index_expr <"1 + 2*__wave_dsl_mxfp4_step"> ["__wave_dsl_mxfp4_step"]'
    in symbolic_mxfp4_step_text
)
assert_external_assumption_count(module_symbolic_mxfp4_step, 3)
print("symbolic-mxfp4-step ok")

a0, b0 = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=7)
a1, b1 = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=7)
a2, _ = generate_wmma_f16_matmul_inputs(32, 32, 32, random_data=True, random_seed=8)
abf16, bbf16 = generate_wmma_f16_matmul_inputs(
    32, 32, 32, input_type="bf16", random_data=True, random_seed=7
)
assert a0 == a1 and b0 == b1
assert a0 != a2
assert len(abf16) == len(a0) and len(bbf16) == len(b0)
ref = compute_wmma_f16_matmul_reference_buffer(
    32,
    32,
    32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma",
)
print("random-ref", len(a0), len(b0), len(ref))
ref_row_major = compute_wmma_f16_matmul_reference_buffer(
    32,
    48,
    32,
    wave_m_tiles=2,
    wave_n_tiles=3,
    wave_k_tiles=2,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma",
    output_layout="row-major",
)
ref_column_major = compute_wmma_f16_matmul_reference_buffer(
    32,
    48,
    32,
    wave_m_tiles=2,
    wave_n_tiles=3,
    wave_k_tiles=2,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma",
    output_layout="column-major",
)
for m in range(32):
    for n in range(48):
        assert ref_row_major[m * 48 + n] == ref_column_major[n * 32 + m]
ref_automatic = compute_wmma_f16_matmul_reference_buffer(
    32,
    48,
    32,
    wave_m_tiles=2,
    wave_n_tiles=3,
    wave_k_tiles=2,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma",
)
assert ref_automatic == ref_row_major
print("output-layout-reference ok")
ref_bf16 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    32,
    matrix_intrinsic="mfma_gfx950",
    input_type="bf16",
)
print("bf16-ref", len(ref_bf16), ref_bf16[0])
mxfp4_scales = generate_mxfp4_scale_inputs(16, 16, 128)
print(
    "mxfp4-scales",
    len(mxfp4_scales[0]),
    len(mxfp4_scales[1]),
    mxfp4_scales[0][0],
    mxfp4_scales[1][-1],
)
ref_mxfp4 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    128,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print("mxfp4-ref", len(ref_mxfp4), ref_mxfp4[0], ref_mxfp4[-1])
mxfp4_a0, mxfp4_b0 = generate_mxfp4_packed_matmul_inputs(16, 16, 128, random_seed=7)
mxfp4_a1, mxfp4_b1 = generate_mxfp4_packed_matmul_inputs(16, 16, 128, random_seed=7)
mxfp4_a2, _ = generate_mxfp4_packed_matmul_inputs(16, 16, 128, random_seed=8)
assert mxfp4_a0 == mxfp4_a1 and mxfp4_b0 == mxfp4_b1
assert mxfp4_a0 != mxfp4_a2
print("mxfp4-packed-random", len(mxfp4_a0), len(mxfp4_b0), mxfp4_a0[0], mxfp4_b0[-1])
aiter_b_input = tuple(i % 251 for i in range(32 * 64))
aiter_b = shuffle_mxfp4_b_aiter(aiter_b_input, 32, 128)
for row in range(32):
    row_block, row_inner = divmod(row, 16)
    for k_byte in range(64):
        k_block, k_inner = divmod(k_byte, 32)
        half, byte = divmod(k_inner, 16)
        dst = ((((row_block * 2 + k_block) * 2 + half) * 16 + row_inner) * 16) + byte
        assert aiter_b[dst] == aiter_b_input[row * 64 + k_byte]
aiter_scale_input = tuple(i % 251 for i in range(257 * 16))
aiter_scales = shuffle_mxfp4_scales_aiter(aiter_scale_input, 257, 512)
mapped_scales = set()
for row in range(257):
    row_block, row_inner = divmod(row, 32)
    row_half, row_lane = divmod(row_inner, 16)
    for group in range(16):
        group_block, group_inner = divmod(group, 8)
        group_half, group_lane = divmod(group_inner, 4)
        dst = (
            (row_block * 2 + group_block) * 256
            + group_lane * 64
            + row_lane * 4
            + group_half * 2
            + row_half
        )
        mapped_scales.add(dst)
        assert aiter_scales[dst] == aiter_scale_input[group * 257 + row]
assert all(
    value == 0x7F for i, value in enumerate(aiter_scales) if i not in mapped_scales
)
print("mxfp4-aiter-shuffle", len(aiter_b), len(aiter_scales))
assert_raises(
    ValueError,
    "AITER B shuffle requires positive N/16 and K/64",
    lambda: shuffle_mxfp4_b_aiter((0,) * (16 * 32), 16, 65),
)
assert_raises(
    ValueError,
    "AITER scale shuffle requires positive rows and K/32",
    lambda: shuffle_mxfp4_scales_aiter((0,) * 16, 16, 33),
)

aiter_shared_cfg = wm._make_matmul_config(
    M=256,
    N=256,
    K=1024,
    BM=2,
    BN=2,
    wave_m_tiles=8,
    wave_n_tiles=8,
    wave_k_tiles=4,
    use_buffer=True,
    use_dma_lds=True,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
    output_type="f16",
    output_layout="row-major",
    mxfp4_scale_path="dma",
    mxfp4_input_layout="aiter",
    random_data=False,
    random_seed=0,
    cta_swizzle_xcds=1,
    cta_group_m=1,
)
assert wm._uses_cta_shared_aiter_mxfp4_scales(aiter_shared_cfg)
wave = dsl.sym("__wave_dsl_aiter_shared_test_wave")
for wave_id in range(4):
    for axis, expected_owner, expected_group in (
        ("m", wave_id // 2, wave_id % 2),
        ("n", wave_id % 2, wave_id // 2),
    ):
        owner, group = wm._aiter_mxfp4_scale_owner(aiter_shared_cfg, axis, wave)
        assert owner.subs({wave: wave_id}).eval({}) == expected_owner
        assert group.subs({wave: wave_id}).eval({}) == expected_group
print("mxfp4-aiter-shared-scale-owners ok")

ref_mxfp4_random = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    128,
    random_data=True,
    random_seed=7,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print(
    "mxfp4-random-ref", len(ref_mxfp4_random), ref_mxfp4_random[0], ref_mxfp4_random[-1]
)
ref_f32 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    512,
    random_data=True,
    random_seed=91,
    output_type="f32",
)
ref_f16 = compute_wmma_f16_matmul_reference_buffer(
    16,
    16,
    512,
    random_data=True,
    random_seed=91,
    output_type="f16",
)
assert ref_f32 != ref_f16
rounding_pair = next(
    pair for pair in zip(ref_f32, ref_f16, strict=True) if pair[0] != pair[1]
)
print("f16-ref-rounding", rounding_pair[0], rounding_pair[1])

module_mxfp4_random = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=128,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
    random_data=True,
    random_seed=7,
)
assert "memref.store" in str(module_mxfp4_random)
print("mxfp4-random-module ok")

module = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=32,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    matrix_intrinsic="mfma",
    enable_multi_wave_specialization=True,
)
print(module)

module_f16 = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=32,
    output_type="f16",
    output_layout="tile-packed",
)
print(module_f16)

module_bf16 = build_wmma_f16_matmul_module(
    M=16,
    N=16,
    K=32,
    matrix_intrinsic="mfma_gfx950",
    input_type="bf16",
)
print(module_bf16)

module_mxfp4 = build_wmma_f16_matmul_module(
    M=32,
    N=32,
    K=256,
    wave_m_tiles=2,
    wave_n_tiles=2,
    wave_k_tiles=2,
    matrix_intrinsic="mfma_gfx950",
    input_type="mxfp4",
)
print("mxfp4-module")
print(module_mxfp4)

module_dynamic_lds = build_wmma_f16_matmul_module(
    M=64,
    N=64,
    K=64,
    BM=4,
    BN=4,
    wave_k_tiles=2,
    matrix_intrinsic="mfma_gfx950",
)
print("dynamic-lds-module")
print(module_dynamic_lds)

static_cfg = wm._make_matmul_config(
    M=16,
    N=16,
    K=32,
    BM=1,
    BN=1,
    wave_m_tiles=1,
    wave_n_tiles=1,
    wave_k_tiles=1,
    use_buffer=False,
    use_dma_lds=False,
    matrix_intrinsic="wmma",
    input_type="f16",
    output_type="f32",
    output_layout="tile-packed",
    mxfp4_scale_path="dma",
    random_data=False,
    random_seed=0,
    cta_swizzle_xcds=1,
    cta_group_m=1,
)
static_bld = dsl.ModuleBuilder()
with static_bld:
    wm._declare_matmul_externals(static_bld, static_cfg)
    with static_bld.function(
        "static_matmul_kernel",
        wm._kernel_input_types(static_cfg, include_trip_count=False),
        kernel=True,
        lds_size=static_cfg.lds_bytes,
        workgroup_size=[static_cfg.threads_per_workgroup, 1, 1],
    ) as fb:
        wm._emit_kernel(fb, static_cfg)
    wm._attach_wavemeta_params(static_bld.module, static_cfg)
    dsl.specialize_wavemeta(static_bld.module)
static_text = str(static_bld.module)
static_signature = static_text.split("func.func @static_matmul_kernel", 1)[1].split(
    ")", 1
)[0]
assert "i32" not in static_signature
assert_external_assumption_count(static_bld.module, 3)
print(static_bld.module)

# CHECK: mxfp4-aiter-packed-scale-dma ok
# CHECK: subpanel-validation ok
# CHECK: spatial-subpanel ok
# CHECK: spatial-subpanel-short-k ok
# CHECK: regular-subpanel ok
# CHECK: cta-remap-symbolic-ranges ok
# CHECK: rectangular-subpanel-serpentine ok
# CHECK: output-store-cache ok
# CHECK: dense-output-layouts ok
# CHECK: symbolic-mma-index ok
# CHECK: coalesced-mfma-output ok
# CHECK: lds-coalesced-output-store-cache ok
# CHECK: symbolic-mxfp4-step ok
# CHECK: random-ref 1024 1024 1024
# CHECK: output-layout-reference ok
# CHECK: bf16-ref 256 32.0
# CHECK: mxfp4-scales 64 64 127 122
# CHECK: mxfp4-ref 256 42.5 21.25
# CHECK: mxfp4-packed-random 1024 1024 68 34
# CHECK: mxfp4-aiter-shuffle 2048 8192
# CHECK: mxfp4-aiter-shared-scale-owners ok
# CHECK: mxfp4-random-ref 256 92.703125 12.6484375
# CHECK: f16-ref-rounding -132.5625 -132.5
# CHECK: mxfp4-random-module ok
# CHECK-LABEL: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: wave.lds_size = 2048
# CHECK-SAME: waveamdmachine.enable_multi_wave_specialization
# CHECK-NOT: wavemeta.
# CHECK: %[[TRIP:.*]] = wave.assume %arg3 as "x" {{\[.*\]}} : i32
# CHECK: scf.for %{{.*}} = %{{.*}} to %[[TRIP]] step
# CHECK-COUNT-8: waveamd.mma "mfma.f32.16x16x16.f16"
# CHECK: wave.load
# CHECK-COUNT-4: waveamd.fragment_unpack
# CHECK: func.func private @printMemrefF16
# CHECK: func.func @wmma_f16_matmul_tiled(%{{.*}}!wave.ptr<#wave.global, f16>
# CHECK: waveamd.fragment_unpack
# CHECK-SAME: !waveamd.fragment<2, f32, 16, 16, 32, 8> -> !wave.simd<vector<8xf32>, 32>
# CHECK: wave.cast fpconvert
# CHECK-SAME: !wave.simd<f32, 32> -> !wave.simd<f16, 32>
# CHECK: wave.pack
# CHECK-SAME: -> !wave.simd<vector<8xf16>, 32>
# CHECK: func.func private @wave_memref_to_ptr_global_bf16
# CHECK: func.func @wmma_f16_matmul_tiled(%{{.*}}!wave.ptr<#wave.global, bf16>
# CHECK: waveamd.mma "mfma.f32.16x16x32.bf16"
# CHECK: mxfp4-module
# CHECK: func.func private @wave_memref_to_ptr_global_i8
# CHECK: func.func @wmma_f16_matmul_tiled
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: !wave.ptr<#wave.global, f32>
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK-SAME: i32
# CHECK: %{{.*}}, %{{.*}} = wave.load
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK: %{{.*}}, %{{.*}} = wave.load
# CHECK-SAME: !wave.ptr<#wave.global, i8>
# CHECK: wave.shared_memory_base
# CHECK-SAME: !wave.ptr<#wave.shared, i8>
# CHECK: wave.load
# CHECK-SAME: -> (!wave.simd<vector<16xi8>, 64>, !wave.mem.token)
# CHECK: wave.store
# CHECK-SAME: !wave.simd<vector<16xi8>, 64>
# CHECK: wave.gather
# CHECK-SAME: mapping <bit_offset =
# CHECK-SAME: -> (!wave.simd<vector<8xi8>, 64>, !wave.mem.token)
# CHECK-COUNT-8: waveamd.mma_scale "mfma.scale.f32.16x16x128.f4.f4"
# CHECK-SAME: !wave.simd<vector<8xi8>, 64>
# CHECK-SAME: !wave.simd<vector<8xi8>, 64>
# CHECK: dynamic-lds-module
# CHECK: attributes {gpu.kernel, gpu.known_block_size = array<i32: 1024, 1, 1>, wave.dynamic_lds_size = 65536 : i64, wave.kernel, wave.lds_size = 0 : i64, wave.workgroup_size = array<i32: 1024, 1, 1>}
# CHECK: arith.constant 65536 : i32
# CHECK: gpu.launch_func
# CHECK-SAME: dynamic_shared_memory_size
# CHECK-LABEL: func.func @static_matmul_kernel
# CHECK-SAME: wave.lds_size = 2048 : i64
# CHECK: %[[TRIP:.*]] = arith.constant 1 : i32
# CHECK-NOT: wave.assume %[[TRIP]]
# CHECK: scf.for %{{.*}} = %{{.*}} to %[[TRIP]] step
