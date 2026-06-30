# Flowkit v18.10-p005_1
###############################################################################
## LIBRARY SETS
###############################################################################

create_library_set \
    -name       PVT_1P08V_125C \
    -timing \
                [list \
            ../LIB/gsclib045_v3.5/timing/slow.lib   \
            ../LIB/macro_libs/pllclk_slow.lib \
            ../LIB/macro_libs/CDK_S128x16.lib   \
            ../LIB/macro_libs/CDK_S256x16.lib \
            ../LIB/macro_libs/CDK_R512x16.lib   \

                ]

#create_library_set \
#   -name           PVT_1P32V_0C    \
#   -timing     \
#                [list \
                    [get_db lib_dir]/gsclib045/timing/fast_vdd1v2_basicCells.lib        \

                ]

#############################################################################
# OPERATING CONDITIONS
#############################################################################

create_opcond   \
    -name       max \
    -process    1 \
    -voltage    1.08    \
    -temperatures   125
#creat_opcond \
#   -name       min \
#   -process    1 \
#   -voltage    1.32 \
#   -temperature    0


######################################################################
## TIMING CONDITIONS
######################################################################

create_timing_condition \
    -name   slow\
    -library_sets   [list PVT_1P08V_125C ]  \
    -opcond     max 


#create_timing_condition     \
#   -name   fast \
#   -library_sets   [list PVT_1P32_0C]  \
#   -opcond         min


############################################################
##  RC CORNERS
############################################################
create rc_corner    \
    -name   rc_max \
    -temperature    125 \
    -qrc_tech       ../LIB/qrcTechFile


#create_rc_corner   \
#   -name       rc_min  \
#   -temperature        0 \
#   -qrc_tech       [get_db lib_dir]/gsclib045_tech/qrc/qx/gpdk045.tch  

####################################################################
## DELAY CORNERS
####################################################################

create_delay_corner \
    -name           slow_maxrc  \
    -timing_condition       slow \
    -rc_corner      rc_max


# create_delay_corner \
#   -name   fast_maxrc  \
#   -timing_condition       fast \
#    -rc_corner         rc_min


############################################################
## CONSTRAINT MODES
############################################################

create_constraint_mode     \
    -name   func \
    -sdc_files [list    \
                    ../Constraints_MMMC/dtmf_recvr_core_gate.iSpatial.sdc   \
                ]



###############################################################
## ANALYSIS MODE
###############################################################

create_analysis_view    \
    -name   func-slow_maxrc \
    -constraint_mode        func    \
    -delay_corner       slow_maxrc  


#create_analysis_view       \
#   -name   func-slow_minrc     \
#   -constraint_mode        func    \
#   -delay_corner       fast_minrc  


#############################################################
##  ACTIVE VIEWS
############################################################

set_analysis_view   \
    -setup      [list func-slow_maxrc]  \
    -hold       [list func-slow_maxrc]  \
    -leakage    [list func-slow_maxrc]  \
    -dynamic    [list func-slow_maxrc]  