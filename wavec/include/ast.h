/*===- ast.h - Abstract syntax tree -------------------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. The AST is the data structure the
 * parser produces, sema annotates, and a SEPARATE lowering stage walks
 * to emit Wave IR. Every grammar production in CFrontendGrammar.md has a
 * node form here; nothing is collapsed or special-cased.
 *
 * Design constraints (Implementation rules in CFrontendDesign.md):
 *   - Arena-allocated: nodes come from an Arena, never malloc; freed
 *     wholesale. Lists are arena arrays (pointer + count), not linked
 *     nodes, so a lowering walk indexes them directly.
 *   - Tagged: each node has a `kind` enum discriminating a union of
 *     per-kind payloads. The discriminant is the single source of truth
 *     for the active union member.
 *   - Carries spans: every node has a SourceSpan (from diag.h) for
 *     diagnostics during sema and lowering.
 *   - Unambiguous to walk: no node requires re-parsing text; the type
 *     of generic args (TypeRef vs int literal) is tagged, the after-clause
 *     is an explicit optional field, destructuring is its own stmt kind.
 *
 * Sema annotation: nodes carry a `sema_type` slot (an opaque pointer the
 * sema stage fills with a resolved/canonical TypeRef, or leaves NULL
 * before sema). The parser sets it NULL. This keeps the parser free of
 * type logic while giving sema/lowering a place to thread results
 * without a parallel side table.
 */

#ifndef WAVEC_AST_H
#define WAVEC_AST_H

#include "arena.h"
#include "diag.h"  /* SourceSpan */
#include "token.h" /* TokenKind for operator/keyword echoes */

#include <stddef.h>
#include <stdint.h>

/*===----------------------------------------------------------------===*/
/* Forward declarations                                                  */
/*===----------------------------------------------------------------===*/

typedef struct TypeRef TypeRef;
typedef struct Expr Expr;
typedef struct Stmt Stmt;
typedef struct Attribute Attribute;
typedef struct Param Param;
typedef struct Kernel Kernel;
typedef struct Program Program;

/*===----------------------------------------------------------------===*/
/* Types: `type = [shared] base_type [*]`                                */
/*===----------------------------------------------------------------===*/

/*
 * Scalar element kinds: the closed `scalar_type` set plus `index` and
 * `token`, which are spellable as a `base_type` directly. (`void` is a
 * kernel return marker, handled at the kernel node, not a value type.)
 * Signedness of the sized ints is intrinsic to the kind and drives the
 * cast/compare policy choices described in the design's cast note.
 */
typedef enum ScalarKind {
  SCALAR_BOOL,
  SCALAR_HALF,
  SCALAR_FLOAT,
  SCALAR_INDEX, /* uniform target-width integer (MLIR `index`). */
  SCALAR_TOKEN, /* memory-ordering token (a value type here). */
  SCALAR_INT8,
  SCALAR_INT16,
  SCALAR_INT32,
  SCALAR_INT64,
  SCALAR_UINT8,
  SCALAR_UINT16,
  SCALAR_UINT32,
  SCALAR_UINT64
} ScalarKind;

/*
 * The shape of a base_type. SIMD and VECTOR are the two generic
 * constructors carrying an element TypeRef and a width/count; MASK
 * carries only a width. SCALAR uses the `scalar` field.
 *
 * FRAGMENT is reserved (no v1 production) -- present so the enum is
 * complete and the parser can emit a clean "fragment not supported"
 * error rather than a parse failure; its payload is unused in v1.
 */
typedef enum TypeKind {
  TYPE_SCALAR,  /* bool/half/float/index/token + sized ints */
  TYPE_SIMD,    /* simd<elem, width>  -> !wave.simd<T,W> */
  TYPE_MASK,    /* mask<width>        -> !wave.mask<W>  */
  TYPE_VECTOR,  /* vector<elem, count> -> vector<N x T> */
  TYPE_FRAGMENT /* reserved; not produced in v1 */
} TypeKind;

/*
 * A parsed type. `is_shared` records the optional leading `shared`
 * qualifier and `is_pointer` the optional trailing `*` (the grammar
 * allows exactly one star; `shared` requires the star -- a sema rule,
 * not enforced here). For SIMD/VECTOR, `element` points at the inner
 * type and `width` holds the int literal; for MASK only `width` is set;
 * for SCALAR only `scalar` is set.
 *
 * `width` is the literal value as written (the lexer/parser validate it
 * is a non-negative int_lit). The same TypeRef shape is reused for the
 * type form of a generic argument (`garg = type | int_lit`).
 */
struct TypeRef {
  TypeKind kind;
  ScalarKind scalar; /* valid when kind == TYPE_SCALAR */
  TypeRef *element;  /* valid when kind == TYPE_SIMD/TYPE_VECTOR */
  uint64_t width;    /* lanes (SIMD/MASK) or element count (VECTOR) */
  int is_shared;     /* leading `shared` qualifier present */
  int is_pointer;    /* trailing `*` present */
  SourceSpan span;
};

/*===----------------------------------------------------------------===*/
/* Expressions                                                           */
/*===----------------------------------------------------------------===*/

/*
 * Expression node kinds, one per `expr`/`unary`/`postfix`/`primary`
 * alternative. Operators are echoed as the original TokenKind so the
 * lowering stage maps them to Wave ops without re-deriving precedence.
 */
typedef enum ExprKind {
  EXPR_INT_LIT,    /* integer literal */
  EXPR_FLOAT_LIT,  /* floating literal */
  EXPR_IDENT,      /* identifier reference (params, locals, builtins) */
  EXPR_TOKEN_SEED, /* the `token()` nullary seed -> wave.token */
  EXPR_PAREN,      /* `( expr )` -- kept explicit for faithful spans */
  EXPR_UNARY,      /* prefix `- ! ~` applied to one operand */
  EXPR_BINARY,     /* `lhs binop rhs` (precedence already resolved) */
  EXPR_CALL        /* postfix call: callee<gargs>(args [after dep]) */
} ExprKind;

/*
 * A generic argument (`garg`): either a type or an int literal. Both
 * forms appear in `f<...>(...)`; e.g. `cast<float>(x)` (type) and
 * `lane_id<32>()` (int). The tag selects which field is live.
 */
typedef enum GArgKind { GARG_TYPE, GARG_INT } GArgKind;

typedef struct GArg {
  GArgKind kind;
  TypeRef *type;      /* valid when kind == GARG_TYPE */
  uint64_t int_value; /* valid when kind == GARG_INT */
  SourceSpan span;
} GArg;

/* Integer literal payload: parsed value plus a flag for the source
 * radix so lowering/diagnostics can reproduce the spelling if needed. */
typedef struct ExprIntLit {
  uint64_t value;
  int is_hex;
} ExprIntLit;

/*
 * Floating literal payload. The lexer records the source span; the
 * parser also stores the decoded double for convenience. `is_half`
 * marks a trailing `f`? No -- `f` is the float suffix in this language's
 * lexer (float_lit `[ "f" ]`); `has_f_suffix` records it so lowering
 * can pick f32 vs the context type. The element type is finalized by
 * sema from context (a literal adopts the destination type).
 */
typedef struct ExprFloatLit {
  double value;
  int has_f_suffix;
} ExprFloatLit;

/* Identifier payload: the name is a slice of the source recorded as a
 * pointer+length into the original buffer (the front never copies
 * source); `name` is NOT NUL-terminated, use `name_len`. */
typedef struct ExprIdent {
  const char *name;
  uint32_t name_len;
} ExprIdent;

/* Unary payload: `op` is one of TOK_MINUS/TOK_BANG/TOK_TILDE. */
typedef struct ExprUnary {
  TokenKind op;
  Expr *operand;
} ExprUnary;

/* Binary payload: `op` is the binop TokenKind (TOK_PLUS .. TOK_PIPEPIPE
 * per the precedence table). Children already reflect precedence and
 * left-associativity. */
typedef struct ExprBinary {
  TokenKind op;
  Expr *lhs;
  Expr *rhs;
} ExprBinary;

/*
 * Call payload (`postfix` with a `call_tail`). `callee` is the primary
 * being called (an EXPR_IDENT in v1, but kept as a general Expr so
 * future call-of-expression needs no reshape). `gargs`/`garg_count`
 * hold the optional `< ... >` compile-time args; `args`/`arg_count`
 * hold the value arguments; `dep`/`has_dep` hold the optional trailing
 * `after expr` dependency token (rule 5). A call with no generic args
 * has garg_count == 0; with no after-clause has has_dep == 0.
 */
typedef struct ExprCall {
  Expr *callee;
  GArg *gargs; /* arena array, length garg_count */
  size_t garg_count;
  Expr **args; /* arena array of Expr*, length arg_count */
  size_t arg_count;
  Expr *dep; /* the `after` dependency expr, or NULL */
  int has_dep;
} ExprCall;

struct Expr {
  ExprKind kind;
  union {
    ExprIntLit int_lit;
    ExprFloatLit float_lit;
    ExprIdent ident;
    Expr *paren; /* EXPR_PAREN: the inner expression */
    ExprUnary unary;
    ExprBinary binary;
    ExprCall call;
    /* EXPR_TOKEN_SEED has no payload. */
  } as;
  SourceSpan span;
  void *sema_type; /* TypeRef* result type filled by sema, else NULL */
};

/*===----------------------------------------------------------------===*/
/* Statements                                                            */
/*===----------------------------------------------------------------===*/

typedef enum StmtKind {
  STMT_DECL,        /* type ident = expr ;                       */
  STMT_DESTRUCTURE, /* auto [ ident {, ident} ] = expr ;         */
  STMT_ASSIGN,      /* ident assign_op expr ;                    */
  STMT_CALL,        /* call ;                                    */
  STMT_IF,          /* if (expr) block [else block]             */
  STMT_WHERE,       /* where (expr) block [otherwise block]     */
  STMT_FOR,         /* for iv_type ident in expr..expr [step expr] block */
  STMT_WHILE,       /* while (expr) block                       */
  STMT_BLOCK        /* { stmt* }                                */
} StmtKind;

/* A bound identifier (declaration LHS name): a source slice plus span.
 * Used for the decl name and for each name in a destructure list. */
typedef struct BoundName {
  const char *name;
  uint32_t name_len;
  SourceSpan span;
} BoundName;

/* STMT_DECL: a single typed declaration with a mandatory initializer
 * (the grammar's decl_stmt requires `= expr`). */
typedef struct StmtDecl {
  TypeRef *type;
  BoundName name;
  Expr *init;
} StmtDecl;

/* STMT_DESTRUCTURE: `auto [a, b, ...] = expr`. Binds the multi-result
 * of a builtin (only `load` in v1) to N names. `names`/`name_count`
 * is the arena array; `init` is the producing expression. */
typedef struct StmtDestructure {
  BoundName *names; /* arena array, length name_count (>= 1) */
  size_t name_count;
  Expr *init;
} StmtDestructure;

/* STMT_ASSIGN: `ident assign_op expr`. `op` is one of the assign_op
 * TokenKinds (TOK_ASSIGN .. TOK_SHR_EQ). `target` is the single-name
 * LHS (no chaining, no general lvalue per the grammar). */
typedef struct StmtAssign {
  BoundName target;
  TokenKind op;
  Expr *value;
} StmtAssign;

/* STMT_CALL: a call expression used as a statement. `call` is always an
 * EXPR_CALL node (the grammar's call_stmt = call ";"). */
typedef struct StmtCall {
  Expr *call;
} StmtCall;

/*
 * STMT_IF / STMT_WHERE share a shape: a condition, a then-block, and an
 * optional else/otherwise block. `cond` is `bool` for if and `mask<W>`
 * for where (the type checker enforces the split, not the parser).
 * Blocks are STMT_BLOCK nodes; `else_block` is NULL when absent.
 */
typedef struct StmtCond {
  Expr *cond;
  Stmt *then_block; /* a STMT_BLOCK */
  Stmt *else_block; /* a STMT_BLOCK, or NULL (else / otherwise) */
} StmtCond;

/*
 * STMT_FOR: the range for. `iv_type` is the declared induction-variable
 * type (restricted to index / sized ints by `iv_type`; the parser
 * records whatever TypeRef it parsed and sema validates the
 * restriction). `iv_name` is the IV binding. `lb`/`ub` are the
 * half-open bounds [lb, ub); `step` is optional (NULL => unit step).
 * `body` is a STMT_BLOCK.
 */
typedef struct StmtFor {
  TypeRef *iv_type;
  BoundName iv_name;
  Expr *lb;
  Expr *ub;
  Expr *step; /* optional, NULL when omitted */
  Stmt *body; /* a STMT_BLOCK */
} StmtFor;

/* STMT_WHILE: `while (cond) block`. `cond` is `bool` (sema-checked). */
typedef struct StmtWhile {
  Expr *cond;
  Stmt *body; /* a STMT_BLOCK */
} StmtWhile;

/* STMT_BLOCK: a brace-delimited statement sequence. `stmts`/`stmt_count`
 * is the arena array of child statements (possibly empty). */
typedef struct StmtBlock {
  Stmt **stmts; /* arena array of Stmt*, length stmt_count */
  size_t stmt_count;
} StmtBlock;

struct Stmt {
  StmtKind kind;
  union {
    StmtDecl decl;
    StmtDestructure destructure;
    StmtAssign assign;
    StmtCall call;
    StmtCond cond; /* STMT_IF and STMT_WHERE */
    StmtFor for_;
    StmtWhile while_;
    StmtBlock block;
  } as;
  SourceSpan span;
};

/*===----------------------------------------------------------------===*/
/* Top level: attributes, params, kernels, program                      */
/*===----------------------------------------------------------------===*/

/*
 * An attribute `[[ ident [ ( int_lit ) ] ]]`. `name`/`name_len` is the
 * attribute identifier (a source slice). `has_arg`/`arg` carry the
 * optional integer argument. The closed attribute set
 * (amdgpu_wave_size, amdgpu_lds_size) is validated in sema, not here.
 */
struct Attribute {
  const char *name;
  uint32_t name_len;
  int has_arg;
  uint64_t arg;
  SourceSpan span;
};

/* A kernel parameter `type ident`. */
struct Param {
  TypeRef *type;
  BoundName name;
  SourceSpan span;
};

/*
 * A kernel: `kernel { attribute } void ident ( [params] ) block`. The
 * return is always `void` in v1 (no value-returning kernels), so no
 * return type is stored. `attrs`/`params` are arena arrays; `body` is
 * the top-level STMT_BLOCK.
 */
struct Kernel {
  BoundName name;
  Attribute **attrs; /* arena array of Attribute*, length attr_count */
  size_t attr_count;
  Param **params; /* arena array of Param*, length param_count */
  size_t param_count;
  Stmt *body; /* a STMT_BLOCK */
  SourceSpan span;
};

/*
 * A whole translation unit: `program = { kernel }`. `kernels` is the
 * arena array of top-level kernels (v1 has no other top-level forms).
 */
struct Program {
  Kernel **kernels; /* arena array of Kernel*, length kernel_count */
  size_t kernel_count;
  SourceSpan span;
};

#endif /* WAVEC_AST_H */
