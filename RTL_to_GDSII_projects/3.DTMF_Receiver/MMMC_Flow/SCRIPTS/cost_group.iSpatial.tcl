####################################################################
## Cost Group Setting (clock-clock, input-clock, input-output)##
####################################################################










# Report timing with cost group
for each cg [get_db cost_groups * ] {
  report_timing -group [list $cg] >> $_REPORTS_PATH/${DESIGN}_pretim.rpt
}
