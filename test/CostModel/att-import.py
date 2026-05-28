# ruff: noqa: E501
# RUN: %PYTHON %S/../../tools/wave-att-import/wave-att-import.py --att-dir %S/Inputs/att-sample --objdump %S/Inputs/att-objdump.txt --summary | FileCheck %s
# RUN: %PYTHON %S/../../tools/wave-att-import/wave-att-import.py --att-dir %S/Inputs/att-sample --objdump %S/Inputs/att-objdump.txt --windows | FileCheck %s --check-prefix=WIN
# RUN: %PYTHON %S/../../tools/wave-att-import/wave-att-import.py --att-dir %S/Inputs/att-sample --objdump %S/Inputs/att-objdump.txt --summary --trip-count 0 | FileCheck %s --check-prefix=POS
# RUN: %PYTHON %S/../../tools/wave-att-import/wave-att-import.py --att-dir %S/Inputs/att-sample --objdump %S/Inputs/att-objdump.txt --summary --trip-count 0 --window-summary | FileCheck %s --check-prefix=SUM

# CHECK: summary:
# CHECK:   static_instructions: 4
# CHECK:   stats_rows: 3
# CHECK:   stats_resolved: 2
# CHECK:   stats_unresolved: 1
# CHECK:   code_json_files: 1
# CHECK:   code_lines: 2
# CHECK:   wave_files: 1
# CHECK:   wave_rows: 4
# CHECK:   wave_resolved: 2
# CHECK:   wave_unresolved: 2

# CHECK: pc_hex,pc_dec,instruction,mnemonic,class,model_latency,static_index,att_stats_hitcount,att_stats_avg_latency,att_stats_avg_stall,att_stats_idle_total,wave_hitcount,wave_avg_duration,wave_avg_stall,wave_first_time_avg
# CHECK: 0x1600,5632,"s_load_b64 s[6:7], s[0:1], null",s_load_b64,WriteSMEM,20,0,2,10.0,0.0,7.0,1,1.0,0.0,100.0
# CHECK: 0x1608,5640,s_waitcnt lgkmcnt(0),s_waitcnt,WaitcntPseudo,0,1,2,30.0,29.0,0.0,1,31.0,30.0,101.0
# CHECK: 0x160c,5644,"v_and_b32_e32 v1, 15, v0",v_and_b32_e32,Write32Bit,5,2,,,,,,,,
# CHECK: 0x1610,5648,s_endpgm,s_endpgm,WriteBranch,32,3,,,,,,,,

# WIN: wait_pc_hex,wait_pc_dec,wait_instruction,phase,counter,limit,pending_count,drained_count,pending_pcs,drained_pcs,pending_classes,model_max_latency,model_static_wait,att_stats_hitcount,att_stats_avg_latency,att_stats_avg_stall,wave_hitcount,wave_avg_duration,wave_avg_stall
# WIN: 0x1608,5640,s_waitcnt lgkmcnt(0),unknown,lgkm,0,1,1,0x1600,0x1600,WriteSMEM,20,19,2,30.0,29.0,1,31.0,30.0

# POS: wave_resolved: 4
# POS: wave_code_resolved: 2
# POS: wave_position_resolved: 2
# POS: wave_unresolved: 0
# POS: 0x160c,5644,"v_and_b32_e32 v1, 15, v0",v_and_b32_e32,Write32Bit,5,2,,,,,1,1.0,0.0,132.0
# POS: 0x1610,5648,s_endpgm,s_endpgm,WriteBranch,32,3,,,,,1,1.0,0.0,133.0

# SUM: wait_windows: 1
# SUM: scope,name,windows,model_static_wait_per_wave,att_wave_duration_per_wave,att_wave_stall_per_wave
# SUM: all,all,1,19.0,31.0,30.0
# SUM: class,SMEM,1,19.0,31.0,30.0
# SUM: phase,unknown,1,19.0,31.0,30.0
# SUM: phase:unknown,SMEM,1,19.0,31.0,30.0
