#################################################################################
#
# Created by Genus(TM) Synthesis Solution 23.13-s073_1 on Wed Jun 24 01:10:48 IST 2026
#
#################################################################################

## library_sets
create_library_set -name wcl_slow \
    -timing { /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/gsclib045_v3.5/timing/slow.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/pllclk_slow.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_S128x16.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_S256x16.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_R512x16.lib }
create_library_set -name wcl_fast \
    -timing { /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/gsclib045_v3.5/timing/fast.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/pllclk_slow.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_S128x16.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_R512x16.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_S256x16.lib }
create_library_set -name wcl_typical \
    -timing { /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/gsclib045_v3.5/timing/typical.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/pllclk_slow.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_S128x16.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_R512x16.lib \
              /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../LIB/macro_libs/CDK_S256x16.lib }

## opcond
create_opcond -name op_cond_wcl_slow \
    -process 1.0 \
    -voltage 1.08 \
    -temperature 125.0
create_opcond -name op_cond_wcl_fast \
    -process 1.0 \
    -voltage 1.32 \
    -temperature 0.0
create_opcond -name op_cond_wcl_typical \
    -process 1.0 \
    -voltage 1.2 \
    -temperature 25.0

## timing_condition
create_timing_condition -name timing_cond_wcl_slow \
    -opcond op_cond_wcl_slow \
    -library_sets { wcl_slow }
create_timing_condition -name timing_cond_wcl_fast \
    -opcond op_cond_wcl_fast \
    -library_sets { wcl_fast }
create_timing_condition -name timing_cond_wcl_typical \
    -opcond op_cond_wcl_typical \
    -library_sets { wcl_typical }

## rc_corner
create_rc_corner -name rc_corner \
    -cap_table /mnt/storage/Music/ram/GenusCUI_25_1/MMMC_Flow/work_mmmc/../Captable/cln28hpl_1p10m+alrdl_5x2yu2yz_typical.capTbl \
    -pre_route_res 1.0 \
    -pre_route_cap 1.0 \
    -pre_route_clock_res 0.0 \
    -pre_route_clock_cap 0.0 \
    -post_route_res {1.0 1.0 1.0} \
    -post_route_cap {1.0 1.0 1.0} \
    -post_route_cross_cap {1.0 1.0 1.0} \
    -post_route_clock_res {1.0 1.0 1.0} \
    -post_route_clock_cap {1.0 1.0 1.0} \
    -post_route_clock_cross_cap {1.0 1.0 1.0}

## delay_corner
create_delay_corner -name delay_corner_wcl_slow \
    -early_timing_condition { timing_cond_wcl_slow } \
    -late_timing_condition { timing_cond_wcl_slow } \
    -early_rc_corner rc_corner \
    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_wcl_fast \
    -early_timing_condition { timing_cond_wcl_fast } \
    -late_timing_condition { timing_cond_wcl_fast } \
    -early_rc_corner rc_corner \
    -late_rc_corner rc_corner
create_delay_corner -name delay_corner_wcl_typical \
    -early_timing_condition { timing_cond_wcl_typical } \
    -late_timing_condition { timing_cond_wcl_typical } \
    -early_rc_corner rc_corner \
    -late_rc_corner rc_corner

## constraint_mode
create_constraint_mode -name functional_wcl_slow \
    -sdc_files { OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb/cmn/dtmf_recvr_core.mmmc/modes/functional_wcl_slow/functional_wcl_slow.sdc.gz }
create_constraint_mode -name functional_wcl_fast \
    -sdc_files { OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb/cmn/dtmf_recvr_core.mmmc/modes/functional_wcl_fast/functional_wcl_fast.sdc.gz }
create_constraint_mode -name functional_wcl_typical \
    -sdc_files { OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb/cmn/dtmf_recvr_core.mmmc/modes/functional_wcl_typical/functional_wcl_typical.sdc.gz }

## analysis_view
create_analysis_view -name view_wcl_slow \
    -constraint_mode functional_wcl_slow \
    -delay_corner delay_corner_wcl_slow \
    -latency_file OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb/cmn/dtmf_recvr_core.mmmc/views/view_wcl_slow/latency.sdc.gz
create_analysis_view -name view_wcl_fast \
    -constraint_mode functional_wcl_fast \
    -delay_corner delay_corner_wcl_fast \
    -latency_file OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb/cmn/dtmf_recvr_core.mmmc/views/view_wcl_fast/latency.sdc.gz
create_analysis_view -name view_wcl_typical \
    -constraint_mode functional_wcl_typical \
    -delay_corner delay_corner_wcl_typical \
    -latency_file OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb/cmn/dtmf_recvr_core.mmmc/views/view_wcl_typical/latency.sdc.gz

## set_analysis_view
set_analysis_view -setup { view_wcl_slow view_wcl_fast view_wcl_typical } \
                  -hold { view_wcl_slow view_wcl_fast view_wcl_typical }
