/*===- arena.c - Bump-pointer arena allocator -----------------*- C -*-===*/
/*
 * Part of the wavec C99 frontend. See arena.h for the contract.
 *
 * This file holds the ONLY malloc/free in the whole front (the single
 * backing allocation per arena). The diagnostics sink body lives in
 * diag.c; nothing here touches the OS beyond stdlib malloc/free.
 */

#include "arena.h"

#include <stdint.h>
#include <stdlib.h>

/* Round `n` up to the next multiple of `align` (a power of two).
 * Writes the result through `out` and returns 1 on success, or 0 if the
 * rounding would overflow size_t (the caller then reports OOM). */
static int round_up_pow2(size_t n, size_t align, size_t *out) {
  size_t mask = align - 1u;
  /* Overflow guard: n + mask must not wrap. */
  if (n > SIZE_MAX - mask)
    return 0;
  *out = (n + mask) & ~mask;
  return 1;
}

Arena arena_create(size_t size) {
  Arena a;
  size_t request;
  uintptr_t base_addr;

  a.raw = NULL;
  a.base = NULL;
  a.used = 0;
  a.capacity = 0;

  /* A zero request still yields a usable one-page arena. */
  if (size == 0)
    size = ARENA_PAGE_ALIGN;

  /* Over-allocate by (ARENA_PAGE_ALIGN - 1) so we can hand-align the
   * usable base up to a 4 KiB boundary without aligned_alloc. Guard the
   * addition against size_t overflow. */
  if (size > SIZE_MAX - (ARENA_PAGE_ALIGN - 1u))
    return a;
  request = size + (ARENA_PAGE_ALIGN - 1u);

  a.raw = (unsigned char *)malloc(request);
  if (a.raw == NULL)
    return a; /* All fields stay 0/NULL; arena_alloc will return NULL. */

  /* Hand-align: advance to the next ARENA_PAGE_ALIGN boundary. We use
   * uintptr_t arithmetic on the address; the over-allocation guarantees
   * the aligned base plus `size` usable bytes still fit in the block. */
  base_addr = (uintptr_t)a.raw;
  base_addr = (base_addr + (ARENA_PAGE_ALIGN - 1u)) &
              ~(uintptr_t)(ARENA_PAGE_ALIGN - 1u);
  a.base = (unsigned char *)base_addr;
  a.used = 0;
  /* Usable capacity is the requested size; the alignment slack consumed
   * to reach `base` came out of the (ARENA_PAGE_ALIGN - 1) pad. */
  a.capacity = size;
  return a;
}

void *arena_alloc(Arena *a, size_t bytes, size_t align) {
  size_t aligned_used;
  size_t end;

  if (a == NULL || a->base == NULL)
    return NULL; /* Dead/failed arena: OOM by policy, never a crash. */

  /* A zero or non-power-of-two alignment falls back to 1 (byte
   * alignment); callers pass alignof(T), always a power of two. */
  if (align == 0)
    align = 1;

  /* Bump the cursor up to the requested alignment. */
  if (!round_up_pow2(a->used, align, &aligned_used))
    return NULL;

  /* Compute the end offset, guarding the add against overflow, then
   * check it fits the fixed capacity (no grow -- see arena_create). */
  if (aligned_used > SIZE_MAX - bytes)
    return NULL;
  end = aligned_used + bytes;
  if (end > a->capacity)
    return NULL;

  a->used = end;
  return a->base + aligned_used;
}

void arena_reset(Arena *a) {
  if (a == NULL)
    return;
  a->used = 0;
}

void arena_destroy(Arena *a) {
  if (a == NULL)
    return;
  free(a->raw);
  a->raw = NULL;
  a->base = NULL;
  a->used = 0;
  a->capacity = 0;
}
