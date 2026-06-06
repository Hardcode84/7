/*===- lex.c - Lexer stage implementation ---------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. See lex.h for the contract. Pure
 * computation over a byte buffer: source bytes -> an arena-allocated
 * array of Tokens, always terminated by exactly one TOK_EOF. Links only
 * libc (string.h for memcmp); NO MLIR, NO OS calls, NO global state --
 * everything threads through the LexContext.
 *
 * Implements the Lexical section of CFrontendGrammar.md:
 *   - line comments "//" and non-nested block comments "/" "*" ... "*" "/";
 *   - identifiers vs the closed reserved-word set (builtins stay IDENT);
 *   - int_lit (decimal and "0x" hex) and float_lit, where a "." opens a
 *     fraction ONLY when immediately followed by a digit (so a float
 *     always has a digit on both sides of the dot), plus the
 *     exponent-only alternative ("1e9");
 *   - maximal-munch operators: ".." is the range token (never float "0."),
 *     "<<"/">>"/"<<="/">>=", the compound assigns, "[["/"]]", "->", the
 *     two-char relational/logical operators;
 *   - ASCII-only input (a byte > 0x7f is a lex error);
 *   - 1-based line/col tracking;
 *   - on a bad byte: a TOK_ERROR token and a diagnostic, then scanning
 *     continues (never crash, never silently skip).
 *
 * Strategy: two passes over the same scanner. Pass 1 counts the tokens
 * (so the array can be allocated exactly once); pass 2 fills the array
 * and emits diagnostics. A single contiguous arena allocation backs the
 * Token array -- no realloc (the arena does not grow) and no per-token
 * allocation interleaving that would fragment the array.
 */

#include "lex.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

/*
 * Scanner state. `pos` is the current byte offset into [0, len]; `line`
 * and `col` are the 1-based position of the byte at `pos`. `out` is the
 * destination array when filling (NULL during the counting pass);
 * `count` is the number of tokens produced so far (and, after a full
 * scan, the total). `cap` bounds writes to `out` defensively so a count
 * mismatch can never overrun the array. `diags` collects errors, but
 * only on the filling pass (NULL while counting) so each error is
 * recorded exactly once.
 */
typedef struct Scanner {
  const char *src;
  size_t len;
  size_t pos;
  uint32_t line;
  uint32_t col;
  Token *out;      /* NULL while counting. */
  size_t count;    /* tokens emitted so far. */
  size_t cap;      /* capacity of `out` (0 while counting). */
  DiagList *diags; /* NULL while counting. */
} Scanner;

/* --- Character classes (ASCII only, per the grammar). ----------------- */

static int is_digit(int c) { return c >= '0' && c <= '9'; }

static int is_hex_digit(int c) {
  return is_digit(c) || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}

static int is_letter(int c) {
  return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z');
}

/* ident-start = letter | '_'. */
static int is_ident_start(int c) { return is_letter(c) || c == '_'; }

/* ident-continue = letter | digit | '_'. */
static int is_ident_continue(int c) {
  return is_letter(c) || is_digit(c) || c == '_';
}

/* A byte that is structurally whitespace per C source conventions; the
 * grammar's tokens are all non-whitespace, so these separate tokens and
 * are otherwise skipped. Vertical tab and form feed are included as
 * benign blanks; only '\n' advances the line counter (handled by the
 * advance helper, not here). */
static int is_space(int c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' ||
         c == '\f';
}

/* --- Low-level cursor helpers. ---------------------------------------- */

/* Peek the byte at offset `pos + ahead`, or -1 if out of range. Returned
 * as an int in [0, 255] so callers compare against char literals and the
 * -1 sentinel without sign-extension surprises. */
static int peek(const Scanner *s, size_t ahead) {
  size_t idx = s->pos + ahead;
  if (idx >= s->len)
    return -1;
  return (unsigned char)s->src[idx];
}

/* Advance one byte, maintaining line/col. A '\n' increments the line and
 * resets the column to 1; any other byte (including the bytes of a
 * "\r\n" pair, where the '\r' just bumps the column) increments the
 * column. Columns are byte-based, as documented on Token. */
static void advance(Scanner *s) {
  int c = (s->pos < s->len) ? (unsigned char)s->src[s->pos] : -1;
  if (c < 0)
    return;
  s->pos++;
  if (c == '\n') {
    s->line++;
    s->col = 1;
  } else {
    s->col++;
  }
}

/* Advance `n` bytes via the line/col-aware single-step advance. */
static void advance_n(Scanner *s, size_t n) {
  size_t i;
  for (i = 0; i < n; i++)
    advance(s);
}

/* --- Token emission. -------------------------------------------------- */

/*
 * Append one token spanning [start_off, s->pos) with the recorded start
 * line/col. On the counting pass (`out` NULL) this only bumps the count;
 * on the filling pass it writes into the array (bounded by `cap`). The
 * length is derived from the current cursor, so callers advance the
 * cursor over the lexeme first, then emit.
 */
static void emit(Scanner *s, TokenKind kind, uint32_t start_off,
                 uint32_t start_line, uint32_t start_col) {
  if (s->out != NULL && s->count < s->cap) {
    Token *t = &s->out[s->count];
    t->kind = kind;
    t->offset = start_off;
    t->len = (uint32_t)(s->pos - (size_t)start_off);
    t->line = start_line;
    t->col = start_col;
  }
  s->count++;
}

/* Record a lex-error diagnostic for the span [start_off, s->pos) (only
 * on the filling pass). The accompanying TOK_ERROR token is emitted by
 * the caller so the span and the token stay in lockstep. */
static void lex_error(Scanner *s, uint32_t start_off, uint32_t start_line,
                      uint32_t start_col, const char *msg) {
  if (s->diags != NULL) {
    SourceSpan span;
    span.offset = start_off;
    span.len = (uint32_t)(s->pos - (size_t)start_off);
    span.line = start_line;
    span.col = start_col;
    diag_emit(s->diags, DIAG_ERROR, span, msg);
  }
}

/* --- Reserved-word recognition. --------------------------------------- */

/*
 * Map a lexeme [text, text+len) to its reserved-word TokenKind, or
 * TOK_IDENT if it is an ordinary identifier (including the predeclared
 * builtins, which are NOT reserved -- the grammar resolves them in sema).
 * The reserved set is exactly the list in CFrontendGrammar.md "Lexical".
 *
 * A small linear table keyed by length then bytes. Closed and tiny, so a
 * table is clearer than a hand-rolled trie and avoids any global state.
 */
typedef struct Keyword {
  const char *text;
  size_t len;
  TokenKind kind;
} Keyword;

static TokenKind keyword_lookup(const char *text, size_t len) {
  /* Listed in the grammar's reserved order; sized-int names grouped. The
   * lengths are precomputed to skip a strlen per probe. */
  static const Keyword kws[] = {
      {"kernel", 6, TOK_KW_KERNEL},
      {"void", 4, TOK_KW_VOID},
      {"auto", 4, TOK_KW_AUTO},
      {"if", 2, TOK_KW_IF},
      {"else", 4, TOK_KW_ELSE},
      {"where", 5, TOK_KW_WHERE},
      {"otherwise", 9, TOK_KW_OTHERWISE},
      {"for", 3, TOK_KW_FOR},
      {"in", 2, TOK_KW_IN},
      {"step", 4, TOK_KW_STEP},
      {"while", 5, TOK_KW_WHILE},
      {"after", 5, TOK_KW_AFTER},
      {"shared", 6, TOK_KW_SHARED},
      {"bool", 4, TOK_KW_BOOL},
      {"half", 4, TOK_KW_HALF},
      {"float", 5, TOK_KW_FLOAT},
      {"index", 5, TOK_KW_INDEX},
      {"token", 5, TOK_KW_TOKEN},
      {"int8_t", 6, TOK_KW_INT8},
      {"int16_t", 7, TOK_KW_INT16},
      {"int32_t", 7, TOK_KW_INT32},
      {"int64_t", 7, TOK_KW_INT64},
      {"uint8_t", 7, TOK_KW_UINT8},
      {"uint16_t", 8, TOK_KW_UINT16},
      {"uint32_t", 8, TOK_KW_UINT32},
      {"uint64_t", 8, TOK_KW_UINT64},
      {"simd", 4, TOK_KW_SIMD},
      {"mask", 4, TOK_KW_MASK},
      {"vector", 6, TOK_KW_VECTOR},
      {"fragment", 8, TOK_KW_FRAGMENT},
  };
  size_t i;
  for (i = 0; i < sizeof(kws) / sizeof(kws[0]); i++) {
    if (kws[i].len == len && memcmp(kws[i].text, text, len) == 0)
      return kws[i].kind;
  }
  return TOK_IDENT;
}

/* --- Sub-lexers for the multi-byte token classes. --------------------- */

/*
 * Lex an identifier or reserved word starting at the current cursor
 * (which the caller has checked is an ident-start byte). Consumes the
 * maximal ident run, then classifies it.
 */
static void lex_ident(Scanner *s) {
  uint32_t off = (uint32_t)s->pos;
  uint32_t line = s->line;
  uint32_t col = s->col;
  size_t start = s->pos;
  TokenKind kind;
  while (is_ident_continue(peek(s, 0)))
    advance(s);
  kind = keyword_lookup(s->src + start, s->pos - start);
  emit(s, kind, off, line, col);
}

/*
 * Lex a numeric literal starting at a digit. Decides INT vs FLOAT by the
 * grammar:
 *   dec_lit   = digit {digit}
 *   hex_lit   = "0x" hexdigit {hexdigit}
 *   float_lit = digit {digit} ( "." digit {digit} [exp] | exp ) ["f"]
 * Crucially a "." opens a fraction ONLY when immediately followed by a
 * digit, so "0..n" stops the integer before the "..", and "0." is the
 * integer "0" (the lone "." is handled by the caller). The exponent-only
 * form ("1e9") is a float. Maximal munch otherwise.
 *
 * Malformed numbers ("0x" with no hex digit, an exponent with no digits)
 * are surfaced as TOK_ERROR with a diagnostic -- a clear error, never a
 * silent or faked acceptance.
 */
static int lex_hex_number(Scanner *s, uint32_t off, uint32_t line,
                          uint32_t col) {
  if (peek(s, 0) != '0' || (peek(s, 1) != 'x' && peek(s, 1) != 'X'))
    return 0;
  advance_n(s, 2);
  if (!is_hex_digit(peek(s, 0))) {
    while (is_ident_continue(peek(s, 0)))
      advance(s);
    lex_error(s, off, line, col,
              "hex literal needs at least one hex digit after 0x");
    emit(s, TOK_ERROR, off, line, col);
    return 1;
  }
  while (is_hex_digit(peek(s, 0)))
    advance(s);
  emit(s, TOK_INT_LIT, off, line, col);
  return 1;
}

static int lex_fraction(Scanner *s) {
  if (peek(s, 0) == '.' && is_digit(peek(s, 1))) {
    advance(s);
    while (is_digit(peek(s, 0)))
      advance(s);
    return 1;
  }
  return 0;
}

static int lex_exponent(Scanner *s) {
  if (peek(s, 0) == 'e' || peek(s, 0) == 'E') {
    size_t sign_at = (peek(s, 1) == '+' || peek(s, 1) == '-') ? 1u : 0u;
    if (is_digit(peek(s, 1u + sign_at))) {
      advance(s);
      if (sign_at != 0u)
        advance(s);
      while (is_digit(peek(s, 0)))
        advance(s);
      return 1;
    }
  }
  return 0;
}

static int lex_decimal_tail(Scanner *s) {
  int is_float;
  while (is_digit(peek(s, 0)))
    advance(s);

  is_float = lex_fraction(s);
  if (lex_exponent(s))
    is_float = 1;

  if (is_float && peek(s, 0) == 'f')
    advance(s);
  return is_float;
}

static void lex_number(Scanner *s) {
  uint32_t off = (uint32_t)s->pos;
  uint32_t line = s->line;
  uint32_t col = s->col;
  int is_float;

  if (lex_hex_number(s, off, line, col))
    return;
  is_float = lex_decimal_tail(s);
  emit(s, is_float ? TOK_FLOAT_LIT : TOK_INT_LIT, off, line, col);
}

/* --- Comment skipping. ------------------------------------------------ */

/* Skip a "//" line comment: from the "//" to end-of-line (the newline is
 * not consumed here; the main loop's whitespace handling advances it).
 * The caller has confirmed the leading "//". */
static void skip_line_comment(Scanner *s) {
  advance(s); /* first '/' */
  advance(s); /* second '/' */
  while (peek(s, 0) != -1 && peek(s, 0) != '\n')
    advance(s);
}

/*
 * Skip a non-nested block comment from the opening to the matching "*"
 * "/". Returns 1 on a properly closed comment, 0 if EOF is reached
 * first (unterminated) -- the caller reports that as an error so it is
 * never silently swallowed. The caller has confirmed the leading.
 */
static int skip_block_comment(Scanner *s) {
  advance(s); /* '/' */
  advance(s); /* '*' */
  while (peek(s, 0) != -1) {
    if (peek(s, 0) == '*' && peek(s, 1) == '/') {
      advance(s); /* '*' */
      advance(s); /* '/' */
      return 1;
    }
    advance(s);
  }
  return 0; /* unterminated. */
}

/* --- Operator / punctuation lexing. ----------------------------------- */

/*
 * Lex a single punctuation or operator token at the cursor using maximal
 * munch: always prefer the longest matching operator. Returns after
 * emitting exactly one token (TOK_ERROR for a byte that begins no valid
 * token). The caller has already ruled out whitespace, comments,
 * identifiers and numbers, so `c` is a punctuation lead byte (or junk).
 */
typedef struct PunctRule {
  const char *text;
  TokenKind kind;
} PunctRule;

static const PunctRule kPunctRules[] = {
    {"<<=", TOK_SHL_EQ},  {">>=", TOK_SHR_EQ},    {"[[", TOK_LATTR},
    {"]]", TOK_RATTR},    {"..", TOK_DOTDOT},     {"+=", TOK_PLUS_EQ},
    {"-=", TOK_MINUS_EQ}, {"->", TOK_ARROW},      {"*=", TOK_STAR_EQ},
    {"/=", TOK_SLASH_EQ}, {"%=", TOK_PERCENT_EQ}, {"<<", TOK_SHL},
    {">>", TOK_SHR},      {"<=", TOK_LE},         {">=", TOK_GE},
    {"==", TOK_EQ},       {"!=", TOK_NE},         {"&&", TOK_AMPAMP},
    {"&=", TOK_AMP_EQ},   {"||", TOK_PIPEPIPE},   {"|=", TOK_PIPE_EQ},
    {"^=", TOK_CARET_EQ}, {"(", TOK_LPAREN},      {")", TOK_RPAREN},
    {"{", TOK_LBRACE},    {"}", TOK_RBRACE},      {"[", TOK_LBRACKET},
    {"]", TOK_RBRACKET},  {",", TOK_COMMA},       {";", TOK_SEMI},
    {"+", TOK_PLUS},      {"-", TOK_MINUS},       {"*", TOK_STAR},
    {"/", TOK_SLASH},     {"%", TOK_PERCENT},     {"<", TOK_LT},
    {">", TOK_GT},        {"=", TOK_ASSIGN},      {"!", TOK_BANG},
    {"&", TOK_AMP},       {"|", TOK_PIPE},        {"^", TOK_CARET},
    {"~", TOK_TILDE},
};

static int punct_matches(Scanner *s, const char *text) {
  size_t i;
  for (i = 0; text[i] != '\0'; i++) {
    if (peek(s, i) != (unsigned char)text[i])
      return 0;
  }
  return 1;
}

static void lex_punct(Scanner *s) {
  uint32_t off = (uint32_t)s->pos;
  uint32_t line = s->line;
  uint32_t col = s->col;
  int c = peek(s, 0);

  size_t i;
  for (i = 0; i < sizeof(kPunctRules) / sizeof(kPunctRules[0]); i++) {
    if (!punct_matches(s, kPunctRules[i].text))
      continue;
    advance_n(s, strlen(kPunctRules[i].text));
    emit(s, kPunctRules[i].kind, off, line, col);
    return;
  }

  advance(s);
  if (c == '.')
    lex_error(s, off, line, col, "stray '.' is not a valid token");
  else if (c >= 0x80)
    lex_error(s, off, line, col, "non-ASCII byte in source (ASCII-only)");
  else
    lex_error(s, off, line, col, "unexpected character");
  emit(s, TOK_ERROR, off, line, col);
}

/* --- The scan driver (shared by both passes). ------------------------- */

/*
 * Run the scanner to completion, emitting tokens (and, on the filling
 * pass, diagnostics) for the whole buffer, terminated by exactly one
 * TOK_EOF. Whitespace and comments separate tokens and are otherwise
 * dropped; an unterminated block comment is reported as an error at its
 * opening but still consumed to EOF.
 */
static int scan_space_or_comment(Scanner *s) {
  int c = peek(s, 0);
  if (is_space(c)) {
    advance(s);
    return 1;
  }
  if (c == '/' && peek(s, 1) == '/') {
    skip_line_comment(s);
    return 1;
  }
  if (c == '/' && peek(s, 1) == '*') {
    uint32_t off = (uint32_t)s->pos;
    uint32_t line = s->line;
    uint32_t col = s->col;
    if (!skip_block_comment(s))
      lex_error(s, off, line, col, "unterminated block comment");
    return 1;
  }
  return 0;
}

static void scan_one(Scanner *s) {
  int c = peek(s, 0);
  if (is_ident_start(c)) {
    lex_ident(s);
    return;
  }
  if (is_digit(c)) {
    lex_number(s);
    return;
  }
  lex_punct(s);
}

static void scan_all(Scanner *s) {
  while (peek(s, 0) >= 0) {
    if (scan_space_or_comment(s))
      continue;
    scan_one(s);
  }
  emit(s, TOK_EOF, (uint32_t)s->pos, s->line, s->col);
}

/* --- Public entry point. ---------------------------------------------- */

TokenArray lex_tokenize(LexContext *ctx) {
  TokenArray result;
  Scanner s;
  size_t token_count;
  Token *array;

  result.tokens = NULL;
  result.count = 0;

  if (ctx == NULL || ctx->arena == NULL)
    return result;

  /* Pass 1: count tokens (no output array, no diagnostics). The EOF is
   * included in the count by scan_all. */
  s.src = ctx->src;
  s.len = ctx->src_len;
  s.pos = 0;
  s.line = 1;
  s.col = 1;
  s.out = NULL;
  s.count = 0;
  s.cap = 0;
  s.diags = NULL;
  scan_all(&s);
  token_count = s.count;

  /* Allocate the exact array in one contiguous arena block. Token holds
   * an enum plus uint32_t fields, so 4-byte alignment suffices; request
   * sizeof(uint32_t) explicitly (a power of two, as arena_alloc wants).
   * token_count is >= 1 (the trailing EOF), so the size is never zero. */
  array = (Token *)arena_alloc(ctx->arena, token_count * sizeof(Token),
                               sizeof(uint32_t));
  if (array == NULL) {
    /* Out of arena memory: record an error (point diagnostic at the
     * start of input) and return an empty result, per lex.h. */
    if (ctx->diags != NULL) {
      SourceSpan span;
      span.offset = 0;
      span.len = 0;
      span.line = 1;
      span.col = 1;
      diag_emit(ctx->diags, DIAG_ERROR, span,
                "out of memory allocating token array");
    }
    return result;
  }

  /* Pass 2: fill the array and emit diagnostics. Re-run the identical
   * scan from a fresh cursor; the token sequence is deterministic, so
   * the count matches pass 1 exactly. */
  s.src = ctx->src;
  s.len = ctx->src_len;
  s.pos = 0;
  s.line = 1;
  s.col = 1;
  s.out = array;
  s.count = 0;
  s.cap = token_count;
  s.diags = ctx->diags;
  scan_all(&s);

  result.tokens = array;
  result.count = s.count;
  return result;
}
