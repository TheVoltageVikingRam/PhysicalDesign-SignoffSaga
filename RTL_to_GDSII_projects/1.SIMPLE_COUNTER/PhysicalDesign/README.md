# Physical Design — 8-bit Simple Counter
> **Tool:** Cadence Innovus Implementation System &nbsp;|&nbsp; **PDK:** GPDK045 (45 nm) &nbsp;|&nbsp; **Flow:** Netlist-to-GDSII

A complete, documented place-and-route (PnR) run on a scan-enabled 8-bit ripple counter, carried from gate-level netlist import all the way to a clean, DRC/LVS-ready GDSII. Every stage is captured with screenshots and the key input scripts are reproduced here for reference.

---

## Table of Contents
1. [Design Overview](#1-design-overview)
2. [File Structure](#2-file-structure)
3. [Input Files & MMMC Setup](#3-input-files--mmmc-setup)
4. [Design Import (Innovus)](#4-design-import-innovus)
5. [Floorplan](#5-floorplan)
6. [Power Planning](#6-power-planning)
7. [Placement](#7-placement)
8. [Clock Tree Synthesis](#8-clock-tree-synthesis)
9. [Routing](#9-routing)
10. [Filler Cell Insertion](#10-filler-cell-insertion)
11. [Timing Signoff](#11-timing-signoff)
12. [Power Integrity — Rail Analysis](#12-power-integrity--rail-analysis)
13. [Results at a Glance](#13-results-at-a-glance)

---

## 1. Design Overview

| Parameter | Value |
|---|---|
| Design | 8-bit synchronous counter (scan-enabled) |
| Technology | GPDK 45 nm (gsclib045) |
| Clock Period | 10 ns (100 MHz) |
| Input Delay | 1 ns (rst, SE, scan_in) |
| Output Delay | 1 ns (count[7:0], scan_out) |
| Power Nets | VDD / VSS |
| Scan Chain | 1 chain, 8 FFs (count_reg[7:0]) |
| Cell Density after route | ~70% |

---

## 2. File Structure

```
PhysicalDesign/
├── Implementation/
│   ├── counter.view        # MMMC view definition (library sets, RC corners, analysis views)
│   ├── counter_sdc.sdc     # Timing constraints (clock, I/O delays, uncertainty)
│   ├── counter.scandef     # Scan-chain definition (DEF format)
│   ├── pins.io             # Pin assignment file (layer, offset, side)
│   └── power.tcl           # Global net connection commands
└── img/                    # Stage-by-stage Innovus screenshots
```

---

## 3. Input Files & MMMC Setup

### `counter_sdc.sdc` — Timing Constraints

The SDC targets a **10 ns clock period** with a symmetric waveform, ±0.1 ns uncertainty, and 1 ns I/O margins. The scan enable (`SE`) and reset (`rst`) are declared ideal networks (not subject to clock-tree buffering).

```tcl
set sdc_version 1.7
set_units -capacitance 1000.0fF -time 1000.0ps

current_design counter
create_clock "clk" -add -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_clock_uncertainty -setup 0.1 [get_ports clk]
set_clock_uncertainty -hold  0.1 [get_ports clk]

set_input_delay  -clock clk -add_delay -max 1.0 [get_ports rst]
set_output_delay -clock clk -add_delay -max 1.0 [get_ports {count[7] count[6] count[5] count[4] \
                                                              count[3] count[2] count[1] count[0]}]
set_ideal_network [get_ports rst]
set_ideal_network [get_ports SE]
set_wire_load_mode "enclosed"
set_dont_use [get_lib_cells slow_vdd1v0/HOLDX1]
```

### `counter.view` — MMMC View Definition

Worst-case (setup) and best-case (hold) corners are both linked to the same RC extraction corner from the GPDK045 cap table.

```tcl
create_library_set -name max_timing -timing ../lib/slow_vdd1v0_basicCells.lib
create_library_set -name min_timing -timing ../lib/fast_vdd1v0_basicCells.lib

create_rc_corner -name rccorners \
  -cap_table ../captable/cln28hpl_1p10m+alrdl_5x2yu2yz_typical.capTbl \
  -qrc_tech   ../QRC_Tech/gpdk045.tch \
  -pre_route_res 1 -post_route_res 1 \
  -pre_route_cap 1 -post_route_cap 1 -post_route_cross_cap 1

create_delay_corner -name max_delay -timing_condition default_mapping_tc_1 -rc_corner rccorners
create_delay_corner -name min_delay -timing_condition default_mapping_tc_2 -rc_corner rccorners

create_constraint_mode -name sdc_cons -sdc_files counter_sdc.sdc

create_analysis_view -name wc -constraint_mode sdc_cons -delay_corner max_delay
create_analysis_view -name bc -constraint_mode sdc_cons -delay_corner min_delay

set_analysis -setup wc -hold bc
```

### `counter.scandef` — Scan Chain

One scan chain connecting all 8 count registers, entering via `scan_in` and exiting via `scan_out`.

```
SCANCHAINS 1;
  -top_chain_seg1_clk_rising
    + PARTITION p_clk_rising  MAXBITS 8
    + START PIN scan_in
    + FLOATING
      count_reg[0] ( IN SI ) ( OUT 0 )
      ...
      count_reg[7] ( IN SI ) ( OUT 0 )
    + STOP PIN scan_out
END SCANCHAINS
```

### `pins.io` — Pin Placement

Pins are distributed across all four sides, using Metal-2 (layer 2) for horizontal runs and Metal-3 (layer 3) for vertical runs. The clock is placed at a fixed offset from the corner to ease clock routing.

```
(top
    (pin name="clk"      offset=7.3 layer=2 width=0.08 depth=0.25 place_status=placed)
    (pin name="rst"      space=2.2  layer=2 ...)
    (pin name="count[7]" space=2.2  layer=2 ...)
    (pin name="count[6]" space=2.2  layer=2 ...)
)
(left  -> count[5:2]  layer=3)
(bottom -> count[1], count[0], SE, scan_in  layer=2)
(right  -> scan_out   layer=3)
```

---

## 4. Design Import (Innovus)

The gate-level netlist (`counter_netlist.v`), technology LEF (`gsclib045_macro.lef`), and the MMMC view file (`counter.view`) are loaded in a single **Design Import** dialog.

![Importing netlist, LEF, and MMMC into Innovus](img/Importing_netlist_lef_and_MMMC_file_for_counter_design_into_innovus.png)

Key settings in the dialog:
- **Netlist** → Verilog: `counter_netlist.v`
- **Technology Library** → LEF: `../lef/gsclib045_macro.lef`
- **Power Nets** → VDD / VSS
- **MMMC View Definition** → `counter.view`

After import, the **design browser** confirms all cells and nets were resolved correctly.

![Design browser after import](img/DESIGN_BROWSER_AFTER_IMPORT.png)

---

## 5. Floorplan

The die-area and core-area boundaries are set with a fixed core-to-die margin, and standard-cell rows are initialized.

![Floorplan initialized — die and core boundaries visible](img/floorplan_initialized.png)

The core rows appear as horizontal white lines. Pins are assigned via the `pins.io` file using:

```tcl
read_io_file pins.io
```

![IO file read — pin locations assigned](img/io_file_read_using_read_io_file_command_and_assigned_view_snapshot.png)

Floorplan dimensions are confirmed by measuring the core-to-die distance.

![Core-to-die boundary distance](img/distance_b_w_core_And_die_boundary.png)

---

## 6. Power Planning

Power planning follows the standard **ring → stripe → follow-pin** flow.

### 6.1 Global Net Connection

Before strapping, power/ground pins of all standard cells are connected to the global VDD/VSS nets.

```tcl
# power.tcl
connect_global_net VDD -type pg_pin  -pin VDD -inst *
connect_global_net VSS -type pg_pin  -pin VSS -inst *
connect_global_net VDD -type tie_hi
connect_global_net VSS -type tie_lo
connect_global_net VDD -type tie_hi  -pin VDD -inst *
connect_global_net VSS -type tie_lo  -pin VSS -inst *
```

![Global VDD/VSS association command](img/associate_global_VDD_VSS_with_standard_cell_pins_command.png)

### 6.2 Power Rings

VDD/VSS rings are added around the core boundary on **Metal-10 (vertical)** and **Metal-11 (horizontal)**, width = 0.7 µm, spacing = 0.2 µm, offset = 0.5 µm.

![Add Rings menu — net, layer, and config settings](img/add_ring_power_plan_menu_nets_vdd_vss_selected_around_ring_boundary_contour_and_ring_config.png)

![Power rings generated](img/power_rings_generated_after_click_apply.png)

### 6.3 Power Stripes

Vertical stripes are added across the core to ensure adequate current delivery to all rows. Rings and stripes are stitched together with vias automatically.

![Add Stripes menu](img/add_stripe_power_plan_menu.png)

![Stripes and ring-to-stripe vias created](img/power_stripes_and_vias_connecting_rings_to_stripes_created.png)

### 6.4 Special Route

Follow-pin routes connect the horizontal power stripes in each standard-cell row to the VDD/VSS rails.

![Power route connected to targets via vias](img/power_route_connected_to_power_planned_targets_with_vias.png)

---

## 7. Placement

Standard cells are placed using `place_design` (global → detailed placement). The physical view shows all 8 `count_reg` flip-flops and combinational logic cells legally placed within the core rows, with VDD/VSS rails clearly visible.

![Physical view with standard cells placed](img/physical_view_with_std_cells_placed.png)

After placement, `check_place` is run to verify no overlaps or illegal placements exist.

---

## 8. Clock Tree Synthesis

CTS is run with `ccopt_design`. The ideal clock (`clk`) is buffered and balanced across the 8 flip-flops. Reset (`rst`) and scan enable (`SE`) remain ideal — not buffered by CTS, as declared in the SDC via `set_ideal_network`.

---

## 9. Routing

Detailed routing is performed using **NanoRoute**.

![NanoRoute settings form](img/NanoRouteform.png)

Post-route, the layout shows all signal and clock nets fully routed with no DRC violations.

![Layout after NanoRoute](img/design_after_nano_route.png)

### Connectivity & DRC Checks

Both connectivity and DRC checks are run post-route to verify a clean result.

![Check Connectivity form](img/check_connectivity_form.png)

![Check DRC form](img/check_drc_form.png)

---

## 10. Filler Cell Insertion

Filler cells (FILL / DECAP) are inserted to complete n-well continuity and eliminate gaps between standard cells.

![Add Filler Cells menu](img/add_filler_cells_menu.png)

The final physical view after filler insertion is the implementation endpoint — the layout is complete and ready for GDSII streaming.

![Final layout after filler insertion](img/after_filler_cell_placement.png)

![Final layout — clean implementation end state](img/after_filler_cell_placement_layout_implementation_end.png)

> The animated GIF below captures the complete journey from an empty floorplan to the fully routed and filled layout.

![Full layout journey — animated](img/layout_final.gif)

---

## 11. Timing Signoff

Post-route RC extraction (`extract_rc`) is followed by `time_design` for both setup and hold views.

### Setup (WC corner)

```
time_design Summary
──────────────────────────────────────────────────
 Setup mode   │  all   │ reg2reg │ default
──────────────────────────────────────────────────
 WNS (ns):    │  8.341 │  8.341  │  8.731
 TNS (ns):    │  0.000 │  0.000  │  0.000
 Violating:   │  0     │  0      │  0
 All Paths:   │  40    │  15     │  25
```

✅ **Zero setup violations. WNS = 8.341 ns — slack = 83% of the clock period.**

![Timing summary — setup (WC corner)](img/timing_summary_nano_routed_rc_extracted.png)

### Hold (BC corner)

```
time_design Summary
──────────────────────────────────────────────────
 Hold mode    │  all    │ reg2reg │ default
──────────────────────────────────────────────────
 WNS (ns):    │ -0.093  │ -0.024  │ -0.093
 TNS (ns):    │ -0.988  │ -0.161  │ -0.827
 Violating:   │  17     │  8      │  9
 All Paths:   │  24     │  15     │  9
```

> ⚠️ **Hold violations present (WNS = −93 ps).** This is expected at this stage for a design without a dedicated hold-fix buffering pass. A production flow would follow with `time_design -hold` optimization before tape-out sign-off.

![Timing summary — hold (BC corner)](img/timing_summary_nano_routed_rc_extracted_hold.png)

---

## 12. Power Integrity — Rail Analysis

Power/rail analysis is run using **Voltus** (integrated within Innovus). The IR-drop heatmap confirms that worst-case voltage droop is **< 10 mV** across the entire design — well within acceptable limits for a 1.0 V supply.

![Rail Analysis settings form](img/rail_analysis_form.png)

![Run Rail Analysis form](img/run_rail_analysis_form.png)

![IR Drop heatmap — post-route (max drop < 10 mV)](img/IR_DROP_RESULTS_AFTER_RAIL_ANALYSIS.png)

Power activity context was loaded prior to the analysis:

![Power activity after analysis](img/power_activity_after_power_analysis.png)

---

## 13. Results at a Glance

| Stage | Status |
|---|---|
| Design Import | ✅ Clean — netlist, LEF, MMMC loaded |
| Floorplan | ✅ Core rows initialized, pins placed |
| Power Planning | ✅ Rings + Stripes + Special Route |
| Placement | ✅ No overlaps, DRC clean |
| Clock Tree Synthesis | ✅ Clock balanced across 8 FFs |
| Routing (NanoRoute) | ✅ No DRC / connectivity violations |
| Filler Insertion | ✅ N-well continuity achieved |
| Setup Timing | ✅ WNS = +8.341 ns (0 violations) |
| Hold Timing | ⚠️ WNS = −0.093 ns (17 violations — hold-fix pending) |
| IR Drop | ✅ < 10 mV worst-case |
| Cell Density | ~70% |

---

*Part of the [PhysicalDesign-SignoffSaga](../../..) RTL-to-GDSII project series.*
