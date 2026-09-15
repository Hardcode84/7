# REQUIRES: wave-python-bindings
# RUN: %python %s --emit both > %t.both.mlir
# RUN: %python %s --emit first > %t.first.mlir
# RUN: wave-opt %t.both.mlir --canonicalize | FileCheck %s --check-prefix=BOTH
# RUN: wave-opt %t.first.mlir --canonicalize | FileCheck %s --check-prefix=FIRST
# RUN: wave-translate %t.both.mlir --wave-to-amdgpu-asm > %t.both.s
# RUN: wave-translate %t.first.mlir --wave-to-amdgpu-asm > %t.first.s
# RUN: %python %s --check-asm %t.both.s %t.first.s

import argparse
import re
import sys
from pathlib import Path

from mlir.dialects import func
from mlir.dialects import wave_dsl as w
from mlir.dialects.wave_matmul import build_wmma_f16_matmul_module
from mlir.ir import FunctionType, InsertionPoint, Location, TypeAttr


def operations(op):
    op = op.operation
    yield op
    for region in op.regions:
        for block in region.blocks:
            for child in block.operations:
                yield from operations(child)


def add_output(kernel, observe_second):
    block = kernel.regions[0].blocks[0]
    original_output = block.arguments[2]
    second_output = block.add_argument(original_output.type, Location.unknown())
    returned = block.operations[-1].operation
    first = returned.operands[0]
    mapping = {original_output: second_output}

    def copy_address(value):
        if value in mapping:
            return mapping[value]
        owner = value.owner
        if not hasattr(owner, "operation"):
            return value
        op = owner.operation
        operands = [copy_address(operand) for operand in op.operands]
        if operands == list(op.operands):
            return value
        cloned = op.clone(ip=InsertionPoint(returned)).operation
        for index, operand in enumerate(operands):
            cloned.operands[index] = operand
        mapping.update(zip(op.results, cloned.results, strict=True))
        return mapping[value]

    stores = [op for op in block.operations if op.operation.name == "wave.store"]
    second = []
    with InsertionPoint(returned):
        builder = w.FunctionBuilder(block)
        for store in stores:
            second.append(
                builder.store(store.operands[0], copy_address(store.operands[1]))
            )
        done = builder.join(*second)
    with InsertionPoint(returned):
        replacement = func.ReturnOp([first, done] if observe_second else [first])
    returned.erase()
    returned = replacement.operation
    kernel.attributes["function_type"] = TypeAttr.get(
        FunctionType.get(
            [arg.type for arg in block.arguments],
            [value.type for value in returned.operands],
        )
    )


def add_host(mod, kernel_name="wmma_f16_matmul_tiled"):
    with InsertionPoint(mod.body):
        main = func.FuncOp("main", ([], []))
        with InsertionPoint(main.add_entry_block()):
            host = w.FunctionBuilder(main.body.blocks[0])
            zero = host.constant(w.index_type(), 0)
            one = host.constant(w.index_type(), 1)
            size = host.constant(w.index_type(), 65536)
            buffers = [host.alloc([65536], w.f16()) for _ in range(4)]
            for index, buffer in enumerate(buffers):
                value = host.constant(w.f16(), float(index + 1) if index < 2 else -1.0)
                with host.for_loop(zero, size, one) as loop:
                    host.memref_store(value, buffer, [loop])
            pointers = []
            for buffer in buffers:
                host.host_register(host.cast_unranked(buffer))
                dynamic = host.memref_cast(buffer, w.dynamic_1d_memref_type(w.f16()))
                pointers.extend(
                    host.call(
                        "wave_memref_to_ptr_global_f16",
                        [dynamic],
                        [w.ptr_type(w.f16())],
                    )
                )
            threads = host.constant(w.index_type(), 1024)
            trip_count = host.constant(w.i32(), 7)
            shared = host.constant(w.i32(), 131072)
            host.launch(
                "kernels",
                kernel_name,
                (one, one, one),
                (threads, one, one),
                [*pointers[:3], trip_count, pointers[3]],
                dynamic_shared_memory_size=shared,
            )
            for buffer in buffers[2:]:
                host.call("printMemrefF16", [host.cast_unranked(buffer)])
            host.finish()


def build(observe_second, include_host=False):
    mod = build_wmma_f16_matmul_module(
        256,
        256,
        256,
        BM=4,
        BN=4,
        wave_m_tiles=4,
        wave_n_tiles=4,
        use_buffer=True,
        use_dma_lds=True,
        matrix_intrinsic="mfma_gfx950",
        output_type="f16",
        output_layout="column-major",
        include_host=False,
    )
    with mod.context, Location.unknown():
        kernel = next(
            op
            for op in operations(mod)
            if op.name == "func.func" and op.regions[0].blocks
        )
        add_output(kernel, observe_second)
        assert mod.operation.verify()
        if not include_host:
            with w.module() as result:
                kernel.clone()
                result.module.operation.attributes["waveamdmachine.target"] = (
                    w.StringAttr.get("amdgcn-amd-amdhsa--gfx950")
                )
                return str(result.module)

        add_host(mod)
        assert mod.operation.verify()
        return str(mod)


def check_runtime(build_module=build, expected=(512.0, 512.0)):
    sys.path.insert(0, str(Path(__file__).resolve().parents[2] / "examples" / "wave"))
    from common import parse_runner_values, run_module

    for observed in (True, False):
        output = run_module(
            build_module(observed, True),
            chip="gfx950",
            wave_opt=None,
            mlir_runner=None,
            shared_libs=None,
        )
        payloads = re.findall(r"data =\s*(\[[\s\S]*?\])", output)
        assert len(payloads) == 2
        values = tuple(
            value
            for payload in payloads
            for value in parse_runner_values("data =" + payload)
        )
        assert len(values) == 2 * 65536
        assert all(value == expected[0] for value in values[:65536])
        assert all(
            value == (expected[1] if observed else -1.0) for value in values[65536:]
        )
    print("Both observation sets passed")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--emit", choices=("both", "first"))
    parser.add_argument("--check-asm", nargs=2, type=Path)
    parser.add_argument("--run", action="store_true")
    args = parser.parse_args()
    if args.check_asm:
        both, first = [path.read_text() for path in args.check_asm]

        def count(text, mnemonic):
            return sum(mnemonic in line for line in text.splitlines())

        assert count(both, "buffer_store_") == 2 * count(first, "buffer_store_") > 0
        assert count(both, "buffer_load_") == count(first, "buffer_load_") > 0
        assert "s_endpgm" in first
        print("Output stores halved; shared DMA retained")
    elif args.run:
        check_runtime()
    else:
        print(build(args.emit == "both"))


if __name__ == "__main__":
    main()

# BOTH-LABEL: func.func @wmma_f16_matmul_tiled
# BOTH: scf.for
# BOTH: waveamd.dma_load_lds
# BOTH-COUNT-32: wave.store
# BOTH: return {{%.*}}, {{%.*}} : !wave.mem.token, !wave.mem.token
# FIRST-LABEL: func.func @wmma_f16_matmul_tiled
# FIRST: scf.for
# FIRST: waveamd.dma_load_lds
# FIRST-COUNT-16: wave.store
# FIRST-NOT: wave.store
# FIRST: return {{%.*}} : !wave.mem.token
