# AMDGPU Kernarg Preload Policy

Status: Wave enables kernarg preload by default on targets with the LLVM
`kernarg-preload` feature.

LLVM reference:

- `GCNSubtarget::needsKernArgPreloadProlog()` is
  `hasKernargPreload() && !HasGFX1250Insts`.
- `AMDGPUPreloadKernArgProlog` inserts a 256-byte entry prolog. Old firmware
  runs it and fills preload SGPRs with `s_load*`; compatible firmware jumps past
  it to the optimized entry.

Wave policy:

- ABI lowering preloads the longest complete kernarg prefix that fits target
  user-SGPR limits when the kernel has no explicit preload attrs.
- Explicit `waveamdmachine.kernarg_preload_length` / `_offset` attrs keep
  caller policy intact.
- `wave-to-amdgpu-asm` emits preload metadata for preload-capable targets.
- Compatibility prolog is still missing, so old firmware that does not skip the
  256-byte prolog window remains a follow-up.

Prolog implementation plan:

1. Reserve a 256-byte compatibility entry before the real entry.
2. Load sequential kernarg dwords from the kernarg segment pointer into preload
   SGPRs, using the widest aligned `s_load_dword{xN}` chunks available.
3. Emit `s_waitcnt lgkmcnt(0)`.
4. Branch to the real entry and align it to the firmware skip target.
