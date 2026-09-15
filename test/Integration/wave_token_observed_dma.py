# REQUIRES: wave-python-bindings
# RUN: %python %s both > %t.both.mlir
# RUN: %python %s first > %t.first.mlir
# RUN: wave-translate %t.both.mlir --wave-to-amdgpu-asm > %t.both.s
# RUN: wave-translate %t.first.mlir --wave-to-amdgpu-asm > %t.first.s
# RUN: FileCheck %s --check-prefix=BOTH < %t.both.s
# RUN: FileCheck %s --check-prefix=FIRST < %t.first.s

import sys

from mlir.dialects import wave_dsl as w
from mlir.ir import InsertionPoint
from wave_token_observed_matmul import add_host, check_runtime


def copy_tile(f, source, output, item, first_item, iteration, shared_offset, dep):
    offset = f.index_expr(
        2 * (w.sym("item") + 1024 * w.sym("iteration")),
        {w.sym("item"): item, w.sym("iteration"): iteration},
    )
    shared = f.shared_memory_base(w.i32(), offset=shared_offset)
    dma = f.dma_load_lds(
        f.ptr_add(source, offset), f.ptr_add(shared, first_item), after=dep
    )
    value, read = f.load(
        f.ptr_add(shared, item), w.simd_type(w.vector_type(2, w.f16()), 64), after=dma
    )
    return f.store(value, f.ptr_add(output, offset), after=read)


def build(observe_second, include_host=False):
    with w.module() as mod:
        mod.declare_external(
            "wave_memref_to_ptr_global_f16",
            [w.dynamic_1d_memref_type(w.f16())],
            [w.ptr_type(w.f16())],
        )
        mod.declare_external("printMemrefF16", [w.unranked_memref_type(w.f16())], [])
        with (
            mod.gpu_module("kernels") as gpu,
            gpu.kernel(
                "dma_output_copy",
                [w.ptr_type(w.f16())] * 3 + [w.i32(), w.ptr_type(w.f16())],
                lds_size=8192,
                workgroup_size=[1024, 1, 1],
            ) as f,
        ):
            a, b, c, _, d = f.args
            item = f.assume_range(f.workitem_id(width=64), 0, 1023)
            first_item = f.read_first(item)
            zero = f.constant(w.i32(), 0)
            one = f.constant(w.i32(), 1)
            limit = f.constant(w.i32(), 32)
            with f.for_loop(zero, limit, one, init_args=[f.token(), f.token()]) as loop:
                x, y = loop.inner_iter_args
                done_a = copy_tile(
                    f, a, c, item, first_item, loop.induction_variable, 0, x
                )
                done_b = copy_tile(
                    f, b, d, item, first_item, loop.induction_variable, 4096, y
                )
                f.yield_([done_a, done_b])
            f.observe(loop.results[0])
            if observe_second:
                f.observe(loop.results[1])
        if include_host:
            add_host(mod.module, "dma_output_copy")
        else:
            # Move the kernel to module scope for direct assembly emission.
            gpu_op = next(
                op
                for op in mod.module.body.operations
                if op.operation.name == "gpu.module"
            )
            kernel = gpu_op.regions[0].blocks[0].operations[0]
            kernel.clone(ip=InsertionPoint(gpu_op))
            gpu_op.erase()
            mod.module.operation.attributes["waveamdmachine.target"] = w.StringAttr.get(
                "amdgcn-amd-amdhsa--gfx950"
            )
        assert mod.module.operation.verify()
        return str(mod.module)


if __name__ == "__main__":
    if sys.argv[1] == "run":
        check_runtime(build, (1.0, 2.0))
    else:
        print(build(sys.argv[1] == "both"))

# BOTH-LABEL: dma_output_copy:
# BOTH-COUNT-2: buffer_load_dword {{.*}} lds
# BOTH: s_endpgm
# FIRST-LABEL: dma_output_copy:
# FIRST: buffer_load_dword {{.*}} lds
# FIRST-NOT: buffer_load_dword {{.*}} lds
# FIRST: s_endpgm
