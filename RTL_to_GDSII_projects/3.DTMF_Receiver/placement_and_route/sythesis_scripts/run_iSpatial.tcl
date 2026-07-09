#Genus iSpatial flow script

if  {[file exists /proc/cpuinfo]} {
    sh grep "model name" /proc/cpuinfo
    sh grep "cpu MHz" /proc/cpuinfo
}

puts "Hostname: [info hostname]"

##############################################
## Global Variables and Attributes settings ##
##############################################

# Set design name and effort level for various objects

set DESIGN dtmf_recvr_core      ; #Top Design Name
set GEN_EFF medium                ; #Effort level during generic synthesis -physcial
set MAP_EFF high            ; #Effort level during mapping -physical
set LOCAL_DIR ".."
set SYNTH_DIR "."
set TCL_PATH "."
set REPORTS_PATH "./reports"
set LIB_PATH "../lib"
set LEF_PATH "../lef"
set RTL_PATH "../rtl"







#Set the library search path , script search path and HDL search path

set_db init_lib_search_path "$LIB_PATH $LEF_PATH"   ; # Path will be used for finding libs and lefs
set_db hdl_search_path $RTL_PATH   ; # Search path for HDL files
set_db script_search_path $TCL_PATH  ; #Path specifying the location of scripts

# Set effort level for syn_generic and syn_map

set_db syn_generic_effort $GEN_EFF
set_db syn_map_effort $MAP_EFF

set _OUTPUTS_PATH iSpatial_outputs ; #Directory name for output
set _REPORTS_PATH iSpatial_reports ; #Directory name for reports
set _LOG_PATH iSpatial_logs ; #Setting directory name for logs

#Creating directory name for outputs, reports and logs if not present already based on the variables set at the initial stage 
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
    puts "Creating directory ${_REPORTS_PATH} "

}

regexp \[0-9\]+(\.\[0-9\]+) [get_db program_version] exe_ver exe_sub_ver

puts "Executable Version : $exe_ver"
set_db information_level 9    ; # Controls the amount of information genus produces when executing commands, Specify an integer number from 0 to 9, higher the number higher the verbosity

######################
## iSpatial setup ##
######################



#Enable iSpatial 
set_db opt_spatial_effort extreme


#IMPORTANT : specify Innovus executable by uncommenting the following and filling in your Innovus command path

#NOT requried if you have your PATH env variable set to find the innovus command
#set_db innovus_executable  <path to innovus executable>


#Optional power optimization settings
#set_db design_power_effort high



########################################
## Library and MMMC Settings ##
########################################


read_mmmc dtmf_syn.mmmc
read_physical -lefs {../lef/all.lef}

#########################################
## Load Design and Initialize ##
#########################################

#Making a list of all hdl files to be read in


puts "Now load RTL"
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
    macro_bb_rtl/ram_256x16_test.v \
"

    #Reading hdl files and elaborating the design 

    read_hdl $rtl_list 
    elaborate $DESIGN


    set_db [get_db pins PLLCLK_INST/clk1x]  .dft_controllable "PLLCLK_INST/refclk non_inverting"

    set_db dft_scan_style muxed_scan

    define_test_signal -name test_mode -active high -function test_mode test_mode
    define_test_signal -name scan_en -active high -function shift_enable -default scan_en
    define_test_clock scan_clk


    check_dft_rules > ${_REPORTS_PATH}/${DESIGN}_pre_syn_dft_rules.rpt




    puts "Runtime & Mmeory 'read_hdl"
    time_info Elaboration 

    init_design
    puts "The number of exceptions is [llength [vfind /designs/$DESIGN -exception *]]"
    
    check_design -unresolved 
    check_timing_intent 
    report_ple > ${_REPORTS_PATH}/ple.rpt ; # Reports the Physical layout estimation report  from lef and QRC tech file



##############
## Read DEF ##
##############

        read_io_file dtmf.io
        read_floorplan dtmf_power_syn.fp

        

        check_floorplan -detailed 




###############################################################################
## Cost Group Setting (clock-clock, clock-output. input-clock, input-output) ##
################################################################################

        # Uncomment to remove already existing costgrups before creating new ones.
        # delete_obj [vfind /designs/* --cost_group *]

        #Defining cost groups I2C -> Input to register ; C2O -> Register to output ; C2C -> register to register ; I2O -> input to output paths

        foreach view [get_db analysis_views -if {.is_setup == true}] {
                if {[llength [all_registers]] > 0} {
            define_cost_group -name I2C -design $DESIGN
            define_cost_group -name C2O -design $DESIGN
            #We will use the clock cost groups created by the SDCs instead of C2C
            #define_cost_group -name C2C -design $DESIGN
            path_group -from [all_registers] -to [all_outputs] -group C2O -name C2O -view $view
            path_group -from [all_inputs] -to [all_registers] -group I2C -name I2C -view $view
            #path_group -from [all_registers] -to [all_registers] -group C2C -name C2C -view $view

                }
                define_cost_group -name I2O -design $DESIGN
                path_group -from [all_inputs] -to [all_outputs] -group I2O -name I2O -view $view 
        }

        #Report timing with cost group

        foreach cg [get_db cost_groups *] {
            report_timing -group [list $cg] >> ${_REPORTS_PATH}/${DESIGN}_pretim.rpt
        }


#################################
## Physical aware synthesis ##
#################################

syn_generic -physical
puts "Runtime & Memory after 'syn_generic -physical'"
time_info GENERIC


#Generate a summary for the current stage of synthesis

write_reports -directory $_REPORTS_PATH -tag generic 
write_db ${_OUTPUTS_PATH}/${DESIGN}_generic.db


syn_map -physical
puts "Runtime and Memory after 'syn_map -physical'"

time_info MAPPED

# Check dft rules on mapped gate level netlist

check_dft_rules > ${_REPORTS_PATH}/${DESIGN}_post_map_dft_rules.rpt

# preview or configure the scan chains

set_db design:$DESIGN  .dft_min_number_of_scan_chains 2


# Physically synthesize and insert scan chains


connect_scan_chains -preview

connect_scan_chains


report_dft_setup  >  ${_REPORTS_PATH}/${DESIGN}_scansetup.rpt
report_dft_chains  >  ${_REPORTS_PATH}/${DESIGN}_scan_chains.rpt






write_reports -directory $_REPORTS_PATH -tag map
write_db ${_OUTPUTS_PATH}/${DESIGN}_map.db 

#Report timing path with cost group 

foreach cg [get_db cost_groups *] {
    report_timing -group [list $cg] > $_REPORTS_PATH/${DESIGN}_[vbasename $cg]_post_map.rpt 

}

#LEC Verification

write_do_lec -golden_design rtl -revised_design fv_map -no_exit -logfile ${_LOG_PATH}/rtl_2_fv_map.lec.log  > ${_OUTPUTS_PATH}/rtl_2_fv_map.lec.do 

#####################################################################################################
## DB Handoff to Innovus preCTS
####################################################################################################

#The file invs2genus_final_db is saved in invs_temp_dir

#We should specify the temp directory which contains Innovus Interface files generated during syn_opt -spatial, using the attribute invs_temp_dir.

# If not set the temp dir is deleted after syn_opt run


####################################
## iSpatial Synthesis  ##
####################################

syn_opt -spatial
puts "Runtime and memory after 'syn_opt -spatial'"
time_info ISPATIAL 

########################
## WRITE REPORTS ##
########################

report_message > $_REPORTS_PATH/${DESIGN}_messages.rpt     ; # Summarizes the information , Warnings, Errors issued by Genus in the current run since last report
report_gates > $_REPORTS_PATH/${DESIGN}_gates.rpt       ; # Reports the technology library cells that were implemented  
report_power > $_REPORTS_PATH/${DESIGN}_power.rpt      ; # Reports the leakage power and dynamic power
write_reports -directory $_REPORTS_PATH -tag final          ; # Generate reports from Genus session

#LEC Verification

write_do_lec -golden_design fv_map -revised_design ${_OUTPUTS_PATH}/final/${DESIGN}.v.gz -no_exit -logfile  ${_LOG_PATH}/fv_map_2_final.lec.log > ${_OUTPUTS_PATH}/fv_map_2_final.lec.do


##################################################################################################

## Netlist handoff to Innovus preCTS

##################################################################################################


write_db -common INVS -design dtmf_recvr_core

puts "Final Runtime & Memory"

time_info FINAL
puts "==================================="
puts "Synthesis Finished  ..............."
puts "==================================="

file copy [get_db stdout_log]  ${_LOG_PATH}/.

# QUIT