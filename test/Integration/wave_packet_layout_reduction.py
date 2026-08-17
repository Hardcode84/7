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

from mlir.dialects import wave
from mlir.dialects import wave_dsl as w
from mlir.ir import InsertionPoint

with w.module() as module_builder:
    with module_builder.function(
        "packet_layout_reduce_wave",
        [w.ptr_type(w.i32()), w.ptr_type(w.i32())],
        kernel=True,
        workgroup_size=[128, 1, 1],
        attrs={"wave.waves_per_workgroup": w.i64_attr(2)},
    ) as function_builder:
        source, destination = function_builder.args
        raw_item = function_builder.workitem_id(width=64)
        item = function_builder.assume_range(raw_item, 0, 127)
        source_pointer = function_builder.ptr_add(source, item)
        value, read = function_builder.load(
            source_pointer, w.simd_type(w.i32(), width=64)
        )
        reduction = w.sym("reduction")
        relation = w._redistribution_attr(
            1,
            128,
            w.sym("block"),
            w.mod(w.sym("item"), 64) + 64 * w.mod(reduction, 2),
            w.sym("slot"),
        )
        reduce_op = wave.ReduceOp(w.simd_type(w.i32(), width=64), value, relation, 2)
        combiner = reduce_op.combiner.blocks.append(
            w.simd_type(w.i32(), width=64),
            w.simd_type(w.i32(), width=64),
        )
        with InsertionPoint(combiner):
            lhs, rhs = combiner.arguments
            wave.YieldOp([function_builder.addi(lhs, rhs)])
        pointer = function_builder.ptr_add(destination, item)
        function_builder.store(reduce_op.result, pointer, after=read)

    with module_builder.function(
        "packet_layout_reduce_reorderable_register",
        [w.ptr_type(w.i32()), w.ptr_type(w.i32())],
        kernel=True,
        workgroup_size=[64, 1, 1],
    ) as function_builder:
        source, destination = function_builder.args
        raw_item = function_builder.workitem_id(width=64)
        item = function_builder.assume_range(raw_item, 0, 63)
        source_pointer = function_builder.ptr_add(source, item)
        value, read = function_builder.load(
            source_pointer,
            w.simd_type(w.vector_type(4, w.i32()), width=64),
        )
        reduction = w.sym("reduction")
        relation = w._redistribution_attr(
            1,
            64,
            w.sym("block"),
            w.sym("item"),
            w.xor(
                2 * w.mod(w.floor(reduction / 2), 2),
                w.mod(reduction, 2),
            ),
        )
        reduce_op = wave.ReduceOp(
            w.simd_type(w.i32(), width=64),
            value,
            relation,
            4,
            associative=True,
            commutative=True,
        )
        combiner = reduce_op.combiner.blocks.append(
            w.simd_type(w.i32(), width=64),
            w.simd_type(w.i32(), width=64),
        )
        with InsertionPoint(combiner):
            lhs, rhs = combiner.arguments
            wave.YieldOp([function_builder.addi(lhs, rhs)])
        pointer = function_builder.ptr_add(destination, item)
        function_builder.store(reduce_op.result, pointer, after=read)

    with module_builder.function(
        "packet_layout_reduce_permuted_register",
        [w.ptr_type(w.i32()), w.ptr_type(w.i32())],
        kernel=True,
        workgroup_size=[64, 1, 1],
    ) as function_builder:
        source, destination = function_builder.args
        raw_item = function_builder.workitem_id(width=64)
        item = function_builder.assume_range(raw_item, 0, 63)
        source_pointer = function_builder.ptr_add(source, item)
        value, read = function_builder.load(
            source_pointer,
            w.simd_type(w.vector_type(8, w.i32()), width=64),
        )
        reduction = w.sym("reduction")
        relation = w._redistribution_attr(
            1,
            64,
            w.sym("block"),
            w.xor(w.sym("item"), w.mod(reduction, 2)),
            4 * w.mod(w.floor(reduction / 2), 2) + w.floor(reduction / 4),
        )
        reduce_op = wave.ReduceOp(
            w.simd_type(w.i32(), width=64),
            value,
            relation,
            16,
            associative=True,
            commutative=True,
        )
        combiner = reduce_op.combiner.blocks.append(
            w.simd_type(w.i32(), width=64),
            w.simd_type(w.i32(), width=64),
        )
        with InsertionPoint(combiner):
            lhs, rhs = combiner.arguments
            wave.YieldOp([function_builder.addi(lhs, rhs)])
        pointer = function_builder.ptr_add(destination, item)
        function_builder.store(reduce_op.result, pointer, after=read)

    print(module_builder.module)


# REDUCE-LABEL: func.func @packet_layout_reduce_wave
# REDUCE: %[[VALUE:.*]], %[[READ:.*]] = wave.load
# REDUCE: %[[RESULT:.*]] = wave.reduce %[[VALUE]]
# REDUCE-SAME: using <blocks = 1, items = 128
# REDUCE-SAME: source_block = "block"
# REDUCE-SAME: source_item = "Mod(item, 64) + 64*Mod(reduction, 2)"
# REDUCE-SAME: source_slot = "slot"
# REDUCE-SAME: extent 2
# REDUCE-NOT: associative
# REDUCE-NOT: commutative
# REDUCE: ^bb0(%[[LHS:.*]]: !wave.simd<i32, 64>, %[[RHS:.*]]: !wave.simd<i32, 64>):
# REDUCE: wave.binary addi %[[LHS]], %[[RHS]]
# REDUCE: wave.yield
# REDUCE: wave.store %[[RESULT]] {{.*}} after %[[READ]]

# REDUCE-LABEL: func.func @packet_layout_reduce_reorderable_register
# REDUCE: %[[REGISTER_VALUE:.*]], %[[REGISTER_READ:.*]] = wave.load
# REDUCE: %[[REGISTER_RESULT:.*]] = wave.reduce %[[REGISTER_VALUE]]
# REDUCE-SAME: source_block = "block"
# REDUCE-SAME: source_item = "item"
# REDUCE-SAME: source_slot = "xor(2*Mod(floor(1/2*reduction), 2), Mod(reduction, 2))"
# REDUCE-SAME: extent 4 {associative, commutative}
# REDUCE: wave.store %[[REGISTER_RESULT]] {{.*}} after %[[REGISTER_READ]]

# REDUCE-LABEL: func.func @packet_layout_reduce_permuted_register
# REDUCE: %[[PERMUTED_VALUE:.*]], %[[PERMUTED_READ:.*]] = wave.load
# REDUCE: %[[PERMUTED_RESULT:.*]] = wave.reduce %[[PERMUTED_VALUE]]
# REDUCE-SAME: source_item = "xor(item, Mod(reduction, 2))"
# REDUCE-SAME: source_slot = "floor(1/4*reduction) + 4*Mod(floor(1/2*reduction), 2)"
# REDUCE-SAME: extent 16 {associative, commutative}
# REDUCE: wave.store %[[PERMUTED_RESULT]] {{.*}} after %[[PERMUTED_READ]]

# LOWER-LABEL: func.func @packet_layout_reduce_wave
# LOWER: %[[INPUT:.*]], %[[READ:.*]] = wave.load
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute
# LOWER: %[[ALLOC:.*]] = wave.alloc()
# LOWER: %[[STORE:.*]] = wave.store %[[INPUT]]
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
# LOWER: wave.alloc_release %[[NEXT_ALLOC]] after %[[NEXT_DONE]]
# LOWER-SAME: {workgroup_collective}
# LOWER: wave.binary addi
# LOWER: wave.store {{.*}} after %[[READ]]
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute

# LOWER-LABEL: func.func @packet_layout_reduce_reorderable_register
# LOWER: %[[REGISTER_INPUT:.*]], %[[REGISTER_READ:.*]] = wave.load
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute
# LOWER-COUNT-4: wave.extract %[[REGISTER_INPUT]]
# LOWER-COUNT-3: wave.binary addi
# LOWER: wave.store {{.*}} after %[[REGISTER_READ]]
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute

# LOWER-LABEL: func.func @packet_layout_reduce_permuted_register
# LOWER: %[[PERMUTED_INPUT:.*]], %[[PERMUTED_READ:.*]] = wave.load
# LOWER-NOT: wave.reduce
# LOWER-DAG: %[[S0:.*]] = wave.extract %[[PERMUTED_INPUT]][0]
# LOWER-DAG: %[[S1:.*]] = wave.extract %[[PERMUTED_INPUT]][1]
# LOWER-DAG: %[[S2:.*]] = wave.extract %[[PERMUTED_INPUT]][2]
# LOWER-DAG: %[[S3:.*]] = wave.extract %[[PERMUTED_INPUT]][3]
# LOWER-DAG: %[[S4:.*]] = wave.extract %[[PERMUTED_INPUT]][4]
# LOWER-DAG: %[[S5:.*]] = wave.extract %[[PERMUTED_INPUT]][5]
# LOWER-DAG: %[[S6:.*]] = wave.extract %[[PERMUTED_INPUT]][6]
# LOWER-DAG: %[[S7:.*]] = wave.extract %[[PERMUTED_INPUT]][7]
# LOWER: %[[S04:.*]] = wave.binary addi %[[S0]], %[[S4]]
# LOWER: %[[S041:.*]] = wave.binary addi %[[S04]], %[[S1]]
# LOWER: %[[S0415:.*]] = wave.binary addi %[[S041]], %[[S5]]
# LOWER: %[[S04152:.*]] = wave.binary addi %[[S0415]], %[[S2]]
# LOWER: %[[S041526:.*]] = wave.binary addi %[[S04152]], %[[S6]]
# LOWER: %[[S0415263:.*]] = wave.binary addi %[[S041526]], %[[S3]]
# LOWER: %[[LOCAL:.*]] = wave.binary addi %[[S0415263]], %[[S7]]
# LOWER: %[[R04:.*]] = wave.binary addi %[[S0]], %[[S4]]
# LOWER: %[[R041:.*]] = wave.binary addi %[[R04]], %[[S1]]
# LOWER: %[[R0415:.*]] = wave.binary addi %[[R041]], %[[S5]]
# LOWER: %[[R04152:.*]] = wave.binary addi %[[R0415]], %[[S2]]
# LOWER: %[[R041526:.*]] = wave.binary addi %[[R04152]], %[[S6]]
# LOWER: %[[R0415263:.*]] = wave.binary addi %[[R041526]], %[[S3]]
# LOWER: %[[REMOTE_LOCAL:.*]] = wave.binary addi %[[R0415263]], %[[S7]]
# LOWER: %[[REMOTE:.*]] = wave.shuffle %[[REMOTE_LOCAL]]
# LOWER: %[[RESULT:.*]] = wave.binary addi %[[LOCAL]], %[[REMOTE]]
# LOWER: wave.store %[[RESULT]] {{.*}} after %[[PERMUTED_READ]]
# LOWER-NOT: wave.reduce
# LOWER-NOT: wave.redistribute

# ASM-LABEL: packet_layout_reduce_wave:
# ASM: ; wave backend: WaveAMDMachine MLIR pipeline finalized
# ASM: buffer_load_dword
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

# ASM-LABEL: packet_layout_reduce_reorderable_register:
# ASM: buffer_load_dwordx4
# ASM: v_add_u32
# ASM-NEXT: v_add3_u32
# ASM: buffer_store_dword
# ASM: s_endpgm

# ASM-LABEL: packet_layout_reduce_permuted_register:
# ASM: buffer_load_dwordx4
# ASM: s_waitcnt vmcnt(0)
# ASM-NEXT: v_add_u32_e32 [[ACC:v[0-9]+]], {{v[0-9]+}}, {{v[0-9]+}}
# ASM-NEXT: v_add3_u32 [[ACC]], [[ACC]], {{v[0-9]+}}, {{v[0-9]+}}
# ASM-NEXT: v_add3_u32 [[ACC]], [[ACC]], {{v[0-9]+}}, {{v[0-9]+}}
# ASM-NEXT: v_add3_u32 [[ACC]], [[ACC]], {{v[0-9]+}}, {{v[0-9]+}}
# ASM-NEXT: ds_bpermute_b32
# ASM: buffer_store_dword
# ASM: s_endpgm
