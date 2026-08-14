# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects import wave_dsl as w


def run(function):
    print(f"\nTEST: {function.__name__}")
    function()


# CHECK-LABEL: TEST: test_symbolic_packet_relations
@run
def test_symbolic_packet_relations():
    with w.module() as module_builder:
        scalar = w.simd_type(w.i32(), width=32)
        pair = w.simd_type(w.vector_type(2, w.i32()), width=32)
        with module_builder.function(
            "symbolic_packet_relations",
            [scalar, scalar, scalar, scalar, scalar, pair],
        ) as function_builder:
            identity, broadcast, expand, reshape, transpose, split = (
                function_builder.args
            )
            item = w.sym("item")
            slot = w.sym("slot")
            zero = w.sym_ctx.int_(0)
            for source, result_type, source_slot in (
                (identity, scalar, slot),
                (broadcast, pair, zero),
                (expand, scalar, slot),
                (reshape, scalar, slot),
                (transpose, scalar, slot),
                (split, scalar, w.sym_ctx.int_(1)),
            ):
                function_builder.redistribute(
                    source,
                    result_type,
                    items=32,
                    source_item=item,
                    source_slot=source_slot,
                )

        # CHECK: func.func @symbolic_packet_relations
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "0"
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "slot"
        # CHECK: wave.redistribute {{.*}}source_slot = "1"
        print(module_builder.module)
