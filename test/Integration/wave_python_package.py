# REQUIRES: wave-python-bindings
# RUN: %python %s %wave_obj_root/python_packages/wave_mlir | FileCheck %s

import sys
from pathlib import Path

import ixsimpl
from ixsimpl import _ixsimpl
from mlir.dialects import wave_dsl as w

package_root = Path(sys.argv[1]).resolve()
for loaded_path in (ixsimpl.__file__, _ixsimpl.__file__):
    assert Path(loaded_path).resolve().is_relative_to(package_root), loaded_path

symbolic_context = ixsimpl.Context()
symbol = symbolic_context.sym("package_abi_x")
expression = 4 * symbol + 1
predicate = symbolic_context.eq(expression, 9)
with w.Context() as mlir_context:
    expression_attr = w.ExprAttr.get_from_node_ptr(
        expression.node_ptr, context=mlir_context
    )
    predicate_attr = w.PredAttr.get_from_node_ptr(
        predicate.node_ptr, context=mlir_context
    )

assert str(expression_attr) == '#wave.expr<"1 + 4*package_abi_x">'
assert str(predicate_attr) == '#wave.pred<"-8 + 4*package_abi_x == 0">'
print("package-root: ok")
print("structural-abi: ok")

# CHECK: package-root: ok
# CHECK: structural-abi: ok
