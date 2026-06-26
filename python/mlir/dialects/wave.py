#  Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
#  See https://llvm.org/LICENSE.txt for license information.
#  SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

from mlir._mlir_libs import _waveDialectsNanobind as _wave_ext

from ._wave_enum_gen import *  # noqa: F403
from ._wave_ops_gen import *  # noqa: F403


def register_dialects(context, load=True):
    _wave_ext.register_dialects(context, load)
