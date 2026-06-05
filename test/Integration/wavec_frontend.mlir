# RUN: wavec %S/../../wavec/test/e2e/good/saxpy.wave | wave-opt | FileCheck %s

# CHECK: func.func @saxpy
# CHECK: wave.where
# CHECK: wave.store
