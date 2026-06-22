# Apply clocks

define_clock -p 6000 -name refclk [get_db ports refclk]
define_clock -p 6000 -rise 20 -fall 20 -name refclk [get_db ports refclk]

define_clock -p 6000 -name m_clk [get_db hpins TEST_CONTROL_INST/m_clk]
define_clock -p 12000 -name m_rcc_clk [get_db hpins TEST_CONTROL_INST/m_rcc_clk]
define_clock -p 12000 -name m_spi_clk [get_db hpins TEST_CONTROL_INST/m_spi_clk]
define_clock -p 12000 -name m_dsram_clk [get_db hpins TEST_CONTROL_INST/m_dsram_clk]
define_clock -p 12000 -name m_ram_clk [get_db hpins TEST_CONTROL_INST/m_ram_clk]
define_clock -p 12000 -name m_digit_clk [get_db hpins TEST_CONTROL_INST/m_digit_clk]


set_db [get_db clocks m*] .clock_source_late_latency 2000
set_db [get_db clocks m*] .clock_network_late_latency 2000
set_db [get_db clocks *] .clock_setup_uncertainty 250

#Apply external delays
external_delay -input 500 -clock refclk [all_inputs]
external_delay -output 500 -clock refclk [all_outputs]

# set ideal drivers

set_db [get_db ports refclk] .ideal_driver true
external_delay -input 0 -clock refclk [get_db ports reset]
set_db [get_db ports reset] .ideal_driver true

# Apply Path Exceptions

path_disable -from [get_db ports reset]
path_disable -from [get_db ports test_mode]
path_disable -from [get_db ports scan_en]
path_disable -from [get_db ports spi_data]
path_disable -from [get_db ports spi_fs]
multi_cycle -to [get_db insts TDSP_CORE_INST/EXECUTE_INST/acc_reg*] -launch_shift 0 -capture_shift 2 -name ACC_REG_SLOW
multi_cycle -to [get_db insts TDSP_CORE_INST/EXECUTE_INST/p_reg* ] -launch_shift 0 -capture_shift 2 -name P_REG_SLOW
multi_cycle -to [get_db insts TDSP_CORE_INST/EXECUTE_INST/ov_flag_reg*] -launch_shift 0 -capture_shift 2 -name OVFLAG_REG_SLOW


# Apply Design Rule Constraints


set_db [all_inputs] .external_driver [get_db [get_db lib_cells */PDO04CDG] .lib_pins */PAD]
set_db [get_db ports reset] .external_driver ""
set_db [get_db ports refclk] .external_driver ""
set_db [all_inputs] .max_fanout 15
set_db [get_db ports reset] .max_fanout ""
set_db [get_db ports refclk] .max_fanout ""


