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

#Set the library search path , script search path and HDL search path

set_db init_lib_search_path {../LIB/gsclib045_v3.5/timing ../LIB/gsclib045_v3.5/lef ../LIB/macro_libs ../LEF/gsclib045_v3.5/lef ../LEF/macro_lefs}   ; # Path will be used for finding libs and lefs
set_db hdl_search_path {../RTL}   ; # Search path for HDL files
set_db script_search_path { . }  ; #Path specifying the location of scripts

# Set effort level for syn_generic and syn_map

set_db syn_generic_effort $GEN_EFF
set_db syn_map_effort $MAP_EFF

set _OUTPUTS_PATH iSpatial_outputs ; #Directory name for output
set _REPORTS_PATH iSpatial_reports ; #Directory name for reports
set _LOGS_PATH iSpatial_logs ; #Setting directory name for logs

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


read_mmmc ../SCRIPTS/mmmc_iSpatial.tcl
read_physical -lefs [gsclib045_tech.lef gsclib045_macro.lef pllclk.lef CDK_S128x16.lef CDK_S256x16.lef CDK_R512x16.lef}


#########################################
## Load Design and Initialize ##
#########################################

#Making a list of all hdl files to be read in


puts "Now load RTL"








