# ########################################################
# SDC constraints file for dtmf recvr core
# ########################################################


set sdc_version 1.4

#set the current design

current_design dtmf_recvr_core

set_case_analysis 0 [get_ports test_mode]
set_case_analysis 0 [get_ports scan_en]


