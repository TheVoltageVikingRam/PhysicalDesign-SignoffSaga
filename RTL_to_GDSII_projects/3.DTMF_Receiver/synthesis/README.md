# dtmf_recvr_core — Genus Synthesis

Physically Aware Synthesis (PLE) for the `dtmf_recvr_core` design targeting **TSMC 130nm** (8-layer metal), synthesized with **Cadence Genus™ 23.13-s073_1** under worst-case operating conditions (`ss_1v08_125c`).

---

## Directory Structure

```
genus_labs/
├── RTL/               Verilog source files (28 modules)
├── tcl/               Genus setup & constraint scripts
│   ├── setup.tcl          PLE-mode initialization (primary)
│   ├── setup.lp.tcl       Legacy-mode initialization (timestamped outputs)
│   ├── setup.opto.tcl     Optimization-mode initialization
│   ├── setup_dft.tcl      DFT-aware initialization + scan controllability
│   ├── constraints.tcl    Cadence-native timing constraints (legacy format)
│   └── list_ports.tcl     Utility — enumerate design ports
├── constraints/       SDC timing constraints
│   ├── constraints.sdc    IEEE 1801-compliant SDC (used during synthesis)
│   └── dtmf_recvr_core.sdc   Full per-clock-domain I/O delay constraints
├── libraries/         Vendor .lib (timing/power) and .lef (physical) files ¹
├── QRC/               Quantus parasitic extraction tech file (t018s6mm.tch) ¹
├── def/               DEF floorplan placeholder for PLE
├── sim/               Switching-activity TCF files (RTL + gate-level)
├── work/              Genus execution directory
│   ├── reports/           Generated QoR, timing, area, and power reports
│   ├── dtmf_recvr_core_syn.v      Gate-level netlist
│   ├── dtmf_recvr_core_syn.sdc    Mapped timing constraints
│   └── dtmf_recvr_core.db         Genus database snapshot
└── README.md          This file
```

> ¹ Proprietary foundry files excluded from the repository (NDA). See `libraries/README.md` and `QRC/README.md` for details.

---

## Technology & Libraries

| Category | File(s) | Description |
|---|---|---|
| Standard cells (SVT) | `ss_g_1v08_125c.lib` | Slow-slow corner, 1.08 V, 125 °C |
| Standard cells (HVT) | `ss_hvt_1v08_125c.lib` | High-Vt variant for leakage reduction |
| SRAM macro | `ram_256x16A_slow_syn.lib` | 256×16 single-port SRAM |
| ROM macro | `rom_512x16A_slow_syn.lib` | 512×16 ROM |
| PLL macro | `pllclk_slow.lib` | Clock PLL (1× output) |
| Tech LEF | `tsmc13fsg_8lm_tech.lef` | 8-layer metal stack definition |
| Std-cell LEF | `tsmc13g_m_macros.lef`, `tsmc13hvt_m_macros.lef` | SVT + HVT physical geometries |
| Macro LEF | `pllclk.lef`, `ram_256X16A.lef`, `rom_512x16A.lef` | Hard-macro footprints |
| I/O LEF | `tpz013g2_7lm.lef` | I/O pad library |
| QRC tech | `t018s6mm.tch` | Parasitic RC extraction rules for PLE |

---

## RTL Modules

28 Verilog source files compose the `dtmf_recvr_core` hierarchy:

| Module | Role |
|---|---|
| `dtmf_recvr_core.v` | Top-level core wrapper |
| `tdsp_core.v` | TDSP processor top |
| `tdsp_core_mach.v` | TDSP core state machine |
| `tdsp_core_glue.v` | Glue logic between TDSP sub-blocks |
| `execute_i.v` | Execution unit (ALU interface) |
| `decode_i.v` | Instruction decoder |
| `alu_32.v` | 32-bit ALU |
| `m16x16.v` | 16×16 multiplier block |
| `mult_32_dp.v` | 32-bit multiply datapath |
| `accum_stat.v` | Accumulator & status register |
| `data_bus_mach.v` | Data bus controller |
| `prog_bus_mach.v` | Program bus controller |
| `port_bus_mach.v` | Port bus controller |
| `decoder.v` | Address decoder |
| `data_sample_mux.v` | Data sample multiplexer |
| `tdsp_data_mux.v` | TDSP data multiplexer |
| `tdsp_ds_cs.v` | TDSP data/chip select |
| `arb.v` | Bus arbiter |
| `dma.v` | DMA controller |
| `spi.v` | SPI interface |
| `digit_reg.v` | Digit register |
| `results_conv.v` | Results converter |
| `conv_subreg.v` | Conversion sub-register |
| `ulaw_lin_conv.v` | µ-law ↔ linear PCM converter |
| `ram_128x16_test.v` | 128×16 RAM test wrapper |
| `ram_256x16_test.v` | 256×16 RAM test wrapper |
| `iopads.v` | I/O pad ring |
| `test_control.v` | Test/scan control & clock muxing |
| `power_manager.v` | Power management unit |

---

## Synthesis Flow

### 1. Environment Setup

```tcl
source ../tcl/setup.tcl
```

Performs the following:

- Sets library search paths for timing (`.lib`) and physical (`.lef`) files across `TIMING/STDCELL`, `TIMING/CUSTOM`, `TIMING/IO`, `LEF/STDCELL`, `LEF/CUSTOM`, `LEF/IO` sub-directories.
- Reads all five timing libraries and seven LEF files via `read_libs` / `read_physical -lef`.
- Configures QRC parasitic extraction: `set_db qrc_tech_file ../QRC/t018s6mm.tch`.
- Sets power unit to **mW**: `set_db lp_power_unit mW`.
- Enables HDL source tracking: `set_db hdl_track_filename_row_col true`.
- Suppresses benign library warnings: `LBR-30 LBR-31 LBR-40 LBR-41 LBR-72 LBR-77 LBR-162`.

---

### 2. RTL Elaboration

```tcl
read_hdl $RTL_LIST
elaborate $DESIGN
check_design -unresolved
```

> Ensure `accum_stat.v` is included in `RTL_LIST` before elaboration to avoid `[TUI-273]` black-box errors.

---

### 3. Timing Constraints

```tcl
read_sdc ../constraints/dtmf_recvr_core.sdc
check_timing_intent
```

#### Clock Definitions

| Clock | Period | Frequency | Source |
|---|---|---|---|
| `refclk` | 8.0 ns | 125 MHz | Port `refclk` |
| `m_clk` | 8.0 ns | 125 MHz | Pin `TEST_CONTROL_INST/m_clk` |
| `m_rcc_clk` | 16.0 ns | 62.5 MHz | Pin `TEST_CONTROL_INST/m_rcc_clk` |
| `m_spi_clk` | 16.0 ns | 62.5 MHz | Pin `TEST_CONTROL_INST/m_spi_clk` |
| `m_dsram_clk` | 16.0 ns | 62.5 MHz | Pin `TEST_CONTROL_INST/m_dsram_clk` |
| `m_ram_clk` | 16.0 ns | 62.5 MHz | Pin `TEST_CONTROL_INST/m_ram_clk` |
| `m_digit_clk` | 16.0 ns | 62.5 MHz | Pin `TEST_CONTROL_INST/m_digit_clk` |

#### I/O & Path Constraints

- **I/O delays**: 0.3 ns (`set_input_delay` / `set_output_delay`) applied to all ports against every clock domain.
- **False paths**: `reset`, `test_mode` — excluded from timing analysis.
- **Case analysis**: `scan_en = 0`, `test_mode = 0` — test logic disabled for functional synthesis.
- **Design rules**: `max_fanout = 15`, `max_transition = 1.2 ns`.
- **External driver**: `PDO04CDG/PAD` (I/O pad model) on all inputs except `reset` and `refclk`.

#### Expected Warnings — No Action Required

| Warning | Reason |
|---|---|
| Unconstrained: `Avdd`, `Avss`, `VDD_AO` | Analog power rails; no timing constraint needed |
| Sequential pins without clock waveform | Test clocks intentionally gated off |

---

### 4. Compilation

```tcl
syn_generic   ;# Technology-independent optimization
syn_map       ;# Map to TSMC 130nm standard cells
syn_opt       ;# Gate sizing, buffering, and logic restructuring
```

---

## Results

> Generated on **Jun 23, 2026** — Operating conditions: `ss_1v08_125c` — Interconnect mode: **global** — Area mode: **physical library**

### Timing (Per-Clock-Domain)

| Clock Domain | Period (ps) | WNS (ps) | TNS (ps) | Violating Paths |
|---|---|---|---|---|
| `m_clk` | 8,000 | **0.5** | 0.0 | 0 |
| `m_rcc_clk` | 16,000 | 3,888.3 | 0.0 | 0 |
| `m_spi_clk` | 16,000 | 7,092.0 | 0.0 | 0 |
| `m_dsram_clk` | 16,000 | 3,372.2 | 0.0 | 0 |
| `m_ram_clk` | 16,000 | 3,768.4 | 0.0 | 0 |
| `m_digit_clk` | 16,000 | 7,092.0 | 0.0 | 0 |
| `refclk` | 8,000 | 7,092.0 | 0.0 | 0 |
| **Total** | — | — | **0.0** | **0** |

✅ **All clock domains meet timing** — zero violating paths, zero TNS.

#### Critical Path (m_clk domain)

```
Startpoint : TDSP_CORE_INST_DATA_BUS_MACH_INST_data_out_reg[13]/CK  (rising, m_clk)
Endpoint   : TDSP_CORE_INST_EXECUTE_INST_p_reg[31]/D0                (rising, m_clk)
Path delay : 7,696 ps  (data)   |   Setup: 303 ps   |   Slack: 0 ps
```

| Segment | Key Cells | Notes |
|---|---|---|
| Launch → MUX tree | `AO22X4M` → `MXI2X4M` → `NAND2X6M` | Data-out register fan-out → operand select |
| Multiplier core | `XNOR2X8M` → `MXI2X8M` → `AND2X12M` → `ADDFHX4M` | `MPY_32_INST_M16X16` — 16×16 Wallace-tree multiplier |
| Carry chain | `OAI2BB1X4M` → `NAND2X4M` chains (×12) | Ripple through partial-product accumulator |
| Final subtract | `NOR3BX4M` → `NAND2X2M` → `NOR2X4M` → `XNOR2X2M` | `SUB_UNS_OP42` — 2's complement result |

Logic depth: **~52 cells** through the multiplier tree and subtract unit.

---

### Area

| Metric | Value |
|---|---|
| Cell area | 208,129.60 µm² |
| Estimated net area (PLE) | 26,033.58 µm² |
| **Total area** | **234,163.18 µm²** |

---

### Gate Count

| Type | Count |
|---|---|
| Sequential (flip-flops) | 514 |
| Combinational (logic gates) | 3,917 |
| Hierarchical instances | 1 |
| **Total leaf instances** | **4,431** |

#### Fanout Statistics

| Metric | Value |
|---|---|
| Max fanout | 361 (`m_clk`) |
| Average fanout | 2.7 |
| Terms-to-net ratio | 3.74 |
| Terms-to-instance ratio | 3.93 |

---

### Power

Power estimated using switching-activity data from `sim/top.hier.rtl.tcf` (RTL-level TCF).

| Category | Leakage (mW) | Internal (mW) | Switching (mW) | Total (mW) | % |
|---|---|---|---|---|---|
| Memory | 0.000 | 0.253 | 0.001 | 0.254 | 2.74 |
| Register | 0.016 | 1.033 | 0.112 | 1.161 | 12.51 |
| Logic | 0.030 | 0.873 | 0.968 | 1.871 | 20.15 |
| Black-box (macros) | 0.017 | 5.789 | 0.008 | 5.814 | 62.62 |
| Clock network | ~0 | 0.007 | 0.176 | 0.183 | 1.98 |
| **Total** | **0.063** | **7.956** | **1.265** | **9.284** | **100** |

**Power breakdown**: 85.7% internal (short-circuit + cell-internal), 13.6% switching (dynamic), 0.7% leakage.

---

### Runtime

| Metric | Value |
|---|---|
| CPU time | 45.85 s |
| Wall-clock time | 110 s |
| Peak memory (Genus) | 1,893 MB |

---

## DFT Integration

A dedicated DFT-aware setup script (`setup_dft.tcl`) is provided for scan insertion flows:

```tcl
source ../tcl/setup_dft.tcl
```

- Reads RTL and elaborates the design inline.
- Applies `dtmf_recvr_core.sdc` constraints.
- Marks PLL output as DFT-controllable: `set_db [get_db pins PLLCLK_INST/clk1x] .dft_controllable "PLLCLK_INST/refclk non_inverting"`.

---

## TCL Script Variants

| Script | Mode | Use Case |
|---|---|---|
| `setup.tcl` | **PLE (default)** | Physically-aware synthesis with QRC extraction |
| `setup.lp.tcl` | Legacy + timestamped dirs | Creates `outputs_<date>` and `reports_<date>` directories |
| `setup.opto.tcl` | Legacy optimization | Optimization-focused initialization |
| `setup_dft.tcl` | DFT | Full elaboration + scan-controllability setup |

---

## Output Files

| File | Path | Description |
|---|---|---|
| `dtmf_recvr_core_syn.v` | `work/` | Gate-level netlist (~800 KB, 4,431 instances) |
| `dtmf_recvr_core_syn.sdc` | `work/` | Constraints mapped to synthesized gates |
| `dtmf_recvr_core.db` | `work/` | Genus database snapshot for incremental runs |
| `dtmf_recvr_core_timing.rpt` | `work/reports/` | Detailed critical-path timing report |
| `dtmf_recvr_core_area.rpt` | `work/reports/` | Hierarchical area breakdown |
| `dtmf_recvr_core_power.rpt` | `work/reports/` | Category-wise power breakdown |
| `dtmf_recvr_core_qor.rpt` | `work/reports/` | Quality-of-Results summary (all clock domains) |

---

## Quick Start

```bash
cd genus_labs/work
genus -legacy_ui          # Launch Genus in legacy UI mode
```

```tcl
# Inside Genus shell:
source ../tcl/setup.tcl
read_hdl $RTL_LIST
elaborate $DESIGN
check_design -unresolved
read_sdc ../constraints/dtmf_recvr_core.sdc
check_timing_intent
syn_generic
syn_map
syn_opt

# Reports
report_timing > reports/dtmf_recvr_core_timing.rpt
report_area   > reports/dtmf_recvr_core_area.rpt
report_power  > reports/dtmf_recvr_core_power.rpt
report_qor    > reports/dtmf_recvr_core_qor.rpt

# Export
write_hdl > dtmf_recvr_core_syn.v
write_sdc > dtmf_recvr_core_syn.sdc
write_db  dtmf_recvr_core -to_file dtmf_recvr_core.db
```

---

## Notes

- The SDC uses `.` as the decimal separator (e.g., `0.3`, not `0,3`).
- The `constraints.tcl` file contains the legacy Cadence-native constraint format (using `define_clock` / `external_delay`); the IEEE SDC format in `dtmf_recvr_core.sdc` is the primary constraint source used during synthesis.
- All macro power is reported under the **black-box** category (~62.6% of total) since the macros (RAM, ROM, PLL) are treated as opaque instances by Genus.
