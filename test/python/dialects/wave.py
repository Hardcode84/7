# RUN: %PYTHON %s | FileCheck %s

from mlir.dialects import wave_dsl as w


def run(f):
    print("\nTEST:", f.__name__)
    f()


# CHECK-LABEL: TEST: test_generic_wave_kernel
@run
def test_generic_wave_kernel():
    with w.module() as m:
        with m.function(
            "generic_wave_kernel", [w.ptr_type(w.i32()), w.i32()], kernel=True
        ) as f:
            out, x = f.args
            lane = f.lane_id()
            vx = f.splat(x)
            ptrs = f.ptr_add(out, lane, w.simd_type(w.ptr_type(w.i32())))
            token = f.store(vx, ptrs)
            f.wait(token)
        # CHECK: func.func @generic_wave_kernel
        # CHECK: wave.lane_id
        # CHECK: wave.splat
        # CHECK: wave.store
        # CHECK: wave.wait
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_matrix_kernel
@run
def test_waveamd_matrix_kernel():
    with w.module() as m:
        with m.function("matrix_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (out,) = f.args
            zero = f.constant(w.i32(), 0)
            seven = f.constant(w.i32(), 7)
            base = f.constant(w.index_type(), 0)
            a_t = w.fragment_type(0, w.i8(), registers=4)
            b_t = w.fragment_type(1, w.i8(), registers=4)
            acc_t = w.fragment_type(2, w.i32(), registers=8)
            a = f.fragment_fill(zero, a_t)
            b = f.fragment_fill(zero, b_t)
            acc = f.fragment_fill(seven, acc_t)
            result = f.mma("wmma.i32.16x16x16.iu8", a, b, acc)
            ptr = f.ptr_add(out, base)
            token = f.fragment_store(result, ptr)
            f.wait(token)
        # CHECK: func.func @matrix_kernel
        # CHECK: waveamd.fragment_fill
        # CHECK: waveamd.mma
        # CHECK: waveamd.fragment_store
        # CHECK: wave.wait
        print(m.module)


# CHECK-LABEL: TEST: test_waveamd_load_and_fragment_pack
@run
def test_waveamd_load_and_fragment_pack():
    with w.module() as m:
        with m.function(
            "load_pack_kernel",
            [w.ptr_type(w.i32()), w.ptr_type(w.i32())],
            kernel=True,
        ) as f:
            in_ptr, out_ptr = f.args
            lane = f.lane_id()
            simd_in = f.ptr_add(in_ptr, lane, w.simd_ptr_type(w.i32()))
            base = f.constant(w.index_type(), 0)
            scalar_out = f.ptr_add(out_ptr, base)

            tuple_t = w.simd_type(w.vector_type(8, w.i32()))
            acc_t = w.fragment_type(2, w.f32(), registers=8)
            regs, tok = f.load(simd_in, tuple_t)
            frag = f.fragment_pack(regs, acc_t)
            f.fragment_store(frag, scalar_out, after=tok)

            scalar_t = w.simd_type(w.i32())
            simd_out = f.ptr_add(out_ptr, lane, w.simd_ptr_type(w.i32()))
            scalar, scalar_tok = f.load(simd_in, scalar_t, after=tok)
            f.store(scalar, simd_out, after=scalar_tok)

            packed_frag, pack_tok = f.fragment_load(simd_in, acc_t, after=scalar_tok)
            f.fragment_store(packed_frag, scalar_out, after=pack_tok)
        # CHECK: func.func @load_pack_kernel
        # CHECK: wave.load {{.*}} -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
        # CHECK: waveamd.fragment_pack {{.*}} -> !waveamd.fragment<2, f32, 16, 16, 32, 8>
        # CHECK: wave.load {{.*}} after {{.*}} -> (!wave.simd<i32, 32>, !wave.mem.token)
        # CHECK: wave.load {{.*}} -> (!wave.simd<vector<8xi32>, 32>, !wave.mem.token)
        # CHECK: waveamd.fragment_pack
        print(m.module)


# CHECK-LABEL: TEST: test_typed_bindings
@run
def test_typed_bindings():
    with w.module():
        i32, f32 = w.i32(), w.f32()
        global_addr = w.global_address_space()
        buffer_addr = w.buffer_address_space()

        simd = w.simd_type(i32)
        assert w.SimdType.isinstance(simd)
        casted = w.SimdType(simd)
        assert casted.element_type == i32 and casted.width == 32

        ptr = w.ptr_type(f32, global_addr)
        assert w.PtrType.isinstance(ptr)
        casted_ptr = w.PtrType(ptr)
        assert casted_ptr.element_type == f32
        assert casted_ptr.address_space == global_addr

        mask = w.mask_type(32)
        assert w.MaskType.isinstance(mask)
        assert w.MaskType(mask).width == 32

        tok = w.mem_token_type()
        assert w.MemTokenType.isinstance(tok)

        bptr = w.buffer_ptr_type(f32)
        assert w.PtrType(bptr).address_space == buffer_addr

        frag = w.fragment_type(2, f32, registers=8)
        assert w.FragmentType.isinstance(frag)
        casted_frag = w.FragmentType(frag)
        assert casted_frag.role == 2
        assert casted_frag.element_type == f32
        assert casted_frag.rows == 16
        assert casted_frag.columns == 16
        assert casted_frag.wave_size == 32
        assert casted_frag.registers == 8
        print("ok")
        # CHECK: ok


# CHECK-LABEL: TEST: test_waveamd_buffer_pointer_type
@run
def test_waveamd_buffer_pointer_type():
    with w.module() as m:
        with m.function("buffer_ptr_kernel", [w.ptr_type(w.i32())], kernel=True) as f:
            (out,) = f.args
            range_bytes = f.constant(w.i32(), 128)
            buffer = f.make_buffer(out, range_bytes, w.buffer_ptr_type(w.i32()))
            lane = f.lane_id()
            f.ptr_add(buffer, lane, w.simd_type(w.buffer_ptr_type(w.i32())))
        # CHECK: func.func @buffer_ptr_kernel
        # CHECK: waveamd.make_buffer
        # CHECK: !wave.ptr<i32, #waveamd.buffer>
        # CHECK: !wave.simd<!wave.ptr<i32, #waveamd.buffer>, 32>
        print(m.module)
