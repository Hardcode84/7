# AMDGPU Fused Integer Peepholes

Local WaveAMDMachine greedy rewrite pass. It forms typed fused VALU ops when
the replacement is target-legal, semantics-exact, and cheaper after copies and
pressure.

## Placement

Run after `waveamd-to-machine`, post-selection `canonicalize`/`cse`/LICM,
ABI lowering, and memory tuple decomposition. Run before scheduling, ticket
waits, hardware-register preservation, regalloc, hazard waits, resource info,
metadata, and asm emission.

This placement keeps pointer/index-expression planning ahead of the peephole.
The pass must not hide constants or uniform offsets from memory address slot
selection. If the pass ever moves earlier, reject chains feeding memory address
operands until offset planning has run.

## Target Gate

Resolve the module target through `waveamdmachine.target` and
`getAMDGPUTargetIsaVersion`. Malformed or unsupported targets fail the pass.
Each replacement is gated through the destination op's
`Op::isSupportedOnIsa(isa)` predicate. Unsupported opcodes reject the candidate;
they do not create fallback raw mnemonics.

The pass emits only first-class `waveamdmachine` ops. AMDGPU text still comes
from MCInst/MCInstPrinter.

## Match Boundary

Match inside one block. No cross-block matching, no region boundary crossing,
no general reassociation.

Match from a fixed whitelist of known-pure machine ops. Every erased op must
have one data result, have no flag/token/result state to preserve, and be
single-use by the matched consumer. Reject any candidate that would delete a
value with non-matched users.

Commutative operands may be swapped only for that instruction. Do not rebuild
larger expression trees to make a pattern fit.

## Uniform Values

Keep all-SGPR expressions on the scalar pipe. A fused VALU op is allowed only
when the original chain already produces a VGPR value, or when a VGPR consumer
would force the same VALU materialization anyway.

Reject candidates that need new SGPR-to-VGPR copies, VGPR-to-SGPR copies,
readfirstlane, scalarization, tuple packing/splitting, or extra literal
materialization. Existing SGPR or inline-immediate operands are allowed only
within the target constant-bus limit. Non-inline literal operands are rejected
before gfx10 for these fused ternary ops; MC rejects them even when the generic
constant-bus count would fit.

## Semantics

Match machine integer semantics, not source-language intent.

- 32-bit add families are modulo `2^32`; no carry-out replacement.
- Bitwise families operate on raw `b32`; no mask or predicate reinterpretation.
- Shift-add families require logical-left-shift semantics and the same shift
  count interpretation as the destination ISA instruction.
- Signedness-sensitive MAD/narrow forms use `IntegerRangeAnalysis` facts on
  the multiply operands. Do not infer signedness from op names alone.
- Flag-producing forms (`*_vcc`, scalar ops with SCC results, compares) are not
  source ops for this peephole family.

## Current Opcode Rules

| Source chain | Replacement | Extra conditions |
| --- | --- | --- |
| `v_add_u32(v_add_u32(x, y), z)` | `v_add3_u32 x, y, z` | Inner add single-use, no carry/VCC form. |
| `v_add_u32(v_lshlrev_b32(x, k), z)` | `v_lshl_add_u32 x, k, z` | Shift result single-use; shift operand order follows WaveAMDMachine `v_lshlrev_b32` semantics. |
| `v_lshlrev_b32(v_add_u32(x, y), k)` | `v_add_lshl_u32 x, y, k` | Add result single-use, no carry/VCC form. |
| `v_or_b32(v_and_b32(x, y), z)` | `v_and_or_b32 x, y, z` | Bitwise only. |
| `v_or_b32(v_or_b32(x, y), z)` | `v_or3_b32 x, y, z` | Existing nested OR edge only. |
| `v_add_u32(v_xor_b32(x, y), z)` | `v_xad_u32 x, y, z` | XOR result single-use; add is modulo. |
| `v_add_u32(v_mul_lo_u32(x, y), z)` | `v_mad_u32_u24 x, y, z` | `x` and `y` proven in unsigned 24-bit range. |
| `v_add_u32(v_mul_lo_u32(x, y), z)` | `v_mad_i32_i24 x, y, z` | `x` and `y` proven in signed 24-bit range. |

Commuted outer operands are legal when the outer op is commutative and the
result still satisfies constant-bus and copy rules.

## Profitability

For current fixed `2 -> 1` patterns, single-use is the issue-count proof. The
inner op has exactly one fusable consumer, the outer op is replaced by one fused
op, and no new copies/materializations/pack/extract ops are inserted.

Recompute or query local register pressure before committing a rewrite. Reject
if peak VGPR or SGPR pressure increases, or if the match extends live ranges
enough to exceed an explicit multi-wave/register budget. Until exact pressure
queries are wired into the pass, use the conservative form: only accept matches
whose deleted producer is single-use and whose operands are already live at the
consumer or are immediates/block arguments.

Do not trade scalar-pipe work for VALU work unless the old chain already had to
produce a VGPR and the replacement reduces VALU issue count.

## Diagnostics

Default pipeline stays quiet. Debug/report mode may print the matched family,
the chosen replacement op, and the first rejection reason: target, semantics,
uniform/scalar, constant bus, copies, pressure, or address-slot risk.
