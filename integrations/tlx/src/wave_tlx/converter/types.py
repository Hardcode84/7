"""Type and layout conversion for the TLX Wave converter."""

from collections import defaultdict, deque
from dataclasses import dataclass, replace

from . import layouts
from .layouts import LayoutMap, build_layout_map

_MMA_PACKET_ELEMENT_TYPES = frozenset({"bf16", "f16", "f32"})
_MMA_DOT_OPERAND_ELEMENT_TYPES = _MMA_PACKET_ELEMENT_TYPES | frozenset({"i8"})


@dataclass(frozen=True)
class ConvertedType:
    kind: str
    representation: str
    element_type: str | None = None
    lane_width: int | None = None
    component_count: int = 1


@dataclass(frozen=True)
class ConvertedValue:
    value_id: int
    type: ConvertedType
    layout_map_id: int | None = None


@dataclass(frozen=True)
class TypeLayoutProgram:
    values: dict[int, ConvertedValue]
    layouts: tuple[LayoutMap, ...]


def convert_source_program(program):
    lane_width = int(program.kernel.threads_per_warp or 64)
    warp_count = int(program.kernel.num_warps or 1)
    block_count = int(program.kernel.num_ctas or 1)
    layouts = []
    converted_values = {}
    layout_templates = {}
    for value_id, source_value in program.values.items():
        source_type = source_value.type
        layout_key = (source_type.raw, lane_width)
        if layout_key not in layout_templates:
            layout_templates[layout_key] = build_layout_map(
                0,
                value_id,
                source_type,
                lane_width,
                warp_count,
                block_count,
            )
        template = layout_templates[layout_key]
        layout = (
            None
            if template is None
            else replace(
                template,
                layout_map_id=len(layouts),
                value_id=value_id,
            )
        )
        layout_id = None
        if layout is not None:
            layout_id = layout.layout_map_id
            layouts.append(layout)
        converted_values[value_id] = ConvertedValue(
            value_id,
            _convert_type(source_value.type, layout, lane_width),
            layout_id,
        )
    converted = TypeLayoutProgram(converted_values, tuple(layouts))
    return _retarget_local_load_carries(
        program, converted, lane_width, warp_count, block_count
    )


def _retarget_local_load_carries(
    program, converted, lane_width, warp_count, block_count
):
    graph = defaultdict(list)
    internal_uses = set()

    def connect(source, result, transform="identity", order=()):
        if (
            program.values[source].type.kind != "tensor"
            or program.values[result].type.kind != "tensor"
        ):
            return
        graph[source].append((result, transform, order))
        reverse_order = (
            tuple(order.index(index) for index in range(len(order)))
            if transform == "trans"
            else order
        )
        graph[result].append((source, transform, reverse_order))

    for op in program.ops:
        if op.name in {"tt.reshape", "tt.trans"}:
            order = tuple(int(index) for index in op.attrs.get("order", ()))
            if op.name == "tt.trans" and sorted(order) != list(range(len(order))):
                continue
            connect(
                op.operands[0],
                op.results[0],
                "reshape" if op.name == "tt.reshape" else "trans",
                order,
            )
            internal_uses.add((op.index, 0))
        elif op.name == "scf.for":
            region = program.regions[op.region_ids[0]]
            if not region.op_indices:
                continue
            yield_op = program.ops[region.op_indices[-1]]
            for index, (init, argument, result, yielded) in enumerate(
                zip(
                    op.operands[3:],
                    region.block_arg_ids[1:],
                    op.results,
                    yield_op.operands,
                    strict=True,
                )
            ):
                connect(init, argument)
                connect(argument, result)
                connect(result, yielded)
                internal_uses.add((op.index, index + 3))
                internal_uses.add((yield_op.index, index))
        elif op.name == "scf.if":
            for region_id in op.region_ids:
                region = program.regions[region_id]
                if not region.op_indices:
                    continue
                yield_op = program.ops[region.op_indices[-1]]
                for index, (yielded, result) in enumerate(
                    zip(yield_op.operands, op.results, strict=True)
                ):
                    connect(yielded, result)
                    internal_uses.add((yield_op.index, index))

    uses = defaultdict(list)
    for op in program.ops:
        for index, operand in enumerate(op.operands):
            uses[operand].append((op, index))

    values = dict(converted.values)
    layout_maps = list(converted.layouts)
    visited = set()
    starts = list(graph)
    starts.extend(
        result
        for op in program.ops
        if op.name == "ttg.local_load"
        for result in op.results
    )
    for start in starts:
        if start in visited:
            continue
        component = set()
        pending = [start]
        while pending:
            value_id = pending.pop()
            if value_id in component:
                continue
            component.add(value_id)
            pending.extend(neighbor for neighbor, _transform, _order in graph[value_id])
        visited.update(component)
        if not any(
            program.values[value_id].producer_name == "ttg.local_load"
            for value_id in component
        ):
            continue
        if any(
            program.values[value_id].producer_name
            not in {
                "ttg.local_load",
                "tt.reshape",
                "tt.trans",
                "scf.for",
                "scf.if",
                "block_argument",
            }
            for value_id in component
        ):
            continue

        demands = []
        for value_id in component:
            for user, operand_index in uses[value_id]:
                if (user.index, operand_index) in internal_uses:
                    continue
                if user.name != "ttg.convert_layout" or operand_index != 0:
                    demands = []
                    break
                result = values[user.results[0]]
                if result.layout_map_id is None:
                    demands = []
                    break
                demands.append((value_id, converted.layouts[result.layout_map_id]))
            else:
                continue
            break
        if not demands:
            continue

        seed, candidate = demands[0]
        if any(
            program.values[value_id].type.element_type != candidate.element_type
            for value_id in component
        ):
            continue
        planned = {seed: candidate.linear_layout}
        queue = deque((seed,))
        valid = candidate.linear_layout is not None
        while queue and valid:
            source = queue.popleft()
            linear = planned[source]
            for target, transform, order in graph[source]:
                target_shape = program.values[target].type.shape
                if transform == "identity":
                    remapped = linear
                    if program.values[source].type.shape != target_shape:
                        valid = False
                        break
                else:
                    remapped = layouts.relabel_linear_output(
                        linear,
                        target_shape,
                        order=order if transform == "trans" else None,
                    )
                    if remapped is None:
                        valid = False
                        break
                previous = planned.get(target)
                if previous is not None:
                    if previous != remapped:
                        valid = False
                        break
                    continue
                planned[target] = remapped
                queue.append(target)
        if not valid or any(
            layout.kind != candidate.kind
            or layout.properties != candidate.properties
            or layout.shape != candidate.shape
            or layout.element_type != candidate.element_type
            or layout.component_count != candidate.component_count
            or layout.lane_width != candidate.lane_width
            or planned[value_id] != layout.linear_layout
            for value_id, layout in demands
        ):
            continue

        for value_id, linear in planned.items():
            source_type = program.values[value_id].type
            layout_map_id = len(layout_maps)
            if (
                source_type.shape == candidate.shape
                and linear == candidate.linear_layout
            ):
                layout = replace(
                    candidate, layout_map_id=layout_map_id, value_id=value_id
                )
            else:
                layout = layouts.layout_map_from_linear(
                    layout_map_id,
                    value_id,
                    source_type,
                    linear,
                    lane_width,
                    warp_count,
                    block_count,
                )
            layout_maps.append(layout)
            values[value_id] = ConvertedValue(
                value_id,
                _convert_type(source_type, layout, lane_width),
                layout_map_id,
            )

    return TypeLayoutProgram(values, tuple(layout_maps))


def _convert_type(source_type, layout, lane_width):
    if source_type.kind == "scalar":
        return ConvertedType(
            "scalar", "scalar", source_type.element_type or source_type.raw
        )
    if source_type.kind == "pointer":
        return ConvertedType("pointer", "uniform_pointer", source_type.pointee_type)
    if source_type.kind == "token":
        return ConvertedType("token", "token")
    if source_type.kind == "memdesc":
        return ConvertedType("memdesc", "memdesc", source_type.element_type)
    if source_type.kind == "tensor":
        component_count = 1 if layout is None else int(layout.component_count)
        scalar_component_count = component_count
        if layout is not None and layout.kind in {"amd_mfma", "dot_operand"}:
            # Coordinates, masks, and pointers need a scalar component for
            # every distributed register slot.  Floating MMA values below keep
            # their instruction-sized payload grouped as an ordinary typed
            # SIMD packet; only the immediate MMA wrapper is a fragment.
            scalar_component_count = layouts.linear_layout_in_dim_size(
                layout.linear_layout,
                "register",
            )
        if source_type.element_type == "i1":
            return ConvertedType(
                "mask",
                "mask" if scalar_component_count == 1 else "mask_tuple",
                source_type.element_type,
                lane_width,
                scalar_component_count,
            )
        if source_type.pointee_type is not None:
            return ConvertedType(
                "pointer",
                "per_lane_pointer" if scalar_component_count == 1 else "pointer_tuple",
                source_type.pointee_type,
                lane_width,
                scalar_component_count,
            )
        if (
            layout is not None
            and layout.kind == "dot_operand"
            and source_type.element_type in _MMA_DOT_OPERAND_ELEMENT_TYPES
        ):
            return ConvertedType(
                "tensor",
                "simd_packet" if component_count == 1 else "simd_packet_tuple",
                source_type.element_type,
                lane_width,
                component_count,
            )
        if (
            layout is not None
            and layout.kind == "amd_mfma"
            and source_type.element_type in _MMA_PACKET_ELEMENT_TYPES
        ):
            return ConvertedType(
                "tensor",
                "simd_packet" if component_count == 1 else "simd_packet_tuple",
                source_type.element_type,
                lane_width,
                component_count,
            )
        return ConvertedType(
            "tensor",
            "simd" if scalar_component_count == 1 else "simd_tuple",
            source_type.element_type,
            lane_width,
            scalar_component_count,
        )
    return ConvertedType("unsupported", "unsupported")
