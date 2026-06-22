# *******************************************************
# * Script Name: Genus Legacy Mode Initialization Script
# *******************************************************
set LOCAL_DIR "[exec pwd]/.."
set SYNTH_DIR ${LOCAL_DIR}/work
set TCL_PATH "${LOCAL_DIR}/tcl $LOCAL_DIR/constraints"
set REPORTS_PATH "${LOCAL_DIR}/work/reports"
set LIB_PATH "${LOCAL_DIR}/libraries/TIMING/CUSTOM ${LOCAL_DIR}/libraries/TIMING/STDCELL ${LOCAL_DIR}/libraries/TIMING/IO ${LOCAL_DIR}/libraries/LEF/STDCELL ${LOCAL_DIR}/libraries/LEF/CUSTOM ${LOCAL_DIR}/libraries/LEF/IO"
set RTL_PATH    "${LOCAL_DIR}/rtl"
set DESIGN "dtmf_recvr_core"

set MSGS_TO_BE_SUPRESSED {LBR-58 LBR-40 LBR-41 VLOGPT-35}

set DATE [clock format [clock seconds] -format "%b%d-%T"]

set _OUTPUTS_PATH outputs_${DATE}
set _REPORTS_PATH reports_${DATE}

if {![file exists ${_OUTPUTS_PATH}]} {
    file mkdir ${_OUTPUTS_PATH}
    puts "Creating directory ${_OUTPUTS_PATH}"
}

if {![file exists ${_REPORTS_PATH}]} {
    file mkdir ${_REPORTS_PATH}
    puts "Creating directory ${_REPORTS_PATH}"
}

# Baseline libraries


set LIB_LIST { \

ss_g_1v08_125c.lib \
ss_hvt_1v08_125c.lib \
ram_256x16A_slow_syn.lib \
rom_512x16A_slow_syn.lib \
pllclk_slow.lib \

}

set LEF_LIST { \
tsmc13fsg_8lm_tech.lef \
tsmc13g_m_macros.lef \
tsmc13hvt_m_macros.lef \
pllclk.lef \
ram_256X16A.lef \
rom_512x16A.lef \
tpz013g2_7lm.lef \

}


# Baseline RTL 

set RTL_LIST { \
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
execute_i.v  \
iopads.v \
m16x16.v \
mult_32_dp.v \
port_bus_mach.v \
prog_bus_mach.v \
ram_128x16_test.v \
ram_256x16_test.v \
results_conv.v  \
spi.v \
tdsp_core_glue.v \
tdsp_core_mach.v \
tdsp_core.v  \
tdsp_data_mux.v \
tdsp_ds_cs.v \
test_control.v \
ulaw_lin_conv.v \
power_manager.v \

}


# set CAP_TABLE_FILE ../libraries/tsmc13fsg.capTbl 
set QRC_TECH_FILE ../QRC/t018s6mm.tch
suppress_messages {LBR-30 LBR-31 LBR-40 LBR-41 LBR-72 LBR-77 LBR-162}
set_db lp_power_unit mW
