
###############################################################################
## Cost Group Setting (clock-clock, clock-output. input-clock, input-output) ##
################################################################################

        # Uncomment to remove already existing costgrups before creating new ones.
        # delete_obj [vfind /designs/* --cost_group *]

        #Defining cost groups I2C -> Input to register ; C2O -> Register to output ; C2C -> register to register ; I2O -> input to output paths

        foreach view [get_db analysis_views -if {.is_setup == true}] {
                if {[llength [all_registers]] > 0} {
            define_cost_group -name I2C -design $DESIGN
            define_cost_group -name C2O -design $DESIGN
            #We will use the clock cost groups created by the SDCs instead of C2C
            #define_cost_group -name C2C -design $DESIGN
            path_group -from [all_registers] -to [all_outputs] -group C2O -name C2O -view $view
            path_group -from [all_inputs] -to [all_registers] -group I2C -name I2C -view $view
            #path_group -from [all_registers] -to [all_registers] -group C2C -name C2C -view $view

                }
                define_cost_group -name I2O -design $DESIGN
                path_group -from [all_inputs] -to [all_outputs] -group I2O -name I2O -view $view 
        }

        #Report timing with cost group

        foreach cg [get_db cost_groups *] {
            report_timing -group [list $cg] >> ${_REPORTS_PATH}/${DESIGN}_pretim.rpt
        }

