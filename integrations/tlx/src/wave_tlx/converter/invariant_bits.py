"""Prove logical tensor coordinates whose value does not change."""

from collections import defaultdict, deque


def _widths(source_type):
    if source_type.kind != "tensor":
        return ()
    if any(extent < 1 or extent & (extent - 1) for extent in source_type.shape):
        return None
    return tuple(extent.bit_length() - 1 for extent in source_type.shape)


def _all_bits(widths):
    return (1 << sum(widths)) - 1


def _remap_dims(source_bits, source_widths, result_widths, mapping, *, broadcast=False):
    result = 0
    source_offset = 0
    source_offsets = []
    for width in source_widths:
        source_offsets.append(source_offset)
        source_offset += width
    result_offset = 0
    for result_dim, source_dim in enumerate(mapping):
        result_width = result_widths[result_dim]
        if source_dim >= 0:
            source_width = source_widths[source_dim]
            copied = min(source_width, result_width)
            source_mask = (1 << copied) - 1
            result |= (
                (source_bits >> source_offsets[source_dim]) & source_mask
            ) << result_offset
            if broadcast and source_width == 0:
                result |= ((1 << result_width) - 1) << result_offset
        result_offset += result_width
    return result


def _remap_reshape(source_bits, source_widths, result_widths):
    source_offset = 0
    source_suffix = sum(source_widths)
    linear_bits = set()
    for width in source_widths:
        source_suffix -= width
        for bit in range(width):
            if source_bits & (1 << (source_offset + bit)):
                linear_bits.add(source_suffix + bit)
        source_offset += width
    result = 0
    result_offset = 0
    result_suffix = sum(result_widths)
    for width in result_widths:
        result_suffix -= width
        for bit in range(width):
            if result_suffix + bit in linear_bits:
                result |= 1 << (result_offset + bit)
        result_offset += width
    return result


def _consumers(program):
    consumers = defaultdict(set)
    for op in program.ops:
        for value_id in op.operands:
            consumers[value_id].add(op.index)
        if op.name not in {"scf.for", "scf.if"}:
            continue
        for region_id in op.region_ids:
            region = program.regions[region_id]
            if region.op_indices:
                for value_id in program.ops[region.op_indices[-1]].operands:
                    consumers[value_id].add(op.index)
    return consumers


def _refine_loop(program, op, bits, refine):
    region = program.regions[op.region_ids[0]]
    yield_ids = program.ops[region.op_indices[-1]].operands if region.op_indices else ()
    for arg_id, init_id, result_id, yield_id in zip(
        region.block_arg_ids[1:], op.operands[3:], op.results, yield_ids, strict=True
    ):
        refine(arg_id, bits[init_id])
        refine(arg_id, bits[yield_id])
        refine(result_id, bits[init_id])
        refine(result_id, bits[yield_id])


def _refine_branches(program, op, bits, refine):
    for region_id in op.region_ids:
        region = program.regions[region_id]
        if not region.op_indices:
            continue
        yield_ids = program.ops[region.op_indices[-1]].operands
        for result_id, yield_id in zip(op.results, yield_ids, strict=True):
            refine(result_id, bits[yield_id])


def _expanded_dims(source_bits, source_widths, widths, axis):
    if len(source_widths) + 1 != len(widths):
        return 0
    mapping = tuple(
        -1 if dim == axis else dim - (dim > axis) for dim in range(len(widths))
    )
    return _remap_dims(source_bits, source_widths, widths, mapping)


def _structural_bits(op, source_bits, source_widths, widths):
    if source_widths is None:
        return 0
    if op.name == "tt.broadcast" and len(source_widths) == len(widths):
        return _remap_dims(
            source_bits, source_widths, widths, range(len(widths)), broadcast=True
        )
    if op.name == "tt.expand_dims":
        return _expanded_dims(source_bits, source_widths, widths, int(op.attrs["axis"]))
    if op.name == "tt.trans":
        return _remap_dims(
            source_bits,
            source_widths,
            widths,
            tuple(int(dim) for dim in op.attrs["order"]),
        )
    if op.name == "tt.reshape" and sum(source_widths) == sum(widths):
        return _remap_reshape(source_bits, source_widths, widths)
    return 0


def _elementwise_bits(op, values, bits, widths):
    tensor_ids = [
        value_id for value_id in op.operands if values[value_id].type.kind == "tensor"
    ]
    if not tensor_ids:
        return 0
    inferred = _all_bits(widths)
    for value_id in tensor_ids:
        if sum(_widths(values[value_id].type) or ()) != sum(widths):
            return 0
        inferred &= bits[value_id]
    return inferred


def _result_bits(op, result_id, values, bits):
    widths = _widths(values[result_id].type)
    if widths is None:
        return 0
    # Constant folding owns splats; quotient only structural duplication.
    if op.name in {"tt.broadcast", "tt.expand_dims", "tt.trans", "tt.reshape"}:
        source_id = op.operands[0]
        return _structural_bits(
            op, bits[source_id], _widths(values[source_id].type), widths
        )
    if op.name in {"tlx.require_layout", "tlx.release_layout", "ttg.convert_layout"}:
        source_id = op.operands[0]
        return (
            bits[source_id]
            if sum(_widths(values[source_id].type) or ()) == sum(widths)
            else 0
        )
    if op.is_elementwise:
        return _elementwise_bits(op, values, bits, widths)
    return 0


def _refine_op(program, op, bits, refine):
    if op.name == "scf.for" and op.region_ids:
        _refine_loop(program, op, bits, refine)
    elif op.name == "scf.if" and op.region_ids:
        _refine_branches(program, op, bits, refine)
    elif op.results and all(bits[value_id] is not None for value_id in op.operands):
        for result_id in op.results:
            refine(result_id, _result_bits(op, result_id, program.values, bits))


def analyze_invariant_bits(program):
    """Return proven invariant logical-bit indices for each source value."""
    values = program.values
    bits = {
        value_id: (
            0
            if value.argument_index is not None or value.type.kind != "tensor"
            else None
        )
        for value_id, value in values.items()
    }
    consumers = _consumers(program)
    pending = deque(range(len(program.ops)))
    queued = set(pending)

    def refine(value_id, inferred):
        if inferred is None:
            return
        previous = bits[value_id]
        updated = inferred if previous is None else previous & inferred
        if previous == updated:
            return
        bits[value_id] = updated
        for index in consumers[value_id]:
            if index not in queued:
                pending.append(index)
                queued.add(index)

    while pending:
        op = program.ops[pending.popleft()]
        queued.remove(op.index)
        _refine_op(program, op, bits, refine)

    return {
        value_id: _bit_indices(bits[value_id], value.type)
        for value_id, value in values.items()
    }


def _bit_indices(bits, source_type):
    return tuple(
        bit
        for bit in range(sum(_widths(source_type) or ()))
        if (bits or 0) & (1 << bit)
    )
