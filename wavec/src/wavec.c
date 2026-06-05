/*===- wavec.c - Command-line driver --------------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. The entry point: read a source file,
 * run the front (lex -> parse -> sema), print diagnostics, and -- when
 * the lowering bridge is linked in -- emit textual Wave IR.
 *
 * This is the ONE place file I/O is allowed (Implementation rule:
 * "file I/O stays at the entry point"); the stages themselves are pure
 * computation over a byte buffer. The driver owns the arena and threads
 * it, plus a diag sink, through each stage -- no global state.
 *
 * Stages not yet present in the build are gated by the WAVEC_HAVE_*
 * macros the CMake build sets from source availability. A gated-off
 * stage prints a clear "not yet implemented" notice and the driver
 * stops there; it never fakes a result. This keeps the driver honest
 * and always-building while the parallel stage agents fill the front.
 */

#include "arena.h"
#include "diag.h"

#if defined(WAVEC_HAVE_LEX) && WAVEC_HAVE_LEX
#include "lex.h"
#endif
#if defined(WAVEC_HAVE_PARSE) && WAVEC_HAVE_PARSE
#include "parse.h"
#endif
#if defined(WAVEC_HAVE_SEMA) && WAVEC_HAVE_SEMA
#include "sema.h"
#endif
#if defined(WAVEC_HAVE_LOWERING) && WAVEC_HAVE_LOWERING
#include "lower.h"
#endif

#include <stdio.h>
#include <stdlib.h>

/* A generous default arena: large enough for any v1 kernel's tokens +
 * AST. Fixed-capacity by the arena's no-grow policy; oversize rather
 * than risk exhaustion on a real input. */
#define WAVEC_ARENA_BYTES (8u * 1024u * 1024u)

/* Map a severity to a short label for printed diagnostics. */
static const char *severity_label(DiagSeverity sev) {
  switch (sev) {
  case DIAG_ERROR:
    return "error";
  case DIAG_WARNING:
    return "warning";
  case DIAG_NOTE:
    return "note";
  }
  return "diag";
}

/* Print every diagnostic in the list to stderr in emission order. */
static void print_diags(const char *path, const DiagList *diags) {
  const Diag *d;
  for (d = diags->head; d != NULL; d = d->next) {
    fprintf(stderr, "%s:%u:%u: %s: %s\n", path, d->span.line, d->span.col,
            severity_label(d->severity), d->message);
  }
}

/*
 * Read an entire file into a heap buffer (the only stdio file read in
 * the project). Returns the buffer (caller frees) and writes its length
 * through `out_len`; returns NULL on any I/O failure. The buffer is NOT
 * arena-backed: it is the raw input the lexer slices, owned by the
 * driver and freed before exit. NUL-terminated for convenience although
 * the lexer is length-bounded.
 */
static char *read_file(const char *path, size_t *out_len) {
  FILE *f;
  long size;
  size_t n;
  char *buf;

  f = fopen(path, "rb");
  if (f == NULL)
    return NULL;
  if (fseek(f, 0, SEEK_END) != 0) {
    fclose(f);
    return NULL;
  }
  size = ftell(f);
  if (size < 0) {
    fclose(f);
    return NULL;
  }
  if (fseek(f, 0, SEEK_SET) != 0) {
    fclose(f);
    return NULL;
  }
  buf = (char *)malloc((size_t)size + 1u);
  if (buf == NULL) {
    fclose(f);
    return NULL;
  }
  n = fread(buf, 1, (size_t)size, f);
  fclose(f);
  if (n != (size_t)size) {
    free(buf);
    return NULL;
  }
  buf[n] = '\0';
  *out_len = n;
  return buf;
}

int main(int argc, char **argv) {
  const char *path;
  char *src;
  size_t src_len;
  Arena arena;
  DiagList diags;
  int status;

  if (argc != 2) {
    fprintf(stderr, "usage: %s <source.wc>\n", argv[0]);
    return 2;
  }
  path = argv[1];

  src = read_file(path, &src_len);
  if (src == NULL) {
    fprintf(stderr, "%s: error: cannot read file\n", path);
    return 2;
  }

  arena = arena_create(WAVEC_ARENA_BYTES);
  if (arena.raw == NULL) {
    fprintf(stderr, "%s: error: out of memory (arena)\n", path);
    free(src);
    return 2;
  }
  diag_list_init(&diags, &arena);

  status = 0;

#if defined(WAVEC_HAVE_LEX) && WAVEC_HAVE_LEX
  {
    LexContext lex_ctx;
    TokenArray toks;

    /* Stage 1: lex. */
    lex_ctx.src = src;
    lex_ctx.src_len = src_len;
    lex_ctx.arena = &arena;
    lex_ctx.diags = &diags;
    toks = lex_tokenize(&lex_ctx);

#if defined(WAVEC_HAVE_PARSE) && WAVEC_HAVE_PARSE
    {
      ParseContext pctx;
      Program *program;

      parse_context_init(&pctx, toks.tokens, toks.count, src, src_len, &arena,
                         &diags);
      program = parse_program(&pctx);

      if (program == NULL || diag_has_errors(&diags)) {
        status = 1;
      } else {
#if defined(WAVEC_HAVE_SEMA) && WAVEC_HAVE_SEMA
        SemaContext sctx;
        sema_context_init(&sctx, &arena, &diags);
        if (!sema_check(&sctx, program)) {
          status = 1;
        } else {
#if defined(WAVEC_HAVE_LOWERING) && WAVEC_HAVE_LOWERING
          char *mlir = wavec_lower_to_mlir(program, &diags);
          if (mlir == NULL) {
            status = 1;
          } else {
            fputs(mlir, stdout);
            wavec_lower_free(mlir);
          }
#else
          fprintf(stderr,
                  "%s: note: lowering bridge not built; stopping after sema\n",
                  path);
#endif /* lowering */
        }
      }
#else
        fprintf(stderr,
                "%s: note: sema stage not built; stopping after parse\n", path);
      }
#endif /* sema */
    }
#else
    fprintf(stderr,
            "%s: note: parser stage not built; stopping after lex "
            "(%lu tokens)\n",
            path, (unsigned long)toks.count);
#endif /* parse */
  }
#else
  fprintf(stderr, "%s: note: lexer stage not built; nothing to do\n", path);
#endif /* lex */

  if (diag_has_errors(&diags))
    status = 1;
  print_diags(path, &diags);

  arena_destroy(&arena);
  free(src);
  return status;
}
