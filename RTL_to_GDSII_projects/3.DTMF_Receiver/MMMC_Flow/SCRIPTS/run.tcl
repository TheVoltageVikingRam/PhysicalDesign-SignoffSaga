if {[file exists /proc/cpuinfo]} {

sh grep "model name" /proc/cpuinfo
sh grep "cpu MHz" /proc/cpuinfo
}

puts "Hostname : [info hostname]"

set DESIGN dtmf_recvr_core
set SYN_EFF medium
set MAP_EFF medium
set OPT_EFF medium

set RELEASE [lindex [get_db program_version] end]
set _OUTPUTS_PATH OUTPUT/outputs_${RELEASE}
set _REPORTS_PATH OUTPUT/reports_${RELEASE}


if {![file exists ${_OUTPUTS_PATH}]} {
    file mkdir ${_OUTPUTS_PATH}
    puts "Creating directory ${_OUTPUTS_PATH}"

}

if {![file exists ${_REPORTS_PATH}]} {
    file mkdir ${_REPORTS_PATH}
    puts "Creating directory ${_REPORTS_PATH}"
}


set rtlDir ../RTL 
set_db init_lib_search_path {. ../}
set_db script_search_path { . }
set_db init_hdl_search_path {. ../RTL}

set_db max_cpus_per_server 8 
set_db syn_generic_effort $SYN_EFF
set_db syn_map_effort $MAP_EFF
set_db syn_opt_effort $OPT_EFF

set_db information_level 9
# set_db pbs_mmmc_flow true

set_db lp_insert_clock_gating true

puts "Now load RTL List"

set rtlList " \
${rtlDir}/pllclk.v      \
${rtlDir}/accum_stat.v      \
${rtlDir}/alu_32.v      \
${rtlDir}/arb.v         \
${rtlDir}/data_bus_mach.v      \
${rtlDir}/data_sample_mux.v      \
${rtlDir}/decode_i.v      \
${rtlDir}/decoder.v      \
${rtlDir}/digit_reg.v      \
${rtlDir}/conv_subreg.v      \
${rtlDir}/dma.v      \
${rtlDir}/dtmf_recvr_core.v      \
${rtlDir}/execute_i.v      \
${rtlDir}/m16x16.v      \
${rtlDir}/mult_32_dp.v      \
${rtlDir}/port_bus_mach.v      \
${rtlDir}/prog_bus_mach.v      \
${rtlDir}/results_conv.v      \
${rtlDir}/spi.v      \
${rtlDir}/tdsp_core_glue.v      \
${rtlDir}/tdsp_core_mach.v      \
${rtlDir}/tdsp_core.v      \
${rtlDir}/tdsp_data_mux.v      \
${rtlDir}/tdsp_ds_cs.v      \
${rtlDir}/test_control.v      \
${rtlDir}/ulaw_lin_conv.v      \
${rtlDir}/power_manager.v      \
${rtlDir}/macro_bb_rtl/ram_128x16_test.v      \
${rtlDir}/macro_bb_rtl/ram_256x16_test.v      \
"


suspend


# Reading in MMMC definition file and LEF files

read_mmmc ../SCRIPTS/mmmc.tcl


read_physical -lefs { \
    ../LEF/gsclib045_v3.5/lef/gsclib045_tech.lef 
    ../LEF/gsclib045_v3.5/lef/gsclib045_macro.lef 
    ../LEF/macro_lefs/pllclk.lef 
    ../LEF/macro_lefs/CDK_S128x16.lef
    ../LEF/macro_lefs/CDK_S256x16.lef
    ../LEF/macro_lefs/CDK_R512x16.lef

}




# Reading hdl files. initalize the database and elaborating them

read_hdl $rtlList
elaborate $DESIGN
#read_def ../DEF/dtmf.def 

init_design 
time_info init_design 
check_design -unresolved

## set the innovus executable  to be used for the placement and routing
## set_db innovus_executable <Innovus executables>


#############################################################################
## Synthesize the design 
###########################################################################


syn_generic
write_snapshot -directory $_OUTPUTS_PATH -tag syn_generic 
report_summary -directory $_REPORTS_PATH 

puts "Runtime & Memory after 'syn_generic' "
time_info GENERIC 

syn_map 
write_snapshot -directory $_OUTPUTS_PATH -tag syn_map
report_summary -directory $_REPORTS_PATH
puts "Runtime and Mmemory after 'syn_map'"
time_info MAPPED

syn_opt


## generate reports to save the innvous stats

 write_snapshot -innovus -directory $_OUTPUTS_PATH -tag syn_opt 
 report_summary -directory $_REPORTS_PATH 
 puts "Runtime & Memory after syn_opt" 
 time_info OPT 

 ## write out the final database 
 write_db -to_file ${DESIGN}.db 

 puts "Final Runtime & Memory."

 time_info FINAL 
 puts "==========================================="
 puts "Synthesis Finished ........................"
 puts "==========================================="

 #quit 