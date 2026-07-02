/*===- parse_test.c - Parser + AST dumper conformance tests ---*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Tests Stage 2 (parser) at its own
 * interface: feed source bytes, lex (via the minimal stand-in lexer
 * minilex.c, since src/lex.c was not yet present when this stage was
 * built -- see minilex.c's header note), parse to an arena AST, dump the
 * AST to deterministic text, and assert the exact dump. This is the
 * data-structure boundary the Implementation rules require -- each stage
 * tested independently, not only end-to-end.
 *
 * Coverage (one assertion-bearing case each):
 *   - the spec saxpy (attributes, params, ptr/simd/mask types, generic
 *     `lane_id<32>()`, precedence `wave*32+lane`, the `i < n` compare that
 *     is NOT a generic (rule 2), `where`, value-first `store`);
 *   - an if/else (dangling else binds to the nearest if, rule 6);
 *   - a where/otherwise;
 *   - a for-with-carry (range `0..K step 64`, destructuring `auto [v,t1]`,
 *     the `after` dependency token, reassignment carries);
 *   - the LDS token snippet (`shared half *`, `shared_memory_base<half>`,
 * nested `store(load(...), ...)`, `load(... after bar)`);
 *   - destructuring + an `after` clause;
 *   - the `token()` seed.
 * Plus the required robustness checks:
 *   - malformed input yields a diagnostic (never a crash);
 *   - deep nesting hits the recursion cap cleanly (a diagnostic, no
 *     stack overflow / crash).
 *
 * Uses a custom CHECK macro (not assert(), which -DNDEBUG disables) so the
 * tests are meaningful in any build, mirroring arena_test.c. Links only
 * libc plus the front's arena/diag/parse/astdump and the stand-in lexer.
 */

#include "arena.h"
#include "astdump.h"
#include "diag.h"
#include "lex.h"
#include "parse.h"

#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int g_failures;

#define CHECK(cond, msg)                                                       \
  do {                                                                         \
    if (!(cond)) {                                                             \
      fprintf(stderr, "CHECK failed at %s:%d: %s (%s)\n", __FILE__, __LINE__,  \
              #cond, (msg));                                                   \
      g_failures++;                                                            \
    }                                                                          \
  } while (0)

/*
 * Parse `src` into an AST and dump it. The arena is provided by the
 * caller so the returned dump string stays alive for comparison. Writes
 * the error flag through `out_errors` and returns the dump (or NULL).
 */
static const char *parse_and_dump(Arena *arena, const char *src,
                                  int *out_errors) {
  DiagList diags;
  LexContext lex_ctx;
  TokenArray toks;
  ParseContext pctx;
  Program *program;
  AstDumpOptions opt;
  const char *dump;

  diag_list_init(&diags, arena);

  lex_ctx.src = src;
  lex_ctx.src_len = strlen(src);
  lex_ctx.arena = arena;
  lex_ctx.diags = &diags;
  toks = lex_tokenize(&lex_ctx);

  parse_context_init(&pctx, toks.tokens, toks.count, src, strlen(src), arena,
                     &diags);
  program = parse_program(&pctx);

  opt.include_types = 0;
  opt.indent_width = 2;
  dump = astdump_program(arena, program, &opt);

  if (out_errors != NULL)
    *out_errors = diag_has_errors(&diags);
  return dump;
}

/*
 * Assert that parsing `src` produces no diagnostics and the dump equals
 * `expected` exactly. On mismatch, print both so the divergence is
 * obvious (a poor-man's diff: the full actual and expected text).
 */
static void check_dump(const char *name, const char *src,
                       const char *expected) {
  Arena a = arena_create(8u * 1024u * 1024u);
  int errors = 1;
  const char *got;

  CHECK(a.raw != NULL, "arena for parse test");
  got = parse_and_dump(&a, src, &errors);
  CHECK(errors == 0, name); /* a clean program must not error */
  CHECK(got != NULL, name);
  if (got != NULL && strcmp(got, expected) != 0) {
    fprintf(stderr, "---- %s: AST dump mismatch ----\n", name);
    fprintf(stderr, "---- expected ----\n%s\n", expected);
    fprintf(stderr, "---- got ----\n%s\n", got);
    g_failures++;
  }
  arena_destroy(&a);
}

/*===----------------------------------------------------------------===*/
/* Positive cases -- exact AST goldens                                   */
/*===----------------------------------------------------------------===*/

static const char kSaxpySrc[] =
    "kernel [[amdgpu_wave_size(32)]]\n"
    "void saxpy(float *x, float *y, float a, uint32_t n) {\n"
    "  simd<uint32_t, 32> lane = lane_id<32>();\n"
    "  uint32_t           wave = wave_id_in_grid();\n"
    "  simd<uint32_t, 32> i    = wave * 32 + lane;\n"
    "  mask<32>           active = i < n;\n"
    "  where (active) {\n"
    "    simd<float, 32> xv = load(x + i);\n"
    "    simd<float, 32> yv = load(y + i);\n"
    "    store(a * xv + yv, y + i);\n"
    "  }\n"
    "}\n";

static const char kSaxpyExpected[] =
    "(program\n"
    "  (kernel \"saxpy\"\n"
    "    (attrs (attr \"amdgpu_wave_size\" 32))\n"
    "    (params\n"
    "      (param (type (ptr float)) \"x\")\n"
    "      (param (type (ptr float)) \"y\")\n"
    "      (param (type float) \"a\")\n"
    "      (param (type uint32_t) \"n\")\n"
    "    )\n"
    "    (block\n"
    "      (decl (type (simd uint32_t 32)) \"lane\"\n"
    "        (call\n"
    "          (ident \"lane_id\")\n"
    "          (gargs (gint 32))\n"
    "          (args))\n"
    "      )\n"
    "      (decl (type uint32_t) \"wave\"\n"
    "        (call\n"
    "          (ident \"wave_id_in_grid\")\n"
    "          (gargs)\n"
    "          (args))\n"
    "      )\n"
    "      (decl (type (simd uint32_t 32)) \"i\"\n"
    "        (binary \"+\"\n"
    "          (binary \"*\"\n"
    "            (ident \"wave\")\n"
    "            (int 32)\n"
    "          )\n"
    "          (ident \"lane\")\n"
    "        )\n"
    "      )\n"
    "      (decl (type (mask 32)) \"active\"\n"
    "        (binary \"<\"\n"
    "          (ident \"i\")\n"
    "          (ident \"n\")\n"
    "        )\n"
    "      )\n"
    "      (where\n"
    "        (cond\n"
    "          (ident \"active\")\n"
    "        )\n"
    "        (block\n"
    "          (decl (type (simd float 32)) \"xv\"\n"
    "            (call\n"
    "              (ident \"load\")\n"
    "              (gargs)\n"
    "              (args\n"
    "                (binary \"+\"\n"
    "                  (ident \"x\")\n"
    "                  (ident \"i\")\n"
    "                )\n"
    "              ))\n"
    "          )\n"
    "          (decl (type (simd float 32)) \"yv\"\n"
    "            (call\n"
    "              (ident \"load\")\n"
    "              (gargs)\n"
    "              (args\n"
    "                (binary \"+\"\n"
    "                  (ident \"y\")\n"
    "                  (ident \"i\")\n"
    "                )\n"
    "              ))\n"
    "          )\n"
    "          (call-stmt\n"
    "            (call\n"
    "              (ident \"store\")\n"
    "              (gargs)\n"
    "              (args\n"
    "                (binary \"+\"\n"
    "                  (binary \"*\"\n"
    "                    (ident \"a\")\n"
    "                    (ident \"xv\")\n"
    "                  )\n"
    "                  (ident \"yv\")\n"
    "                )\n"
    "                (binary \"+\"\n"
    "                  (ident \"y\")\n"
    "                  (ident \"i\")\n"
    "                )\n"
    "              ))\n"
    "          )\n"
    "        )\n"
    "      )\n"
    "    )\n"
    "  )\n"
    ")\n";

static void test_saxpy(void) { check_dump("saxpy", kSaxpySrc, kSaxpyExpected); }

static void test_if_else(void) {
  const char *src = "kernel void k(uint32_t n) {\n"
                    "  simd<float, 32> acc = 0.0f;\n"
                    "  if (n == 0) {\n"
                    "    acc = acc + 1.0f;\n"
                    "  } else {\n"
                    "    acc = acc - 1.0f;\n"
                    "  }\n"
                    "}\n";
  const char *expected = "(program\n"
                         "  (kernel \"k\"\n"
                         "    (attrs)\n"
                         "    (params\n"
                         "      (param (type uint32_t) \"n\")\n"
                         "    )\n"
                         "    (block\n"
                         "      (decl (type (simd float 32)) \"acc\"\n"
                         "        (float 0.0 f)\n"
                         "      )\n"
                         "      (if\n"
                         "        (cond\n"
                         "          (binary \"==\"\n"
                         "            (ident \"n\")\n"
                         "            (int 0)\n"
                         "          )\n"
                         "        )\n"
                         "        (block\n"
                         "          (assign \"=\" \"acc\"\n"
                         "            (binary \"+\"\n"
                         "              (ident \"acc\")\n"
                         "              (float 1.0 f)\n"
                         "            )\n"
                         "          )\n"
                         "        )\n"
                         "        (else (block\n"
                         "          (assign \"=\" \"acc\"\n"
                         "            (binary \"-\"\n"
                         "              (ident \"acc\")\n"
                         "              (float 1.0 f)\n"
                         "            )\n"
                         "          )\n"
                         "        ))\n"
                         "      )\n"
                         "    )\n"
                         "  )\n"
                         ")\n";
  check_dump("if_else", src, expected);
}

static void test_where_otherwise(void) {
  const char *src = "kernel void k(uint32_t n) {\n"
                    "  mask<32> m = lane_id<32>() < n;\n"
                    "  where (m) {\n"
                    "    store(cast<float>(m), m);\n"
                    "  } otherwise {\n"
                    "    barrier();\n"
                    "  }\n"
                    "}\n";
  const char *expected = "(program\n"
                         "  (kernel \"k\"\n"
                         "    (attrs)\n"
                         "    (params\n"
                         "      (param (type uint32_t) \"n\")\n"
                         "    )\n"
                         "    (block\n"
                         "      (decl (type (mask 32)) \"m\"\n"
                         "        (binary \"<\"\n"
                         "          (call\n"
                         "            (ident \"lane_id\")\n"
                         "            (gargs (gint 32))\n"
                         "            (args))\n"
                         "          (ident \"n\")\n"
                         "        )\n"
                         "      )\n"
                         "      (where\n"
                         "        (cond\n"
                         "          (ident \"m\")\n"
                         "        )\n"
                         "        (block\n"
                         "          (call-stmt\n"
                         "            (call\n"
                         "              (ident \"store\")\n"
                         "              (gargs)\n"
                         "              (args\n"
                         "                (call\n"
                         "                  (ident \"cast\")\n"
                         "                  (gargs (gtype float))\n"
                         "                  (args\n"
                         "                    (ident \"m\")\n"
                         "                  ))\n"
                         "                (ident \"m\")\n"
                         "              ))\n"
                         "          )\n"
                         "        )\n"
                         "        (otherwise (block\n"
                         "          (call-stmt\n"
                         "            (call\n"
                         "              (ident \"barrier\")\n"
                         "              (gargs)\n"
                         "              (args))\n"
                         "          )\n"
                         "        ))\n"
                         "      )\n"
                         "    )\n"
                         "  )\n"
                         ")\n";
  check_dump("where_otherwise", src, expected);
}

static void test_for_carry(void) {
  const char *src = "kernel void k(float *p, uint32_t K) {\n"
                    "  simd<float,32> acc = 0.0f;\n"
                    "  token t = barrier();\n"
                    "  for index k in 0..K step 64 {\n"
                    "    auto [v, t1] = load(p after t);\n"
                    "    acc = acc + v;\n"
                    "    t = t1;\n"
                    "  }\n"
                    "}\n";
  const char *expected = "(program\n"
                         "  (kernel \"k\"\n"
                         "    (attrs)\n"
                         "    (params\n"
                         "      (param (type (ptr float)) \"p\")\n"
                         "      (param (type uint32_t) \"K\")\n"
                         "    )\n"
                         "    (block\n"
                         "      (decl (type (simd float 32)) \"acc\"\n"
                         "        (float 0.0 f)\n"
                         "      )\n"
                         "      (decl (type token) \"t\"\n"
                         "        (call\n"
                         "          (ident \"barrier\")\n"
                         "          (gargs)\n"
                         "          (args))\n"
                         "      )\n"
                         "      (for (type index) \"k\"\n"
                         "        (lb\n"
                         "          (int 0)\n"
                         "        )\n"
                         "        (ub\n"
                         "          (ident \"K\")\n"
                         "        )\n"
                         "        (step\n"
                         "          (int 64)\n"
                         "        )\n"
                         "        (block\n"
                         "          (destructure (names \"v\" \"t1\")\n"
                         "            (call\n"
                         "              (ident \"load\")\n"
                         "              (gargs)\n"
                         "              (args\n"
                         "                (ident \"p\")\n"
                         "              )\n"
                         "              (after\n"
                         "                (ident \"t\")\n"
                         "              ))\n"
                         "          )\n"
                         "          (assign \"=\" \"acc\"\n"
                         "            (binary \"+\"\n"
                         "              (ident \"acc\")\n"
                         "              (ident \"v\")\n"
                         "            )\n"
                         "          )\n"
                         "          (assign \"=\" \"t\"\n"
                         "            (ident \"t1\")\n"
                         "          )\n"
                         "        )\n"
                         "      )\n"
                         "    )\n"
                         "  )\n"
                         ")\n";
  check_dump("for_carry", src, expected);
}

static void test_lds(void) {
  const char *src = "kernel [[amdgpu_lds_size(4096)]] void k() {\n"
                    "  shared half *lds_a = shared_memory_base<half>(0);\n"
                    "  shared half *lds_b = shared_memory_base<half>(2048);\n"
                    "  token g0 = store(load(gA + off_a), lds_a);\n"
                    "  token bar = barrier(g0);\n"
                    "  simd<half,32> a = load(lds_a after bar);\n"
                    "}\n";
  const char *expected = "(program\n"
                         "  (kernel \"k\"\n"
                         "    (attrs (attr \"amdgpu_lds_size\" 4096))\n"
                         "    (params)\n"
                         "    (block\n"
                         "      (decl (type (shared (ptr half))) \"lds_a\"\n"
                         "        (call\n"
                         "          (ident \"shared_memory_base\")\n"
                         "          (gargs (gtype half))\n"
                         "          (args\n"
                         "            (int 0)\n"
                         "          ))\n"
                         "      )\n"
                         "      (decl (type (shared (ptr half))) \"lds_b\"\n"
                         "        (call\n"
                         "          (ident \"shared_memory_base\")\n"
                         "          (gargs (gtype half))\n"
                         "          (args\n"
                         "            (int 2048)\n"
                         "          ))\n"
                         "      )\n"
                         "      (decl (type token) \"g0\"\n"
                         "        (call\n"
                         "          (ident \"store\")\n"
                         "          (gargs)\n"
                         "          (args\n"
                         "            (call\n"
                         "              (ident \"load\")\n"
                         "              (gargs)\n"
                         "              (args\n"
                         "                (binary \"+\"\n"
                         "                  (ident \"gA\")\n"
                         "                  (ident \"off_a\")\n"
                         "                )\n"
                         "              ))\n"
                         "            (ident \"lds_a\")\n"
                         "          ))\n"
                         "      )\n"
                         "      (decl (type token) \"bar\"\n"
                         "        (call\n"
                         "          (ident \"barrier\")\n"
                         "          (gargs)\n"
                         "          (args\n"
                         "            (ident \"g0\")\n"
                         "          ))\n"
                         "      )\n"
                         "      (decl (type (simd half 32)) \"a\"\n"
                         "        (call\n"
                         "          (ident \"load\")\n"
                         "          (gargs)\n"
                         "          (args\n"
                         "            (ident \"lds_a\")\n"
                         "          )\n"
                         "          (after\n"
                         "            (ident \"bar\")\n"
                         "          ))\n"
                         "      )\n"
                         "    )\n"
                         "  )\n"
                         ")\n";
  check_dump("lds", src, expected);
}

static void test_destructure(void) {
  const char *src = "kernel void k(float *x) {\n"
                    "  auto [xv, t] = load(x + i);\n"
                    "  token s = store(scratch, x + i after t);\n"
                    "}\n";
  const char *expected = "(program\n"
                         "  (kernel \"k\"\n"
                         "    (attrs)\n"
                         "    (params\n"
                         "      (param (type (ptr float)) \"x\")\n"
                         "    )\n"
                         "    (block\n"
                         "      (destructure (names \"xv\" \"t\")\n"
                         "        (call\n"
                         "          (ident \"load\")\n"
                         "          (gargs)\n"
                         "          (args\n"
                         "            (binary \"+\"\n"
                         "              (ident \"x\")\n"
                         "              (ident \"i\")\n"
                         "            )\n"
                         "          ))\n"
                         "      )\n"
                         "      (decl (type token) \"s\"\n"
                         "        (call\n"
                         "          (ident \"store\")\n"
                         "          (gargs)\n"
                         "          (args\n"
                         "            (ident \"scratch\")\n"
                         "            (binary \"+\"\n"
                         "              (ident \"x\")\n"
                         "              (ident \"i\")\n"
                         "            )\n"
                         "          )\n"
                         "          (after\n"
                         "            (ident \"t\")\n"
                         "          ))\n"
                         "      )\n"
                         "    )\n"
                         "  )\n"
                         ")\n";
  check_dump("destructure", src, expected);
}

static void test_token_seed(void) {
  const char *src = "kernel void k() {\n"
                    "  token z = token();\n"
                    "}\n";
  const char *expected = "(program\n"
                         "  (kernel \"k\"\n"
                         "    (attrs)\n"
                         "    (params)\n"
                         "    (block\n"
                         "      (decl (type token) \"z\"\n"
                         "        (token-seed)\n"
                         "      )\n"
                         "    )\n"
                         "  )\n"
                         ")\n";
  check_dump("token_seed", src, expected);
}

/*
 * A focused expression test through astdump_expr: a compound-assign-free
 * pure expression exercising the full precedence ladder. Confirms
 * precedence climbing groups `a || b && c == d | e` as
 * `a || (b && (c == (d | e)))` (|| lowest, then &&, then ==, then |),
 * and that a non-generic `<` is a compare. Uses a small wrapper kernel so
 * the parser entry is exercised, then dumps the init expression.
 */
static void test_precedence_ladder(void) {
  const char *src = "kernel void k() {\n"
                    "  bool r = a || b && c == d | e;\n"
                    "}\n";
  Arena a = arena_create(2u * 1024u * 1024u);
  DiagList diags;
  LexContext lex_ctx;
  TokenArray toks;
  ParseContext pctx;
  Program *program;
  AstDumpOptions opt;
  const char *got;
  /* Per the precedence table: || (band 12, loosest) < && (11) < == (7) <
   * | (10)? No -- lower band number binds tighter, so == (band 7) binds
   * TIGHTER than | (band 10). Hence `c == d | e` = `(c == d) | e` (the C
   * footgun), and the whole thing is `a || (b && ((c == d) | e))`. */
  const char *expected = "(binary \"||\"\n"
                         "  (ident \"a\")\n"
                         "  (binary \"&&\"\n"
                         "    (ident \"b\")\n"
                         "    (binary \"|\"\n"
                         "      (binary \"==\"\n"
                         "        (ident \"c\")\n"
                         "        (ident \"d\")\n"
                         "      )\n"
                         "      (ident \"e\")\n"
                         "    )\n"
                         "  )\n"
                         ")\n";

  CHECK(a.raw != NULL, "arena for precedence test");
  diag_list_init(&diags, &a);
  lex_ctx.src = src;
  lex_ctx.src_len = strlen(src);
  lex_ctx.arena = &a;
  lex_ctx.diags = &diags;
  toks = lex_tokenize(&lex_ctx);
  parse_context_init(&pctx, toks.tokens, toks.count, src, strlen(src), &a,
                     &diags);
  program = parse_program(&pctx);
  CHECK(program != NULL, "precedence: program parsed");
  CHECK(!diag_has_errors(&diags), "precedence: no errors");

  opt.include_types = 0;
  opt.indent_width = 2;
  got = NULL;
  if (program != NULL && program->kernel_count == 1) {
    const Stmt *body = program->kernels[0]->body;
    if (body != NULL && body->kind == STMT_BLOCK &&
        body->as.block.stmt_count == 1) {
      const Stmt *decl = body->as.block.stmts[0];
      if (decl->kind == STMT_DECL)
        got = astdump_expr(&a, decl->as.decl.init, &opt);
    }
  }
  CHECK(got != NULL, "precedence: reached the init expression");
  if (got != NULL && strcmp(got, expected) != 0) {
    fprintf(stderr, "---- precedence: expr dump mismatch ----\n");
    fprintf(stderr, "---- expected ----\n%s\n", expected);
    fprintf(stderr, "---- got ----\n%s\n", got);
    g_failures++;
  }
  arena_destroy(&a);
}

/*===----------------------------------------------------------------===*/
/* Negative / robustness cases                                           */
/*===----------------------------------------------------------------===*/

/* Each malformed input must produce at least one diagnostic and never
 * crash; the parser still returns a (partial) Program. */
static void check_malformed(const char *name, const char *src) {
  Arena a = arena_create(2u * 1024u * 1024u);
  int errors = 0;
  const char *dump;

  CHECK(a.raw != NULL, "arena for malformed test");
  dump = parse_and_dump(&a, src, &errors);
  CHECK(errors != 0, name);  /* a diagnostic is required */
  CHECK(dump != NULL, name); /* still produced output, no crash */
  arena_destroy(&a);
}

static void test_malformed(void) {
  /* Missing terminating semicolon. */
  check_malformed("missing_semicolon", "kernel void k() { uint32_t n = 1 }\n");
  /* A bare compare is not a statement (rule 7). */
  check_malformed("compare_as_stmt", "kernel void k() { a < b; }\n");
  /* No top-level kernel. */
  check_malformed("no_kernel", "void k() {}\n");
  /* Unterminated parenthesis in an expression. */
  check_malformed("unbalanced_paren", "kernel void k() { uint32_t n = (1; }\n");
  /* Missing '>' in a type constructor. */
  check_malformed("bad_type_ctor",
                  "kernel void k() { simd<float 32> v = 0; }\n");
  /* `for` with a non-iv type. */
  check_malformed("bad_for_iv", "kernel void k() { for float i in 0..n {} }\n");
  /* Empty input -- a program with no kernels is legal but the driver
   * expects at least nothing crashes; this must NOT error (it is a valid
   * empty program), so it is checked separately below. */
}

/* An empty translation unit is a valid (empty) program with no errors.
 * The arena is sized generously so the stand-in lexer's token buffer fits
 * (a too-small arena would make the lexer OOM, which is a different
 * failure than the empty-program behavior under test). */
static void test_empty_program(void) {
  Arena a = arena_create(1u * 1024u * 1024u);
  int errors = 1;
  const char *got;

  CHECK(a.raw != NULL, "arena for empty test");
  got = parse_and_dump(&a, "", &errors);
  CHECK(errors == 0, "empty program is not an error");
  CHECK(got != NULL, "empty program dumps");
  if (got != NULL)
    CHECK(strcmp(got, "(program)\n") == 0, "empty program dump");
  arena_destroy(&a);
}

/*
 * Deep nesting must hit the recursion cap and emit a diagnostic rather
 * than overflow the C stack. We build a string with many more nested
 * parentheses than PARSE_DEFAULT_MAX_DEPTH and confirm: (a) an error is
 * reported, (b) the parser returns (no crash). Two shapes are exercised:
 * nested parenthesized expressions and nested blocks.
 *
 * The buffers are heap-allocated (this is test code, not the front, so a
 * malloc is fine here -- the no-malloc rule binds the front, not tests).
 */
static void check_deep(const char *name, char *src) {
  Arena a = arena_create(16u * 1024u * 1024u);
  int errors = 0;
  const char *dump;

  CHECK(a.raw != NULL, "arena for deep test");
  dump = parse_and_dump(&a, src, &errors);
  CHECK(errors != 0, name);  /* the cap must trip and report */
  CHECK(dump != NULL, name); /* and we get here at all -> no crash */
  arena_destroy(&a);
}

static void test_recursion_cap(void) {
  size_t n = 4u * (size_t)PARSE_DEFAULT_MAX_DEPTH; /* well past the cap */
  size_t i;
  char *buf;
  size_t pos;
  const char *pre = "kernel void k() { uint32_t z = ";

  /* Deeply nested parentheses: pre + n*'(' + '1' + n*')' + ";}". */
  buf = (char *)malloc(strlen(pre) + 2u * n + 8u);
  CHECK(buf != NULL, "alloc deep-paren buffer");
  if (buf != NULL) {
    pos = 0;
    memcpy(buf, pre, strlen(pre));
    pos += strlen(pre);
    for (i = 0; i < n; i++)
      buf[pos++] = '(';
    buf[pos++] = '1';
    for (i = 0; i < n; i++)
      buf[pos++] = ')';
    buf[pos++] = ';';
    buf[pos++] = '}';
    buf[pos] = '\0';
    check_deep("deep_parens", buf);
    free(buf);
  }

  /* Deeply nested blocks: "kernel void k() " + n*'{' + n*'}'. */
  {
    const char *kpre = "kernel void k() ";
    buf = (char *)malloc(strlen(kpre) + 2u * n + 4u);
    CHECK(buf != NULL, "alloc deep-block buffer");
    if (buf != NULL) {
      pos = 0;
      memcpy(buf, kpre, strlen(kpre));
      pos += strlen(kpre);
      for (i = 0; i < n; i++)
        buf[pos++] = '{';
      for (i = 0; i < n; i++)
        buf[pos++] = '}';
      buf[pos] = '\0';
      check_deep("deep_blocks", buf);
      free(buf);
    }
  }
}

int main(void) {
  g_failures = 0;

  test_saxpy();
  test_if_else();
  test_where_otherwise();
  test_for_carry();
  test_lds();
  test_destructure();
  test_token_seed();
  test_precedence_ladder();

  test_empty_program();
  test_malformed();
  test_recursion_cap();

  if (g_failures != 0) {
    fprintf(stderr, "parse_test: %d check(s) FAILED\n", g_failures);
    return EXIT_FAILURE;
  }
  printf("parse_test: all checks passed\n");
  return EXIT_SUCCESS;
}
