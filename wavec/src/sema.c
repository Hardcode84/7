/*===- sema.c - Semantic analysis / type checker --------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. Stage 3: a parsed AST -> a checked,
 * type-annotated AST plus diagnostics. See sema.h for the contract and
 * CFrontendDesign.md (Types / Operators / Control flow / cast note) +
 * CFrontendGrammar.md (Sema-only rules) for the rules enforced here.
 *
 * This file links ONLY libc (string.h for memcpy/strncmp, stdio.h for
 * snprintf into in-memory buffers, stdint.h). It contains NO MLIR and NO
 * global state: every piece of mutable state -- the symbol table, the
 * per-kernel wave width, the recursion guard -- threads through an
 * explicit `Checker` value derived from the public SemaContext. snprintf
 * is used only to format diagnostic strings into stack buffers (not file
 * I/O, not OS-specific); diag_emit copies the bytes into the arena.
 *
 * Design notes:
 *   - Uniformity is type-directed, never inferred. A type's shape
 *     (scalar vs simd<T,W> vs mask<W>) decides SGPR vs VGPR; the checker
 *     only PROPAGATES types bottom-up and enforces the rules.
 *   - Every Expr gets its `sema_type` filled with a canonical TypeRef*
 *     so the separate lowering stage needs no re-inference.
 *   - Integer assignment-compatibility is by bit width (signless IR):
 *     int32_t and uint32_t unify; signedness only selects op variants and
 *     cast policy. index and token are distinct, non-convertible kinds.
 *   - Literals are width/precision polymorphic: an int literal adopts any
 *     integer/index destination, a float literal adopts float/half. With
 *     no constraining context they default to int32 / float (f32).
 *   - Definite-assignment (a small, exact dataflow, NOT a fixpoint):
 *     a declaration's name is in scope but `defined = 0` while its own
 *     initializer is checked (so self-reference is a use-before-def), then
 *     becomes defined. Branch merges intersect the defined sets; reading
 *     an in-scope-but-undefined local is a use-before-def error. This is
 *     the use-before-def / some-but-not-all-branch rule from the design.
 */

#include "sema.h"

#include "ast.h"
#include "diag.h"
#include "token.h"

#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

/*===----------------------------------------------------------------===*/
/* Bounded recursion + symbol-table sizing                               */
/*===----------------------------------------------------------------===*/

/* Cap on recursive descent into nested expressions/statements during the
 * check, mirroring the parser's bounded-recursion rule so a pathological
 * (still grammatical) AST cannot overflow the C stack. */
#define SEMA_MAX_DEPTH 512

/* Maximum number of live symbols (params + locals across all scopes). A
 * fixed cap because the arena never grows; generous for any v1 kernel. */
#define SEMA_MAX_SYMBOLS 4096

#define SEMA_MAX_WORKGROUP_SIZE 1024

/* Stack buffer size for formatting a single diagnostic message. Sized
 * with headroom over the longest fixed message text plus any embedded
 * identifier (capped at SEMA_NAME_CAP) so snprintf never truncates a
 * diagnostic (and -Wformat-truncation stays quiet under _FORTIFY_SOURCE). */
#define SEMA_MSG_CAP 512

/* Identifiers/type names embedded in a message are copied (and bounded)
 * to this many bytes -- ample for any real identifier, and small enough
 * that prefix + name always fits SEMA_MSG_CAP. */
#define SEMA_NAME_CAP 128

/*===----------------------------------------------------------------===*/
/* Symbol table                                                          */
/*===----------------------------------------------------------------===*/

/*
 * One bound name visible in the current scope. `name`/`name_len` is a
 * slice of the source (not NUL-terminated). `type` is the resolved
 * canonical TypeRef. `defined` is the definite-assignment bit. `scope`
 * is the lexical depth at which the symbol was introduced, used to drop
 * inner-scope symbols on scope exit while keeping outer symbols (whose
 * `defined` bit may have been mutated by an inner assignment).
 */
typedef struct Symbol {
  const char *name;
  uint32_t name_len;
  TypeRef *type;
  int defined;
  int scope;
} Symbol;

/*
 * The checker: the working state for one sema_check run. Holds the public
 * arena/diag handles, the symbol stack, the current lexical scope depth,
 * the recursion guard, and the wave width N for the kernel currently
 * being checked (0 means "no [[amdgpu_wave_size]] in effect", which makes
 * any width-bearing type an error). No file-scope state lives here.
 */
typedef struct Checker {
  Arena *arena;
  DiagList *diags;
  Symbol *syms; /* arena array, capacity SEMA_MAX_SYMBOLS */
  size_t sym_count;
  int scope;       /* current lexical scope depth (0 = params) */
  unsigned depth;  /* recursion-depth guard */
  uint64_t wave_n; /* kernel wave size N; 0 if unset */
  int has_wave_n;  /* whether N is established for this kernel */
} Checker;

/*===----------------------------------------------------------------===*/
/* Diagnostics helpers                                                   */
/*===----------------------------------------------------------------===*/

/* Emit an error with a preformatted (already-complete) message. */
static void err(Checker *c, SourceSpan span, const char *msg) {
  diag_emit(c->diags, DIAG_ERROR, span, msg);
}

/* Emit an error formatting `fmt` with a single string argument. The
 * string argument is a (pointer,len) source slice; it is reproduced
 * verbatim. Truncates safely at SEMA_MSG_CAP. */
static void err_name(Checker *c, SourceSpan span, const char *fmt,
                     const char *name, uint32_t name_len) {
  char buf[SEMA_MSG_CAP];
  char namebuf[SEMA_NAME_CAP];
  uint32_t n = name_len;
  if (n >= sizeof(namebuf))
    n = (uint32_t)sizeof(namebuf) - 1u;
  if (name != NULL && n > 0u)
    memcpy(namebuf, name, n);
  namebuf[n] = '\0';
  snprintf(buf, sizeof(buf), fmt, namebuf);
  diag_emit(c->diags, DIAG_ERROR, span, buf);
}

/* Emit an error formatting `fmt` with a single unsigned argument. */
static void err_u(Checker *c, SourceSpan span, const char *fmt,
                  unsigned long long v) {
  char buf[SEMA_MSG_CAP];
  snprintf(buf, sizeof(buf), fmt, v);
  diag_emit(c->diags, DIAG_ERROR, span, buf);
}

/* Emit an error formatting `fmt` with two unsigned arguments. */
static void err_uu(Checker *c, SourceSpan span, const char *fmt,
                   unsigned long long a, unsigned long long b) {
  char buf[SEMA_MSG_CAP];
  snprintf(buf, sizeof(buf), fmt, a, b);
  diag_emit(c->diags, DIAG_ERROR, span, buf);
}

static SourceSpan empty_span(void) {
  SourceSpan s;
  memset(&s, 0, sizeof(s));
  return s;
}

/*===----------------------------------------------------------------===*/
/* Canonical type construction + classification                          */
/*===----------------------------------------------------------------===*/

/* Allocate a zeroed TypeRef from the arena. Returns NULL on exhaustion. */
static TypeRef *new_type(Checker *c) {
  TypeRef *t =
      (TypeRef *)arena_alloc(c->arena, sizeof(TypeRef), sizeof(void *));
  if (t == NULL)
    return NULL;
  t->kind = TYPE_SCALAR;
  t->scalar = SCALAR_BOOL;
  t->element = NULL;
  t->width = 0;
  t->fragment_role = 0;
  t->fragment_rows = 0;
  t->fragment_cols = 0;
  t->fragment_registers = 0;
  t->is_shared = 0;
  t->is_pointer = 0;
  t->span.offset = 0;
  t->span.len = 0;
  t->span.line = 0;
  t->span.col = 0;
  return t;
}

static int require_wave_n(Checker *c, SourceSpan span, uint64_t *out);

/* Build a canonical non-pointer scalar TypeRef of the given kind. */
static TypeRef *scalar_type(Checker *c, ScalarKind k) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  t->kind = TYPE_SCALAR;
  t->scalar = k;
  return t;
}

/* Build a canonical simd<element, width>. */
static TypeRef *simd_type(Checker *c, TypeRef *element, uint64_t width) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  t->kind = TYPE_SIMD;
  t->element = element;
  t->width = width;
  return t;
}

/* Build a canonical mask<width>. */
static TypeRef *mask_type(Checker *c, uint64_t width) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  t->kind = TYPE_MASK;
  t->width = width;
  return t;
}

static TypeRef *vector_type(Checker *c, TypeRef *element, uint64_t count) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  t->kind = TYPE_VECTOR;
  t->element = element;
  t->width = count;
  return t;
}

static TypeRef *fragment_type(Checker *c, TypeRef *element, uint64_t role,
                              uint64_t rows, uint64_t cols, uint64_t wave,
                              uint64_t regs) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  t->kind = TYPE_FRAGMENT;
  t->element = element;
  t->width = wave;
  t->fragment_role = role;
  t->fragment_rows = rows;
  t->fragment_cols = cols;
  t->fragment_registers = regs;
  return t;
}

static TypeRef *copy_type(Checker *c, const TypeRef *src) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  *t = *src;
  return t;
}

/* Build a canonical pointer-to-element with the given address space. */
static TypeRef *ptr_type(Checker *c, const TypeRef *base, int is_shared) {
  TypeRef *t = copy_type(c, base);
  if (t == NULL)
    return NULL;
  t->is_pointer = 1;
  t->is_shared = is_shared;
  return t;
}

/* --- ScalarKind predicates ---------------------------------------- */

static int sk_is_sized_int(ScalarKind k) {
  switch (k) {
  case SCALAR_INT8:
  case SCALAR_INT16:
  case SCALAR_INT32:
  case SCALAR_INT64:
  case SCALAR_UINT8:
  case SCALAR_UINT16:
  case SCALAR_UINT32:
  case SCALAR_UINT64:
    return 1;
  default:
    return 0;
  }
}

static int sk_is_signed_int(ScalarKind k) {
  return k == SCALAR_INT8 || k == SCALAR_INT16 || k == SCALAR_INT32 ||
         k == SCALAR_INT64;
}

static int sk_is_float(ScalarKind k) {
  return k == SCALAR_FLOAT || k == SCALAR_HALF;
}

static const unsigned kScalarBits[] = {
    [SCALAR_HALF] = 16,   [SCALAR_FLOAT] = 32,  [SCALAR_INT8] = 8,
    [SCALAR_INT16] = 16,  [SCALAR_INT32] = 32,  [SCALAR_INT64] = 64,
    [SCALAR_UINT8] = 8,   [SCALAR_UINT16] = 16, [SCALAR_UINT32] = 32,
    [SCALAR_UINT64] = 64,
};

static unsigned sk_bits(ScalarKind k) {
  if ((unsigned)k < sizeof(kScalarBits) / sizeof(kScalarBits[0]))
    return kScalarBits[k];
  return 0;
}

/* A scalar numeric element usable as a simd/vector element or a pointer
 * target (half/float and the sized ints). Excludes bool/index/token. */
static int sk_is_numeric(ScalarKind k) {
  return sk_is_sized_int(k) || sk_is_float(k);
}

/* --- TypeRef classification --------------------------------------- */

static int is_scalar(const TypeRef *t) {
  return t != NULL && t->kind == TYPE_SCALAR && !t->is_pointer;
}
static int is_pointer(const TypeRef *t) { return t != NULL && t->is_pointer; }
static int is_simd(const TypeRef *t) {
  return t != NULL && t->kind == TYPE_SIMD;
}
static int is_mask(const TypeRef *t) {
  return t != NULL && t->kind == TYPE_MASK;
}
static int is_bool(const TypeRef *t) {
  return is_scalar(t) && t->scalar == SCALAR_BOOL;
}
static int is_token(const TypeRef *t) {
  return is_scalar(t) && t->scalar == SCALAR_TOKEN;
}
static int is_index(const TypeRef *t) {
  return is_scalar(t) && t->scalar == SCALAR_INDEX;
}

/* The element scalar kind of a scalar or a simd-of-scalar; returns 1 and
 * writes *out on success, 0 if `t` has no scalar element (e.g. mask, or a
 * simd carrying a vector payload). */
static int element_scalar(const TypeRef *t, ScalarKind *out) {
  if (is_scalar(t)) {
    *out = t->scalar;
    return 1;
  }
  if (is_simd(t) && t->element != NULL && t->element->kind == TYPE_SCALAR &&
      !t->element->is_pointer) {
    *out = t->element->scalar;
    return 1;
  }
  return 0;
}

/* --- Type equality / assignment compatibility --------------------- */

/* Two scalar element kinds are assignment-compatible. Sized ints unify by
 * bit width (signless IR), regardless of signedness; every other kind
 * matches only itself. */
static int scalar_compatible(ScalarKind a, ScalarKind b) {
  if (a == b)
    return 1;
  if (sk_is_sized_int(a) && sk_is_sized_int(b))
    return sk_bits(a) == sk_bits(b);
  return 0;
}

static int same_kind_compatible(const TypeRef *a, const TypeRef *b);

/* Structural assignment-compatibility of two canonical types (ignoring
 * literal polymorphism, handled separately at the call site). */
static int base_type_compatible(const TypeRef *a, const TypeRef *b) {
  TypeRef ac = *a;
  TypeRef bc = *b;
  ac.is_pointer = 0;
  bc.is_pointer = 0;
  ac.is_shared = 0;
  bc.is_shared = 0;
  return ac.kind == bc.kind && same_kind_compatible(&ac, &bc);
}

static int pointer_compatible(const TypeRef *a, const TypeRef *b) {
  return is_pointer(a) && is_pointer(b) && a->is_shared == b->is_shared &&
         base_type_compatible(a, b);
}

static int type_compatible(const TypeRef *a, const TypeRef *b);

static int same_scalar_compatible(const TypeRef *a, const TypeRef *b) {
  return scalar_compatible(a->scalar, b->scalar);
}

static int same_width_compatible(const TypeRef *a, const TypeRef *b) {
  return a->width == b->width;
}

static int same_payload_compatible(const TypeRef *a, const TypeRef *b) {
  if (!same_width_compatible(a, b))
    return 0;
  return type_compatible(a->element, b->element);
}

static int same_fragment_compatible(const TypeRef *a, const TypeRef *b) {
  if (a->fragment_role != b->fragment_role)
    return 0;
  if (a->fragment_rows != b->fragment_rows)
    return 0;
  if (a->fragment_cols != b->fragment_cols)
    return 0;
  if (!same_width_compatible(a, b))
    return 0;
  if (a->fragment_registers != b->fragment_registers)
    return 0;
  return type_compatible(a->element, b->element);
}

static int same_void_compatible(const TypeRef *a, const TypeRef *b) {
  (void)a;
  (void)b;
  return 0;
}

static int same_kind_compatible(const TypeRef *a, const TypeRef *b) {
  typedef int (*CompatFn)(const TypeRef *, const TypeRef *);
  static const CompatFn fns[] = {
      same_scalar_compatible,  same_payload_compatible,  same_width_compatible,
      same_payload_compatible, same_fragment_compatible, same_void_compatible};
  return fns[a->kind](a, b);
}

static int type_compatible(const TypeRef *a, const TypeRef *b) {
  if (a == NULL || b == NULL)
    return 0;
  if (is_pointer(a) || is_pointer(b))
    return pointer_compatible(a, b);
  if (a->kind != b->kind)
    return 0;
  return same_kind_compatible(a, b);
}

static const char *const kScalarNames[] = {
    [SCALAR_BOOL] = "bool",       [SCALAR_HALF] = "half",
    [SCALAR_FLOAT] = "float",     [SCALAR_INDEX] = "index",
    [SCALAR_TOKEN] = "token",     [SCALAR_INT8] = "int8_t",
    [SCALAR_INT16] = "int16_t",   [SCALAR_INT32] = "int32_t",
    [SCALAR_INT64] = "int64_t",   [SCALAR_UINT8] = "uint8_t",
    [SCALAR_UINT16] = "uint16_t", [SCALAR_UINT32] = "uint32_t",
    [SCALAR_UINT64] = "uint64_t",
};

static const char *scalar_name(ScalarKind k) {
  if ((unsigned)k < sizeof(kScalarNames) / sizeof(kScalarNames[0]) &&
      kScalarNames[k] != NULL)
    return kScalarNames[k];
  return "?";
}

/* Short category word for a type, for diagnostics. */
static const char *type_category(const TypeRef *t) {
  if (t == NULL)
    return "<none>";
  if (is_pointer(t))
    return t->is_shared ? "shared pointer" : "pointer";
  switch (t->kind) {
  case TYPE_SCALAR:
    return scalar_name(t->scalar);
  case TYPE_SIMD:
    return "simd";
  case TYPE_MASK:
    return "mask";
  case TYPE_VECTOR:
    return "vector";
  case TYPE_FRAGMENT:
    return "fragment";
  case TYPE_VOID:
    return "void";
  }
  return "?";
}

/*===----------------------------------------------------------------===*/
/* Symbol-table operations                                               */
/*===----------------------------------------------------------------===*/

/* Find a symbol by name slice; returns the most recently declared match
 * (so an inner-scope shadow wins), or NULL. */
static Symbol *sym_lookup(Checker *c, const char *name, uint32_t len) {
  size_t i;
  for (i = c->sym_count; i > 0; i--) {
    Symbol *s = &c->syms[i - 1];
    if (s->name_len == len && memcmp(s->name, name, len) == 0)
      return s;
  }
  return NULL;
}

/* Declare a name in the current scope with the given type and initial
 * definedness. Returns the new Symbol*, or NULL on capacity/arena limits
 * (a diagnostic is emitted). A redeclaration in the SAME scope is an
 * error (shadowing across scopes is allowed). */
static Symbol *sym_declare(Checker *c, const BoundName *bn, TypeRef *type,
                           int defined) {
  Symbol *existing;
  Symbol *s;
  existing = sym_lookup(c, bn->name, bn->name_len);
  if (existing != NULL && existing->scope == c->scope) {
    err_name(c, bn->span, "redeclaration of '%s' in the same scope", bn->name,
             bn->name_len);
    return existing;
  }
  if (c->sym_count >= SEMA_MAX_SYMBOLS) {
    err(c, bn->span, "too many local symbols (symbol table exhausted)");
    return NULL;
  }
  s = &c->syms[c->sym_count++];
  s->name = bn->name;
  s->name_len = bn->name_len;
  s->type = type;
  s->defined = defined;
  s->scope = c->scope;
  return s;
}

/* Enter a nested lexical scope. */
static void scope_enter(Checker *c) { c->scope++; }

/* Leave the current scope: drop symbols declared at this depth. Symbols
 * from outer scopes (whose `defined` bit may have been changed by inner
 * assignments) are kept. */
static void scope_leave(Checker *c) {
  while (c->sym_count > 0 && c->syms[c->sym_count - 1].scope == c->scope)
    c->sym_count--;
  c->scope--;
}

/*===----------------------------------------------------------------===*/
/* Forward declarations of the walk                                      */
/*===----------------------------------------------------------------===*/

static TypeRef *check_expr(Checker *c, Expr *e);
static void check_stmt(Checker *c, Stmt *s);
static void check_block(Checker *c, Stmt *block);

/*===----------------------------------------------------------------===*/
/* Type-reference resolution (params, decls, gargs, IV)                  */
/*===----------------------------------------------------------------===*/

static TypeRef *resolve_type(Checker *c, const TypeRef *t);

static TypeRef *resolve_pointer_type(Checker *c, const TypeRef *t) {
  TypeRef *base;
  TypeRef copy = *t;
  copy.is_pointer = 0;
  copy.is_shared = 0;
  if (t->kind != TYPE_SCALAR && t->kind != TYPE_VECTOR) {
    err(c, t->span, "pointer base must be a numeric scalar or vector type");
    return NULL;
  }
  base = resolve_type(c, &copy);
  if (base == NULL)
    return NULL;
  if (base->kind == TYPE_SCALAR && !sk_is_numeric(base->scalar)) {
    err_name(c, t->span, "'%s' is not a valid pointer element type",
             scalar_name(base->scalar),
             (uint32_t)strlen(scalar_name(base->scalar)));
    return NULL;
  }
  return ptr_type(c, base, t->is_shared);
}

static const char *width_syntax(const char *what) {
  if (strcmp(what, "simd") == 0)
    return "simd<T,W>";
  if (strcmp(what, "mask") == 0)
    return "mask<W>";
  return what;
}

static int require_type_width(Checker *c, const TypeRef *t, const char *what) {
  if (!c->has_wave_n) {
    char buf[SEMA_MSG_CAP];
    snprintf(buf, sizeof(buf),
             "%s requires the kernel wave size; add "
             "[[amdgpu_wave_size(N)]]",
             width_syntax(what));
    err(c, t->span, buf);
    return 0;
  }
  if (t->width != c->wave_n) {
    char buf[SEMA_MSG_CAP];
    snprintf(buf, sizeof(buf),
             "%s width %llu must equal the kernel wave size %llu", what,
             (unsigned long long)t->width, (unsigned long long)c->wave_n);
    err(c, t->span, buf);
    return 0;
  }
  return 1;
}

static TypeRef *resolve_mask_type(Checker *c, const TypeRef *t) {
  if (!require_type_width(c, t, "mask"))
    return NULL;
  return mask_type(c, t->width);
}

static TypeRef *resolve_simd_element(Checker *c, const TypeRef *elem) {
  if (elem == NULL) {
    err(c, empty_span(), "simd<T,W> requires an element type");
    return NULL;
  }
  if (elem->kind == TYPE_VECTOR)
    return resolve_type(c, elem);
  if (elem->kind != TYPE_SCALAR || elem->is_pointer) {
    err(c, elem->span,
        "simd element must be a numeric scalar or a vector payload");
    return NULL;
  }
  if (!sk_is_numeric(elem->scalar)) {
    err_name(c, elem->span, "simd element '%s' must be a numeric scalar",
             scalar_name(elem->scalar),
             (uint32_t)strlen(scalar_name(elem->scalar)));
    return NULL;
  }
  return scalar_type(c, elem->scalar);
}

static TypeRef *resolve_simd_type(Checker *c, const TypeRef *t) {
  TypeRef *elem;
  if (!require_type_width(c, t, "simd"))
    return NULL;
  elem = resolve_simd_element(c, t->element);
  if (elem == NULL)
    return NULL;
  return simd_type(c, elem, t->width);
}

static TypeRef *resolve_vector_type(Checker *c, const TypeRef *t) {
  TypeRef *elem;
  TypeRef *vt;
  if (t->element == NULL || t->element->kind != TYPE_SCALAR ||
      t->element->is_pointer || !sk_is_numeric(t->element->scalar)) {
    err(c, t->span, "vector<T,N> element must be a numeric scalar");
    return NULL;
  }
  if (t->width == 0 || t->width > 2147483647u) {
    err(c, t->span, "vector<T,N> length must be between 1 and 2147483647");
    return NULL;
  }
  elem = scalar_type(c, t->element->scalar);
  if (elem == NULL)
    return NULL;
  vt = new_type(c);
  if (vt == NULL)
    return NULL;
  vt->kind = TYPE_VECTOR;
  vt->element = elem;
  vt->width = t->width;
  return vt;
}

static int resolve_fragment_element(Checker *c, const TypeRef *t);
static int resolve_fragment_shape(Checker *c, const TypeRef *t);

static TypeRef *resolve_fragment_type(Checker *c, const TypeRef *t) {
  TypeRef *elem;
  if (!resolve_fragment_element(c, t))
    return NULL;
  if (!resolve_fragment_shape(c, t))
    return NULL;
  elem = scalar_type(c, t->element->scalar);
  if (elem == NULL)
    return NULL;
  return fragment_type(c, elem, t->fragment_role, t->fragment_rows,
                       t->fragment_cols, t->width, t->fragment_registers);
}

static int resolve_fragment_element(Checker *c, const TypeRef *t) {
  if (t->element == NULL || t->element->kind != TYPE_SCALAR ||
      t->element->is_pointer || !sk_is_numeric(t->element->scalar)) {
    err(c, t->span, "fragment element must be a numeric scalar");
    return 0;
  }
  return 1;
}

static int fragment_shape_positive(const TypeRef *t) {
  return t->fragment_rows != 0 && t->fragment_cols != 0 && t->width != 0 &&
         t->fragment_registers != 0;
}

static int fragment_shape_fits_i64(const TypeRef *t) {
  return t->fragment_rows <= (uint64_t)INT64_MAX &&
         t->fragment_cols <= (uint64_t)INT64_MAX &&
         t->width <= (uint64_t)INT64_MAX &&
         t->fragment_registers <= (uint64_t)INT64_MAX;
}

static int resolve_fragment_shape(Checker *c, const TypeRef *t) {
  uint64_t n;
  if (t->fragment_role > 2) {
    err(c, t->span, "fragment role must be 0, 1, or 2");
    return 0;
  }
  if (!fragment_shape_positive(t)) {
    err(c, t->span, "fragment dimensions and register count must be positive");
    return 0;
  }
  if (!fragment_shape_fits_i64(t)) {
    err(c, t->span,
        "fragment dimensions and register count must fit signed 64-bit");
    return 0;
  }
  if (!require_wave_n(c, t->span, &n))
    return 0;
  if (t->width != n) {
    err_uu(c, t->span,
           "fragment wave size %llu must equal the kernel wave size %llu",
           (unsigned long long)t->width, (unsigned long long)n);
    return 0;
  }
  return 1;
}

static TypeRef *resolve_nonpointer_type(Checker *c, const TypeRef *t) {
  switch (t->kind) {
  case TYPE_SCALAR:
    return scalar_type(c, t->scalar);
  case TYPE_MASK:
    return resolve_mask_type(c, t);
  case TYPE_SIMD:
    return resolve_simd_type(c, t);
  case TYPE_VECTOR:
    return resolve_vector_type(c, t);
  case TYPE_FRAGMENT:
    return resolve_fragment_type(c, t);
  case TYPE_VOID:
    err(c, t->span, "void is not a value type");
    return NULL;
  }

  err(c, t->span, "unrecognized type");
  return NULL;
}

static TypeRef *resolve_type(Checker *c, const TypeRef *t) {
  if (t == NULL)
    return NULL;
  if (t->is_shared && !t->is_pointer) {
    err(c, t->span, "'shared' requires a pointer type (shared T*)");
    return NULL;
  }
  if (t->is_pointer)
    return resolve_pointer_type(c, t);
  return resolve_nonpointer_type(c, t);
}

/*===----------------------------------------------------------------===*/
/* Literal coercion                                                      */
/*===----------------------------------------------------------------===*/

/* True if `e` is an integer or floating literal whose type sema has not
 * yet pinned (it is polymorphic until placed in a context). */
static int is_untyped_literal(const Expr *e) {
  return e != NULL && (e->kind == EXPR_INT_LIT || e->kind == EXPR_FLOAT_LIT);
}

/*
 * Try to adopt the element kind `target` for a literal expression. An int
 * literal adopts any integer or index target; a float literal adopts any
 * floating target. On success sets e->sema_type to a scalar of `target`
 * and returns 1; otherwise returns 0 (no diagnostic -- the caller decides
 * whether the mismatch is an error).
 */
static int coerce_literal_to_scalar(Checker *c, Expr *e, ScalarKind target) {
  if (e == NULL)
    return 0;
  if (e->kind == EXPR_INT_LIT) {
    if (sk_is_sized_int(target) || target == SCALAR_INDEX) {
      e->sema_type = scalar_type(c, target);
      return 1;
    }
    return 0;
  }
  if (e->kind == EXPR_FLOAT_LIT) {
    if (sk_is_float(target)) {
      e->sema_type = scalar_type(c, target);
      return 1;
    }
    return 0;
  }
  return 0;
}

/*
 * Coerce `e` (already checked to have provisional type `et`) toward the
 * destination type `dst`. Handles three cases the type-equality check
 * does not:
 *   - an untyped literal adopting a scalar dst (or a simd dst's element,
 *     broadcasting);
 * Returns the final type of `e` (updating e->sema_type when a literal is
 * pinned), or NULL if it cannot be made compatible (caller diagnoses).
 */
static TypeRef *coerce_to(Checker *c, Expr *e, TypeRef *et, TypeRef *dst) {
  if (et == NULL || dst == NULL)
    return NULL;

  if (is_untyped_literal(e)) {
    if (is_scalar(dst)) {
      if (coerce_literal_to_scalar(c, e, dst->scalar))
        return (TypeRef *)e->sema_type;
      return NULL;
    }
    if (is_simd(dst)) {
      ScalarKind ek;
      if (element_scalar(dst, &ek) && coerce_literal_to_scalar(c, e, ek)) {
        /* The literal becomes a scalar that broadcasts into the simd. */
        return (TypeRef *)e->sema_type;
      }
      return NULL;
    }
    return NULL;
  }

  if (type_compatible(et, dst))
    return et;
  return NULL;
}

/*===----------------------------------------------------------------===*/
/* Operator typing                                                       */
/*===----------------------------------------------------------------===*/

/* Operator groupings over TokenKind (the AST echoes the source token). */

static int op_is_arith(TokenKind op) {
  return op == TOK_PLUS || op == TOK_MINUS || op == TOK_STAR ||
         op == TOK_SLASH || op == TOK_PERCENT || op == TOK_SHL || op == TOK_SHR;
}
static int op_requires_int(TokenKind op) {
  return op == TOK_PERCENT || op == TOK_SHL || op == TOK_SHR;
}
static int op_is_compare(TokenKind op) {
  return op == TOK_LT || op == TOK_LE || op == TOK_GT || op == TOK_GE ||
         op == TOK_EQ || op == TOK_NE;
}
static int op_is_bitwise(TokenKind op) {
  return op == TOK_AMP || op == TOK_PIPE || op == TOK_CARET;
}
static int op_is_logical(TokenKind op) {
  return op == TOK_AMPAMP || op == TOK_PIPEPIPE;
}

/* The element kind of a unified arithmetic/compare result for two numeric
 * operands. Both must be numeric and compatible; on integers the result
 * keeps the (shared) width and prefers the signed flavor only for
 * diagnostics (signedness does not affect IR type). Picks `a` when equal.
 * Returns 1 and writes *out, else 0. */
static int unify_numeric(ScalarKind a, ScalarKind b, ScalarKind *out) {
  if (!sk_is_numeric(a) || !sk_is_numeric(b))
    return 0;
  if (sk_is_float(a) != sk_is_float(b))
    return 0; /* no implicit int<->float mixing. */
  if (sk_is_float(a)) {
    if (a != b)
      return 0; /* half vs float need an explicit cast. */
    *out = a;
    return 1;
  }
  /* Both sized ints: must share bit width (signless). */
  if (sk_bits(a) != sk_bits(b))
    return 0;
  *out = a;
  return 1;
}

/*
 * Type a pointer +/- integer-offset expression. `ptr` is a pointer type;
 * `off`/`oe` is the offset operand. A valid offset is index, a sized int,
 * or simd<index|int, W>. The result is the same pointer type (the offset
 * uniform/lane shape is recorded only by the operand's own sema_type --
 * lowering chooses ptr_add vs index_expr). Returns the pointer type, or
 * NULL with a diagnostic.
 */
static TypeRef *type_ptr_offset(Checker *c, Expr *e, TypeRef *ptr, TypeRef *off,
                                Expr *oe) {
  ScalarKind ek;
  if (is_untyped_literal(oe)) {
    /* default an int-literal offset to index. */
    if (coerce_literal_to_scalar(c, oe, SCALAR_INDEX))
      return ptr;
  }
  if (is_scalar(off) && (is_index(off) || sk_is_sized_int(off->scalar)))
    return ptr;
  if (is_simd(off) && element_scalar(off, &ek) &&
      (ek == SCALAR_INDEX || sk_is_sized_int(ek)))
    return ptr;
  err(c, e->span,
      "pointer offset must be an integer or index (scalar or simd)");
  return NULL;
}

/*===----------------------------------------------------------------===*/
/* Builtin call typing                                                   */
/*===----------------------------------------------------------------===*/

/* Match an EXPR_IDENT name against a literal C string. */
static int name_is(const Expr *callee, const char *s) {
  size_t len;
  if (callee == NULL || callee->kind != EXPR_IDENT)
    return 0;
  len = strlen(s);
  return callee->as.ident.name_len == len &&
         memcmp(callee->as.ident.name, s, len) == 0;
}

/* Require exactly `n` value arguments; emit a diagnostic otherwise. */
static int require_argc(Checker *c, Expr *e, size_t n, const char *who) {
  if (e->as.call.arg_count != n) {
    err_u(c, e->span,
          "wrong number of arguments to this builtin (expected %llu)",
          (unsigned long long)n);
    (void)who;
    return 0;
  }
  return 1;
}

/* Check that `e->as.call.dep` (if present) is a token-typed expression.
 * Returns 1 on success (or no dep), 0 on a type error (diagnosed). */
static int check_dep_token(Checker *c, Expr *e) {
  TypeRef *dt;
  if (!e->as.call.has_dep || e->as.call.dep == NULL)
    return 1;
  dt = check_expr(c, e->as.call.dep);
  if (dt == NULL)
    return 0;
  if (!is_token(dt)) {
    err(c, e->as.call.dep->span, "'after' dependency must be a token");
    return 0;
  }
  return 1;
}

/* Check that every value argument is a token; used by barrier/wait/join. */
static int check_all_token_args(Checker *c, Expr *e, int allow_zero,
                                const char *who) {
  size_t i;
  if (!allow_zero && e->as.call.arg_count == 0) {
    err_name(c, e->span, "'%s' requires at least one token argument", who,
             (uint32_t)strlen(who));
    return 0;
  }
  for (i = 0; i < e->as.call.arg_count; i++) {
    TypeRef *at = check_expr(c, e->as.call.args[i]);
    if (at == NULL)
      return 0;
    if (!is_token(at)) {
      err(c, e->as.call.args[i]->span, "argument must be a token");
      return 0;
    }
  }
  return 1;
}

/* Resolve a generic int argument (a width / axis). Returns 1 and writes
 * *out on success, 0 (diagnosed) if the garg is missing or not an int. */
static int garg_int(Checker *c, Expr *e, size_t idx, uint64_t *out) {
  if (idx >= e->as.call.garg_count) {
    err(c, e->span, "missing compile-time argument");
    return 0;
  }
  if (e->as.call.gargs[idx].kind != GARG_INT) {
    err(c, e->as.call.gargs[idx].span,
        "expected an integer compile-time argument");
    return 0;
  }
  *out = e->as.call.gargs[idx].int_value;
  return 1;
}

/* Resolve a generic type argument. Returns the resolved type or NULL. */
static TypeRef *garg_type(Checker *c, Expr *e, size_t idx) {
  if (idx >= e->as.call.garg_count) {
    err(c, e->span, "missing compile-time type argument");
    return NULL;
  }
  if (e->as.call.gargs[idx].kind != GARG_TYPE) {
    err(c, e->as.call.gargs[idx].span, "expected a type compile-time argument");
    return NULL;
  }
  return resolve_type(c, e->as.call.gargs[idx].type);
}

/* Reject any unexpected generic args for a non-generic builtin. */
static int no_gargs(Checker *c, Expr *e, const char *who) {
  if (e->as.call.garg_count != 0) {
    err_name(c, e->span, "'%s' takes no compile-time arguments", who,
             (uint32_t)strlen(who));
    return 0;
  }
  return 1;
}

/* Reject a trailing `after` dependency on a builtin without token ordering
   semantics. Leaving it unchecked also let an undeclared name in the clause
   slip past use-of-undeclared. */
static int no_dep(Checker *c, Expr *e, const char *who) {
  if (e->as.call.has_dep) {
    err_name(c, e->span, "'%s' does not take an 'after' dependency", who,
             (uint32_t)strlen(who));
    return 0;
  }
  return 1;
}

/* The width N of the current kernel, or 0; emits an error if unset. */
static int require_wave_n(Checker *c, SourceSpan span, uint64_t *out) {
  if (!c->has_wave_n) {
    err(c, span,
        "this builtin needs the kernel wave size; add [[amdgpu_wave_size(N)]]");
    return 0;
  }
  *out = c->wave_n;
  return 1;
}

/*
 * The four wave.cast kinds, derived from the source/target element kinds
 * (matches WaveEnums.td and the verifier in Wave.cpp 388-418).
 */
typedef enum CastKindSel {
  CAST_FPCONVERT,  /* fp  -> fp  */
  CAST_INTCONVERT, /* int -> int */
  CAST_INT_TO_FP,  /* int -> fp  */
  CAST_FP_TO_INT   /* fp  -> int */
} CastKindSel;

/*
 * Derive the cast kind from element kinds and confirm every policy the
 * verifier requires is FORMABLE from the static types:
 *   - fpconvert: only optional rounding (always formable);
 *   - intconvert: widening (target bits > source bits) needs an extension
 *     policy taken from the SOURCE int signedness -- formable iff the
 *     source signedness is known (it always is for a sized int);
 *   - int_to_fp / fp_to_int: need a signedness policy from the INT side
 *     (source for int_to_fp, target for fp_to_int) -- formable iff that
 *     int's signedness is known.
 * `src`/`tgt` are numeric scalar element kinds. Returns 1 (and writes the
 * derived kind) on success; on a non-derivable policy emits a diagnostic
 * and returns 0. This is the cast kind/policy derivation the design and
 * the task call out; lowering re-derives the same way from the types.
 */
static int derive_int_convert(Checker *c, SourceSpan span, ScalarKind src,
                              ScalarKind tgt) {
  if (sk_bits(tgt) <= sk_bits(src))
    return 1;
  if (!sk_is_sized_int(src)) {
    err(c, span, "cast<T>: widening int conversion needs a sized-int source");
    return 0;
  }
  (void)sk_is_signed_int(src);
  return 1;
}

static int derive_int_to_fp(Checker *c, SourceSpan span, ScalarKind src) {
  if (sk_is_sized_int(src)) {
    (void)sk_is_signed_int(src);
    return 1;
  }
  err(c, span, "cast<T>: int->fp needs a sized-int source for signedness");
  return 0;
}

static int derive_fp_to_int(Checker *c, SourceSpan span, ScalarKind tgt) {
  if (sk_is_sized_int(tgt)) {
    (void)sk_is_signed_int(tgt);
    return 1;
  }
  err(c, span, "cast<T>: fp->int needs a sized-int target for signedness");
  return 0;
}

static int derive_cast(Checker *c, SourceSpan span, ScalarKind src,
                       ScalarKind tgt, CastKindSel *kind_out) {
  int src_fp = sk_is_float(src);
  int tgt_fp = sk_is_float(tgt);
  if (src_fp && tgt_fp) {
    *kind_out = CAST_FPCONVERT;
    return 1;
  }
  if (!src_fp && !tgt_fp) {
    *kind_out = CAST_INTCONVERT;
    return derive_int_convert(c, span, src, tgt);
  }
  if (!src_fp && tgt_fp) {
    *kind_out = CAST_INT_TO_FP;
    return derive_int_to_fp(c, span, src);
  }
  *kind_out = CAST_FP_TO_INT;
  return derive_fp_to_int(c, span, tgt);
}

/*
 * cast<T>(x): derive the wave.cast kind and confirm a policy is
 * derivable from the static types (kind from src/target element kinds;
 * widening intconvert needs the source int signedness; int_to_fp/fp_to_int
 * need the int signedness -- all available from the sized-int kinds, so
 * the checks here are existence/category checks). Result inherits the
 * lane shape: cast<T>(simd<U,W>) -> simd<T,W>, cast<T>(U) -> T.
 */
static TypeRef *cast_target_type(Checker *c, Expr *e) {
  TypeRef *tgt = garg_type(c, e, 0);
  if (tgt == NULL)
    return NULL;
  if (e->as.call.garg_count != 1) {
    err(c, e->span, "cast<T> takes exactly one type argument");
    return NULL;
  }
  if (is_pointer(tgt))
    return tgt;
  if (!is_scalar(tgt) || !sk_is_numeric(tgt->scalar)) {
    err(c, e->span, "cast<T>: target T must be a numeric scalar or pointer");
    return NULL;
  }
  return tgt;
}

static TypeRef *cast_source_type(Checker *c, Expr *arg) {
  TypeRef *src = check_expr(c, arg);
  if (src == NULL)
    return NULL;
  if (!is_untyped_literal(arg))
    return src;
  if (arg->kind == EXPR_INT_LIT)
    (void)coerce_literal_to_scalar(c, arg, SCALAR_INT32);
  else
    (void)coerce_literal_to_scalar(c, arg, SCALAR_FLOAT);
  return (TypeRef *)arg->sema_type;
}

static int cast_source_element(Checker *c, Expr *arg, TypeRef *src,
                               ScalarKind *se) {
  if (element_scalar(src, se) && sk_is_numeric(*se))
    return 1;
  err(c, arg->span,
      "cast<T>: source must be a numeric scalar or simd of numeric");
  return 0;
}

static TypeRef *type_pointer_cast(Checker *c, Expr *e, Expr *arg, TypeRef *src,
                                  TypeRef *tgt) {
  if (!is_pointer(src)) {
    err(c, arg->span, "cast<T*>: source must be a pointer");
    return NULL;
  }
  if (src->is_shared != tgt->is_shared) {
    err(c, e->span,
        "cast<T*>: source and target pointers must use the same address space");
    return NULL;
  }
  return copy_type(c, tgt);
}

static TypeRef *type_cast(Checker *c, Expr *e) {
  TypeRef *tgt;
  TypeRef *src;
  ScalarKind se;
  Expr *arg;

  tgt = cast_target_type(c, e);
  if (tgt == NULL)
    return NULL;
  if (!require_argc(c, e, 1, "cast"))
    return NULL;
  arg = e->as.call.args[0];
  src = cast_source_type(c, arg);
  if (src == NULL)
    return NULL;
  if (is_pointer(tgt))
    return type_pointer_cast(c, e, arg, src, tgt);
  if (!cast_source_element(c, arg, src, &se))
    return NULL;

  /* Derive the cast kind and validate its required policy is formable
   * from the static element kinds (rejects a cast whose policy cannot be
   * derived). Lowering re-derives the same kind/policy from the types. */
  {
    CastKindSel kind;
    if (!derive_cast(c, e->span, se, tgt->scalar, &kind))
      return NULL;
  }

  if (is_simd(src))
    return simd_type(c, scalar_type(c, tgt->scalar), src->width);
  return scalar_type(c, tgt->scalar);
}

/*
 * index_cast(x): bridges sized int <-> index (arith.index_cast), scalar
 * only. index source -> a sized int (default int32, adoptable like a
 * literal at assignment); sized-int source -> index. Rejects simd / other
 * categories.
 */
static TypeRef *type_index_cast(Checker *c, Expr *e) {
  TypeRef *src;
  Expr *arg;
  if (!no_gargs(c, e, "index_cast"))
    return NULL;
  if (!require_argc(c, e, 1, "index_cast"))
    return NULL;
  arg = e->as.call.args[0];
  src = check_expr(c, arg);
  if (src == NULL)
    return NULL;
  if (is_untyped_literal(arg)) {
    /* index_cast(<int literal>) -> index is the only sensible reading. */
    (void)coerce_literal_to_scalar(c, arg, SCALAR_INT32);
    src = (TypeRef *)arg->sema_type;
  }
  if (!is_scalar(src)) {
    err(c, arg->span, "index_cast expects a scalar int or index operand");
    return NULL;
  }
  if (is_index(src))
    return scalar_type(c, SCALAR_INT32); /* index -> int (sized). */
  if (sk_is_sized_int(src->scalar))
    return scalar_type(c, SCALAR_INDEX); /* int -> index. */
  err(c, arg->span, "index_cast operand must be a sized int or index");
  return NULL;
}

static TypeRef *lds_base_type_arg(Checker *c, Expr *e) {
  if (e->as.call.garg_count != 1) {
    err(c, e->span, "lds_base<T> takes exactly one type argument");
    return NULL;
  }
  TypeRef *t = garg_type(c, e, 0);
  if (t == NULL)
    return NULL;
  if ((t->kind != TYPE_SCALAR && t->kind != TYPE_VECTOR) ||
      (t->kind == TYPE_SCALAR && !sk_is_numeric(t->scalar))) {
    err(c, e->span, "lds_base<T>: T must be a numeric scalar or vector type");
    return NULL;
  }
  return t;
}

static int check_lds_base_offset(Checker *c, Expr *e) {
  if (e->as.call.arg_count > 1) {
    err(c, e->span, "lds_base takes at most one (compile-time) offset");
    return 0;
  }
  if (e->as.call.arg_count == 1) {
    Expr *a = e->as.call.args[0];
    if (a->kind != EXPR_INT_LIT) {
      err(c, a->span, "lds_base offset must be a compile-time integer");
      return 0;
    }
    a->sema_type = scalar_type(c, SCALAR_INT64);
  }
  return 1;
}

/*
 * lds_base<T>([K]): a uniform shared T* into the kernel LDS arena. The
 * optional K is a compile-time byte offset (int literal, default 0).
 */
static TypeRef *type_lds_base(Checker *c, Expr *e) {
  TypeRef *t = lds_base_type_arg(c, e);
  if (t == NULL)
    return NULL;
  if (!check_lds_base_offset(c, e))
    return NULL;
  if (e->as.call.has_dep) {
    err(c, e->span, "lds_base does not take an 'after' dependency");
    return NULL;
  }
  return ptr_type(c, t, /*is_shared=*/1);
}

static TypeRef *pointee_type(Checker *c, const TypeRef *p) {
  TypeRef *base = copy_type(c, p);
  if (base == NULL)
    return NULL;
  base->is_pointer = 0;
  base->is_shared = 0;
  return base;
}

/*
 * load(ptr [after t]): yields simd<elem(ptr), N> (and a token, captured
 * only in the destructuring form). The pointer's element type drives the
 * payload; the width is the kernel N regardless of the offset's shape.
 */
static TypeRef *type_load(Checker *c, Expr *e) {
  TypeRef *p;
  TypeRef *base;
  uint64_t n;
  if (!no_gargs(c, e, "load"))
    return NULL;
  if (!require_argc(c, e, 1, "load"))
    return NULL;
  p = check_expr(c, e->as.call.args[0]);
  if (p == NULL)
    return NULL;
  if (!is_pointer(p)) {
    err(c, e->as.call.args[0]->span, "load expects a pointer operand");
    return NULL;
  }
  if (!check_dep_token(c, e))
    return NULL;
  if (!require_wave_n(c, e->span, &n))
    return NULL;
  base = pointee_type(c, p);
  if (base == NULL)
    return NULL;
  return simd_type(c, base, n);
}

/*
 * store(value, ptr [after t]): value is simd<T,N>, ptr is T* with a
 * matching element; yields a token. Value-first to match the IR.
 */
static int check_store_pointer(Checker *c, Expr *ptr_expr, TypeRef *p) {
  if (p == NULL)
    return 0;
  if (is_pointer(p))
    return 1;
  err(c, ptr_expr->span, "store target must be a pointer");
  return 0;
}

static int check_store_value_shape(Checker *c, Expr *value_expr, TypeRef *v) {
  if (v == NULL)
    return 0;
  if (is_simd(v))
    return 1;
  err(c, value_expr->span,
      "store value must be a simd<T,W> (lane-varying) value");
  return 0;
}

static int check_store_value(Checker *c, Expr *value_expr, TypeRef *v,
                             TypeRef *p, SourceSpan span) {
  ScalarKind ve;
  TypeRef *base = pointee_type(c, p);
  if (base == NULL)
    return 0;
  if (is_untyped_literal(value_expr) && base->kind == TYPE_SCALAR)
    (void)coerce_literal_to_scalar(c, value_expr, base->scalar);
  v = (TypeRef *)value_expr->sema_type;
  if (!check_store_value_shape(c, value_expr, v))
    return 0;
  if (v->kind == TYPE_SIMD && type_compatible(v->element, base))
    return 1;
  {
    char buf[SEMA_MSG_CAP];
    snprintf(buf, sizeof(buf),
             "store value element '%s' does not match pointer element '%s'",
             element_scalar(v, &ve) ? scalar_name(ve) : type_category(v),
             type_category(base));
    err(c, span, buf);
  }
  return 0;
}

static TypeRef *type_store(Checker *c, Expr *e) {
  TypeRef *v;
  TypeRef *p;
  int ok;
  if (!no_gargs(c, e, "store"))
    return NULL;
  if (!require_argc(c, e, 2, "store"))
    return NULL;
  v = check_expr(c, e->as.call.args[0]);
  p = check_expr(c, e->as.call.args[1]);
  ok = check_store_pointer(c, e->as.call.args[1], p);
  if (!ok)
    (void)check_store_value_shape(c, e->as.call.args[0], v);
  if (ok && !check_store_value(c, e->as.call.args[0], v, p, e->span))
    ok = 0;
  if (!ok)
    return NULL;
  if (!check_dep_token(c, e))
    return NULL;
  return scalar_type(c, SCALAR_TOKEN);
}

static int is_fragment(const TypeRef *t) {
  return t != NULL && t->kind == TYPE_FRAGMENT && !t->is_pointer;
}

typedef enum FragElemClass {
  FRAG_ELEM_I8,
  FRAG_ELEM_I32,
  FRAG_ELEM_F16,
  FRAG_ELEM_F32
} FragElemClass;

static int fragment_is_16x16(const TypeRef *t) {
  return t->fragment_rows == 16 && t->fragment_cols == 16;
}

static int fragment_elem_matches(const TypeRef *t, FragElemClass elem) {
  ScalarKind k = t->element->scalar;
  switch (elem) {
  case FRAG_ELEM_I8:
    return sk_is_sized_int(k) && sk_bits(k) == 8;
  case FRAG_ELEM_I32:
    return sk_is_sized_int(k) && sk_bits(k) == 32;
  case FRAG_ELEM_F16:
    return k == SCALAR_HALF;
  case FRAG_ELEM_F32:
    return k == SCALAR_FLOAT;
  }
  return 0;
}

static int fragment_matches(const TypeRef *t, uint64_t role, FragElemClass elem,
                            uint64_t regs, uint64_t wave) {
  return is_fragment(t) && t->fragment_role == role && t->width == wave &&
         t->fragment_registers == regs && fragment_is_16x16(t) &&
         fragment_elem_matches(t, elem);
}

static int fragment_fill_ab_supported(const TypeRef *t) {
  if (fragment_elem_matches(t, FRAG_ELEM_I8))
    return t->fragment_registers == 4;
  if (fragment_elem_matches(t, FRAG_ELEM_F16))
    return t->fragment_registers == 2 || t->fragment_registers == 4 ||
           t->fragment_registers == 8;
  return 0;
}

static int fragment_fill_supported(const TypeRef *t) {
  if (!is_fragment(t) || !fragment_is_16x16(t))
    return 0;
  if (t->fragment_role != 2)
    return fragment_fill_ab_supported(t);
  return (fragment_elem_matches(t, FRAG_ELEM_I32) ||
          fragment_elem_matches(t, FRAG_ELEM_F32)) &&
         (t->fragment_registers == 4 || t->fragment_registers == 8);
}

typedef struct MmaSpec {
  const char *name;
  FragElemClass abElem;
  FragElemClass accElem;
  uint64_t abRegs;
  uint64_t accRegs;
  uint64_t wave;
} MmaSpec;

static const MmaSpec *find_mma_spec(const Expr *callee) {
  static const MmaSpec specs[] = {
      {"mma_wmma_i32_16x16x16_iu8", FRAG_ELEM_I8, FRAG_ELEM_I32, 4, 8, 32},
      {"mma_wmma_f32_16x16x16_f16", FRAG_ELEM_F16, FRAG_ELEM_F32, 8, 8, 32},
      {"mma_mfma_f32_16x16x16_f16", FRAG_ELEM_F16, FRAG_ELEM_F32, 2, 4, 32},
      {"mma_mfma_f32_16x16x32_f16", FRAG_ELEM_F16, FRAG_ELEM_F32, 4, 4, 64},
  };
  size_t i;
  for (i = 0; i < sizeof(specs) / sizeof(specs[0]); i++)
    if (name_is(callee, specs[i].name))
      return &specs[i];
  return NULL;
}

static int check_mma_shapes(Checker *c, Expr *e, const MmaSpec *spec,
                            TypeRef *a, TypeRef *b, TypeRef *acc) {
  if (!fragment_matches(a, 0, spec->abElem, spec->abRegs, spec->wave)) {
    err(c, e->as.call.args[0]->span,
        "mma A operand does not match selected builtin");
    return 0;
  }
  if (!fragment_matches(b, 1, spec->abElem, spec->abRegs, spec->wave)) {
    err(c, e->as.call.args[1]->span,
        "mma B operand does not match selected builtin");
    return 0;
  }
  if (!fragment_matches(acc, 2, spec->accElem, spec->accRegs, spec->wave)) {
    err(c, e->as.call.args[2]->span,
        "mma accumulator does not match selected builtin");
    return 0;
  }
  return 1;
}

static TypeRef *simd_vector_payload(const TypeRef *t, uint64_t width,
                                    uint64_t registers) {
  if (t == NULL || t->kind != TYPE_SIMD || t->width != width)
    return NULL;
  if (t->element == NULL || t->element->kind != TYPE_VECTOR)
    return NULL;
  if (t->element->width != registers)
    return NULL;
  return t->element->element;
}

static int is_scalar_i32(const TypeRef *t) {
  if (t == NULL || t->kind != TYPE_SCALAR || t->is_pointer)
    return 0;
  return sk_is_sized_int(t->scalar) && sk_bits(t->scalar) == 32;
}

static int is_simd_vector_i32(const TypeRef *t, uint64_t width,
                              uint64_t registers) {
  return is_scalar_i32(simd_vector_payload(t, width, registers));
}

/* Dedicated marker: statements accept `wait`, expressions reject it. */
static TypeRef *void_marker(Checker *c) {
  TypeRef *t = new_type(c);
  if (t == NULL)
    return NULL;
  t->kind = TYPE_VOID;
  return t;
}
static int is_void_marker(const TypeRef *t) {
  return t != NULL && t->kind == TYPE_VOID;
}

/*
 * Dispatch a call whose callee is a predeclared builtin identifier.
 * Returns the result type (possibly the void marker for `wait`), or NULL
 * on error. Unknown callee names are reported as not-supported / unknown.
 */
static TypeRef *type_lane_id(Checker *c, Expr *e) {
  uint64_t w;
  uint64_t n;
  if (e->as.call.garg_count != 1) {
    err(c, e->span, "lane_id<W> takes exactly one width argument");
    return NULL;
  }
  if (!garg_int(c, e, 0, &w))
    return NULL;
  if (!require_wave_n(c, e->span, &n))
    return NULL;
  if (w != n) {
    err_uu(c, e->span,
           "lane_id width %llu must equal the kernel wave size %llu",
           (unsigned long long)w, (unsigned long long)n);
    return NULL;
  }
  if (!require_argc(c, e, 0, "lane_id"))
    return NULL;
  if (!no_dep(c, e, "lane_id"))
    return NULL;
  return simd_type(c, scalar_type(c, SCALAR_INT32), n);
}

static TypeRef *type_wave_id_in_grid(Checker *c, Expr *e) {
  if (!no_gargs(c, e, "wave_id_in_grid"))
    return NULL;
  if (!require_argc(c, e, 0, "wave_id_in_grid"))
    return NULL;
  if (!no_dep(c, e, "wave_id_in_grid"))
    return NULL;
  return scalar_type(c, SCALAR_UINT32);
}

static TypeRef *type_workgroup_id(Checker *c, Expr *e) {
  uint64_t w;
  if (!garg_int(c, e, 0, &w) || e->as.call.garg_count != 1) {
    err(c, e->span, "workgroup_id<ax> takes one axis argument (0..2)");
    return NULL;
  }
  if (w > 2) {
    err_u(c, e->span, "workgroup_id axis %llu out of range (0..2)", w);
    return NULL;
  }
  if (!require_argc(c, e, 0, "workgroup_id"))
    return NULL;
  if (!no_dep(c, e, "workgroup_id"))
    return NULL;
  return scalar_type(c, SCALAR_UINT32);
}

static TypeRef *type_workitem_id(Checker *c, Expr *e) {
  uint64_t w;
  uint64_t n;
  if (!garg_int(c, e, 0, &w) || e->as.call.garg_count != 1) {
    err(c, e->span, "workitem_id<ax> takes one axis argument (0..2)");
    return NULL;
  }
  if (w > 2) {
    err_u(c, e->span, "workitem_id axis %llu out of range (0..2)", w);
    return NULL;
  }
  if (!require_argc(c, e, 0, "workitem_id"))
    return NULL;
  if (!require_wave_n(c, e->span, &n))
    return NULL;
  if (!no_dep(c, e, "workitem_id"))
    return NULL;
  return simd_type(c, scalar_type(c, SCALAR_INT32), n);
}

static TypeRef *type_subgroup_id(Checker *c, Expr *e) {
  if (!no_gargs(c, e, "subgroup_id"))
    return NULL;
  if (!require_argc(c, e, 0, "subgroup_id"))
    return NULL;
  if (!no_dep(c, e, "subgroup_id"))
    return NULL;
  return scalar_type(c, SCALAR_INDEX);
}

static TypeRef *type_read_first(Checker *c, Expr *e) {
  TypeRef *src;
  if (!no_gargs(c, e, "read_first"))
    return NULL;
  if (!require_argc(c, e, 1, "read_first"))
    return NULL;
  src = check_expr(c, e->as.call.args[0]);
  if (src == NULL)
    return NULL;
  if (!is_simd(src)) {
    err(c, e->as.call.args[0]->span, "read_first expects a simd value");
    return NULL;
  }
  if (!no_dep(c, e, "read_first"))
    return NULL;
  return src->element;
}

static TypeRef *type_fragment_fill(Checker *c, Expr *e) {
  TypeRef *frag;
  TypeRef *src;
  if (e->as.call.garg_count != 1) {
    err(c, e->span, "fragment_fill<T> takes exactly one fragment type");
    return NULL;
  }
  frag = garg_type(c, e, 0);
  if (!is_fragment(frag)) {
    err(c, e->span, "fragment_fill<T>: T must be a fragment type");
    return NULL;
  }
  if (!require_argc(c, e, 1, "fragment_fill"))
    return NULL;
  src = check_expr(c, e->as.call.args[0]);
  if (is_untyped_literal(e->as.call.args[0])) {
    (void)coerce_literal_to_scalar(c, e->as.call.args[0], SCALAR_INT32);
    src = (TypeRef *)e->as.call.args[0]->sema_type;
  }
  if (src == NULL)
    return NULL;
  if (!is_scalar_i32(src)) {
    err(c, e->as.call.args[0]->span,
        "fragment_fill source must be an i32 bit pattern");
    return NULL;
  }
  if (!fragment_fill_supported(frag)) {
    err(c, e->span, "fragment_fill unsupported fragment layout");
    return NULL;
  }
  if (!no_dep(c, e, "fragment_fill"))
    return NULL;
  return frag;
}

static TypeRef *type_fragment_pack(Checker *c, Expr *e) {
  TypeRef *frag;
  TypeRef *regs;
  if (e->as.call.garg_count != 1) {
    err(c, e->span, "fragment_pack<T> takes exactly one fragment type");
    return NULL;
  }
  frag = garg_type(c, e, 0);
  if (!is_fragment(frag)) {
    err(c, e->span, "fragment_pack<T>: T must be a fragment type");
    return NULL;
  }
  if (!require_argc(c, e, 1, "fragment_pack"))
    return NULL;
  regs = check_expr(c, e->as.call.args[0]);
  if (regs == NULL)
    return NULL;
  if (!is_simd_vector_i32(regs, frag->width, frag->fragment_registers)) {
    err(c, e->as.call.args[0]->span,
        "fragment_pack source must be simd<vector<int32_t,R>,W>");
    return NULL;
  }
  if (!no_dep(c, e, "fragment_pack"))
    return NULL;
  return frag;
}

static TypeRef *type_fragment_unpack(Checker *c, Expr *e) {
  TypeRef *frag;
  if (!no_gargs(c, e, "fragment_unpack"))
    return NULL;
  if (!require_argc(c, e, 1, "fragment_unpack"))
    return NULL;
  frag = check_expr(c, e->as.call.args[0]);
  if (!is_fragment(frag)) {
    err(c, e->as.call.args[0]->span,
        "fragment_unpack expects a fragment value");
    return NULL;
  }
  if (!no_dep(c, e, "fragment_unpack"))
    return NULL;
  return simd_type(
      c, vector_type(c, scalar_type(c, SCALAR_INT32), frag->fragment_registers),
      frag->width);
}

static TypeRef *type_mma(Checker *c, Expr *e) {
  const MmaSpec *spec;
  TypeRef *a;
  TypeRef *b;
  TypeRef *acc;
  if (!no_gargs(c, e, "mma"))
    return NULL;
  if (!require_argc(c, e, 3, "mma"))
    return NULL;
  a = check_expr(c, e->as.call.args[0]);
  b = check_expr(c, e->as.call.args[1]);
  acc = check_expr(c, e->as.call.args[2]);
  if (!is_fragment(a) || !is_fragment(b) || !is_fragment(acc)) {
    err(c, e->span, "mma operands must be fragments");
    return NULL;
  }
  spec = find_mma_spec(e->as.call.callee);
  if (spec == NULL) {
    err(c, e->span, "unknown mma builtin");
    return NULL;
  }
  if (!check_mma_shapes(c, e, spec, a, b, acc))
    return NULL;
  if (!no_dep(c, e, "mma"))
    return NULL;
  return acc;
}

static TypeRef *type_barrier(Checker *c, Expr *e) {
  if (!no_gargs(c, e, "barrier"))
    return NULL;
  if (!check_all_token_args(c, e, /*allow_zero=*/1, "barrier"))
    return NULL;
  if (e->as.call.has_dep) {
    err(c, e->span,
        "barrier dependencies are passed as arguments, not 'after'");
    return NULL;
  }
  return scalar_type(c, SCALAR_TOKEN);
}

static TypeRef *type_join(Checker *c, Expr *e) {
  if (!no_gargs(c, e, "join"))
    return NULL;
  if (!check_all_token_args(c, e, /*allow_zero=*/0, "join"))
    return NULL;
  if (!no_dep(c, e, "join"))
    return NULL;
  return scalar_type(c, SCALAR_TOKEN);
}

static TypeRef *type_wait(Checker *c, Expr *e) {
  if (!no_gargs(c, e, "wait"))
    return NULL;
  if (!check_all_token_args(c, e, /*allow_zero=*/0, "wait"))
    return NULL;
  if (!no_dep(c, e, "wait"))
    return NULL;
  return void_marker(c);
}

static TypeRef *type_lds_base_checked(Checker *c, Expr *e) {
  if (!no_dep(c, e, "lds_base"))
    return NULL;
  return type_lds_base(c, e);
}

static TypeRef *type_index_cast_checked(Checker *c, Expr *e) {
  if (!no_dep(c, e, "index_cast"))
    return NULL;
  return type_index_cast(c, e);
}

static TypeRef *type_cast_checked(Checker *c, Expr *e) {
  if (!no_dep(c, e, "cast"))
    return NULL;
  return type_cast(c, e);
}

typedef TypeRef *(*BuiltinTyper)(Checker *c, Expr *e);

typedef struct BuiltinEntry {
  const char *name;
  BuiltinTyper type;
} BuiltinEntry;

static const BuiltinEntry kBuiltins[] = {
    {"lane_id", type_lane_id},
    {"wave_id_in_grid", type_wave_id_in_grid},
    {"workgroup_id", type_workgroup_id},
    {"workitem_id", type_workitem_id},
    {"subgroup_id", type_subgroup_id},
    {"read_first", type_read_first},
    {"load", type_load},
    {"store", type_store},
    {"barrier", type_barrier},
    {"join", type_join},
    {"wait", type_wait},
    {"lds_base", type_lds_base_checked},
    {"index_cast", type_index_cast_checked},
    {"cast", type_cast_checked},
    {"fragment_fill", type_fragment_fill},
    {"fragment_pack", type_fragment_pack},
    {"fragment_unpack", type_fragment_unpack},
    {"mma_wmma_i32_16x16x16_iu8", type_mma},
    {"mma_wmma_f32_16x16x16_f16", type_mma},
    {"mma_mfma_f32_16x16x16_f16", type_mma},
    {"mma_mfma_f32_16x16x32_f16", type_mma},
};

static TypeRef *type_builtin_call(Checker *c, Expr *e) {
  const Expr *callee = e->as.call.callee;
  size_t i;

  if (callee == NULL || callee->kind != EXPR_IDENT) {
    err(c, e->span, "call of a non-identifier is not supported");
    return NULL;
  }

  for (i = 0; i < sizeof(kBuiltins) / sizeof(kBuiltins[0]); i++) {
    if (name_is(callee, kBuiltins[i].name))
      return kBuiltins[i].type(c, e);
  }

  /* A name that is in scope as a value cannot be "called" in v1 (no user
   * functions, no function pointers). */
  if (sym_lookup(c, callee->as.ident.name, callee->as.ident.name_len) != NULL) {
    err_name(c, e->span, "'%s' is not callable", callee->as.ident.name,
             callee->as.ident.name_len);
    return NULL;
  }

  err_name(c, e->span, "unknown builtin or function '%s'",
           callee->as.ident.name, callee->as.ident.name_len);
  return NULL;
}

/*===----------------------------------------------------------------===*/
/* Expression checking                                                   */
/*===----------------------------------------------------------------===*/

/* Check a unary operator expression. */
static TypeRef *check_unary_minus(Checker *c, Expr *e, TypeRef *t) {
  ScalarKind ek;
  if (is_untyped_literal(e->as.unary.operand)) {
    t = (TypeRef *)e->as.unary.operand->sema_type;
    if (t == NULL)
      t = scalar_type(c, SCALAR_INT32);
    e->sema_type = t;
    return t;
  }
  if ((is_scalar(t) && sk_is_numeric(t->scalar)) ||
      (is_simd(t) && element_scalar(t, &ek) && sk_is_numeric(ek))) {
    e->sema_type = t;
    return t;
  }
  err(c, e->span, "unary '-' requires a numeric scalar or simd operand");
  return NULL;
}

static TypeRef *check_unary_tilde(Checker *c, Expr *e, TypeRef *t) {
  ScalarKind ek;
  if (is_mask(t)) {
    e->sema_type = t;
    return t;
  }
  if ((is_scalar(t) && sk_is_sized_int(t->scalar)) ||
      (is_simd(t) && element_scalar(t, &ek) && sk_is_sized_int(ek))) {
    e->sema_type = t;
    return t;
  }
  err(c, e->span, "unary '~' requires an integer scalar/simd or a mask");
  return NULL;
}

static TypeRef *check_unary_bang(Checker *c, Expr *e, TypeRef *t) {
  if (is_bool(t) || is_mask(t)) {
    e->sema_type = t;
    return t;
  }
  err(c, e->span, "unary '!' requires a bool or a mask");
  return NULL;
}

static TypeRef *check_unary(Checker *c, Expr *e) {
  TypeRef *t = check_expr(c, e->as.unary.operand);
  TokenKind op = e->as.unary.op;
  if (t == NULL)
    return NULL;
  if (op == TOK_MINUS)
    return check_unary_minus(c, e, t);
  if (op == TOK_TILDE)
    return check_unary_tilde(c, e, t);
  if (op == TOK_BANG)
    return check_unary_bang(c, e, t);

  err(c, e->span, "unsupported unary operator");
  return NULL;
}

/* Check a binary operator expression, applying the Type Rules: scalar
 * broadcasts into simd; compare yields mask (simd) or bool (scalar);
 * pointer +/- offset; mask algebra; uniform logical on bool. */
static TypeRef *try_pointer_binary(Checker *c, Expr *e, TypeRef *lt,
                                   TypeRef *rt, Expr *le, Expr *re,
                                   TokenKind op, int *handled) {
  *handled = 0;
  if (op != TOK_PLUS && op != TOK_MINUS)
    return NULL;
  if (is_pointer(lt) && !is_pointer(rt)) {
    *handled = 1;
    e->sema_type = type_ptr_offset(c, e, lt, rt, re);
    return e->sema_type;
  }
  if (is_pointer(rt) && !is_pointer(lt) && op == TOK_PLUS) {
    *handled = 1;
    e->sema_type = type_ptr_offset(c, e, rt, lt, le);
    return e->sema_type;
  }
  if (is_pointer(lt) || is_pointer(rt)) {
    *handled = 1;
    err(c, e->span, "unsupported pointer arithmetic");
  }
  return NULL;
}

static TypeRef *try_mask_binary(Checker *c, Expr *e, TypeRef *lt, TypeRef *rt,
                                TokenKind op, int *handled) {
  *handled = op_is_bitwise(op) && is_mask(lt) && is_mask(rt);
  if (!*handled)
    return NULL;
  if (lt->width != rt->width) {
    err(c, e->span, "mask operands must have the same width");
    return NULL;
  }
  e->sema_type = mask_type(c, lt->width);
  return e->sema_type;
}

static TypeRef *try_logical_binary(Checker *c, Expr *e, TypeRef *lt,
                                   TypeRef *rt, TokenKind op, int *handled) {
  *handled = op_is_logical(op);
  if (!*handled)
    return NULL;
  if (is_bool(lt) && is_bool(rt)) {
    e->sema_type = scalar_type(c, SCALAR_BOOL);
    return e->sema_type;
  }
  err(c, e->span,
      "logical '&&'/'||' require bool operands (use '&'/'|' for mask algebra)");
  return NULL;
}

static ScalarKind default_literal_kind(Expr *e) {
  return e->kind == EXPR_INT_LIT ? SCALAR_INT32 : SCALAR_FLOAT;
}

static void coerce_binary_literals(Checker *c, Expr *le, Expr *re, TypeRef **lt,
                                   TypeRef **rt) {
  ScalarKind ek;
  if (is_untyped_literal(le) && !is_untyped_literal(re)) {
    if (element_scalar(*rt, &ek))
      (void)coerce_literal_to_scalar(c, le, ek);
    *lt = (TypeRef *)le->sema_type;
    return;
  }
  if (is_untyped_literal(re) && !is_untyped_literal(le)) {
    if (element_scalar(*lt, &ek))
      (void)coerce_literal_to_scalar(c, re, ek);
    *rt = (TypeRef *)re->sema_type;
    return;
  }
  if (is_untyped_literal(le) && is_untyped_literal(re)) {
    (void)coerce_literal_to_scalar(c, le, default_literal_kind(le));
    (void)coerce_literal_to_scalar(c, re, default_literal_kind(re));
    *lt = (TypeRef *)le->sema_type;
    *rt = (TypeRef *)re->sema_type;
  }
}

static int check_numeric_inputs(Checker *c, Expr *e, TypeRef *lt, TypeRef *rt,
                                ScalarKind *lk, ScalarKind *rk) {
  if (!element_scalar(lt, lk) || !element_scalar(rt, rk)) {
    err(c, e->span, "operator requires numeric scalar or simd operands");
    return 0;
  }
  if (is_simd(lt) && is_simd(rt) && lt->width != rt->width) {
    err(c, e->span, "simd operands must have the same width");
    return 0;
  }
  return 1;
}

static int check_numeric_op(Checker *c, Expr *e, TokenKind op, ScalarKind lk,
                            ScalarKind rk, ScalarKind *unified) {
  if (!unify_numeric(lk, rk, unified)) {
    char buf[SEMA_MSG_CAP];
    snprintf(buf, sizeof(buf),
             "incompatible operand element types ('%s' and '%s')",
             scalar_name(lk), scalar_name(rk));
    err(c, e->span, buf);
    return 0;
  }
  if (op_requires_int(op) && !sk_is_sized_int(*unified)) {
    err(c, e->span, "operator requires integer operands");
    return 0;
  }
  if (op_is_bitwise(op) && !sk_is_sized_int(*unified)) {
    err(c, e->span, "bitwise operator requires integer operands");
    return 0;
  }
  return 1;
}

static int scalar_index_or_int(const TypeRef *t, ScalarKind *k) {
  if (!is_scalar(t))
    return 0;
  *k = t->scalar;
  return *k == SCALAR_INDEX || sk_is_sized_int(*k);
}

static TypeRef *try_index_binary(Checker *c, Expr *e, TypeRef *lt, TypeRef *rt,
                                 TokenKind op, int *handled) {
  ScalarKind lk;
  ScalarKind rk;
  *handled = 0;
  if (!op_is_arith(op) && !op_is_bitwise(op) && !op_is_compare(op))
    return NULL;
  if (!scalar_index_or_int(lt, &lk) || !scalar_index_or_int(rt, &rk))
    return NULL;
  if (lk != SCALAR_INDEX && rk != SCALAR_INDEX)
    return NULL;
  *handled = 1;
  e->sema_type = op_is_compare(op) ? scalar_type(c, SCALAR_BOOL)
                                   : scalar_type(c, SCALAR_INDEX);
  return e->sema_type;
}

static TypeRef *finish_numeric_binary(Checker *c, Expr *e, TypeRef *lt,
                                      TypeRef *rt, TokenKind op,
                                      ScalarKind unified) {
  int l_simd = is_simd(lt);
  int r_simd = is_simd(rt);
  if (op_is_compare(op)) {
    e->sema_type = (l_simd || r_simd)
                       ? mask_type(c, l_simd ? lt->width : rt->width)
                       : scalar_type(c, SCALAR_BOOL);
    return e->sema_type;
  }
  if (op_is_arith(op) || op_is_bitwise(op)) {
    e->sema_type = (l_simd || r_simd)
                       ? simd_type(c, scalar_type(c, unified),
                                   l_simd ? lt->width : rt->width)
                       : scalar_type(c, unified);
    return e->sema_type;
  }
  err(c, e->span, "unsupported binary operator");
  return NULL;
}

static TypeRef *try_special_binary(Checker *c, Expr *e, TypeRef *lt,
                                   TypeRef *rt, Expr *le, Expr *re,
                                   TokenKind op, int *handled) {
  TypeRef *special = try_pointer_binary(c, e, lt, rt, le, re, op, handled);
  if (*handled)
    return special;
  special = try_mask_binary(c, e, lt, rt, op, handled);
  if (*handled)
    return special;
  return try_logical_binary(c, e, lt, rt, op, handled);
}

static TypeRef *check_numeric_or_index_binary(Checker *c, Expr *e, Expr *le,
                                              Expr *re, TypeRef *lt,
                                              TypeRef *rt, TokenKind op) {
  ScalarKind lk;
  ScalarKind rk;
  ScalarKind unified;
  int handled;

  coerce_binary_literals(c, le, re, &lt, &rt);
  if (lt == NULL || rt == NULL)
    return NULL;
  TypeRef *special = try_index_binary(c, e, lt, rt, op, &handled);
  if (handled)
    return special;
  if (!check_numeric_inputs(c, e, lt, rt, &lk, &rk))
    return NULL;
  if (!check_numeric_op(c, e, op, lk, rk, &unified))
    return NULL;
  return finish_numeric_binary(c, e, lt, rt, op, unified);
}

static TypeRef *check_binary(Checker *c, Expr *e) {
  TokenKind op = e->as.binary.op;
  Expr *le = e->as.binary.lhs;
  Expr *re = e->as.binary.rhs;
  TypeRef *lt = check_expr(c, le);
  TypeRef *rt = check_expr(c, re);
  int handled;

  if (lt == NULL || rt == NULL)
    return NULL;
  TypeRef *special = try_special_binary(c, e, lt, rt, le, re, op, &handled);
  if (handled)
    return special;
  return check_numeric_or_index_binary(c, e, le, re, lt, rt, op);
}

/* Check an identifier reference: resolve to an in-scope symbol; enforce
 * definite assignment (an in-scope but undefined local is a use before
 * definition). A bare builtin name used as a value is not supported. */
static TypeRef *check_ident(Checker *c, Expr *e) {
  Symbol *s = sym_lookup(c, e->as.ident.name, e->as.ident.name_len);
  if (s == NULL) {
    err_name(c, e->span, "use of undeclared identifier '%s'", e->as.ident.name,
             e->as.ident.name_len);
    return NULL;
  }
  if (!s->defined) {
    err_name(c, e->span, "use of '%s' before its definition", e->as.ident.name,
             e->as.ident.name_len);
    return NULL;
  }
  e->sema_type = s->type;
  return s->type;
}

/* Top-level expression dispatch. Fills e->sema_type as a side effect and
 * returns the same type (NULL on error). */
static TypeRef *check_call_expr(Checker *c, Expr *e) {
  TypeRef *t = type_builtin_call(c, e);
  if (t != NULL && !is_void_marker(t))
    e->sema_type = t;
  return t;
}

static TypeRef *check_expr_inner(Checker *c, Expr *e) {
  TypeRef *t;
  t = NULL;
  switch (e->kind) {
  case EXPR_INT_LIT:
    /* Provisional: an int literal is polymorphic. Default to int32 so a
     * standalone use still has a concrete type; contexts that adopt it
     * (assignment, broadcast, offsets) override this before it matters. */
    t = scalar_type(c, SCALAR_INT32);
    e->sema_type = t;
    break;
  case EXPR_FLOAT_LIT:
    t = scalar_type(c, SCALAR_FLOAT);
    e->sema_type = t;
    break;
  case EXPR_IDENT:
    t = check_ident(c, e);
    break;
  case EXPR_TOKEN_SEED:
    t = scalar_type(c, SCALAR_TOKEN);
    e->sema_type = t;
    break;
  case EXPR_PAREN:
    t = check_expr(c, e->as.paren);
    e->sema_type = t;
    break;
  case EXPR_UNARY:
    t = check_unary(c, e);
    break;
  case EXPR_BINARY:
    t = check_binary(c, e);
    break;
  case EXPR_CALL:
    t = check_call_expr(c, e);
    break;
  }
  return t;
}

static TypeRef *check_expr(Checker *c, Expr *e) {
  TypeRef *t;
  if (e == NULL)
    return NULL;
  if (c->depth >= SEMA_MAX_DEPTH) {
    err(c, e->span, "maximum expression nesting depth exceeded");
    return NULL;
  }
  c->depth++;
  t = check_expr_inner(c, e);
  c->depth--;
  return t;
}

/* Check an expression used in a value context (rejects the void marker
 * and a NULL result). Returns the type or NULL. */
static TypeRef *check_value_expr(Checker *c, Expr *e) {
  TypeRef *t = check_expr(c, e);
  if (t == NULL)
    return NULL;
  if (is_void_marker(t)) {
    err(c, e->span, "this builtin produces no value and cannot be used here");
    return NULL;
  }
  return t;
}

/*===----------------------------------------------------------------===*/
/* Statement checking                                                    */
/*===----------------------------------------------------------------===*/

/* A declaration `type ident = expr`. The name is brought into scope as
 * UNDEFINED before its initializer is checked, so a self-reference is a
 * use-before-def; it becomes defined afterward. The initializer must be
 * assignment-compatible with the declared type (with literal adoption and
 * scalar->simd broadcast). */
static void check_bad_decl(Checker *c, Stmt *s) {
  (void)sym_declare(c, &s->as.decl.name, NULL, /*defined=*/1);
  if (s->as.decl.init != NULL)
    (void)check_expr(c, s->as.decl.init);
}

static void check_decl_init(Checker *c, Stmt *s, TypeRef *declared) {
  TypeRef *it;
  Expr *init = s->as.decl.init;
  if (init == NULL) {
    err(c, s->span, "declaration requires an initializer");
    return;
  }
  it = check_value_expr(c, init);
  if (it != NULL) {
    TypeRef *coerced = coerce_to(c, init, it, declared);
    if (coerced == NULL) {
      char buf[SEMA_MSG_CAP];
      /* A simd initializer for a scalar local is the canonical implicit
       * simd->scalar narrowing the design forbids; name it precisely. */
      if (is_scalar(declared) && is_simd(it))
        snprintf(buf, sizeof(buf),
                 "cannot initialize a scalar '%s' from a simd value "
                 "(no implicit simd->scalar; use read_first/reduce)",
                 type_category(declared));
      else
        snprintf(buf, sizeof(buf), "cannot initialize a '%s' from a '%s'",
                 type_category(declared), type_category(it));
      err(c, s->span, buf);
    }
  }
}

static void check_decl(Checker *c, Stmt *s) {
  TypeRef *declared = resolve_type(c, s->as.decl.type);
  Symbol *sym;
  if (declared == NULL) {
    check_bad_decl(c, s);
    return;
  }

  sym = sym_declare(c, &s->as.decl.name, declared, /*defined=*/0);
  check_decl_init(c, s, declared);
  if (sym != NULL)
    sym->defined = 1;
}

/* A destructuring `auto [a, b, ...] = expr`. In v1 the only multi-result
 * producer is `load`, which yields (simd<T,N>, token); the destructure
 * must bind exactly two names. The names enter scope undefined, then
 * become defined. */
static int check_load_destructure(Checker *c, Stmt *s, TypeRef **vty,
                                  TypeRef **tty) {
  Expr *init = s->as.destructure.init;
  if (init == NULL || init->kind != EXPR_CALL ||
      !name_is(init->as.call.callee, "load")) {
    err(c, s->span,
        "destructuring 'auto [..]' is only supported for load(...)");
    return 0;
  }
  if (s->as.destructure.name_count != 2) {
    err(c, s->span,
        "load destructuring binds exactly two names: value and token");
    (void)check_expr(c, init);
    return 0;
  }
  *vty = type_load(c, init);
  if (*vty == NULL)
    return 0;
  init->sema_type = *vty;
  *tty = scalar_type(c, SCALAR_TOKEN);
  return 1;
}

static void check_destructure(Checker *c, Stmt *s) {
  size_t i;
  TypeRef *vty = NULL;
  TypeRef *tty = NULL;
  int ok;

  for (i = 0; i < s->as.destructure.name_count; i++)
    (void)sym_declare(c, &s->as.destructure.names[i], NULL, /*defined=*/0);

  ok = check_load_destructure(c, s, &vty, &tty);

  for (i = 0; i < s->as.destructure.name_count; i++) {
    Symbol *sym = sym_lookup(c, s->as.destructure.names[i].name,
                             s->as.destructure.names[i].name_len);
    if (sym == NULL)
      continue;
    if (ok)
      sym->type = (i == 0) ? vty : tty;
    sym->defined = 1;
  }
}

/* An assignment `ident assign_op expr`. The target must be an in-scope
 * local (params are immutable -- they are not reassignable here? The
 * design treats reassignable locals as carries; params are uniform
 * inputs. We allow assigning to any in-scope name for now, but a compound
 * assign requires the target already defined). The RHS must be
 * assignment-compatible with the target's type. */
static void check_unknown_assign(Checker *c, Stmt *s) {
  err_name(c, s->as.assign.target.span,
           "assignment to undeclared identifier '%s'", s->as.assign.target.name,
           s->as.assign.target.name_len);
  (void)check_expr(c, s->as.assign.value);
}

static void check_simple_assign(Checker *c, Stmt *s, Symbol *sym, TypeRef *rt) {
  TypeRef *coerced = coerce_to(c, s->as.assign.value, rt, sym->type);
  if (coerced != NULL)
    return;
  {
    char buf[SEMA_MSG_CAP];
    if (is_scalar(sym->type) && is_simd(rt))
      snprintf(buf, sizeof(buf),
               "cannot assign a simd value to a scalar '%s' "
               "(no implicit simd->scalar; use read_first/reduce)",
               type_category(sym->type));
    else
      snprintf(buf, sizeof(buf), "cannot assign a '%s' to a '%s'",
               type_category(rt), type_category(sym->type));
    err(c, s->span, buf);
  }
}

static int compound_rhs_compatible(Checker *c, Stmt *s, Symbol *sym,
                                   TypeRef **rt) {
  ScalarKind lk;
  ScalarKind rk;
  ScalarKind u;
  if (!element_scalar(sym->type, &lk))
    return 0;
  if (is_untyped_literal(s->as.assign.value))
    (void)coerce_literal_to_scalar(c, s->as.assign.value, lk);
  *rt = (TypeRef *)s->as.assign.value->sema_type;
  if (*rt == NULL || !element_scalar(*rt, &rk))
    return 0;
  if (!unify_numeric(lk, rk, &u))
    return 0;
  if (is_scalar(sym->type) && is_simd(*rt)) {
    err(c, s->span,
        "cannot assign a simd value to a scalar "
        "(no implicit simd->scalar; use read_first/reduce)");
    return 0;
  }
  return 1;
}

static void check_compound_assign(Checker *c, Stmt *s, Symbol *sym,
                                  TypeRef *rt) {
  if (compound_rhs_compatible(c, s, sym, &rt))
    return;
  {
    char buf[SEMA_MSG_CAP];
    snprintf(buf, sizeof(buf),
             "compound assignment operand types are incompatible with '%s'",
             type_category(sym->type));
    err(c, s->span, buf);
  }
}

static void check_assign(Checker *c, Stmt *s) {
  Symbol *sym =
      sym_lookup(c, s->as.assign.target.name, s->as.assign.target.name_len);
  TypeRef *rt;
  int is_compound = (s->as.assign.op != TOK_ASSIGN);

  if (sym == NULL) {
    check_unknown_assign(c, s);
    return;
  }
  if (is_compound && !sym->defined) {
    err_name(c, s->as.assign.target.span,
             "compound assignment reads '%s' before its definition",
             s->as.assign.target.name, s->as.assign.target.name_len);
  }

  rt = check_value_expr(c, s->as.assign.value);
  if (rt != NULL && sym->type != NULL) {
    if (is_compound)
      check_compound_assign(c, s, sym, rt);
    else
      check_simple_assign(c, s, sym, rt);
  }
  if (sym != NULL)
    sym->defined = 1;
}

/* A call used as a statement: any builtin (including void `wait`) is
 * allowed; the result (if any) is simply discarded. */
static void check_call_stmt(Checker *c, Stmt *s) {
  (void)check_expr(c, s->as.call.call);
}

/*
 * Snapshot the `defined` bits of all currently-live symbols into a
 * caller-provided buffer (arena-allocated, sized to sym_count). Used to
 * compute branch merges without a fixpoint.
 */
static int *snapshot_defined(Checker *c) {
  int *snap;
  size_t i;
  if (c->sym_count == 0)
    return (int *)arena_alloc(c->arena, 1, sizeof(int)); /* non-NULL. */
  snap = (int *)arena_alloc(c->arena, c->sym_count * sizeof(int), sizeof(int));
  if (snap == NULL)
    return NULL;
  for (i = 0; i < c->sym_count; i++)
    snap[i] = c->syms[i].defined;
  return snap;
}

/* Restore the `defined` bits from a snapshot (only for the symbols that
 * still exist; inner-scope symbols are gone after scope_leave). A NULL
 * snapshot (arena exhaustion produced it) is a safe no-op -- an OOM
 * diagnostic was already recorded elsewhere, so the analysis simply stops
 * refining definedness rather than dereferencing NULL. */
static void restore_defined(Checker *c, const int *snap, size_t n) {
  size_t i;
  size_t lim;
  if (snap == NULL)
    return;
  lim = (n < c->sym_count) ? n : c->sym_count;
  for (i = 0; i < lim; i++)
    c->syms[i].defined = snap[i];
}

/*
 * An if / where statement. The condition type drives the split:
 *   - STMT_IF  requires a uniform `bool` (rejects mask -> the if/where
 *     split: a lane-varying compare yields mask and cannot land in if);
 *   - STMT_WHERE requires a `mask<W>` (rejects bool).
 * Definite-assignment merge: a variable is defined after the construct
 * iff it was defined before, or it is defined on every path through the
 * construct (both then and else, where the absent else/otherwise path is
 * the pre-state -- so a then-only assignment to a not-previously-defined
 * variable leaves it undefined, yielding a use-before-def at a later
 * read: the some-but-not-all-branch rule).
 */
static void check_cond_type(Checker *c, Stmt *s, TypeRef *ct, int is_where) {
  if (ct == NULL)
    return;
  if (is_where) {
    if (!is_mask(ct))
      err(c, s->as.cond.cond->span,
          "'where' requires a mask<W> condition (a bool belongs in 'if')");
    return;
  }
  if (is_bool(ct))
    return;
  if (is_mask(ct)) {
    err(c, s->as.cond.cond->span,
        "'if' requires a uniform bool condition; a mask<W> must be consumed by "
        "'where'");
  } else {
    err(c, s->as.cond.cond->span, "'if' requires a uniform bool condition");
  }
}

static void merge_cond_defined(Checker *c, const int *before,
                               const int *after_then, size_t before_n,
                               int has_else) {
  size_t i;
  for (i = 0; i < before_n && i < c->sym_count; i++) {
    int then_def = after_then[i];
    int else_def = has_else ? c->syms[i].defined : 0;
    c->syms[i].defined =
        has_else ? before[i] || (then_def && else_def) : before[i];
  }
}

static void check_cond(Checker *c, Stmt *s, int is_where) {
  TypeRef *ct = check_expr(c, s->as.cond.cond);
  int *before;
  int *after_then;
  size_t before_n;

  check_cond_type(c, s, ct, is_where);

  before = snapshot_defined(c);
  before_n = c->sym_count;

  /* Then branch. */
  check_block(c, s->as.cond.then_block);
  after_then = snapshot_defined(c);
  /* Roll back to the pre-state before checking the else branch, so the
   * two branches are analyzed from the same entry definedness. */
  restore_defined(c, before, before_n);

  if (before == NULL || after_then == NULL) {
    /* A snapshot could not be allocated (arena OOM, already diagnosed).
     * Skip the definedness merge; correctness of the rest is unaffected. */
    return;
  }

  if (s->as.cond.else_block != NULL) {
    check_block(c, s->as.cond.else_block);
    merge_cond_defined(c, before, after_then, before_n, /*has_else=*/1);
  } else {
    merge_cond_defined(c, before, after_then, before_n, /*has_else=*/0);
  }
}

/*
 * A range for: `for iv_type iv in lb..ub [step s] body`. The IV type must
 * be index or a sized int (iv_type restriction). lb/ub/step must unify to
 * the IV type (uniform). The IV is in scope (defined) only within the
 * body. Variables assigned in the body that were defined before the loop
 * stay defined (carry); variables first defined inside the body are NOT
 * defined after (the loop may iterate zero times).
 */
static TypeRef *check_for_iv_type(Checker *c, Stmt *s, ScalarKind *ik) {
  TypeRef *iv = resolve_type(c, s->as.for_.iv_type);
  if (iv != NULL) {
    if (!is_scalar(iv) || !(is_index(iv) || sk_is_sized_int(iv->scalar))) {
      err(c, s->as.for_.iv_type->span,
          "for induction variable must be 'index' or a sized integer");
      iv = NULL;
    }
  }
  if (iv != NULL && is_scalar(iv))
    (void)element_scalar(iv, ik);
  return iv;
}

static void check_for_bound(Checker *c, Expr *b, ScalarKind ik) {
  TypeRef *bt = check_value_expr(c, b);
  if (bt == NULL)
    return;
  if (is_untyped_literal(b)) {
    (void)coerce_literal_to_scalar(c, b, ik);
    return;
  }
  if (ik == SCALAR_INDEX && is_scalar(bt) &&
      (bt->scalar == SCALAR_INDEX || sk_is_sized_int(bt->scalar)))
    return;
  if (!is_scalar(bt) || !scalar_compatible(bt->scalar, ik)) {
    err(c, b->span,
        "for bound/step must be a uniform scalar matching the IV type");
  }
}

static void check_for_bounds(Checker *c, Stmt *s, TypeRef *iv, ScalarKind ik) {
  if (iv == NULL) {
    (void)check_value_expr(c, s->as.for_.lb);
    (void)check_value_expr(c, s->as.for_.ub);
    if (s->as.for_.step != NULL)
      (void)check_value_expr(c, s->as.for_.step);
    return;
  }
  check_for_bound(c, s->as.for_.lb, ik);
  check_for_bound(c, s->as.for_.ub, ik);
  if (s->as.for_.step != NULL)
    check_for_bound(c, s->as.for_.step, ik);
}

static void check_for_body(Checker *c, Stmt *s, TypeRef *iv) {
  size_t k;
  scope_enter(c);
  if (iv != NULL)
    (void)sym_declare(c, &s->as.for_.iv_name, iv, /*defined=*/1);
  else
    (void)sym_declare(c, &s->as.for_.iv_name, NULL, /*defined=*/1);
  if (s->as.for_.body != NULL && s->as.for_.body->kind == STMT_BLOCK) {
    for (k = 0; k < s->as.for_.body->as.block.stmt_count; k++)
      check_stmt(c, s->as.for_.body->as.block.stmts[k]);
  }
  scope_leave(c);
}

static void check_for(Checker *c, Stmt *s) {
  TypeRef *iv;
  int *before;
  size_t before_n;
  size_t i;
  ScalarKind ik = SCALAR_INDEX;

  iv = check_for_iv_type(c, s, &ik);
  check_for_bounds(c, s, iv, ik);

  before = snapshot_defined(c);
  before_n = c->sym_count;
  check_for_body(c, s, iv);

  if (before != NULL) {
    for (i = 0; i < before_n && i < c->sym_count; i++)
      c->syms[i].defined = before[i];
  }
}

/* A while: `while (cond) body`. The condition is a uniform bool. Carry
 * semantics match `for` (the body may run zero times). */
static void check_while(Checker *c, Stmt *s) {
  TypeRef *ct = check_expr(c, s->as.while_.cond);
  int *before;
  size_t before_n;
  size_t i;

  if (ct != NULL && !is_bool(ct)) {
    if (is_mask(ct))
      err(c, s->as.while_.cond->span,
          "'while' requires a uniform bool condition; a mask<W> belongs in "
          "'where' (use 'while (any(mask))' for a lane-varying loop)");
    else
      err(c, s->as.while_.cond->span,
          "'while' requires a uniform bool condition");
  }

  before = snapshot_defined(c);
  before_n = c->sym_count;
  check_block(c, s->as.while_.body);
  if (before != NULL) {
    for (i = 0; i < before_n && i < c->sym_count; i++)
      c->syms[i].defined = before[i];
  }
}

/* A brace block: open a scope, check each statement, close the scope. */
static void check_block(Checker *c, Stmt *block) {
  size_t i;
  if (block == NULL)
    return;
  if (block->kind != STMT_BLOCK) {
    /* Defensive: a non-block where a block is expected. */
    check_stmt(c, block);
    return;
  }
  scope_enter(c);
  for (i = 0; i < block->as.block.stmt_count; i++)
    check_stmt(c, block->as.block.stmts[i]);
  scope_leave(c);
}

static void check_stmt_inner(Checker *c, Stmt *s) {
  switch (s->kind) {
  case STMT_DECL:
    check_decl(c, s);
    break;
  case STMT_DESTRUCTURE:
    check_destructure(c, s);
    break;
  case STMT_ASSIGN:
    check_assign(c, s);
    break;
  case STMT_CALL:
    check_call_stmt(c, s);
    break;
  case STMT_IF:
    check_cond(c, s, /*is_where=*/0);
    break;
  case STMT_WHERE:
    check_cond(c, s, /*is_where=*/1);
    break;
  case STMT_FOR:
    check_for(c, s);
    break;
  case STMT_WHILE:
    check_while(c, s);
    break;
  case STMT_BLOCK:
    check_block(c, s);
    break;
  }
}

/* Statement dispatch. */
static void check_stmt(Checker *c, Stmt *s) {
  if (s == NULL)
    return;
  if (c->depth >= SEMA_MAX_DEPTH) {
    err(c, s->span, "maximum statement nesting depth exceeded");
    return;
  }
  c->depth++;
  check_stmt_inner(c, s);
  c->depth--;
}

/*===----------------------------------------------------------------===*/
/* Attributes + kernel + program                                         */
/*===----------------------------------------------------------------===*/

/* Match an attribute name slice against a C string. */
static int attr_name_is(const Attribute *a, const char *s) {
  size_t len = strlen(s);
  return a->name_len == len && memcmp(a->name, s, len) == 0;
}

typedef struct AttrState {
  uint64_t waves_per_workgroup;
  uint64_t workgroup_size;
  int seen_wave;
  int seen_lds;
  int seen_waves_per_workgroup;
  int seen_workgroup_size;
} AttrState;

static void check_wave_attr(Checker *c, Attribute *a, int *seen_wave) {
  if (!a->has_arg) {
    err(c, a->span, "[[amdgpu_wave_size]] requires an integer argument");
    return;
  }
  if (*seen_wave) {
    err(c, a->span, "duplicate [[amdgpu_wave_size]] attribute");
    return;
  }
  *seen_wave = 1;
  if (a->arg == 0) {
    err(c, a->span, "[[amdgpu_wave_size(N)]] must be a positive width");
    return;
  }
  if (a->arg != 32 && a->arg != 64) {
    err(c, a->span, "[[amdgpu_wave_size(N)]] must be 32 or 64");
    return;
  }
  c->wave_n = a->arg;
  c->has_wave_n = 1;
}

static void check_lds_attr(Checker *c, Attribute *a, AttrState *state) {
  if (!a->has_arg) {
    err(c, a->span, "[[amdgpu_lds_size]] requires an integer argument");
    return;
  }
  if (state->seen_lds) {
    err(c, a->span, "duplicate [[amdgpu_lds_size]] attribute");
    return;
  }
  state->seen_lds = 1;
}

static void check_waves_per_workgroup_attr(Checker *c, Attribute *a,
                                           AttrState *state) {
  if (!a->has_arg) {
    err(c, a->span,
        "[[amdgpu_waves_per_workgroup]] requires an integer argument");
    return;
  }
  if (state->seen_waves_per_workgroup) {
    err(c, a->span, "duplicate [[amdgpu_waves_per_workgroup]] attribute");
    return;
  }
  state->seen_waves_per_workgroup = 1;
  state->waves_per_workgroup = a->arg;
  if (a->arg == 0)
    err(c, a->span,
        "[[amdgpu_waves_per_workgroup(N)]] must be a positive count");
}

static void check_workgroup_size_attr(Checker *c, Attribute *a,
                                      AttrState *state) {
  if (!a->has_arg) {
    err(c, a->span, "[[amdgpu_workgroup_size]] requires an integer argument");
    return;
  }
  if (state->seen_workgroup_size) {
    err(c, a->span, "duplicate [[amdgpu_workgroup_size]] attribute");
    return;
  }
  state->seen_workgroup_size = 1;
  state->workgroup_size = a->arg;
  if (a->arg == 0)
    err(c, a->span, "[[amdgpu_workgroup_size(N)]] must be positive");
  if (a->arg > SEMA_MAX_WORKGROUP_SIZE)
    err(c, a->span, "[[amdgpu_workgroup_size(N)]] must be <= 1024");
}

static void check_attribute(Checker *c, Attribute *a, AttrState *state) {
  if (attr_name_is(a, "amdgpu_wave_size")) {
    check_wave_attr(c, a, &state->seen_wave);
    return;
  }
  if (attr_name_is(a, "amdgpu_lds_size")) {
    check_lds_attr(c, a, state);
    return;
  }
  if (attr_name_is(a, "amdgpu_waves_per_workgroup")) {
    check_waves_per_workgroup_attr(c, a, state);
    return;
  }
  if (attr_name_is(a, "amdgpu_workgroup_size")) {
    check_workgroup_size_attr(c, a, state);
    return;
  }
  err_name(c, a->span,
           "unknown attribute '%s' (only amdgpu_wave_size, "
           "amdgpu_lds_size, amdgpu_waves_per_workgroup, "
           "and amdgpu_workgroup_size are allowed)",
           a->name, a->name_len);
}

static int waves_exceed_workgroup(uint64_t wave_n, uint64_t waves) {
  return waves > SEMA_MAX_WORKGROUP_SIZE / wave_n;
}

static int launch_attrs_mismatch(uint64_t wave_n, const AttrState *state) {
  if (!state->seen_waves_per_workgroup || !state->seen_workgroup_size)
    return 0;
  if (waves_exceed_workgroup(wave_n, state->waves_per_workgroup))
    return 0;
  return state->waves_per_workgroup * wave_n != state->workgroup_size;
}

static void check_launch_attrs(Checker *c, Kernel *k, const AttrState *state) {
  if (!state->seen_wave) {
    err(c, k->span, "kernel requires the [[amdgpu_wave_size(N)]] attribute");
    return;
  }
  if (!c->has_wave_n)
    return;

  if (state->seen_waves_per_workgroup &&
      waves_exceed_workgroup(c->wave_n, state->waves_per_workgroup))
    err(c, k->span, "[[amdgpu_waves_per_workgroup(N)]] exceeds 1024 threads");
  if (state->seen_workgroup_size && state->workgroup_size % c->wave_n != 0)
    err(c, k->span,
        "[[amdgpu_workgroup_size(N)]] must be a multiple of wave size");
  if (launch_attrs_mismatch(c->wave_n, state))
    err(c, k->span,
        "workgroup size must equal wave size times waves per workgroup");
}

static void check_attributes(Checker *c, Kernel *k) {
  size_t i;
  AttrState state;

  memset(&state, 0, sizeof(state));
  c->wave_n = 0;
  c->has_wave_n = 0;
  for (i = 0; i < k->attr_count; i++)
    check_attribute(c, k->attrs[i], &state);
  check_launch_attrs(c, k, &state);
}

/* Check one kernel: attributes (-> N), then parameters (scope 0), then
 * the body. The symbol table is reset to empty per kernel so kernels are
 * independent (no cross-kernel leakage; each validates against its own
 * N). */
static void check_kernel(Checker *c, Kernel *k) {
  size_t i;

  c->sym_count = 0;
  c->scope = 0;
  c->depth = 0;

  check_attributes(c, k);

  /* Parameters live in the outermost scope and are defined on entry. */
  for (i = 0; i < k->param_count; i++) {
    Param *p = k->params[i];
    TypeRef *pt = resolve_type(c, p->type);
    /* A null pt still declares the name (defined) to avoid cascades. */
    (void)sym_declare(c, &p->name, pt, /*defined=*/1);
  }

  /* The body is a top-level block; do NOT open an extra scope beyond the
   * parameter scope -- params and top-level locals share scope 0, matching
   * C function-body scoping. */
  if (k->body != NULL && k->body->kind == STMT_BLOCK) {
    for (i = 0; i < k->body->as.block.stmt_count; i++)
      check_stmt(c, k->body->as.block.stmts[i]);
  }
}

/*===----------------------------------------------------------------===*/
/* Public entry points                                                   */
/*===----------------------------------------------------------------===*/

void sema_context_init(SemaContext *ctx, Arena *arena, DiagList *diags) {
  if (ctx == NULL)
    return;
  ctx->arena = arena;
  ctx->diags = diags;
}

int sema_check(SemaContext *ctx, Program *program) {
  Checker c;
  size_t i;

  if (ctx == NULL || program == NULL)
    return 0;

  c.arena = ctx->arena;
  c.diags = ctx->diags;
  c.sym_count = 0;
  c.scope = 0;
  c.depth = 0;
  c.wave_n = 0;
  c.has_wave_n = 0;

  c.syms = (Symbol *)arena_alloc(ctx->arena, SEMA_MAX_SYMBOLS * sizeof(Symbol),
                                 sizeof(void *));
  if (c.syms == NULL) {
    SourceSpan zero;
    zero.offset = 0;
    zero.len = 0;
    zero.line = 0;
    zero.col = 0;
    err(&c, zero, "out of memory (sema symbol table)");
    return 0;
  }

  for (i = 0; i < program->kernel_count; i++)
    check_kernel(&c, program->kernels[i]);

  return !diag_has_errors(ctx->diags);
}
