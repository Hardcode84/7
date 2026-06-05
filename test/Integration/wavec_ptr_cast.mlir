# RUN: wavec %S/../../wavec/test/e2e/good/ptr_cast.wave \
# RUN:   | wave-opt | FileCheck %s

# CHECK-LABEL: func.func @ptr_cast
# CHECK: wave.ptr_cast
# CHECK: wave.load
# CHECK: wave.store
