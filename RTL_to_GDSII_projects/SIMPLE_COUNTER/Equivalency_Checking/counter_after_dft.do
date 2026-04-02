set log file counter_lec.log -replace

read library /home/server2/design_kits/cadence_dft/Stylus_21.1x_RAK/libs/GPDK045/gsclib045/timing/slow_vdd1v0_basicCells.lib   -liberty -both

read design ../counter.v -verilog -golden

read design /home/server2/Music/ram/counter/genus_dft/outputs/counter_netlist_dft.v -verilog -revised

add pin constraints 0 SE -revised
add ignored inputs scan_in -revised
add ignored outputs scan_out -revised

set system mode lec
add compard point -all
compare

