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
- On targets needing old-firmware compatibility, `wave-to-amdgpu-asm` emits a
  256-byte prolog that loads preload SGPRs, waits `lgkmcnt(0)`, and branches to
  the real entry.
