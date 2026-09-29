module attributes {waveamdmachine.target = "amdgcn-amd-amdhsa--gfx950"} {
  func.func @scaled(
      %a: !waveamdmachine.reg<vgpr, 4>,
      %b: !waveamdmachine.reg<vgpr, 4>,
      %acc: !waveamdmachine.reg<vgpr, 4>,
      %scale: !waveamdmachine.reg<vgpr, 1>,
      %x: !waveamdmachine.reg<vgpr, 2>,
      %y: !waveamdmachine.reg<vgpr, 2>)
      -> (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>) {
    %m = waveamdmachine.mfma_scale_f32_16x16x128_f4_f4
        %a, %b, %acc, %scale, %scale
        : (!waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 4>,
           !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 1>,
           !waveamdmachine.reg<vgpr, 1>) -> !waveamdmachine.reg<vgpr, 4>
    %add = waveamdmachine.v_pk_add_f32 %x, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %mul = waveamdmachine.v_pk_mul_f32 %add, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %fma = waveamdmachine.v_pk_fma_f32 %mul, %x, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
    return %m, %fma : !waveamdmachine.reg<vgpr, 4>, !waveamdmachine.reg<vgpr, 2>
  }

  func.func @packed(%x: !waveamdmachine.reg<vgpr, 2>,
                    %y: !waveamdmachine.reg<vgpr, 2>)
      -> !waveamdmachine.reg<vgpr, 2> {
    %add = waveamdmachine.v_pk_add_f32 %x, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %mul = waveamdmachine.v_pk_mul_f32 %add, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>)
          -> !waveamdmachine.reg<vgpr, 2>
    %fma = waveamdmachine.v_pk_fma_f32 %mul, %x, %y
        : (!waveamdmachine.reg<vgpr, 2>, !waveamdmachine.reg<vgpr, 2>,
           !waveamdmachine.reg<vgpr, 2>) -> !waveamdmachine.reg<vgpr, 2>
    return %fma : !waveamdmachine.reg<vgpr, 2>
  }
}
