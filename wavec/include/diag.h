/*===- diag.h - Diagnostics sink ------------------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. A minimal, arena-backed diagnostics
 * collector shared by every stage (lexer/parser/sema). No I/O here --
 * diagnostics are accumulated as records; the driver formats them. This
 * keeps the front free of OS/printf dependencies (Implementation rule:
 * file I/O stays at the entry point).
 *
 * No global state: a DiagList is created over an explicit Arena and
 * threaded through each stage's context.
 */

#ifndef WAVEC_DIAG_H
#define WAVEC_DIAG_H

#include "arena.h"

#include <stddef.h>
#include <stdint.h>

/* Severity of a diagnostic. ERROR makes the overall compile fail;
 * WARNING is advisory (e.g. the "two stores, no token" lint from the
 * design's Memory section); NOTE attaches context to a prior diag. */
typedef enum DiagSeverity {
  DIAG_NOTE = 0,
  DIAG_WARNING,
  DIAG_ERROR
} DiagSeverity;

/*
 * A source span for a diagnostic: a byte range plus the 1-based
 * line/col of its start, mirroring the fields on Token so a Token can be
 * pointed at directly. `len` may be 0 for a point diagnostic (e.g. "EOF
 * expected here").
 */
typedef struct SourceSpan {
  uint32_t offset;
  uint32_t len;
  uint32_t line;
  uint32_t col;
} SourceSpan;

/*
 * One diagnostic record. `message` is a NUL-terminated string owned by
 * the same arena as the DiagList (diag_emit copies the caller's text in
 * so callers may pass a transient buffer). Records form a singly linked
 * list in emission order via `next`.
 */
typedef struct Diag {
  DiagSeverity severity;
  const char *message;
  SourceSpan span;
  struct Diag *next;
} Diag;

/*
 * An ordered collection of diagnostics, arena-backed. `arena` is where
 * both the Diag nodes and the copied message strings are allocated.
 * `head`/`tail` maintain insertion order; `count` and `error_count`
 * are running totals (error_count > 0 means the stage failed).
 */
typedef struct DiagList {
  Arena *arena;
  Diag *head;
  Diag *tail;
  size_t count;
  size_t error_count;
} DiagList;

/*
 * Initialize an empty DiagList that allocates from `arena`. The arena
 * must outlive the DiagList and all diagnostics it holds.
 */
void diag_list_init(DiagList *list, Arena *arena);

/*
 * Append a diagnostic. `message` is copied into the arena (its bytes up
 * to and including a terminating NUL), so the caller may reuse its
 * buffer immediately. On arena exhaustion the diagnostic is dropped but
 * `error_count` is still bumped for DIAG_ERROR so a failing compile is
 * never silently reported as success; the function returns the stored
 * Diag* or NULL if it could not be allocated.
 */
Diag *diag_emit(DiagList *list, DiagSeverity severity, SourceSpan span,
                const char *message);

/* Convenience predicate: did any DIAG_ERROR get emitted? */
int diag_has_errors(const DiagList *list);

#endif /* WAVEC_DIAG_H */
