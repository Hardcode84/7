/*===- diag.c - Diagnostics sink body -------------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. See diag.h for the contract. Pure
 * computation over an arena -- no I/O, no globals.
 */

#include "diag.h"

#include <string.h>

void diag_list_init(DiagList *list, Arena *arena) {
  if (list == NULL)
    return;
  list->arena = arena;
  list->head = NULL;
  list->tail = NULL;
  list->count = 0;
  list->error_count = 0;
}

/* Copy a NUL-terminated string into the arena. Returns the arena copy,
 * or NULL on exhaustion. A NULL input yields an empty arena string so
 * Diag.message is never NULL on success. */
static const char *arena_strdup(Arena *arena, const char *s) {
  size_t len;
  char *copy;

  if (s == NULL)
    s = "";
  len = strlen(s);
  /* +1 for the terminating NUL; char has alignment 1. */
  copy = (char *)arena_alloc(arena, len + 1u, 1u);
  if (copy == NULL)
    return NULL;
  memcpy(copy, s, len + 1u);
  return copy;
}

Diag *diag_emit(DiagList *list, DiagSeverity severity, SourceSpan span,
                const char *message) {
  Diag *node;
  const char *msg_copy;

  if (list == NULL)
    return NULL;

  /* Count the error regardless of whether allocation below succeeds, so
   * an out-of-memory condition can never downgrade a failing compile to
   * a passing one. */
  if (severity == DIAG_ERROR)
    list->error_count++;

  node = (Diag *)arena_alloc(list->arena, sizeof(Diag), sizeof(void *));
  if (node == NULL)
    return NULL;

  msg_copy = arena_strdup(list->arena, message);
  if (msg_copy == NULL)
    return NULL; /* error_count already bumped above if applicable. */

  node->severity = severity;
  node->message = msg_copy;
  node->span = span;
  node->next = NULL;

  if (list->tail == NULL)
    list->head = node;
  else
    list->tail->next = node;
  list->tail = node;
  list->count++;
  return node;
}

int diag_has_errors(const DiagList *list) {
  if (list == NULL)
    return 0;
  return list->error_count > 0;
}
