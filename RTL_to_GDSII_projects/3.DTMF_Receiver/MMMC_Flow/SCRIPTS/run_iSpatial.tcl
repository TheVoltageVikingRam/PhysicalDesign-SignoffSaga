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

