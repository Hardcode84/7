# REQUIRES: wave-python-bindings
# RUN: %python %s > %t.mlir
# RUN: wave-opt %t.mlir \
# RUN:   --wave-set-target-attr='chip=gfx1250' \
# RUN:   --transform-preload-library='transform-library-paths=%wave_pipelines' \
# RUN:   --transform-interpreter='entry-point=waveamd_backend_unscheduled' \
# RUN:   > %t.lowered
# RUN: FileCheck %s --check-prefix=IR < %t.lowered
# RUN: env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline \
# RUN:   wave-translate --wave-to-amdgpu-asm %t.lowered > %t.s
# RUN: FileCheck %s --check-prefix=ASM < %t.s
# RUN: llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
# RUN:   -filetype=obj %t.s -o /dev/null

from mlir.dialects import wave_dsl as w
from mlir.dialects.wave_target import GFX1250_CHIP, require_matmul_target_profile

wave_size = require_matmul_target_profile(GFX1250_CHIP).wave_size
with w.module() as m:
    with m.function(
        "gfx1250_dynamic_tdm_descriptors",
        [w.i64()],
        kernel=True,
        workgroup_size=[4 * wave_size, 1, 1],
    ) as f:
        (base,) = f.args
        workitem_first = w.sym("tdm_workitem_first")
        item = f.workitem_id(0, width=wave_size)
        first = f.read_first(item)
        wave_id = w.floor(workitem_first / wave_size)
        global_offset = f.index_expr(wave_id * 128, {workitem_first: first})
        lds_address = f.index_expr(wave_id * 512, {workitem_first: first})
        d2 = f.gfx1250_tdm_descriptor(
            base,
            [16, 32],
            [32, 1],
            [16, 32],
            element_bit_width=16,
            global_byte_offset=global_offset,
            lds_address=lds_address,
        )
        d4 = f.gfx1250_tdm_descriptor(
            base,
            [4, 8, 16, 32],
            [4096, 512, 32, 1],
            [4, 8, 16, 32],
            element_bit_width=16,
            global_byte_offset=global_offset,
            lds_address=lds_address,
        )
        d2_done = f.tdm_load(d2, after=f.token())
        f.tdm_load(d4, after=d2_done)

    print(m.module)


# IR-LABEL: func.func @gfx1250_dynamic_tdm_descriptors
# IR-SAME: wave.workgroup_size = array<i32: 128, 1, 1>
# IR: waveamdmachine.v_readfirstlane_b32
# IR: waveamdmachine.s_lshr_b32
# IR: waveamdmachine.s_lshl_b32
# IR: waveamdmachine.s_add_u64
# IR: waveamdmachine.tdm_load
# IR: waveamdmachine.tdm_load

# ASM-LABEL: gfx1250_dynamic_tdm_descriptors:
# ASM: v_readfirstlane_b32
# ASM: s_lshr_b32
# ASM: s_lshl_b32
# ASM: s_add_co_u32
# ASM-NEXT: s_add_co_ci_u32
# ASM: tensor_load_to_lds
# ASM: tensor_load_to_lds
