######################################################################
# Genus SDC labs final version
######################################################################

# set the current DESIGN

current_design dtmf_recvr_core

set_case_analysis 0 [get_ports scan_en]
set_case_analysis 0 [get_ports test_mode]

create_clock -name "refclk" -add -period 8.0 -waveform {0.0 4.0} [get_ports refclk]
set_clock_transition 0.0 [get_clocks refclk]
create_clock -name "m_clk" -add -period 8.0 -waveform {0.0 4.0} [get_pins TEST_CONTROL_INST/m_clk]
set_clock_transition 0.0 [get_clocks m_clk]
create_clock -name "m_rcc_clk" -add -period 16.0 -waveform {0.0 8.0} [get_pins TEST_CONTROL_INST/m_rcc_clk]
set_clock_transition 0.0 [get_clocks m_rcc_clk]
create_clock -name "m_spi_clk" -add -period 16.0 -waveform {0.0 8.0} [get_pins]