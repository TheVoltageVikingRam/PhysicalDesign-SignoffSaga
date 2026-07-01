# Cadence Genus iSpatial Synthesis — DTMF Receiver Core

## Overview

This repository contains synthesis reports and results from a **Cadence Genus iSpatial (physically-aware) synthesis** flow executed on a **DTMF Receiver Core** (`dtmf_recvr_core`) design. The flow demonstrates proficiency with Genus iSpatial's MMMC (Multi-Mode Multi-Corner) synthesis methodology, including physical-aware optimization with Innovus integration.

**Tool:** Cadence Genus Synthesis Solution v23.13-s073_1  
**Technology Node:** 45nm (GSCLIB045)  
**Design:** DTMF Receiver Core — a mixed-signal DSP subsystem featuring:
- TDSP core with 32-bit ALU & multiplier
- Multi-clock domain architecture (8 clock domains)
- Embedded SRAM macros (CDK_S256x16 × 2, CDK_R512x16 × 1)
- PLL integration
- SPI interface, DMA controller, power management unit

---

## Key Results — iSpatial Synthesis

### Timing Closure ✅

| Stage | Critical Path Slack (ps) | TNS (ps) | Violating Paths |
|-------|------------------------:|----------:|:---------------:|
| Generic (`syn_generic -physical`) | +2,705 | 0 | 0 |
| Map (`syn_map -physical`) | +473 | 0 | 0 |
| Innovus Physical Estimation | +46 | 0 | 0 |
| **Final (`syn_opt -spatial`)** | **+45** | **0** | **0** |

> All timing constraints met across all 8 clock domains (clk2x, m_clk, m_digit_clk, m_dsram_clk, m_ram_clk, m_rcc_clk, m_spi_clk, refclk).

### Area

| Metric | Value |
|--------|------:|
| Cell Area | 241,400 µm² |
| Total Area (Cell + Net) | 250,351 µm² |
| Leaf Instances | 4,489 |
| Sequential Instances | 520 |
| Combinational Instances | 3,969 |
| Floorplan Utilization | 6.53% |

### Power

| Category | Power (mW) | Percentage |
|----------|----------:|:----------:|
| Register | 0.576 | 29.0% |
| Logic | 1.291 | 65.0% |
| Clock (gating) | 0.064 | 3.2% |
| Black-box (macros) | 0.054 | 2.7% |
| **Total** | **1.985** | **100%** |

> Leakage power negligible at 0.03% of total.

### Physical Metrics (Post-iSpatial)

| Metric | Value |
|--------|------:|
| Total Net Length | 111,887 µm |
| Average Net Length | 22.98 µm |
| Route Overflow H/V | 0.06% / 0.01% |

---

## iSpatial vs. Standard MMMC Flow — Comparison

One key benefit of iSpatial is its ability to close timing on complex multi-clock designs. The comparison below shows the improvement:

| Metric | Standard MMMC Flow | iSpatial Flow |
|--------|-------------------:|--------------:|
| Worst Slack | **-576 ps (VIOLATED)** | **+45 ps (MET)** |
| Violating Paths | Multiple | 0 |
| Cell Count | 4,966 | 4,489 |
| Interconnect Mode | Global (wireload) | Placement-aware |

> The standard MMMC flow had critical violations (-576ps) on the `m_dsram_clk` domain involving RAM address paths. The iSpatial flow, leveraging Innovus physical estimation during synthesis, resolved these violations entirely.

---

## Synthesis Methodology

### Flow Stages

```
┌─────────────────────────────────────────────────────┐
│  1. Setup & MMMC Configuration                      │
│     • Library sets: PVT_1P08V_125C (slow corner)    │
│     • RC corner: 125°C, QRC tech file               │
│     • Analysis view: func-slow_maxrc (setup/hold)   │
│     • iSpatial: set_db opt_spatial_effort extreme    │
├─────────────────────────────────────────────────────┤
│  2. Design Load & Floorplan                         │
│     • RTL elaboration (26 Verilog modules)          │
│     • DEF floorplan import (fuzzy match)            │
│     • Cost group definition (I2C, C2O, I2O)         │
├─────────────────────────────────────────────────────┤
│  3. syn_generic -physical                           │
│     • Technology-independent optimization            │
│     • Physical-aware during generic synthesis        │
│     • Effort: medium                                │
├─────────────────────────────────────────────────────┤
│  4. syn_map -physical                               │
│     • Technology mapping with physical awareness     │
│     • Effort: high                                  │
│     • LEC dofile generation (RTL → mapped)          │
├─────────────────────────────────────────────────────┤
│  5. syn_opt -spatial (iSpatial)                     │
│     • Innovus-in-the-loop physical estimation        │
│     • Placement-based delay calculation              │
│     • Congestion-aware optimization                  │
│     • LEC dofile generation (mapped → final)        │
├─────────────────────────────────────────────────────┤
│  6. Reports & Handoff                               │
│     • QoR, timing, area, power, gates reports       │
│     • DB handoff to Innovus (write_db -common INVS) │
└─────────────────────────────────────────────────────┘
```

### Multi-Clock Architecture

The design features 8 clock domains with the following periods:

| Clock | Period (ns) | Description |
|-------|----------:|-------------|
| `clk2x` | 8.0 | Main 2× clock |
| `m_clk` | 8.0 | Core machine clock |
| `refclk` | 8.0 | Reference clock |
| `m_digit_clk` | 16.0 | Digit processing clock |
| `m_dsram_clk` | 16.0 | Data SRAM clock |
| `m_ram_clk` | 16.0 | RAM clock |
| `m_rcc_clk` | 16.0 | RCC clock |
| `m_spi_clk` | 16.0 | SPI interface clock |

---

## Repository Structure

```
genus_iSpatial_portfolio/
├── README.md
├── reports/
│   ├── iSpatial/                          # Core iSpatial synthesis reports
│   │   ├── final_qos_summary.rpt          # QoS across all 4 stages (⭐ key file)
│   │   ├── final_qor.rpt                  # Final QoR (timing, area, utilization)
│   │   ├── final_area.rpt                 # Hierarchical area breakdown
│   │   ├── final_gates.rpt                # Cell utilization after iSpatial
│   │   ├── final_timing.rpt               # Detailed timing paths (all MET)
│   │   ├── generic_qor.rpt                # QoR after syn_generic -physical
│   │   ├── map_qor.rpt                    # QoR after syn_map -physical
│   │   ├── map_area.rpt                   # Area after mapping
│   │   ├── map_gates.rpt                  # Gates after mapping
│   │   ├── invs_qor.rpt                   # QoR from Innovus physical estimation
│   │   ├── ple.rpt                        # Physical Layout Estimation
│   │   ├── power.rpt                      # Power breakdown (leakage/internal/switching)
│   │   ├── gates.rpt                      # Post-iSpatial gate report
│   │   ├── messages.rpt                   # Synthesis messages summary
│   │   └── cost_group_timing/             # Per-cost-group timing reports
│   │       ├── I2C_post_map.rpt
│   │       ├── C2O_post_map.rpt
│   │       ├── clk2x_post_map.rpt
│   │       └── ... (all clock domains)
│   └── comparison/                        # Standard MMMC flow for comparison
│       ├── mmmc_area_detailed.rpt
│       ├── mmmc_power_detailed.rpt
│       └── mmmc_timing_worst.rpt          # Shows violations fixed by iSpatial
├── screenshots/
│   ├── gui_schematic.gif                  # Genus GUI schematic view
│   └── gui_schematic.png                  # Genus GUI schematic view
└── OUTPUT_reports/                        # MMMC (non-iSpatial) flow reports
    ├── mmmc_final_qos_summary.rpt
    ├── syn_generic_qor.rpt
    ├── syn_map_qor.rpt
    ├── syn_opt_qor.rpt
    ├── syn_map_area.rpt
    ├── syn_opt_area.rpt
    ├── syn_map_gates.rpt
    └── syn_opt_gates.rpt
```

---

## Runtime Performance

| Stage | CPU Time | Memory (MB) |
|-------|---------|------------:|
| Generic | 00:34:59 | 2,304 |
| Map | 00:33:56 | 2,307 |
| Innovus Estimation | 00:33:21 | 4,737 |
| Final | 00:30:48 | 3,785 |
| **Total** | **00:42:56** | **4,737 (peak)** |

---

## Notes

- All synthesis was performed on Cadence Genus v23.13-s073_1 with Innovus integration for iSpatial physical estimation.
- The design uses a 45nm educational PDK (GSCLIB045). RTL source code and technology libraries are not included due to IP restrictions.
- Reports contain only synthesis metrics (timing, area, power, cell counts) — no proprietary content.

---

*Generated from Cadence Genus iSpatial synthesis flow*
