# REQUIRES: wave-python-bindings
# RUN: %python %s > %t.mlir
# RUN: wave-opt --wave-lower-redistribute %t.mlir \
# RUN:   | FileCheck %s --check-prefix=LOWER
# RUN: wave-opt \
# RUN:   --pass-pipeline='builtin.module(wave-set-target-attr{chip=gfx950})' %t.mlir \
# RUN:   | wave-translate --wave-to-amdgpu-asm - > %t.s 2>/dev/null
# RUN: FileCheck %s --check-prefix=ASM --input-file=%t.s
# RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 \
# RUN:   -filetype=obj %t.s -o /dev/null

from mlir.dialects import wave_dsl as w

with w.module() as module_builder:
    with module_builder.function(
        "packet_layout_cross_wave",
        [w.ptr_type(w.i32())],
        kernel=True,
        workgroup_size=[128, 1, 1],
        attrs={"wave.waves_per_workgroup": w.i64_attr(2)},
    ) as function_builder:
        (destination,) = function_builder.args
        raw_item = function_builder.workitem_id(width=64)
        item = function_builder.assume_range(raw_item, 0, 127)
        symbolic_item = w.sym("item")
        source_item = (
            w.mod(symbolic_item, 32)
            + 32 * w.floor(symbolic_item / 64)
            + 64 * w.mod(w.floor(symbolic_item / 32), 2)
        )
        moved = function_builder.redistribute(
            item,
            w.simd_type(w.i32(), width=64),
            items=128,
            source_item=source_item,
            source_slot=w.sym("slot"),
        )
        pointer = function_builder.ptr_add(destination, item)
        function_builder.store(moved, pointer)

    print(module_builder.module)


# LOWER-LABEL: func.func @packet_layout_cross_wave
# LOWER-NOT: wave.redistribute
# LOWER: %[[ALLOC:.*]] = wave.alloc()
# LOWER: %[[STORE:.*]] = wave.store
# LOWER: %[[PUBLISH:.*]] = wave.barrier %[[STORE]]
# LOWER: %[[VALUE:.*]], %[[LOAD_TOKEN:.*]] = wave.load {{.*}} after %[[PUBLISH]]
# LOWER: %[[DONE:.*]] = wave.join %[[LOAD_TOKEN]]
# LOWER: wave.alloc_release %[[ALLOC]] after %[[DONE]]
# LOWER-SAME: {workgroup_collective}

# ASM-LABEL: packet_layout_cross_wave:
# ASM: ds_write_b32
# ASM: s_waitcnt lgkmcnt(0)
# ASM: s_barrier
# ASM-NOT: s_barrier
# ASM: ds_read_b32
# ASM-NOT: s_barrier
# ASM: buffer_store_dword
# ASM: s_endpgm
# ASM: .amdhsa_group_segment_fixed_size 512
