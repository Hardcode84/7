// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | FileCheck %s --check-prefix=ASM
// RUN: env WAVE_PIPELINES_DIR=%S/Inputs/emit-only-pipeline \
// RUN:   wave-translate --wave-to-amdgpu-asm %s \
// RUN:   | llvm-mc -triple=amdgcn-amd-amdhsa -mcpu=gfx1250 \
// RUN:       -filetype=obj -o %t.o
// RUN: llvm-objdump -d --mcpu=gfx1250 %t.o \
// RUN:   | FileCheck %s --check-prefix=DIS

module attributes {
  waveamdmachine.target = "amdgcn-amd-amdhsa--gfx1250"
} {

// ASM-LABEL: vgpr_window:
// ASM: buffered_high:
// ASM: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM: s_set_vgpr_msb 0xf900
// ASM: s_cbranch_scc0 .Lvgpr_window.if_else_0
// ASM: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM: s_set_vgpr_msb 0xf900
// ASM: s_branch .Lvgpr_window.if_end_0
// ASM: .Lvgpr_window.if_else_0:
// ASM: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v253 /*v1021*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM: s_set_vgpr_msb 0xf900
// ASM: .Lvgpr_window.if_end_0:
// ASM: s_endpgm
// DIS-LABEL: <vgpr_window>:
// DIS: s_set_vgpr_msb 0xf9
// DIS: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS: s_set_vgpr_msb 0xf900
// DIS: s_cbranch_scc0
// DIS: s_set_vgpr_msb 0xf9
// DIS: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS: s_set_vgpr_msb 0xf900
// DIS: s_branch
// DIS: s_set_vgpr_msb 0xf9
// DIS: v_fma_f32 v253 /*v1021*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS: s_set_vgpr_msb 0xf900
// DIS: s_endpgm
// ASM-LABEL: explicit_vgpr_window:
// ASM: s_set_vgpr_msb 0xf9
// ASM-NEXT: s_endpgm
// DIS-LABEL: <explicit_vgpr_window>:
// DIS: s_set_vgpr_msb 0xf9
// DIS-NEXT: s_endpgm
// ASM-LABEL: buffer_vgpr_window:
// ASM: s_set_vgpr_msb 0x81
// ASM-NEXT: buffer_store_b32 v0 /*v512*/, v0 /*v256*/, s[8:11], null offen
// ASM-NEXT: s_endpgm
// DIS-LABEL: <buffer_vgpr_window>:
// DIS: s_set_vgpr_msb 0x81
// DIS-NEXT: buffer_store_b32 v0 /*v512*/, v0 /*v256*/, s[8:11], null offen
// DIS-NEXT: s_endpgm
// ASM-LABEL: wmma_vgpr_window:
// ASM: s_set_vgpr_msb 0xf9
// ASM-NEXT: v_wmma_f32_16x16x32_f16 v[0:7] /*v[768:775]*/, v[0:7] /*v[256:263]*/, v[0:7] /*v[512:519]*/, v[0:7] /*v[768:775]*/
// ASM-NEXT: s_endpgm
// DIS-LABEL: <wmma_vgpr_window>:
// DIS: s_set_vgpr_msb 0xf9
// DIS-NEXT: v_wmma_f32_16x16x32_f16 v[0:7] /*v[768:775]*/, v[0:7] /*v[256:263]*/, v[0:7] /*v[512:519]*/, v[0:7] /*v[768:775]*/
// DIS-NEXT: s_endpgm
// ASM-LABEL: coissue_vgpr_window:
// ASM: s_set_vgpr_msb 0xf9
// ASM-NEXT: s_wait_loadcnt 0x0
// ASM-NOT: s_wait_xcnt
// ASM-NEXT: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-NEXT: s_endpgm
// DIS-LABEL: <coissue_vgpr_window>:
// DIS: s_set_vgpr_msb 0xf9
// DIS-NEXT: s_wait_loadcnt 0x0
// DIS-NOT: s_wait_xcnt
// DIS-NEXT: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS-NEXT: s_endpgm
// ASM-LABEL: mode_setreg_patch:
// ASM: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE), 0xe7000
// ASM-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-NEXT: s_endpgm
// DIS-LABEL: <mode_setreg_patch>:
// DIS: s_set_vgpr_msb 0xf9
// DIS: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE), 0xe7000
// DIS-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-LABEL: mode_setreg_restore:
// ASM: s_set_vgpr_msb 0xf9
// ASM: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-NEXT: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 1, 31), 0
// ASM-NEXT: s_nop 0
// ASM-NEXT: s_set_vgpr_msb 0xf9f9
// ASM-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS-LABEL: <mode_setreg_restore>:
// DIS: s_setreg_imm32_b32 hwreg(HW_REG_WAVE_MODE, 1, 31), 0
// DIS-NEXT: s_nop 0
// DIS-NEXT: s_set_vgpr_msb 0xf9f9
// DIS-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-LABEL: clause_first_switch:
// ASM: s_set_vgpr_msb 0xf9
// ASM-NEXT: s_clause 0x1
// ASM-NEXT: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-NEXT: v_fma_f32 v254 /*v1022*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS-LABEL: <clause_first_switch>:
// DIS: s_set_vgpr_msb 0xf9
// DIS-NEXT: s_clause 0x1
// DIS-NEXT: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// ASM-LABEL: clause_resize:
// ASM: s_clause 0x2
// ASM-NEXT: v_fma_f32 v3, v0, v1, v2
// ASM-NEXT: s_set_vgpr_msb 0xf9
// ASM-NEXT: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS-LABEL: <clause_resize>:
// DIS: s_clause 0x2
// DIS-NEXT: v_fma_f32 v3, v0, v1, v2
// DIS-NEXT: s_set_vgpr_msb 0xf9
// ASM-LABEL: clause_break_drop:
// ASM-NOT: s_clause
// ASM: v_fma_f32 v3, v0, v1, v2
// ASM-NEXT: s_set_vgpr_msb 0xf9
// ASM-NEXT: v_fma_f32 v255 /*v1023*/, v0 /*v256*/, v0 /*v512*/, v0 /*v768*/
// DIS-LABEL: <clause_break_drop>:
// DIS-NOT: s_clause
// DIS: v_fma_f32 v3, v0, v1, v2
// DIS-NEXT: s_set_vgpr_msb 0xf9
func.func @vgpr_window() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  %cond = waveamdmachine.s_cmp_eq_u32 %zero, %zero
      : (!waveamdmachine.imm, !waveamdmachine.imm)
        -> !waveamdmachine.reg<scc, 1>
  waveamdmachine.label "buffered_high"
  %result = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.uniform_if %cond {
    %then = waveamdmachine.v_fma_f32 %src0, %src1, %src2
        : (!waveamdmachine.reg<vgpr, 1, 256>,
           !waveamdmachine.reg<vgpr, 1, 512>,
           !waveamdmachine.reg<vgpr, 1, 768>)
          -> !waveamdmachine.reg<vgpr, 1, 1022>
    waveamdmachine.yield
  } otherwise {
    %else = waveamdmachine.v_fma_f32 %src0, %src1, %src2
        : (!waveamdmachine.reg<vgpr, 1, 256>,
           !waveamdmachine.reg<vgpr, 1, 512>,
           !waveamdmachine.reg<vgpr, 1, 768>)
          -> !waveamdmachine.reg<vgpr, 1, 1021>
    waveamdmachine.yield
  } : !waveamdmachine.reg<scc, 1>
  waveamdmachine.s_endpgm
  return
}

func.func @explicit_vgpr_window() {
  %mode = waveamdmachine.imm 63993 : !waveamdmachine.imm
  waveamdmachine.s_set_vgpr_msb %mode
      : (!waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}

func.func @buffer_vgpr_window() {
  %off = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %value = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %desc = waveamdmachine.uninit
      : !waveamdmachine.reg<sgpr, 4, 8>
  %zero = waveamdmachine.imm 0 : !waveamdmachine.imm
  waveamdmachine.buffer_store_b32 %off, %value, %desc, %zero
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<sgpr, 4, 8>,
         !waveamdmachine.imm) -> ()
  waveamdmachine.s_endpgm
  return
}

func.func @wmma_vgpr_window() {
  %a = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 256>
  %b = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 512>
  %acc = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 8, 768>
  %result = waveamdmachine.wmma_f32_16x16x32_f16 %a, %b, %acc
      : (!waveamdmachine.reg<vgpr, 8, 256>,
         !waveamdmachine.reg<vgpr, 8, 512>,
         !waveamdmachine.reg<vgpr, 8, 768>)
     -> !waveamdmachine.reg<vgpr, 8, 768>
  waveamdmachine.s_endpgm
  return
}

func.func @coissue_vgpr_window() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  waveamdmachine.s_waitcnt_split loadcnt(0)
  waveamdmachine.s_waitcnt_split xcnt(0)
  %result = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.s_endpgm
  return
}

func.func @mode_setreg_patch() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  %first = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.s_setreg_imm32_b32 value 0 hwreg(1, 0, 32)
  %second = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1022>
  waveamdmachine.s_endpgm
  return
}

func.func @mode_setreg_restore() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  %first = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.s_setreg_imm32_b32 value 0 hwreg(1, 1, 31)
  %second = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1022>
  waveamdmachine.s_endpgm
  return
}

func.func @clause_first_switch() {
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  waveamdmachine.s_clause length 2 breaks 0
  %first = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  %second = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1022>
  waveamdmachine.s_endpgm
  return
}

func.func @clause_resize() {
  %low0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %low1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %low2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 2>
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  waveamdmachine.s_clause length 2 breaks 0
  %low = waveamdmachine.v_fma_f32 %low0, %low1, %low2
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %high = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.s_endpgm
  return
}

func.func @clause_break_drop() {
  %low0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 0>
  %low1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 1>
  %low2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 2>
  %src0 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 256>
  %src1 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 512>
  %src2 = waveamdmachine.uninit
      : !waveamdmachine.reg<vgpr, 1, 768>
  waveamdmachine.s_clause length 2 breaks 1
  %low = waveamdmachine.v_fma_f32 %low0, %low1, %low2
      : (!waveamdmachine.reg<vgpr, 1, 0>,
         !waveamdmachine.reg<vgpr, 1, 1>,
         !waveamdmachine.reg<vgpr, 1, 2>)
        -> !waveamdmachine.reg<vgpr, 1, 3>
  %high = waveamdmachine.v_fma_f32 %src0, %src1, %src2
      : (!waveamdmachine.reg<vgpr, 1, 256>,
         !waveamdmachine.reg<vgpr, 1, 512>,
         !waveamdmachine.reg<vgpr, 1, 768>)
        -> !waveamdmachine.reg<vgpr, 1, 1023>
  waveamdmachine.s_endpgm
  return
}

}
