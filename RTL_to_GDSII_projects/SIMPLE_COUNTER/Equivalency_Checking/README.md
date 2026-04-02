# Equivalency Checking — Simple 8-bit Counter

![Equivalency Checking](screenshots/Equivalency_checking.png)

Formal Logic Equivalence Checking (LEC) using **Cadence Conformal LEC** to verify that the post-DFT gate-level netlist (`counter_netlist_dft.v`) is functionally equivalent to the original RTL (`counter.v`).

---

## Directory Structure

```
Equivalency_Checking/
├── counter_after_dft.do          # Conformal LEC dofile
├── counter_lec.log               # Execution transcript and results
├── ../counter.v                  # Golden: RTL reference
└── ../dft/outputs/
    └── counter_netlist_dft.v     # Revised: scan-inserted gate-level netlist
```

---

## Tool & Design Info

| Parameter       | Value                                        |
|-----------------|----------------------------------------------|
| Tool            | Cadence Conformal LEC                        |
| Library         | `slow_vdd1v0_basicCells.lib` (`-liberty`)    |
| Golden          | `counter.v` (RTL)                            |
| Revised         | `counter_netlist_dft.v` (gate-level + scan)  |
| SE constraint   | Tied to `0` on Revised (functional mode)     |
| Ignored inputs  | `scan_in` (Revised only)                     |
| Ignored outputs | `scan_out` (Revised only)                    |

---

## LEC Flow (`counter_after_dft.do`)

```tcl
set log file counter_lec.log -replace

read library <PDK_DIR>/gsclib045/timing/slow_vdd1v0_basicCells.lib -liberty -both

read design ../counter.v -verilog -golden
read design <NETLIST_PATH>/counter_netlist_dft.v -verilog -revised

add pin constraints 0 SE -revised
add ignored inputs scan_in -revised
add ignored outputs scan_out -revised

set system mode lec
add compared points -all   ;# fix: was "add compard point" in original
compare
```

> **Note:** The original dofile has a typo — `add compard point -all`. Correct it to `add compared points -all` before re-running.

---

## Verification Results

| Key Points  | Compared | Equivalent | Non-Equivalent |
|-------------|----------|------------|----------------|
| PO (outputs)| 8        | 8          | 0              |
| DFF         | 8        | 8          | 0              |
| **Total**   | **16**   | **16**     | **0**          |

**Result: PASS — Equivalent**

---

## How to Re-run

```bash
cd Equivalency_Checking/
lec -XL -nogui -color -64 -dofile counter_after_dft.do
```

Check `counter_lec.log` for `Compare Results: PASS` at the end.

---

## Notes

- Always use `-liberty` when reading `.lib` files — using `-verilog` on a `.lib` will cause parse errors.
- `scan_in` appears as an extra PI in the Revised design; `add ignored inputs` handles this cleanly.
- OS support warnings on university/corporate servers are benign and don't affect the proof.
- To debug non-equivalent points interactively, drop `-nogui` from the command.
