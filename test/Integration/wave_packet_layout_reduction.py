# REQUIRES: wave-python-bindings
# RUN: %python %s > %t.mlir
# RUN: FileCheck %s --check-prefix=REDUCE --input-file=%t.mlir
# RUN: wave-opt --wave-lower-redistribute %t.mlir \
# RUN:   | FileCheck %s --check-prefix=LOWER
# RUN: wave-opt \
# RUN:   --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950})' %t.mlir \
# RUN:   | wave-translate --wave-to-amdgpu-asm - > %t.s 2>/dev/null
# RUN: FileCheck %s --check-prefix=ASM --input-file=%t.s
# RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
# RUN:   -filetype=obj %t.s -o /dev/null

from mlir.dialects import wave_dsl as w

SOURCE_LAYOUT = w.PacketLayout(
    64,
    (("reduce", 2), ("x", 64)),
    (
        ("lane", ((0, 1), (0, 2), (0, 4), (0, 8), (0, 16), (0, 32))),
        ("warp", ((1, 0),)),
    ),
)
RESULT_LAYOUT = w.PacketLayout(
    64,
    (("x", 64),),
    (
        ("lane", ((1,), (2,), (4,), (8,), (16,), (32,))),
        ("warp", ((0,),)),
    ),
)


with w.module() as module_builder:
    with module_builder.function(
        "packet_layout_reduce_wave",
        [w.ptr_type(w.i32())],
        kernel=True,
        workgroup_size=[128, 1, 1],
        attrs={"wave.waves_per_workgroup": w.i64_attr(2)},
    ) as function_builder:
        (destination,) = function_builder.args
        item = function_builder.workitem_id(width=64)
        with function_builder.reduce_layout(
            item,
            w.simd_type(w.i32(), width=64),
            source_layout=SOURCE_LAYOUT,
            result_layout=RESULT_LAYOUT,
            axis=0,
        ) as reduction:
            lhs, rhs = reduction.arguments
            function_builder.yield_((function_builder.addi(lhs, rhs),))
        pointer = function_builder.ptr_add(destination, item)
        function_builder.store(reduction.result, pointer)

    print(module_builder.module)


# REDUCE-LABEL: func.func @packet_layout_reduce_wave
# REDUCE: %[[RESULT:.*]] = wave.reduce
# REDUCE-SAME: using <
# REDUCE-SAME: reduction
# REDUCE-SAME: extent 2
# REDUCE-NOT: associative
# REDUCE-NOT: commutative
# REDUCE: ^bb0(%[[LHS:.*]]: !wave.simd<i32, 64>, %[[RHS:.*]]: !wave.simd<i32, 64>):
# REDUCE: wave.binary addi %[[LHS]], %[[RHS]]
# REDUCE: wave.yield
# REDUCE: wave.store %[[RESULT]]

# LOWER-LABEL: func.func @packet_layout_reduce_wave
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute
# LOWER: %[[ALLOC:.*]] = wave.alloc()
# LOWER: %[[STORE:.*]] = wave.store
# LOWER: %[[PUBLISH:.*]] = wave.barrier %[[STORE]]
# LOWER: %[[VALUE:.*]], %[[LOAD_TOKEN:.*]] = wave.load {{.*}} after %[[PUBLISH]]
# LOWER: %[[DONE:.*]] = wave.join %[[LOAD_TOKEN]]
# LOWER: %[[RELEASE:.*]] = wave.alloc_release %[[ALLOC]] after %[[DONE]]
# LOWER-SAME: {workgroup_collective}
# LOWER: %[[NEXT_ALLOC:.*]] = wave.alloc()
# LOWER: %[[NEXT_STORE:.*]] = wave.store {{.*}} after %[[RELEASE]]
# LOWER: %[[NEXT_PUBLISH:.*]] = wave.barrier %[[NEXT_STORE]]
# LOWER: %[[NEXT_VALUE:.*]], %[[NEXT_LOAD_TOKEN:.*]] = wave.load
# LOWER-SAME: after %[[NEXT_PUBLISH]]
# LOWER: %[[NEXT_DONE:.*]] = wave.join %[[NEXT_LOAD_TOKEN]]
# LOWER: wave.alloc_release %[[NEXT_ALLOC]] after %[[NEXT_DONE]] {workgroup_collective}
# LOWER: wave.binary addi
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute

# ASM-LABEL: packet_layout_reduce_wave:
# ASM: ; wave backend: WaveAMDMachine MLIR pipeline finalized
# ASM: ds_write_b32
# ASM: s_waitcnt lgkmcnt(0)
# ASM: s_barrier
# ASM: ds_read_b32
# ASM: ds_write_b32
# ASM: s_waitcnt lgkmcnt(0)
# ASM: s_barrier
# ASM: ds_read_b32
# ASM: v_add_u32
# ASM: buffer_store_dword
# ASM: s_endpgm
# ASM: .amdhsa_group_segment_fixed_size 1024
