# DFT — Simple 8-bit Counter

Design-for-Test (DFT) implementation of the 8-bit counter using **Cadence Genus Synthesis Solution 23.13** with muxed-scan insertion targeting the **GPDK045** (`gsclib045`) standard-cell library.

---

## Directory Structure

```
dft/
├── genus_dft_script.tcl          # Genus DFT + synthesis script
├── outputs/
│   ├── counter_netlist_dft.v     # Scan-inserted gate-level netlist
│   ├── counter_sdc_dft.sdc       # Output SDC with DFT port constraints
│   ├── counter_scanDEF.scandef   # Scan-chain DEF for P&R
│   └── delays.sdf                # Back-annotated SDF (OVI 3.0, 1 ns timescale)
└── reports/
    └── report_dft_chains.rpt     # Scan chain summary report
```

---

## DFT Architecture

| Parameter        | Value                     |
|------------------|---------------------------|
| Scan style       | Muxed-scan (`muxed_scan`) |
| Number of chains | 1 (`top_chain`)           |
| Chain length     | 8 flip-flops              |
| Scan-in port     | `scan_in`                 |
| Scan-out port    | `scan_out`                |
| Shift enable     | `SE` (active-high)        |
| Clock domain     | `clk` (rising edge)       |

All 8 count registers (`count_reg[0]` → `count_reg[7]`) are stitched into a single scan chain in LSB-to-MSB order. The scan output is driven through a `BUFX20` buffer (`rm_assigns_buf_scan_out`) to eliminate the assign statement on `scan_out`.

### Scan Flip-Flop Cell

All registers map to **`SDFFRHQX1`** — a scan D flip-flop with active-low async reset (`RN`), scan input (`SI`), and scan enable (`SE`) from the `gsclib045` library.

---

## Synthesis & DFT Flow

The script `genus_dft_script.tcl` runs the full Genus flow in order:

1. **Library setup** — load timing lib (`slow_vdd1v0_basicCells.lib`) and LEF files from `$PDK_DIR/gsclib045`
2. **RTL read** — `counter.v` (Verilog 2001) + `constraints_top.sdc`
3. **Pre-synthesis DFT setup** — define scan style, SE port, and run `check_dft_rules`
4. **Synthesis** — `syn_generic` → `syn_map` → `syn_opt` (all medium effort)
5. **Scan insertion** — define chain (`top_chain`, SDI: `scan_in`, SDO: `scan_out`), `connect_scan_chains`, final `syn_opt`
6. **Outputs** — netlist, SDC, SDF, ScanDEF, ATPG library

---

## Timing (GPDK045, slow corner)

| Cell         | CK→Q rise (ns) | CK→Q fall (ns) | Setup D↑ (ns) | Hold SE↑ (ns) |
|--------------|---------------|----------------|---------------|---------------|
| `count_reg[0]` (SDFFRHQX1) | 0.403 | 0.392 | 0.235 | 0.000 |
| `count_reg[1–6]` (SDFFRHQX1) | 0.374 | 0.361 | 0.217 | 0.000 |
| `count_reg[7]` (SDFFRHQX1) | 0.390 | 0.378 | 0.217 | 0.000 |

Combinational carry chain uses **`ADDHX1`** half-adders (A→CO max: ~0.257 ns) and one **`CLKXOR2X1`** for the MSB XOR (A→Y: 0.333 ns).

Clock period constraint: **10 ns** | Input/output delay: **1 ns** | Clock uncertainty: **0.1 ns (setup & hold)**

---

## Key Output Files

### `counter_netlist_dft.v`
Gate-level netlist with scan ports added to the module interface:
```verilog
module counter(clk, rst, count, SE, scan_in, scan_out);
```
Scan chain stitching is via the `SI` port of each `SDFFRHQX1`, connected LSB → MSB with `scan_in` entering `count_reg[0]` and `count_reg[7].Q` feeding `scan_out` through `BUFX20`.

### `counter_scanDEF.scandef`
ScanDEF v5.5 file defining `top_chain_seg1_clk_rising` for use by Cadence Innovus during physical implementation. All 8 flip-flops are listed as FLOATING (placement not yet fixed).

### `delays.sdf`
OVI 3.0 SDF at **1 ns timescale**, 125 °C, 0.9 V. Contains IOPATH delays and setup/hold/recovery/removal timing checks for all cells. Input port delays are annotated as 0.000 ns (wire delays to be back-annotated post-P&R).

---

## How to Re-run

```bash
cd dft/
genus -f genus_dft_script.tcl
```

> Ensure `$PDK_DIR` resolves to the GPDK045 installation and `counter.v` is present in the HDL search path (`/home/server2/Music/ram/counter`).

---

## Notes

- `set_dont_touch` is applied to `rm_assigns_buf_scan_out` in the output SDC to prevent Innovus from optimising away the scan-out buffer.
- The `write_dft_atpg` output references `../lib/slow_vddd1v0_basiccells.v` — note the triple-`d` typo vs. the read_libs filename; verify the path before running ATPG in Cadence Modus/Xcelium.
- ATPG patterns are not included in this repo; generate them separately using the `.scandef` and ATPG library.
