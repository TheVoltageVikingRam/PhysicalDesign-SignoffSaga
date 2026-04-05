##In order to convert from .lib to .v for a library this script can be used


set log file lib_v.log -replace


read library /home/server2/design_kits/cadence_dft/Stylus_21.1x_RAK/libs/GPDK045/gsclib045/timing/slow_vdd1v0_basicCells.lib -liberty -both

write library slow_vdd1v0_basicCells.v -verilog

