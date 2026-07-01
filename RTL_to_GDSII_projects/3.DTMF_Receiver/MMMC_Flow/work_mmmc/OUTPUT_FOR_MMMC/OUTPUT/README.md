# DTMF Receiver Core — MMMC Synthesis Report

> **Design:** `dtmf_recvr_core` &nbsp;|&nbsp; **Tool:** Cadence Genus™ Synthesis Solution `23.13-s073_1` &nbsp;|&nbsp; **Date:** June 24, 2026  
> **Flow:** Multi-Mode Multi-Corner (MMMC) &nbsp;|&nbsp; **Technology:** GSCLIB045 (45 nm)

---

## Table of Contents

1. [Overview](#overview)  
2. [Directory Structure](#directory-structure)  
3. [MMMC Configuration](#mmmc-configuration)  
4. [Synthesis Script Flow (`run.tcl`)](#synthesis-script-flow-runtcl)  
5. [Input Collateral](#input-collateral)  
6. [Clock Architecture](#clock-architecture)  
7. [Synthesis Results Summary](#synthesis-results-summary)  
   - [Timing (QoS)](#timing-qos)  
   - [Area](#area)  
   - [Power](#power)  
   - [Instance Distribution](#instance-distribution)  
8. [Worst Timing Paths](#worst-timing-paths)  
9. [Output Deliverables](#output-deliverables)  
10. [Known Issues & Observations](#known-issues--observations)  
11. [Innovus Handoff](#innovus-handoff)  
12. [Runtime & Resource Usage](#runtime--resource-usage)  
13. [Reproducing the Run](#reproducing-the-run)  

---

## Overview

This directory contains the complete output of an **MMMC-aware RTL-to-gate synthesis** run for the **DTMF (Dual-Tone Multi-Frequency) Receiver Core** performed using **Cadence Genus**. The design was synthesized across **three PVT corners** (Slow, Fast, Typical) with independent SDC constraints per corner, enabling concurrent multi-corner timing optimization during synthesis.

The synthesis flow executes three sequential stages — **`syn_generic`** → **`syn_map`** → **`syn_opt`** — with snapshot and QoR reporting at each stage. The final optimized netlist and an Innovus-compatible database (`.cdb`) are exported for downstream Place & Route.

---

## Directory Structure

```
MMMC_Flow/
├── Captable/                         # Parasitic capacitance table (NDA — excluded)
│   └── cln28hpl_1p10m+alrdl_5x2yu2yz_typical.capTbl
├── Constraints_MMMC/                 # Per-corner SDC timing constraints
│   ├── dtmf_recvr_core_gate_slow.sdc
│   ├── dtmf_recvr_core_gate_fast.sdc
│   └── dtmf_recvr_core_gate_typical.sdc
├── DEF/                              # Floorplan DEF files
│   ├── dtmf.def
│   ├── fp.def
│   └── fp.onlybbox.def
├── LEF/                              # Library Exchange Format (NDA — excluded)
│   └── gsclib045_v3.5/lef/, macro_lefs/
├── LIB/                              # Liberty timing libraries (NDA — excluded)
│   └── gsclib045_v3.5/timing/, macro_libs/
├── SCRIPTS/                          # Synthesis & MMMC scripts
│   ├── run.tcl                       # Main synthesis driver
│   ├── mmmc.tcl                      # MMMC view/corner definitions
│   ├── postload.tcl                  # Post-load hooks (placeholder)
│   ├── db_handoff_to_invs.tcl        # DB handoff to Innovus (placeholder)
│   └── netlist_handoff_to_invs.tcl   # Netlist handoff (placeholder)
└── work_mmmc/OUTPUT/                 # ← YOU ARE HERE
    ├── outputs_23.13-s073_1/         # Databases, snapshots, per-stage reports
    └── reports_23.13-s073_1/         # Consolidated summary reports
```

---

## MMMC Configuration

Defined in [`mmmc.tcl`](../SCRIPTS/mmmc.tcl), the MMMC setup creates three analysis views covering worst-case slow, best-case fast, and nominal typical corners.

### Library Sets

| Library Set | Std Cell Lib | Macro Libraries |
|---|---|---|
| `wcl_slow` | `slow.lib` | `pllclk_slow.lib`, `CDK_S128x16.lib`, `CDK_S256x16.lib`, `CDK_R512x16.lib` |
| `wcl_fast` | `fast.lib` | `pllclk_slow.lib`, `CDK_S128x16.lib`, `CDK_S256x16.lib`, `CDK_R512x16.lib` |
| `wcl_typical` | `typical.lib` | `pllclk_slow.lib`, `CDK_S128x16.lib`, `CDK_S256x16.lib`, `CDK_R512x16.lib` |

### Operating Conditions

| Corner | Process | Voltage (V) | Temperature (°C) |
|---|---|---|---|
| `op_cond_wcl_slow` | 1.0 | 1.08 | 125 |
| `op_cond_wcl_fast` | 1.0 | 1.32 | 0 |
| `op_cond_wcl_typical` | 1.0 | 1.20 | 25 |

### RC Corner

A single RC corner (`rc_corner`) is shared across all views, using the `cln28hpl_1p10m+alrdl_5x2yu2yz_typical.capTbl` parasitic capacitance table.

### Analysis Views

| View | Constraint Mode | Delay Corner | SDC File |
|---|---|---|---|
| `view_wcl_slow` | `functional_wcl_slow` | `delay_corner_wcl_slow` | `dtmf_recvr_core_gate_slow.sdc` |
| `view_wcl_fast` | `functional_wcl_fast` | `delay_corner_wcl_fast` | `dtmf_recvr_core_gate_fast.sdc` |
| `view_wcl_typical` | `functional_wcl_typical` | `delay_corner_wcl_typical` | `dtmf_recvr_core_gate_typical.sdc` |

All three views are configured for **setup** analysis via `set_analysis_view -setup`.

---

## Synthesis Script Flow (`run.tcl`)

The main synthesis script ([`run.tcl`](../SCRIPTS/run.tcl)) orchestrates the full flow:

```
┌─────────────────────────────────────────────────────────┐
│  1. Environment Setup                                   │
│     • Design name: dtmf_recvr_core                      │
│     • Effort levels: medium (syn/map/opt)                │
│     • Max CPUs: 8  │  Clock gating: enabled              │
├─────────────────────────────────────────────────────────┤
│  2. Input Loading                                       │
│     • read_mmmc mmmc.tcl                                │
│     • read_physical (6 LEF files: tech + macro)         │
│     • read_hdl (28 Verilog RTL files)                   │
│     • elaborate dtmf_recvr_core                         │
│     • init_design + check_design -unresolved            │
├─────────────────────────────────────────────────────────┤
│  3. syn_generic    → write_snapshot → report_summary    │
│  4. syn_map        → write_snapshot → report_summary    │
│  5. syn_opt        → write_snapshot (Innovus) → report  │
├─────────────────────────────────────────────────────────┤
│  6. Final Export                                        │
│     • write_db → dtmf_recvr_core.db                     │
│     • Innovus .cdb exported for P&R handoff              │
└─────────────────────────────────────────────────────────┘
```

### Key Settings

| Parameter | Value |
|---|---|
| `syn_generic_effort` | medium |
| `syn_map_effort` | medium |
| `syn_opt_effort` | medium |
| `max_cpus_per_server` | 8 |
| `lp_insert_clock_gating` | true |
| `information_level` | 9 |

---

## Input Collateral

### RTL Sources (28 files)

| Module | Description |
|---|---|
| `dtmf_recvr_core.v` | Top-level DTMF receiver core |
| `tdsp_core.v` | TDSP processor core |
| `tdsp_core_mach.v` | TDSP core state machine |
| `execute_i.v` | Execution unit |
| `decode_i.v` | Instruction decode |
| `decoder.v` | General decoder |
| `alu_32.v` | 32-bit ALU |
| `m16x16.v` | 16×16 multiplier |
| `mult_32_dp.v` | 32-bit multiplier datapath |
| `accum_stat.v` | Accumulator status |
| `data_bus_mach.v` | Data bus machine |
| `prog_bus_mach.v` | Program bus machine |
| `port_bus_mach.v` | Port bus machine |
| `data_sample_mux.v` | Data sample multiplexer |
| `tdsp_data_mux.v` | TDSP data mux |
| `tdsp_ds_cs.v` | TDSP chip select |
| `tdsp_core_glue.v` | TDSP core glue logic |
| `dma.v` | DMA controller |
| `spi.v` | SPI interface |
| `arb.v` | Arbiter |
| `digit_reg.v` | Digit register |
| `conv_subreg.v` | Conversion sub-register |
| `results_conv.v` | Results conversion |
| `ulaw_lin_conv.v` | μ-law ↔ linear conversion |
| `test_control.v` | Test/scan control |
| `power_manager.v` | Power management |
| `pllclk.v` | PLL clock module |
| `ram_128x16_test.v`, `ram_256x16_test.v` | Memory macro RTL models |

### Physical Libraries (LEF)

| LEF File | Purpose |
|---|---|
| `gsclib045_tech.lef` | 45 nm technology layer definitions |
| `gsclib045_macro.lef` | Standard cell physical abstracts |
| `pllclk.lef` | PLL macro physical abstract |
| `CDK_S128x16.lef` | 128×16 SRAM macro |
| `CDK_S256x16.lef` | 256×16 SRAM macro |
| `CDK_R512x16.lef` | 512×16 register file macro |

---

## Clock Architecture

The design operates with **8 clocks** defined in the SDC constraints:

| Clock | Period (ns) | Frequency | Source |
|---|---|---|---|
| `refclk` | 5.0 – 8.0 * | 125 – 200 MHz | Port `refclk` |
| `clk2x` | 5.0 – 8.0 * | 125 – 200 MHz | Pin `PLLCLK_INST/clk2x` |
| `m_clk` | 5.0 – 8.0 * | 125 – 200 MHz | Pin `TEST_CONTROL_INST/m_clk` |
| `m_rcc_clk` | 16.0 | 62.5 MHz | Pin `TEST_CONTROL_INST/m_rcc_clk` |
| `m_spi_clk` | 16.0 | 62.5 MHz | Pin `TEST_CONTROL_INST/m_spi_clk` |
| `m_dsram_clk` | 16.0 | 62.5 MHz | Pin `TEST_CONTROL_INST/m_dsram_clk` |
| `m_ram_clk` | 16.0 | 62.5 MHz | Pin `TEST_CONTROL_INST/m_ram_clk` |
| `m_digit_clk` | 16.0 | 62.5 MHz | Pin `TEST_CONTROL_INST/m_digit_clk` |

> \* Period varies by corner: **Slow = 8 ns**, **Typical = 6 ns**, **Fast = 5 ns** for `refclk`, `clk2x`, and `m_clk`.

**Timing Exceptions:**
- `reset` and `test_mode` are false-pathed from all clocks.
- Hold false path through `PM_INST/clk_enable` (power manager gating).
- DFT: `test_mode = 0`, `scan_en = 0` via `set_case_analysis` (functional mode).
- I/O delays: 0.2 ns on all ports across all clock domains.
- Design rules: `max_fanout = 15`, `max_transition = 1.2 ns`.

---

## Synthesis Results Summary

### Timing (QoS)

Extracted from [`final.rpt`](reports_23.13-s073_1/final.rpt) — post `syn_opt` values:

| Metric | view_wcl_slow | view_wcl_fast | view_wcl_typical |
|---|---|---|---|
| **WNS (ps)** | **0** ✅ | **−576** ❌ | **252** ✅ |
| R2R Slack (ps) | 0 | −576 | 252 |
| I2R Slack (ps) | 7,326 | 478 | 1,500 |
| R2O Slack (ps) | 7,358 | 458 | 1,493 |
| CG Slack (ps) | 5,246 | 438 | 1,174 |
| **TNS (ps)** | **0** | **−9,466** | **0** |
| **Failing Paths** | **0** | **40** | **0** |

**Timing Progression Across Stages:**

| Stage | Slow WNS (ps) | Fast WNS (ps) | Typical WNS (ps) |
|---|---|---|---|
| `syn_generic` | 1,684 | −579 | 251 |
| `syn_map` | 0 | −609 | 202 |
| `syn_opt` | 0 | −576 | 252 |

> **Observation:** The **slow** and **typical** corners meet timing closure. The **fast** corner shows persistent setup violations (~−576 ps WNS) on cross-domain `clk2x → m_dsram_clk` paths. See [Known Issues](#known-issues--observations).

### Area

| Metric | syn_generic | syn_map | syn_opt (Final) |
|---|---|---|---|
| Cell Area | 230,424 | 243,436 | **243,139** |
| Net Area | — | — | 6,456 |
| Total Area | — | — | **249,595** |
| Leaf Instances | 10,936 | 5,148 | **4,966** |

**Module-Level Breakdown (post `syn_opt`):**

| Instance | Module | Cells | Cell Area | Total Area |
|---|---|---|---|---|
| `dtmf_recvr_core` (top) | — | 4,966 | 243,139 | 249,595 |
| `TDSP_CORE_INST_DECODE_INST` | `decode_i` | 103 | 403 | 491 |
| `SPI_INST` | `spi` | 44 | 195 | 228 |
| `TDSP_CORE_INST_DATA_BUS_MACH_INST` | `data_bus_mach` | 39 | 173 | 194 |
| `TDSP_CORE_INST_PORT_BUS_MACH_INST` | `port_bus_mach` | 32 | 147 | 162 |
| `TDSP_CORE_INST_PROG_BUS_MACH_INST` | `prog_bus_mach` | 29 | 139 | 151 |
| `TDSP_CORE_INST_TDSP_CORE_MACH_INST` | `tdsp_core_mach` | 28 | 87 | 110 |
| `PM_INST` | `power_manager` | 27 | 78 | 106 |
| `TDSP_CORE_INST_ACCUM_STAT_INST` | `accum_stat` | 18 | 35 | 46 |
| `TEST_CONTROL_INST` | `test_control` | 11 | 15 | 22 |

> **Note:** ~94.7% of total area is consumed by timing models (memory macros: 2× CDK_S256x16, 1× CDK_R512x16, 1× PLL).

### Power

From [`power_detailed.rpt`](reports_23.13-s073_1/power_detailed.rpt) (slow corner, post `syn_opt`):

| Metric | Value |
|---|---|
| **Total Leakage Power** | **618.4 nW** |
| **Total Internal Power** | **488,930 nW** (~489 µW) |

**Power by Cell Type:**

| Type | Instances | Leakage (nW) | Leakage % | Internal (nW) | Internal % |
|---|---|---|---|---|---|
| Logic | 3,802 | 404.0 | 65.3% | 215,030 | 44.0% |
| Sequential | 517 | 157.1 | 25.4% | 227,608 | 46.6% |
| Clock Gating | 35 | 7.6 | 1.2% | 27,605 | 5.6% |
| Buffer | 150 | 25.1 | 4.1% | 12,639 | 2.6% |
| Inverter | 458 | 24.5 | 4.0% | 6,048 | 1.2% |
| Timing Model (macros) | 4 | 0.1 | 0.0% | 0 | 0.0% |

### Instance Distribution

| Category | Count |
|---|---|
| Leaf Instances | 4,966 |
| Sequential | 555 |
| Combinational | 4,411 |
| Hierarchical | 44 |
| Clock Gating Cells (TLATNTSCAX2) | 35 |

---

## Worst Timing Paths

From [`timing_worst.rpt`](reports_23.13-s073_1/timing_worst.rpt) — all 10 worst paths are in the **`view_wcl_fast`** corner:

| # | Slack (ps) | Group | Startpoint | Endpoint | Launch → Capture Clk |
|---|---|---|---|---|---|
| 1 | **−576** | `m_dsram_clk` | `ar0_reg[2]` | `RAM_256x16 ADDRESS[5]` | `clk2x` → `m_dsram_clk` |
| 2 | −576 | `m_dsram_clk` | `ar0_reg[3]` | `RAM_256x16 ADDRESS[5]` | `clk2x` → `m_dsram_clk` |
| 3 | −575 | `m_dsram_clk` | `ar1_reg[2]` | `RAM_256x16 ADDRESS[5]` | `clk2x` → `m_dsram_clk` |
| 4 | −574 | `m_dsram_clk` | `ir_reg[0]` | `RAM_256x16 ADDRESS[5]` | `clk2x` → `m_dsram_clk` |
| 5 | −574 | `m_dsram_clk` | `dmov_inc_reg` | `RAM_256x16 ADDRESS[5]` | `clk2x` → `m_dsram_clk` |
| 6–10 | −573 to −574 | `m_dsram_clk` | Various execute/decode regs | `RAM_256x16 ADDRESS[5]` | `clk2x` → `m_dsram_clk` |

> **Root Cause:** All violations are cross-domain paths from `clk2x` (5 ns period at fast corner) through execute/decode registers to the **CDK_S256x16** SRAM macro address input. The macro setup time (1,206 ps) and aggressive clock period at the fast corner leave insufficient margin. Data path delay is ~370 ps with 12 logic levels.

---

## Output Deliverables

### `outputs_23.13-s073_1/`

| File | Description |
|---|---|
| `syn_generic_dtmf_recvr_core.db` | Generic synthesis database |
| `syn_map_dtmf_recvr_core.db` | Technology-mapped database |
| `syn_opt_dtmf_recvr_core.cdb/` | **Final optimized Innovus-compatible CDB** |
| `syn_opt_dtmf_recvr_core.invs_setup.tcl` | Innovus import script |
| `syn_generic_qor.rpt` | QoR report — generic stage |
| `syn_map_qor.rpt` | QoR report — mapping stage |
| `syn_opt_qor.rpt` | QoR report — optimization stage |
| `syn_{generic,map,opt}_time_view_wcl_{slow,fast,typical}.rpt` | Per-view, per-stage timing reports (9 files) |
| `syn_{map,opt}_area.rpt` | Hierarchical area reports |
| `syn_{map,opt}_gates.rpt` | Gate-level instance/power reports |
| `final.rpt` | Consolidated QoS comparison across all stages |

### `reports_23.13-s073_1/`

| File | Description |
|---|---|
| `final.rpt` | **Master QoS summary** — timing/area across all stages and views |
| `area_detailed.rpt` | Hierarchical area breakdown per module |
| `power_detailed.rpt` | Per-gate leakage & internal power |
| `timing_worst.rpt` | Top-10 worst setup paths (all corners) |

---

## Known Issues & Observations

| # | Severity | Description |
|---|---|---|
| 1 | ⚠️ **Warning** | **Fast-corner timing violations:** 40 failing paths in `view_wcl_fast` with WNS = −576 ps and TNS = −9,466 ps. All violations are on cross-domain `clk2x → m_dsram_clk` / `m_ram_clk` paths into SRAM macros. |
| 2 | ℹ️ Info | The fast corner uses an aggressive 5 ns period for `clk2x` (200 MHz), while macro setup times are ~1.2 ns. Tightening fast-corner constraints or relaxing the clock period may resolve violations. |
| 3 | ℹ️ Info | `syn_opt` reduced instance count from 10,936 (generic) → 4,966 (optimized), a **54.6% reduction** through technology mapping and optimization. |
| 4 | ℹ️ Info | Clock gating insertion generated **35 TLATNTSCAX2** integrated clock gating cells, contributing to dynamic power savings. |
| 5 | ℹ️ Info | Utilization reports `0.00%` since no floorplan DEF was loaded during synthesis (the `read_def` line is commented out in `run.tcl`). |

---

## Innovus Handoff

The `syn_opt` stage generates an Innovus-ready database for Place & Route:

```tcl
# Import into Innovus using the auto-generated setup script:
read_db -common OUTPUT/outputs_23.13-s073_1/syn_opt_dtmf_recvr_core.cdb
```

This loads the final optimized netlist with MMMC views preserved for PnR-stage timing closure.

---

## Runtime & Resource Usage

| Metric | syn_generic | syn_map | syn_opt | Total |
|---|---|---|---|---|
| CPU Runtime | 00:33:58 | 00:37:09 | 00:31:10 | — |
| Real (Wall) Time | 00:33:58 | 00:33:42 | 00:31:03 | — |
| Elapsed (Wall) | 00:33:59 | 00:37:41 | 00:38:43 | **00:39:27** |
| Peak Memory (MB) | 2,160 | 2,148 | 2,148 | **2,170** |

**Host:** `s2` &nbsp;|&nbsp; **Genus Version:** `23.13-s073_1`

---

## Reproducing the Run

```bash
# 1. Navigate to the working directory
cd MMMC_Flow/work_mmmc

# 2. Ensure proprietary files are in place:
#    - LIB/  → Liberty timing libraries (slow.lib, fast.lib, typical.lib, macro libs)
#    - LEF/  → Technology & macro LEFs
#    - Captable/ → RC parasitic cap table

# 3. Launch Genus with the synthesis script
genus -f ../SCRIPTS/run.tcl -log genus_mmmc.log

# Note: The script contains a 'suspend' command after RTL list definition.
#       Type 'resume' in the Genus console to continue execution.
```

---

<sub>Generated from synthesis outputs in `work_mmmc/OUTPUT/`. For questions or issues, refer to the original report files linked above.</sub>
