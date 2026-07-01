#### Template script for RTL -> Gate-Level Flow

if  {[file exists /proc/cpuinfo]} {
    sh grep "model name" /proc/cpuinfo
    sh grep "cpu MHz" /proc/cpuinfo
}


puts "Hostname : [info hostname]"

####################################################
## Include TCL utility scripts
####################################################


include load_etc.tcl 

#####################################################################
## Present global variables and attributes
#####################################################################

source ../tcl/setup.lp.tcl 

set DATE [clock format [clock seconds] -format "%b%d-%T"]
set _OUTPUT_PATH outputs_${DATE}
set_db init_lib_search_path $LIB_PATH
set_db script_search_path "$TCL_PATH ."
set_db init_hdl_search_path $RTL_PATH
set_db information_level 7 
set_db hdl_track_filename_row_col true
set_db lp_power_unit mW


## Turning on Genus Power Engine
## set_db power_engine legacy

########################################################
## Optimization attributes
########################################################


set_db optimize_constant_0_flops true
set_db optimize_constant_1_flops true
set_db delete_unloaded_seqs true

###########################################################
######### Library setup
##########################################################


#set_db library $LIB_LIST 
read_libs $LIB_LIST


# set_db lef_library $LEF_LIST
read_physical -lef $LEF_LIST

# set_db cap_table_file $CAP_TABLE_FILE

set_db qrc_tech_file $QRC_TECH_FILE

if {![file exists ${_OUTPUTS_PATH}]} {
    file mkdir ${_OUTPUTS_PATH}
    puts "Creating directory ${_OUTPUTS_PATH}"

}


