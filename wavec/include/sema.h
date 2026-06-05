/*===- sema.h - Semantic analysis stage interface -------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Stage 3: a parsed AST -> a checked,
 * type-annotated AST plus diagnostics. Signatures only; src/sema.c
 * links only libc. No global state -- the symbol table and per-kernel
 * context thread through the SemaContext.
 *
 * Sema enforces the Type Rules (CFrontendDesign.md Types/Operators/
 * Control flow, the model md 544-576 checklist) and the Sema-only rules
 * in CFrontendGrammar.md: `shared` needs a star; the closed attribute
 * set; `if` takes bool / `where` takes mask; the `for` IV is int/index;
 * `simd<T,W>`/`mask<W>`/`lane_id<W>` all use the kernel wave width W
 * from [[amdgpu_wave_size(W)]]. It is type PROPAGATION, not a fixpoint:
 * each Expr's `sema_type` is filled in a single bottom-up pass. It does
 * NOT touch MLIR.
 *
 * This header declares the stage boundary only. The internal symbol
 * table and TypeRef-canonicalization helpers live in src/sema.c; the
 * arena and diag sink are the only shared state exposed here.
 */

#ifndef WAVEC_SEMA_H
#define WAVEC_SEMA_H

#include "arena.h"
#include "ast.h"
#include "diag.h"

#include <stddef.h>

/*
 * Sema context. `arena` backs any nodes/types sema materializes (e.g.
 * canonical TypeRefs for literal results) and its internal symbol
 * table. `diags` collects type errors. The wave width is NOT stored
 * here as a global: it is read per-kernel from each kernel's
 * [[amdgpu_wave_size]] attribute during the check, so multiple kernels
 * with different widths in one program each validate against their own
 * W. No file-scope mutable state.
 */
typedef struct SemaContext {
  Arena *arena;
  DiagList *diags;
} SemaContext;

/* Initialize a SemaContext with an arena and diag sink. */
void sema_context_init(SemaContext *ctx, Arena *arena, DiagList *diags);

/*
 * Check and annotate `program` in place: each Expr gets its `sema_type`
 * filled, declarations are scope-checked, and Type Rule violations are
 * reported through `ctx->diags`. Returns 1 if the program is well-typed
 * (no DIAG_ERROR emitted), 0 otherwise. On a feature that is parsed but
 * not yet implemented, sema emits a clear "error: <feature> not
 * supported" diagnostic and returns 0 -- never a fake success. The AST
 * is mutated (annotated) regardless of result; lowering must only run
 * when this returns 1.
 */
int sema_check(SemaContext *ctx, Program *program);

#endif /* WAVEC_SEMA_H */
