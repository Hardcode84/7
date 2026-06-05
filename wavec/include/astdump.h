/*===- astdump.h - Deterministic AST text dump ----------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. A debugging/testing serializer: an
 * AST -> a deterministic, human-readable text form. This is the
 * observable output the parser and sema tests assert on (feed source,
 * parse, dump, compare) -- the data-structure boundary that lets each
 * stage be tested at its own interface (Implementation rule: every
 * stage tested independently). Signatures only; src/astdump.c links
 * only libc, no MLIR.
 *
 * The format is an S-expression-like indented tree. It is DETERMINISTIC
 * (no pointer addresses, no hash-ordered output) so golden comparisons
 * are stable. When `include_types` is set and the AST has been through
 * sema, each expression node also prints its resolved `sema_type`, so
 * the same dumper serves parser tests (types off) and sema tests
 * (types on).
 */

#ifndef WAVEC_ASTDUMP_H
#define WAVEC_ASTDUMP_H

#include "arena.h"
#include "ast.h"

#include <stddef.h>

/*
 * Options controlling the dump. `include_types` toggles printing each
 * Expr's resolved sema_type (use 0 for parser tests, 1 for sema tests).
 * `indent_width` is spaces per nesting level (0 selects a default of 2).
 */
typedef struct AstDumpOptions {
  int include_types;
  int indent_width;
} AstDumpOptions;

/*
 * Serialize `program` to a NUL-terminated string allocated from
 * `arena`. Returns the string, or NULL on arena exhaustion. The output
 * is stable across runs for a given AST and options. A NULL `program`
 * yields the empty string (not NULL) on a live arena.
 */
const char *astdump_program(Arena *arena, const Program *program,
                            const AstDumpOptions *options);

/*
 * Serialize a single expression subtree (handy for focused expression
 * tests). Same return contract as astdump_program.
 */
const char *astdump_expr(Arena *arena, const Expr *expr,
                         const AstDumpOptions *options);

#endif /* WAVEC_ASTDUMP_H */
