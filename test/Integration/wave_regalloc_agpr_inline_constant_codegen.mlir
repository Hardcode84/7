// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=agpr_relief_direct},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},symbol-dce,waveamd-pack-vgpr-zero-moves,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: wave-opt %s --pass-pipeline='builtin.module(transform-interpreter{entry-point=agpr_relief_direct},transform-preload-library{transform-library-paths=%wave_pipelines},transform-interpreter{entry-point=waveamd_regalloc_transform_loop},symbol-dce,waveamd-pack-vgpr-zero-moves,waveamd-resource-info)' \
// RUN:   | env WAVE_PIPELINES_DIR=%S/../Target/Wave/Inputs/emit-only-pipeline wave-translate --wave-to-amdgpu-asm - \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx950 -filetype=obj -o /dev/null

module attributes {
  transform.with_named_sequence,
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"
} {
  transform.named_sequence private @match_func(
      %root: !transform.any_op {transform.readonly}) -> !transform.any_op {
    transform.match.operation_name %root ["func.func"] : !transform.any_op
    transform.yield %root : !transform.any_op
  }

  transform.named_sequence private @agpr_relief_direct(
      %root: !transform.any_op {transform.readonly}) {
    %func = transform.collect_matching @match_func in %root
        : (!transform.any_op) -> !transform.any_op
    %r0 = wave.transform.regalloc_agpr_relief from %func
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }

  // ASM-LABEL: agpr_inline_constant_codegen:
    // ASM-NOT: v_mov
    // ASM: v_accvgpr_write_b32 a0, 1
    // ASM-NEXT: v_accvgpr_write_b32 a1, 1
    // ASM: v_accvgpr_read_b32 v2, a0
    // ASM-NEXT: v_accvgpr_read_b32 v3, a1
    // ASM: global_store_dwordx2 v[0:1], v[2:3], off
    func.func @agpr_inline_constant_codegen(
        %addr: !waveamdmachine.reg<vgpr, 2, 0>)
        attributes {wave.kernel,
                    wave.workgroup_size = array<i32: 64, 1, 1>,
                    waveamdmachine.agpr_count_max = 256 : i64,
                    waveamdmachine.target_waves = 1 : i64,
                    waveamdmachine.regalloc_transform_state = {
          alias_sets = [
            {class = "vgpr", id = 0 : i64,
             members = [{value = 0 : i64}], width = 2 : i64},
            {class = "vgpr", id = 1 : i64,
             members = [{value = 1 : i64}], width = 2 : i64},
            {class = "vgpr", id = 2 : i64,
             members = [{value = 2 : i64}], width = 4 : i64}
          ],
          failure = {
            class = "vgpr",
            overlaps = [
              {base = 3 : i64, class = "vgpr", end = 4 : i64,
               set = 1 : i64, start = 1 : i64, width = 2 : i64}
            ],
            position = 2 : i64,
            reason = "pressure",
            set = 2 : i64
          },
          stage = "linear-scan-failure",
          values = [
            {class = "vgpr", end = 4 : i64, fixed = 0 : i64, id = 0 : i64,
             kind = "block_arg", number = 0 : i64, offset = 0 : i64,
             path = [0, 0], set = 0 : i64, start = 0 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 4 : i64, id = 1 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 1], set = 1 : i64, start = 1 : i64,
             width = 2 : i64},
            {class = "vgpr", end = 4 : i64, fixed = 4 : i64, id = 2 : i64,
             kind = "op_result", number = 0 : i64, offset = 0 : i64,
             path = [0, 0, 2], set = 2 : i64, start = 2 : i64,
             width = 4 : i64}
          ]
        }} {
      %one = waveamdmachine.imm 1 : !waveamdmachine.imm
      %inline = waveamdmachine.v_mov_b32_tuple %one {registers = 2 : i64}
          : (!waveamdmachine.imm) -> !waveamdmachine.reg<vgpr, 2>
      %request = waveamdmachine.uninit
          : !waveamdmachine.reg<vgpr, 4, 4>
      %tok0 = waveamdmachine.global_store_b64_addr64 %addr, %inline
          : (!waveamdmachine.reg<vgpr, 2, 0>,
             !waveamdmachine.reg<vgpr, 2>)
            -> !waveamdmachine.mem.token
      %tok1 = waveamdmachine.global_store_b128_addr64
          %addr, %request after %tok0
          : (!waveamdmachine.reg<vgpr, 2, 0>,
             !waveamdmachine.reg<vgpr, 4, 4>,
             !waveamdmachine.mem.token)
            -> !waveamdmachine.mem.token
      waveamdmachine.s_endpgm
      return
    }
}
