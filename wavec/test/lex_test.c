/*===- lex_test.c - Unit tests for the lexer ------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Tests the lexer at its own interface
 * (source bytes -> Token array), not end-to-end: feed a source string,
 * assert the exact TokenKind sequence (and, where it matters, the
 * lexeme span and line/col). Covers every required case and every
 * disambiguation rule from CFrontendGrammar.md:
 *   - "0..n" -> INT DOTDOT IDENT (the range-vs-float rule, maximal munch);
 *   - "0.5" -> FLOAT (digit on both sides of the dot);
 *   - "1e9" -> FLOAT (exponent-only alternative);
 *   - "a<<=b" -> IDENT SHL_EQ IDENT (maximal-munch compound assign);
 *   - "simd<float,32>" -> the generic type-constructor token run;
 *   - "auto [v,t]" -> AUTO LBRACKET ... (destructuring), NOT "[[";
 *   - line and block comments are skipped;
 *   - reserved words vs identifiers (builtins stay IDENT);
 *   - bad bytes / non-ASCII / unterminated comment -> ERROR + diagnostic.
 *
 * Uses a CHECK macro (always evaluated, survives -DNDEBUG) like
 * arena_test.c -- assert() would no-op in Release and silently test
 * nothing. No OS calls beyond stdio for failure messages and the arena's
 * single malloc.
 */

#include "arena.h"
#include "diag.h"
#include "lex.h"
#include "token.h"

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Running count of failures; main() returns nonzero if any tripped. */
static int g_failures;

#define CHECK(cond, msg)                                                       \
  do {                                                                         \
    if (!(cond)) {                                                             \
      fprintf(stderr, "CHECK failed at %s:%d: %s (%s)\n", __FILE__, __LINE__,  \
              #cond, (msg));                                                   \
      g_failures++;                                                            \
    }                                                                          \
  } while (0)

/* Lex `src` into `out` using a fresh arena and diag list owned by the
 * caller (both passed in so the test can inspect diagnostics). Returns
 * the TokenArray; the arena must outlive any use of the tokens. */
static TokenArray lex_str(const char *src, Arena *arena, DiagList *diags) {
  LexContext ctx;
  diag_list_init(diags, arena);
  ctx.src = src;
  ctx.src_len = strlen(src);
  ctx.arena = arena;
  ctx.diags = diags;
  return lex_tokenize(&ctx);
}

static const char *const kKindNames[TOK__COUNT] = {
    [TOK_EOF] = "EOF",
    [TOK_ERROR] = "ERROR",
    [TOK_KW_KERNEL] = "kernel",
    [TOK_KW_VOID] = "void",
    [TOK_KW_AUTO] = "auto",
    [TOK_KW_IF] = "if",
    [TOK_KW_ELSE] = "else",
    [TOK_KW_WHERE] = "where",
    [TOK_KW_OTHERWISE] = "otherwise",
    [TOK_KW_FOR] = "for",
    [TOK_KW_IN] = "in",
    [TOK_KW_STEP] = "step",
    [TOK_KW_WHILE] = "while",
    [TOK_KW_AFTER] = "after",
    [TOK_KW_SHARED] = "shared",
    [TOK_KW_BOOL] = "bool",
    [TOK_KW_HALF] = "half",
    [TOK_KW_FLOAT] = "float",
    [TOK_KW_INDEX] = "index",
    [TOK_KW_TOKEN] = "token",
    [TOK_KW_INT8] = "int8_t",
    [TOK_KW_INT16] = "int16_t",
    [TOK_KW_INT32] = "int32_t",
    [TOK_KW_INT64] = "int64_t",
    [TOK_KW_UINT8] = "uint8_t",
    [TOK_KW_UINT16] = "uint16_t",
    [TOK_KW_UINT32] = "uint32_t",
    [TOK_KW_UINT64] = "uint64_t",
    [TOK_KW_SIMD] = "simd",
    [TOK_KW_MASK] = "mask",
    [TOK_KW_VECTOR] = "vector",
    [TOK_KW_FRAGMENT] = "fragment",
    [TOK_IDENT] = "IDENT",
    [TOK_INT_LIT] = "INT",
    [TOK_FLOAT_LIT] = "FLOAT",
    [TOK_LPAREN] = "(",
    [TOK_RPAREN] = ")",
    [TOK_LBRACE] = "{",
    [TOK_RBRACE] = "}",
    [TOK_LBRACKET] = "[",
    [TOK_RBRACKET] = "]",
    [TOK_LATTR] = "[[",
    [TOK_RATTR] = "]]",
    [TOK_COMMA] = ",",
    [TOK_SEMI] = ";",
    [TOK_DOTDOT] = "..",
    [TOK_ARROW] = "->",
    [TOK_ASSIGN] = "=",
    [TOK_PLUS_EQ] = "+=",
    [TOK_MINUS_EQ] = "-=",
    [TOK_STAR_EQ] = "*=",
    [TOK_SLASH_EQ] = "/=",
    [TOK_PERCENT_EQ] = "%=",
    [TOK_AMP_EQ] = "&=",
    [TOK_PIPE_EQ] = "|=",
    [TOK_CARET_EQ] = "^=",
    [TOK_SHL_EQ] = "<<=",
    [TOK_SHR_EQ] = ">>=",
    [TOK_PLUS] = "+",
    [TOK_MINUS] = "-",
    [TOK_STAR] = "*",
    [TOK_SLASH] = "/",
    [TOK_PERCENT] = "%",
    [TOK_SHL] = "<<",
    [TOK_SHR] = ">>",
    [TOK_LT] = "<",
    [TOK_LE] = "<=",
    [TOK_GT] = ">",
    [TOK_GE] = ">=",
    [TOK_EQ] = "==",
    [TOK_NE] = "!=",
    [TOK_AMP] = "&",
    [TOK_PIPE] = "|",
    [TOK_CARET] = "^",
    [TOK_TILDE] = "~",
    [TOK_BANG] = "!",
    [TOK_AMPAMP] = "&&",
    [TOK_PIPEPIPE] = "||",
};

static const char *kind_name(TokenKind k) {
  if ((unsigned)k < TOK__COUNT && kKindNames[k] != NULL)
    return kKindNames[k];
  return "?";
}

/*
 * Assert that lexing `src` yields exactly `expected` (a NULL-less array
 * of kinds whose length is `n`), ignoring the trailing TOK_EOF (which is
 * checked separately for presence and count). Reports the first
 * mismatch with both kinds named. `label` identifies the case.
 */
static void expect_kinds(const char *label, const char *src,
                         const TokenKind *expected, size_t n) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  TokenArray ta = lex_str(src, &arena, &diags);
  size_t i;

  /* The array always ends in exactly one EOF, so count == n + 1. */
  CHECK(ta.tokens != NULL, label);
  if (ta.tokens == NULL) {
    arena_destroy(&arena);
    return;
  }
  if (ta.count != n + 1) {
    fprintf(stderr, "[%s] token count: got %lu, want %lu (+EOF)\n", label,
            (unsigned long)ta.count, (unsigned long)(n + 1));
    g_failures++;
  }

  for (i = 0; i < n && i < ta.count; i++) {
    if (ta.tokens[i].kind != expected[i]) {
      fprintf(stderr, "[%s] token %lu: got %s, want %s\n", label,
              (unsigned long)i, kind_name(ta.tokens[i].kind),
              kind_name(expected[i]));
      g_failures++;
    }
  }

  /* The last token must be the single EOF. */
  if (ta.count >= 1) {
    CHECK(ta.tokens[ta.count - 1].kind == TOK_EOF,
          "stream must end in exactly one EOF");
    CHECK(ta.tokens[ta.count - 1].len == 0, "EOF lexeme length is 0");
  }

  arena_destroy(&arena);
}

/* Convenience: the macro computes the element count from the array. */
#define EXPECT(label, src, ...)                                                \
  do {                                                                         \
    static const TokenKind exp_[] = {__VA_ARGS__};                             \
    expect_kinds((label), (src), exp_, sizeof(exp_) / sizeof(exp_[0]));        \
  } while (0)

/* --- Required cases from the task. ------------------------------------ */

/* "0..n" -> INT, DOTDOT, IDENT (the canonical range-vs-float case). */
static void test_range_vs_float(void) {
  EXPECT("0..n", "0..n", TOK_INT_LIT, TOK_DOTDOT, TOK_IDENT);
  /* And the worked-coverage form "0..K". */
  EXPECT("0..K", "0..K", TOK_INT_LIT, TOK_DOTDOT, TOK_IDENT);
  /* A range between two multi-digit numbers: maximal munch keeps "10"
   * and "20" as ints and the ".." as one token. */
  EXPECT("10..20", "10..20", TOK_INT_LIT, TOK_DOTDOT, TOK_INT_LIT);
}

/* "0.5" -> one FLOAT (digit on both sides of the dot). */
static void test_float_simple(void) {
  EXPECT("0.5", "0.5", TOK_FLOAT_LIT);
  EXPECT("3.14", "3.14", TOK_FLOAT_LIT);
  /* The "f" suffix is part of the float token. */
  EXPECT("0.0f", "0.0f", TOK_FLOAT_LIT);
}

/* "1e9" -> one FLOAT (exponent-only alternative). */
static void test_float_exponent(void) {
  EXPECT("1e9", "1e9", TOK_FLOAT_LIT);
  EXPECT("1E9", "1E9", TOK_FLOAT_LIT);
  EXPECT("2e+10", "2e+10", TOK_FLOAT_LIT);
  EXPECT("6e-3", "6e-3", TOK_FLOAT_LIT);
  /* Fraction plus exponent plus suffix, all one float. */
  EXPECT("1.5e3f", "1.5e3f", TOK_FLOAT_LIT);
  /* An incomplete exponent ("1e" with no digit) is NOT taken: the number
   * is the int part "1", then "e"/"ex" lexes as an identifier. */
  EXPECT("1e (incomplete)", "1e", TOK_INT_LIT, TOK_IDENT);
  EXPECT("1ex (incomplete)", "1ex", TOK_INT_LIT, TOK_IDENT);
}

/* The "digit on both sides of the dot" rule, at its boundaries. These
 * forms are deliberately NOT floats in this grammar, so they surface a
 * stray-dot error rather than being silently accepted -- the rule that
 * frees ".." for ranges. */
static void test_float_dot_boundaries(void) {
  /* No leading-dot float: ".5" is a stray '.' then the int "5". */
  EXPECT("leading dot", ".5", TOK_ERROR, TOK_INT_LIT);
  /* No trailing-dot float: "0." is the int "0" then a stray '.'. */
  EXPECT("trailing dot", "0.", TOK_INT_LIT, TOK_ERROR);
  /* A dot must be followed by a DIGIT, not an exponent: "1.e9" is the
   * int "1", a stray '.', then the identifier "e9". */
  EXPECT("dot before e", "1.e9", TOK_INT_LIT, TOK_ERROR, TOK_IDENT);
  /* No integer 'f' suffix: "3f" is the int "3" then the identifier "f". */
  EXPECT("int f suffix", "3f", TOK_INT_LIT, TOK_IDENT);
}

/* "a<<=b" -> IDENT, SHL_EQ, IDENT (maximal munch picks the 3-byte op). */
static void test_shl_assign(void) {
  EXPECT("a<<=b", "a<<=b", TOK_IDENT, TOK_SHL_EQ, TOK_IDENT);
  /* The 2-byte and 1-byte siblings, to prove the munch boundary. */
  EXPECT("a<<b", "a<<b", TOK_IDENT, TOK_SHL, TOK_IDENT);
  EXPECT("a<b", "a<b", TOK_IDENT, TOK_LT, TOK_IDENT);
  EXPECT("a<=b", "a<=b", TOK_IDENT, TOK_LE, TOK_IDENT);
  EXPECT("a>>=b", "a>>=b", TOK_IDENT, TOK_SHR_EQ, TOK_IDENT);
}

/* "simd<float,32>" -> the generic type-constructor token run. The lexer
 * emits LT/GT (not a special bracket); the parser decides type-args. */
static void test_simd_generic(void) {
  EXPECT("simd<float,32>", "simd<float,32>", TOK_KW_SIMD, TOK_LT, TOK_KW_FLOAT,
         TOK_COMMA, TOK_INT_LIT, TOK_GT);
  /* With spaces, same kinds. */
  EXPECT("simd<float, 32>", "simd<float, 32>", TOK_KW_SIMD, TOK_LT,
         TOK_KW_FLOAT, TOK_COMMA, TOK_INT_LIT, TOK_GT);
  /* mask<32> and vector<float,4>. */
  EXPECT("mask<32>", "mask<32>", TOK_KW_MASK, TOK_LT, TOK_INT_LIT, TOK_GT);
  EXPECT("vector<float,4>", "vector<float,4>", TOK_KW_VECTOR, TOK_LT,
         TOK_KW_FLOAT, TOK_COMMA, TOK_INT_LIT, TOK_GT);
}

/* "auto [v,t]" -> AUTO, LBRACKET, IDENT, COMMA, IDENT, RBRACKET. The "["
 * here is a single bracket (destructuring), NOT the "[[" attribute open;
 * the space is irrelevant -- "[" then "v" cannot munch to "[[". */
static void test_auto_destructure(void) {
  EXPECT("auto [v,t]", "auto [v,t]", TOK_KW_AUTO, TOK_LBRACKET, TOK_IDENT,
         TOK_COMMA, TOK_IDENT, TOK_RBRACKET);
  /* No space, still a single '[' since the next byte is 'v'. */
  EXPECT("auto[v,t]", "auto[v,t]", TOK_KW_AUTO, TOK_LBRACKET, TOK_IDENT,
         TOK_COMMA, TOK_IDENT, TOK_RBRACKET);
}

/* Line and block comments are skipped; tokens on either side survive. */
static void test_comments(void) {
  /* "a // comment\n b" -> IDENT, IDENT (comment to EOL dropped). */
  EXPECT("line comment", "a // comment\nb", TOK_IDENT, TOK_IDENT);
  /* A line comment running to EOF (no trailing newline) is fine. */
  EXPECT("line comment at EOF", "a // tail", TOK_IDENT);
  /* Block comment between two idents, including a newline inside. */
  EXPECT("block comment", "a /* c\nomment */ b", TOK_IDENT, TOK_IDENT);
  /* Block comment with a '*' that is not a close. */
  EXPECT("block star", "a /* * / */ b", TOK_IDENT, TOK_IDENT);
  /* "/" alone is divide, not a comment. */
  EXPECT("divide not comment", "a / b", TOK_IDENT, TOK_SLASH, TOK_IDENT);
}

/* --- Each remaining disambiguation case, made concrete. --------------- */

/* Rule 3 corollary: "0.5" is a float but "0..5" is a range. Both in one
 * stream so the boundary is unmistakable. */
static void test_dot_disambiguation(void) {
  EXPECT("0.5 then 0..5", "0.5 0..5", TOK_FLOAT_LIT, TOK_INT_LIT, TOK_DOTDOT,
         TOK_INT_LIT);
  /* "for index k in 0..K step BK" worked-coverage line. */
  EXPECT("for header", "for index k in 0..K step BK", TOK_KW_FOR, TOK_KW_INDEX,
         TOK_IDENT, TOK_KW_IN, TOK_INT_LIT, TOK_DOTDOT, TOK_IDENT, TOK_KW_STEP,
         TOK_IDENT);
}

/* Rule 2: "i < n" is a compare (LT), not a generic, at the lexer level
 * the lexer always emits LT regardless -- prove it emits LT here. */
static void test_compare_lt(void) {
  EXPECT("i < n", "i < n", TOK_IDENT, TOK_LT, TOK_IDENT);
  EXPECT("mask active = i < n", "mask<32> active = i < n", TOK_KW_MASK, TOK_LT,
         TOK_INT_LIT, TOK_GT, TOK_IDENT, TOK_ASSIGN, TOK_IDENT, TOK_LT,
         TOK_IDENT);
}

/* Rule: "[[" attribute open and "]]" close are single tokens (maximal
 * munch), distinct from two "[" / two "]". */
static void test_attribute_brackets(void) {
  EXPECT("[[amdgpu_wave_size(32)]]", "[[amdgpu_wave_size(32)]]", TOK_LATTR,
         TOK_IDENT, TOK_LPAREN, TOK_INT_LIT, TOK_RPAREN, TOK_RATTR);
  /* Nested: "[ [" with a space is two single brackets. */
  EXPECT("[ [ separate", "[ [", TOK_LBRACKET, TOK_LBRACKET);
}

/* Builtins are predeclared identifiers, NOT reserved words. */
static void test_builtins_are_idents(void) {
  EXPECT("builtins", "lane_id load store barrier wait join lds_base cast",
         TOK_IDENT, TOK_IDENT, TOK_IDENT, TOK_IDENT, TOK_IDENT, TOK_IDENT,
         TOK_IDENT, TOK_IDENT);
  /* index_cast and wave_id_in_grid and workgroup_id are idents too. */
  EXPECT("more builtins", "index_cast wave_id_in_grid workgroup_id", TOK_IDENT,
         TOK_IDENT, TOK_IDENT);
}

/* Every reserved word maps to its own kind (and only those words do). */
static void test_reserved_words(void) {
  EXPECT("non-type keywords",
         "kernel void auto if else where otherwise for in step while after "
         "shared",
         TOK_KW_KERNEL, TOK_KW_VOID, TOK_KW_AUTO, TOK_KW_IF, TOK_KW_ELSE,
         TOK_KW_WHERE, TOK_KW_OTHERWISE, TOK_KW_FOR, TOK_KW_IN, TOK_KW_STEP,
         TOK_KW_WHILE, TOK_KW_AFTER, TOK_KW_SHARED);
  EXPECT("type keywords",
         "bool half float index token int8_t int16_t int32_t int64_t "
         "uint8_t uint16_t uint32_t uint64_t simd mask vector fragment",
         TOK_KW_BOOL, TOK_KW_HALF, TOK_KW_FLOAT, TOK_KW_INDEX, TOK_KW_TOKEN,
         TOK_KW_INT8, TOK_KW_INT16, TOK_KW_INT32, TOK_KW_INT64, TOK_KW_UINT8,
         TOK_KW_UINT16, TOK_KW_UINT32, TOK_KW_UINT64, TOK_KW_SIMD, TOK_KW_MASK,
         TOK_KW_VECTOR, TOK_KW_FRAGMENT);
  /* Words that merely CONTAIN a keyword, or differ by a byte, are
   * identifiers -- prove the match is whole-lexeme, not a prefix. */
  EXPECT("near-keywords are idents", "kernels iff int8 uint forr", TOK_IDENT,
         TOK_IDENT, TOK_IDENT, TOK_IDENT, TOK_IDENT);
}

/* The "->" reserved punctuation and the "token()" seed shape. */
static void test_arrow_and_token_seed(void) {
  EXPECT("arrow", "a -> b", TOK_IDENT, TOK_ARROW, TOK_IDENT);
  /* "token z = token();" -- token is a keyword, then the nullary call. */
  EXPECT("token seed", "token z = token();", TOK_KW_TOKEN, TOK_IDENT,
         TOK_ASSIGN, TOK_KW_TOKEN, TOK_LPAREN, TOK_RPAREN, TOK_SEMI);
}

/* All the compound assignments, maximal-munched off their bare siblings. */
static void test_compound_assigns(void) {
  EXPECT("compound assigns", "+= -= *= /= %= &= |= ^= <<= >>= =", TOK_PLUS_EQ,
         TOK_MINUS_EQ, TOK_STAR_EQ, TOK_SLASH_EQ, TOK_PERCENT_EQ, TOK_AMP_EQ,
         TOK_PIPE_EQ, TOK_CARET_EQ, TOK_SHL_EQ, TOK_SHR_EQ, TOK_ASSIGN);
  /* The logical/relational/bitwise two-byte operators. */
  EXPECT("two-byte ops", "== != <= >= && || << >>", TOK_EQ, TOK_NE, TOK_LE,
         TOK_GE, TOK_AMPAMP, TOK_PIPEPIPE, TOK_SHL, TOK_SHR);
  /* The single-byte operators that the two-byte forms shadow. */
  EXPECT("single-byte ops", "+ - * / % < > = & | ^ ~ !", TOK_PLUS, TOK_MINUS,
         TOK_STAR, TOK_SLASH, TOK_PERCENT, TOK_LT, TOK_GT, TOK_ASSIGN, TOK_AMP,
         TOK_PIPE, TOK_CARET, TOK_TILDE, TOK_BANG);
}

/* Hex literals, decimal literals, and the maximal-munch boundary where a
 * hex digit run stops at a non-hex byte. */
static void test_integer_literals(void) {
  EXPECT("hex", "0x1f 0XFF 0xabcDEF", TOK_INT_LIT, TOK_INT_LIT, TOK_INT_LIT);
  EXPECT("decimal", "0 7 42 1000000", TOK_INT_LIT, TOK_INT_LIT, TOK_INT_LIT,
         TOK_INT_LIT);
  /* "0x10+2" -> INT, PLUS, INT (the hex run stops at '+'). */
  EXPECT("hex then op", "0x10+2", TOK_INT_LIT, TOK_PLUS, TOK_INT_LIT);
}

/* --- Span / position checks (not just kinds). ------------------------- */

/* The lexeme span (offset/len) and 1-based line/col are tracked. */
static void test_spans_and_positions(void) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  /* "ab\n  cd" : ab at 1:1, cd at 2:3 (col is byte-based). */
  TokenArray ta = lex_str("ab\n  cd", &arena, &diags);

  CHECK(ta.count == 3, "two idents + EOF");
  if (ta.count == 3) {
    CHECK(ta.tokens[0].kind == TOK_IDENT, "first is ident");
    CHECK(ta.tokens[0].offset == 0, "first offset 0");
    CHECK(ta.tokens[0].len == 2, "first len 2");
    CHECK(ta.tokens[0].line == 1 && ta.tokens[0].col == 1, "first at 1:1");

    CHECK(ta.tokens[1].kind == TOK_IDENT, "second is ident");
    CHECK(ta.tokens[1].offset == 5, "second offset 5");
    CHECK(ta.tokens[1].len == 2, "second len 2");
    CHECK(ta.tokens[1].line == 2 && ta.tokens[1].col == 3, "second at 2:3");
  }
  arena_destroy(&arena);
}

/* --- Error handling: bad bytes never crash, always ERROR + diag. ------ */

static void test_error_bad_byte(void) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  /* '@' begins no token. Expect IDENT, ERROR, IDENT and one diagnostic. */
  TokenArray ta = lex_str("a@b", &arena, &diags);

  CHECK(ta.count == 4, "ident, error, ident, EOF");
  if (ta.count == 4) {
    CHECK(ta.tokens[0].kind == TOK_IDENT, "a");
    CHECK(ta.tokens[1].kind == TOK_ERROR, "@ is an error token");
    CHECK(ta.tokens[1].offset == 1 && ta.tokens[1].len == 1,
          "error span covers the bad byte");
    CHECK(ta.tokens[2].kind == TOK_IDENT, "b");
  }
  CHECK(diag_has_errors(&diags), "a bad byte records a diagnostic");
  CHECK(diags.error_count == 1, "exactly one error for one bad byte");
  arena_destroy(&arena);
}

/* A non-ASCII byte (> 0x7f) is a lex error (ASCII-only rule), not
 * silently accepted. Build the input with an explicit high byte so the
 * source file itself stays ASCII. */
static void test_error_non_ascii(void) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  char buf[4];
  TokenArray ta;

  buf[0] = 'x';
  buf[1] = (char)0xC3; /* a non-ASCII lead byte. */
  buf[2] = 'y';
  buf[3] = '\0';
  ta = lex_str(buf, &arena, &diags);

  CHECK(ta.count == 4, "ident, error, ident, EOF");
  if (ta.count >= 2)
    CHECK(ta.tokens[1].kind == TOK_ERROR, "non-ASCII byte is an error");
  CHECK(diag_has_errors(&diags), "non-ASCII records a diagnostic");
  arena_destroy(&arena);
}

/* A lone '.' not followed by a digit or another '.' is an error (there is
 * no single-dot token, and floats never start with a dot). */
static void test_error_stray_dot(void) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  TokenArray ta = lex_str("a . b", &arena, &diags);

  CHECK(ta.count == 4, "ident, error, ident, EOF");
  if (ta.count >= 2)
    CHECK(ta.tokens[1].kind == TOK_ERROR, "stray '.' is an error");
  CHECK(diag_has_errors(&diags), "stray dot records a diagnostic");
  arena_destroy(&arena);
}

/* "0x" with no hex digit is a malformed literal -> ERROR + diag (never a
 * silently-accepted zero). */
static void test_error_bad_hex(void) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  TokenArray ta = lex_str("0x", &arena, &diags);

  CHECK(ta.count == 2, "error + EOF");
  if (ta.count >= 1)
    CHECK(ta.tokens[0].kind == TOK_ERROR, "bare 0x is an error");
  CHECK(diag_has_errors(&diags), "bad hex records a diagnostic");
  arena_destroy(&arena);
}

/* An unterminated block comment is reported (not silently swallowed), and
 * the stream still terminates with EOF (no crash, no hang). */
static void test_error_unterminated_comment(void) {
  Arena arena = arena_create(1u << 16);
  DiagList diags;
  TokenArray ta = lex_str("a /* unterminated", &arena, &diags);

  CHECK(ta.count == 2, "ident + EOF (comment consumed to EOF)");
  if (ta.count >= 1)
    CHECK(ta.tokens[0].kind == TOK_IDENT, "the ident before the comment");
  CHECK(ta.tokens[ta.count - 1].kind == TOK_EOF, "still ends in EOF");
  CHECK(diag_has_errors(&diags), "unterminated comment records a diag");
  arena_destroy(&arena);
}

/* Empty input yields exactly one EOF and no errors. */
static void test_empty_input(void) {
  Arena arena = arena_create(4096);
  DiagList diags;
  TokenArray ta = lex_str("", &arena, &diags);

  CHECK(ta.count == 1, "empty input is just EOF");
  if (ta.count == 1)
    CHECK(ta.tokens[0].kind == TOK_EOF, "the one token is EOF");
  CHECK(!diag_has_errors(&diags), "empty input has no errors");
  arena_destroy(&arena);
}

/* --- A whole saxpy kernel: the integration-shaped lexer smoke test. --- */
/* Not a special-case: just confirms the real example tokenizes cleanly
 * (no ERROR tokens, no diagnostics) end to end. */
static void test_saxpy_no_errors(void) {
  static const char *src =
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
  Arena arena = arena_create(1u << 18);
  DiagList diags;
  TokenArray ta = lex_str(src, &arena, &diags);
  size_t i;
  int saw_error = 0;

  CHECK(ta.tokens != NULL, "saxpy lexes to a token array");
  for (i = 0; i < ta.count; i++) {
    if (ta.tokens[i].kind == TOK_ERROR)
      saw_error = 1;
  }
  CHECK(!saw_error, "no ERROR tokens in a valid saxpy");
  CHECK(!diag_has_errors(&diags), "no diagnostics for a valid saxpy");
  CHECK(ta.count >= 2 && ta.tokens[ta.count - 1].kind == TOK_EOF,
        "saxpy stream ends in EOF");
  arena_destroy(&arena);
}

int main(void) {
  g_failures = 0;

  test_range_vs_float();
  test_float_simple();
  test_float_exponent();
  test_float_dot_boundaries();
  test_shl_assign();
  test_simd_generic();
  test_auto_destructure();
  test_comments();
  test_dot_disambiguation();
  test_compare_lt();
  test_attribute_brackets();
  test_builtins_are_idents();
  test_reserved_words();
  test_arrow_and_token_seed();
  test_compound_assigns();
  test_integer_literals();
  test_spans_and_positions();
  test_error_bad_byte();
  test_error_non_ascii();
  test_error_stray_dot();
  test_error_bad_hex();
  test_error_unterminated_comment();
  test_empty_input();
  test_saxpy_no_errors();

  if (g_failures != 0) {
    fprintf(stderr, "lex_test: %d check(s) FAILED\n", g_failures);
    return EXIT_FAILURE;
  }
  printf("lex_test: all checks passed\n");
  return EXIT_SUCCESS;
}
