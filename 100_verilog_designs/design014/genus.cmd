# Cadence Genus(TM) Synthesis Solution, Version 23.13-s073_1, built Nov  8 2024 10:01:49

# Date: Mon Sep 29 04:54:07 2025
# Host: hostname1 (x86_64 w/Linux 4.18.0-553.74.1.el8_10.x86_64) (10cores*40cpus*2physical cpus*Intel(R) Xeon(R) CPU E5-2658 v2 @ 2.40GHz 25600KB)
# OS:   Rocky Linux 8.10 (Green Obsidian)

ls
read_hdl 4-bit_comparator.v
elaborate mag
set_db lib_search_path /home/server2/cadence/installs/DDI231/INNOVUS231/share/FoundationFlows/EXAMPLES/INNOVUS/DESIGN/GPDK/LIBS/GPDK045/timing
set_db library "slow.lib typical.lib fast.lib"
elaborate mag
nano constraints.sdc
read_sdc constraints.sdc
ls
cat constraints.sdc
nano constraints.sc
nano constraints.sdc
ls
nano 4-bit_comparator.v
nano constraints.sdc
read_sdc constraints.sdc
nano constraints.sdc
nano 4-bit_comparator.v
read_sdc constraints.sdc
nano 4-bit_comparator.v
read_hdl 4-bit_comparator.v
elaborate mag
read_sdc constraints.sdc
