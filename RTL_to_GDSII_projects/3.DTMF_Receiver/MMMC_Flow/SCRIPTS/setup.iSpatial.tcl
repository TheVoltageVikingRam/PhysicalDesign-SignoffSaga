#This coode is just for manual typing of the rest of the commands on genus shell in accordance with the flow in run_iSpatial.tcl


#Template for Genus iSpatial

if {[file exists /proc/cpuinfo]} {
    sh grep "model name" /proc/cpuinfo
    sh grep "cpu Mhz" /proc/cpuinfo
}

puts "Hostname: [info hostname]" 


##############################################
## Global Variables
##############################################

    # Set Design Name and effort level for various stages
    set DESIGN dtmf_recvr_core  ; # Top design name
    set GEN_EFF medium    ; # Effort level during optimization in syn_generic -physical (or called generic) stage values are (high, medium, or low)
    set MAP_EFF high       ; # Effort level during mapping in syn_generic -physical (or called mapping) stage values are (high, medium, or low)


    # Set the library search path, script search path and HDL search path

    set_db init_lib_search_path { ../LIB/gsclib045_v3.5/timing ../LIB/gsclib045_v3.5/lef ../LIB/macro_libs ../LEF/gsclib045_v3.5/lef ../LEF/macro_lefs}  ; # Path will be used for finding libs and lefs

    set_db init_hdl_search_path { ../RTL } ; # Search path for hdl files 
    set_db script_search_path { . } ; # Path specying the location of scripts 

    # Set the effort level for syn_generic and syn_map

    set_db syn_generic_effort $GEN_EFF
    set_db syn_map_effort $MAP_EFF 

    set _OUTPUTS_PATH iSpatial_outputs ; # Setting directory name for the output
    set _REPORTS_PATH iSpatial_reports ; # Setting directory name for the reports
    set _LOG_PATH iSpatial_logs ; # Setting directory name for the logs

    #Creating the directory for logs, reports and outputs if not already existing based on variable set at the initial stage

    if {![file exists ${_LOG_PATH}]} {
        file mkdir ${_LOG_PATH}
        puts "Creating directory ${_LOG_PATH}"
    }

    if {![file exists ${_OUTPUTS_PATH}]} {
        file mkdir ${_OUTPUTS_PATH}
        puts "Creating directory ${_OUTPUTS_PATH}"
    }


    if {![file exists ${_REPORTS_PATH}]} {
        file mkdir ${_REPORTS_PATH}
        puts "Creating directory ${_REPORTS_PATH}"
    }

    regexp \[0-9\]+(\.\[0-9\]+) [get_db program_version] exe_ver exe_sub_ver
    puts "Executable version: $exe_ver"

    set_db information_level 9          ; # Controls the amount of information Genus produces when executing commands, Specify an integer from 0 to 9, higher the number higher the verbosity

    #Making a list of all hdl files to be read in
    puts "Now load HDL"
    set rtl_list " \
        pllclk.v \
        accum_stat.v \
        alu_32.v \
        arb.v \
        data_bus_mach.v \
        data_sample_mux.v \
        decode_i.v \
        decoder.v \
        digit_reg.v \
        conv_subreg.v \
        dma.v \
        dtmf_recvr_core.v \
        execute_i.v \
        m16x16.v \
        mult_32_dp.v \
        port_bus_mach.v \
        prog_bus_mach.v \
        results_conv.v \
        spi.v \
        tdsp_core_glue.v \
        tdsp_core_mach.v \
        tdsp_core.v \
        tdsp_data_mux.v \
        tdsp_ds_cs.v \
        test_control.v \
        ulaw_lin_conv.v \
        power_manager.v \
        macro_bb_rtl/ram_128x16_test.v \
        macro_bb_rtl/ram_256x16_test.v 

    "