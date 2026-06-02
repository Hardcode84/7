# AMDGPU Kernarg Preload Policy

Status: Wave models kernarg preload in IR, but final asm rejects it on current
backend targets.

LLVM reference:

- `GCNSubtarget::needsKernArgPreloadProlog()` is
  `hasKernargPreload() && !HasGFX1250Insts`.
- `AMDGPUPreloadKernArgProlog` inserts a 256-byte entry prolog. Old firmware
  runs it and fills preload SGPRs with `s_load*`; compatible firmware jumps past
  it to the optimized entry.

Wave policy:

- ABI lowering may form `waveamdmachine.kernarg_preload` values for analysis,
  scheduling, and regalloc tests.
- `wave-to-amdgpu-asm` emits preload metadata only for targets that do not need
  the compatibility prolog.
- The current emitter supports gfx8/gfx9/gfx11. The preload-capable targets in
  that set are gfx9-class and need the prolog, so positive preload length hard
  fails at asm emission.
- Default pipelines must not enable kernarg preload until either gfx125x backend
  support lands or a compatibility prolog is implemented.

Prolog implementation plan:

1. Reserve a 256-byte compatibility entry before the real entry.
2. Load sequential kernarg dwords from the kernarg segment pointer into preload
   SGPRs, using the widest aligned `s_load_dword{xN}` chunks available.
3. Emit `s_waitcnt lgkmcnt(0)`.
4. Branch to the real entry and align it to the firmware skip target.
