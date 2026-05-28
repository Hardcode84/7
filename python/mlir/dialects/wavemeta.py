#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from collections.abc import Sequence

from ._wavemeta_ops_gen import *  # noqa: F403
from ._wavemeta_ops_gen import _Dialect

# Module-level dictionary attribute the specialiser reads to bind
# `wavemeta.param` ops and to resolve parameter-named ptuple widths.
# Mirrors `WaveMetaDialect::getParamsAttrName()` on the C++ side.
PARAMS_ATTR_NAME = "wavemeta.params"

try:
    from ..ir import (
        Block,
        InsertionPoint,
        Location,
        Operation,
        OpView,
        Value,
    )
    from ._ods_common import (
        _cext as _ods_cext,
    )
    from ._ods_common import (
        get_op_results_or_values as _get_op_results_or_values,
    )
except ImportError as e:
    raise RuntimeError("Error loading imports from extension module") from e


@_ods_cext.register_operation(_Dialect, replace=True)
class StaticForOp(StaticForOp):  # noqa: F405
    """Builder helpers around `wavemeta.static_for` that mirror
    `scf.ForOp` for source compatibility: auto-builds the entry block
    from the iter-arg types and exposes `induction_variable` /
    `inner_iter_args` accessors.
    """

    def __init__(
        self,
        lower_bound: Value,
        upper_bound: Value,
        step: Value,
        iter_args: Operation | OpView | Sequence[Value] | None = None,
        *,
        loc: Location | None = None,
        ip: InsertionPoint | None = None,
    ):
        if iter_args is None:
            iter_args = []
        iter_args = _get_op_results_or_values(iter_args)
        result_types = [arg.type for arg in iter_args]
        super().__init__(
            result_types,
            lower_bound,
            upper_bound,
            step,
            iter_args,
            loc=loc,
            ip=ip,
        )
        Block.create_at_start(self.body, [lower_bound.type, *result_types])

    @property
    def body_block(self) -> Block:
        return self.body.blocks[0]

    @property
    def induction_variable(self) -> Value:
        return self.body_block.arguments[0]

    @property
    def inner_iter_args(self):
        return self.body_block.arguments[1:]


@_ods_cext.register_operation(_Dialect, replace=True)
class UnrolledForOp(UnrolledForOp):  # noqa: F405
    """Builder helper around `wavemeta.unrolled_for`."""

    def __init__(
        self,
        lower_bound: Value,
        upper_bound: Value,
        step: Value,
        unroll: Value,
        iter_args: Operation | OpView | Sequence[Value] | None = None,
        *,
        loc: Location | None = None,
        ip: InsertionPoint | None = None,
    ):
        if iter_args is None:
            iter_args = []
        iter_args = _get_op_results_or_values(iter_args)
        result_types = [arg.type for arg in iter_args]
        super().__init__(
            result_types,
            lower_bound,
            upper_bound,
            step,
            unroll,
            iter_args,
            loc=loc,
            ip=ip,
        )
        Block.create_at_start(self.body, [lower_bound.type, *result_types])

    @property
    def body_block(self) -> Block:
        return self.body.blocks[0]

    @property
    def induction_variable(self) -> Value:
        return self.body_block.arguments[0]

    @property
    def inner_iter_args(self):
        return self.body_block.arguments[1:]


@_ods_cext.register_operation(_Dialect, replace=True)
class StaticIfOp(StaticIfOp):  # noqa: F405
    """Builder helpers around `wavemeta.static_if`: auto-creates the
    `then` (and optional `else`) entry blocks and exposes them as
    `then_block` / `else_block`.
    """

    def __init__(
        self,
        condition: Value,
        results_: Sequence = (),
        *,
        has_else: bool = False,
        loc: Location | None = None,
        ip: InsertionPoint | None = None,
    ):
        super().__init__(list(results_), condition, loc=loc, ip=ip)
        Block.create_at_start(self.thenRegion, [])
        if has_else or results_:
            Block.create_at_start(self.elseRegion, [])

    @property
    def then_block(self) -> Block:
        return self.thenRegion.blocks[0]

    @property
    def else_block(self) -> Block:
        return self.elseRegion.blocks[0]
