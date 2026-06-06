/*===- token.h - Token kinds and the Token record -------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Interface only -- NO lexing logic
 * lives here (that is lex.h / src/lex.c). This header is the contract
 * the lexer fills and the parser consumes.
 *
 * TokenKind enumerates EVERY terminal in the Lexical section of
 * CFrontendGrammar.md: all reserved words (including every type
 * keyword), the literal/identifier classes, and all punctuation and
 * operators (including `..`, `<<`, `>>`, the compound assignments,
 * `[[`, `]]`, `->`), plus the synthetic EOF and ERROR sentinels.
 *
 * Builtins (lane_id, load, store, ...) are NOT tokens: per the grammar
 * they are predeclared identifiers, lexed as TOK_IDENT and resolved in
 * sema. Only true reserved words get their own kind.
 */

#ifndef WAVEC_TOKEN_H
#define WAVEC_TOKEN_H

#include <stddef.h>
#include <stdint.h>

/*
 * Token kinds. The ordering groups keywords / type-keywords / literals
 * / operators / punctuation / sentinels for readability; do not rely on
 * specific numeric values. TOK__COUNT is a non-token marker giving the
 * number of kinds (handy for dispatch tables and bounds asserts).
 */
typedef enum TokenKind {
  /* --- Sentinels --- */
  TOK_EOF = 0, /* end of input; the lexer emits exactly one. */
  TOK_ERROR,   /* a lex error; span/line/col point at the bad byte(s). */

  /* --- Reserved words (non-type keywords) --- */
  TOK_KW_KERNEL,    /* kernel    */
  TOK_KW_VOID,      /* void      */
  TOK_KW_AUTO,      /* auto      */
  TOK_KW_IF,        /* if        */
  TOK_KW_ELSE,      /* else      */
  TOK_KW_WHERE,     /* where     */
  TOK_KW_OTHERWISE, /* otherwise */
  TOK_KW_FOR,       /* for       */
  TOK_KW_IN,        /* in        */
  TOK_KW_STEP,      /* step      */
  TOK_KW_WHILE,     /* while     */
  TOK_KW_AFTER,     /* after     */
  TOK_KW_SHARED,    /* shared    */

  /* --- Reserved words that name types / type constructors --- */
  TOK_KW_BOOL,     /* bool   */
  TOK_KW_HALF,     /* half   */
  TOK_KW_FLOAT,    /* float  */
  TOK_KW_INDEX,    /* index  */
  TOK_KW_TOKEN,    /* token  (also the nullary seed constructor token()) */
  TOK_KW_INT8,     /* int8_t   */
  TOK_KW_INT16,    /* int16_t  */
  TOK_KW_INT32,    /* int32_t  */
  TOK_KW_INT64,    /* int64_t  */
  TOK_KW_UINT8,    /* uint8_t  */
  TOK_KW_UINT16,   /* uint16_t */
  TOK_KW_UINT32,   /* uint32_t */
  TOK_KW_UINT64,   /* uint64_t */
  TOK_KW_SIMD,     /* simd     */
  TOK_KW_MASK,     /* mask     */
  TOK_KW_VECTOR,   /* vector   */
  TOK_KW_FRAGMENT, /* fragment */

  /* --- Literals and identifiers --- */
  TOK_IDENT,     /* identifier (also predeclared builtins) */
  TOK_INT_LIT,   /* decimal or hex integer literal */
  TOK_FLOAT_LIT, /* floating literal (digit '.' digit ... ['f']) */

  /* --- Brackets and grouping --- */
  TOK_LPAREN,   /* (  */
  TOK_RPAREN,   /* )  */
  TOK_LBRACE,   /* {  */
  TOK_RBRACE,   /* }  */
  TOK_LBRACKET, /* [  */
  TOK_RBRACKET, /* ]  */
  TOK_LATTR,    /* [[ attribute open  */
  TOK_RATTR,    /* ]] attribute close */

  /* --- Separators --- */
  TOK_COMMA,  /* ,  */
  TOK_SEMI,   /* ;  */
  TOK_DOTDOT, /* .. range (never a binop; a float never ends in '.') */
  TOK_ARROW,  /* -> (reserved punctuation; not in v1 productions) */

  /* --- Assignment operators --- */
  TOK_ASSIGN,     /* =   */
  TOK_PLUS_EQ,    /* +=  */
  TOK_MINUS_EQ,   /* -=  */
  TOK_STAR_EQ,    /* *=  */
  TOK_SLASH_EQ,   /* /=  */
  TOK_PERCENT_EQ, /* %=  */
  TOK_AMP_EQ,     /* &=  */
  TOK_PIPE_EQ,    /* |=  */
  TOK_CARET_EQ,   /* ^=  */
  TOK_SHL_EQ,     /* <<= */
  TOK_SHR_EQ,     /* >>= */

  /* --- Arithmetic operators --- */
  TOK_PLUS,    /* +  (also unary; star/minus reused) */
  TOK_MINUS,   /* -  (binary and unary) */
  TOK_STAR,    /* *  (multiply and the pointer-type star) */
  TOK_SLASH,   /* /  */
  TOK_PERCENT, /* %  */
  TOK_SHL,     /* << */
  TOK_SHR,     /* >> (may be re-split into two '>' in nested generics) */

  /* --- Relational and equality operators --- */
  TOK_LT, /* <  (compare, or opens a type/generic arg list) */
  TOK_LE, /* <= */
  TOK_GT, /* >  (compare, or closes a type/generic arg list) */
  TOK_GE, /* >= */
  TOK_EQ, /* == */
  TOK_NE, /* != */

  /* --- Bitwise and logical operators --- */
  TOK_AMP,      /* &  */
  TOK_PIPE,     /* |  */
  TOK_CARET,    /* ^  */
  TOK_TILDE,    /* ~  (unary) */
  TOK_BANG,     /* !  (unary) */
  TOK_AMPAMP,   /* && */
  TOK_PIPEPIPE, /* || */

  TOK__COUNT /* not a token: count of kinds. Keep last. */
} TokenKind;

/*
 * A lexed token. The lexeme is referenced by a byte span into the
 * source buffer (offset + length) rather than copied -- the front never
 * owns the source, and identifier/literal text is recovered by slicing
 * the original bytes. `line` and `col` are 1-based for diagnostics.
 *
 * For TOK_EOF, `len` is 0 and the span points at the terminating byte.
 * For TOK_ERROR, the span covers the offending byte(s).
 */
typedef struct Token {
  TokenKind kind;
  uint32_t offset; /* byte offset of the lexeme start in the source. */
  uint32_t len;    /* lexeme length in bytes (0 for EOF). */
  uint32_t line;   /* 1-based line of the lexeme start. */
  uint32_t col;    /* 1-based column (byte, not codepoint) of the start. */
} Token;

#endif /* WAVEC_TOKEN_H */
