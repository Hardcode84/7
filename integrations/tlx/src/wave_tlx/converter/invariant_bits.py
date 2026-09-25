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


def analyze_invariant_bits(program):
    """Return proven invariant logical-bit indices for each source value."""
    values = program.values
    bits = dict.fromkeys(values)
    consumers = defaultdict(set)
    ops = program.ops

    for value_id, value in values.items():
        if value.argument_index is not None or value.type.kind != "tensor":
            bits[value_id] = 0
    for op in ops:
        for value_id in op.operands:
            consumers[value_id].add(op.index)
        if op.name in {"scf.for", "scf.if"}:
            for region_id in op.region_ids:
                region = program.regions[region_id]
                if not region.op_indices:
                    continue
                yield_op = ops[region.op_indices[-1]]
                for value_id in yield_op.operands:
                    consumers[value_id].add(op.index)

    pending = deque(range(len(ops)))
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

    def result_widths(value_id):
        return _widths(values[value_id].type)

    while pending:
        op = ops[pending.popleft()]
        queued.remove(op.index)

        if op.name == "scf.for" and op.region_ids:
            region = program.regions[op.region_ids[0]]
            carry_args = region.block_arg_ids[1:]
            init_ids = op.operands[3:]
            yield_ids = ops[region.op_indices[-1]].operands if region.op_indices else ()
            for arg_id, init_id, result_id, yield_id in zip(
                carry_args, init_ids, op.results, yield_ids, strict=True
            ):
                refine(arg_id, bits[init_id])
                refine(arg_id, bits[yield_id])
                refine(result_id, bits[init_id])
                refine(result_id, bits[yield_id])
            continue

        if op.name == "scf.if" and op.region_ids:
            for region_id in op.region_ids:
                region = program.regions[region_id]
                if not region.op_indices:
                    continue
                yield_ids = ops[region.op_indices[-1]].operands
                for result_id, yield_id in zip(op.results, yield_ids, strict=True):
                    refine(result_id, bits[yield_id])
            continue

        if not op.results or any(bits[value_id] is None for value_id in op.operands):
            continue
        for result_id in op.results:
            widths = result_widths(result_id)
            if widths is None:
                refine(result_id, 0)
                continue
            count = sum(widths)
            inferred = 0
            # Constant folding owns splats; quotient only structural duplication.
            if op.name in {
                "tt.broadcast",
                "tt.expand_dims",
                "tt.trans",
                "tt.reshape",
            }:
                source_id = op.operands[0]
                source_widths = result_widths(source_id)
                if source_widths is not None:
                    if op.name == "tt.broadcast" and len(source_widths) == len(widths):
                        inferred = _remap_dims(
                            bits[source_id],
                            source_widths,
                            widths,
                            range(len(widths)),
                            broadcast=True,
                        )
                    elif op.name == "tt.expand_dims" and len(source_widths) + 1 == len(
                        widths
                    ):
                        axis = int(op.attrs["axis"])
                        mapping = tuple(
                            -1 if dim == axis else dim - (dim > axis)
                            for dim in range(len(widths))
                        )
                        inferred = _remap_dims(
                            bits[source_id], source_widths, widths, mapping
                        )
                    elif op.name == "tt.trans":
                        inferred = _remap_dims(
                            bits[source_id],
                            source_widths,
                            widths,
                            tuple(int(dim) for dim in op.attrs["order"]),
                        )
                    elif op.name == "tt.reshape" and sum(source_widths) == count:
                        inferred = _remap_reshape(
                            bits[source_id], source_widths, widths
                        )
            elif op.name in {
                "tlx.require_layout",
                "tlx.release_layout",
                "ttg.convert_layout",
            }:
                source_id = op.operands[0]
                if sum(result_widths(source_id) or ()) == count:
                    inferred = bits[source_id]
            elif op.is_elementwise:
                tensor_ids = (
                    value_id
                    for value_id in op.operands
                    if values[value_id].type.kind == "tensor"
                )
                inferred = _all_bits(widths)
                saw_tensor = False
                for value_id in tensor_ids:
                    saw_tensor = True
                    if sum(result_widths(value_id) or ()) != count:
                        inferred = 0
                        break
                    inferred &= bits[value_id]
                if not saw_tensor:
                    inferred = 0
            refine(result_id, inferred)

    return {
        value_id: tuple(
            bit
            for bit in range(sum(_widths(value.type) or ()))
            if (bits[value_id] or 0) & (1 << bit)
        )
        for value_id, value in values.items()
    }
