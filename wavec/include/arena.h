/*===- arena.h - Bump-pointer arena allocator -----------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend for the Wave kernel language.
 *
 * The arena is the ONLY allocator in the front (lexer/parser/sema). All
 * AST nodes, token arrays, diagnostics and scratch memory bump-allocate
 * from an arena; the whole region is released at once via arena_destroy.
 * There are NO per-node malloc/free calls anywhere in the front -- the
 * single malloc that backs an arena is the only heap allocation, per the
 * Implementation rules in CFrontendDesign.md.
 *
 * No global state: every entry point takes the Arena explicitly.
 */

#ifndef WAVEC_ARENA_H
#define WAVEC_ARENA_H

#include <stddef.h>

/* Page alignment for the backing block, per the Implementation rules
 * ("Arena allocation, page-aligned (4 KiB)"). Fixed at compile time so
 * no OS page-size query is needed -- portable C99, no POSIX. */
#define ARENA_PAGE_ALIGN ((size_t)4096)

/*
 * An arena owns one contiguous backing block obtained from a SINGLE
 * malloc (over-allocated, then hand-aligned to ARENA_PAGE_ALIGN -- no
 * aligned_alloc/posix_memalign, which keeps this portable to any C99
 * host). Allocation is a bump of `used` with per-request alignment.
 *
 * Fields:
 *   raw      original malloc result; the pointer passed to free().
 *   base     the page-aligned start of the usable region (>= raw).
 *   used     bytes consumed from base by arena_alloc (the bump cursor).
 *   capacity usable bytes available from base (raw size minus the
 *            alignment slack burned to reach `base`).
 *
 * The struct is exposed (not opaque) so callers may stack-allocate the
 * handle and inspect it in tests; treat the fields as read-only.
 */
typedef struct Arena {
  unsigned char *raw;
  unsigned char *base;
  size_t used;
  size_t capacity;
} Arena;

/*
 * Create an arena with at least `size` usable bytes. The backing block
 * is a single malloc of (size + ARENA_PAGE_ALIGN - 1) so the usable
 * region can be advanced to a 4 KiB boundary. A zero `size` is rounded
 * up to one page so the arena is always usable.
 *
 * Returns a zero-initialized-on-failure Arena: on malloc failure all
 * fields are 0/NULL and arena_alloc will return NULL for every request
 * (overflow/grow policy below). Callers may check `a.raw != NULL`.
 *
 * Grow/overflow policy: the arena is FIXED-CAPACITY and never grows.
 * Growing would require either realloc (which can move the block and
 * invalidate every outstanding AST pointer) or a freelist of blocks
 * (multiple mallocs) -- both violate the single-backing-malloc and
 * stable-pointer contracts. Instead, a request that does not fit
 * returns NULL; callers must size the arena up front and treat a NULL
 * from arena_alloc as out-of-memory (the parser surfaces this as a
 * diagnostic, never a crash).
 */
Arena arena_create(size_t size);

/*
 * Bump-allocate `bytes` aligned to `align` (which must be a power of
 * two; 0 is treated as alignof-max == ARENA_PAGE_ALIGN-safe default 1).
 * Returns a pointer into the arena, or NULL if the aligned request does
 * not fit in the remaining capacity (see the grow/overflow policy on
 * arena_create) or on integer overflow while aligning. The returned
 * memory is NOT zeroed.
 *
 * A zero-byte request returns a valid, suitably aligned pointer (it may
 * equal the next allocation's pointer); it never returns NULL on a live
 * arena with room for the alignment padding.
 */
void *arena_alloc(Arena *a, size_t bytes, size_t align);

/*
 * Reset the bump cursor to the start of the usable region, making all
 * previously allocated bytes available again WITHOUT freeing the
 * backing block. Outstanding pointers into the arena are invalidated
 * (the bytes will be handed out again). Capacity is unchanged.
 */
void arena_reset(Arena *a);

/*
 * Release the backing block (the single free matching arena_create's
 * single malloc) and zero the handle so a double-destroy is a no-op and
 * any post-destroy arena_alloc safely returns NULL.
 */
void arena_destroy(Arena *a);

#endif /* WAVEC_ARENA_H */
