# dtmf_recvr_core — Genus Synthesis

Physically Aware Synthesis (PLE) for the `dtmf_recvr_core` design targeting **TSMC 130nm**.

---

## Directory Structure

```
rtl/              Verilog source files
tcl/              Genus setup scripts (setup.tcl, setup.lp.tcl, setup.opto.tcl)
constraints/      Timing rules (constraints.sdc)
libraries/        Vendor .lib (timing/power) and .lef (physical layout) files
work/             Genus execution directory — logs and reports generated here
```

---

## Synthesis Flow

### 1. Environment Setup

```tcl
source ../tcl/setup.tcl
```

Loads logical libraries (`.lib`), physical libraries (`.lef`) for PLE, and maps parasitic
extraction via `qrc_tech_file` (`t018s6mm.tch`).

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
read_sdc ../constraints/constraints.sdc
check_timing_intent
```

- Core clock `m_clk`: 125 MHz (8.0 ns period).
- Test logic disabled for functional analysis: `set_case_analysis 0 [get_ports test_mode]`.
- SDC uses `.` as the decimal separator (e.g., `0.3`, not `0,3`).

Expected warnings — no action required:

| Warning | Reason |
|---|---|
| Unconstrained: `Avdd`, `Avss`, `VDD_AO` | Analog power rails; no timing constraint needed |
| Sequential pins without clock waveform | Test clocks intentionally gated off |

---

### 4. Compilation

```tcl
syn_generic   ;# Elaborate to technology-independent logic
syn_map       ;# Map to TSMC 130nm standard cells
syn_opt       ;# Gate sizing and buffer insertion
```

---

## Results

### Timing

| Metric | Value |
|---|---|
| Target clock period | 8.0 ns (125 MHz) |
| Worst Negative Slack (WNS) | **MET** |
| Total Negative Slack (TNS) | 0.0 ps |
| Critical path delay | 7.696 ns |

**Critical Path**

```
Startpoint : TDSP_CORE_INST_DATA_BUS_MACH_INST_data_out_reg[13]/CK
Endpoint   : TDSP_CORE_INST_EXECUTE_INST_p_reg[31]/D0
Logic depth: ~34 cells (OAI / AOI / NAND through MPY_32_INST_M16X16 multiplier tree)
```

---

### Area

| Metric | Value |
|---|---|
| Total area | 234,163.17 µm² |
| Cell area | 208,129.59 µm² |
| Estimated net area (PLE) | 26,033.58 µm² |

---

### Gate Count

| Type | Count |
|---|---|
| Sequential (flip-flops) | 514 |
| Combinational (logic) | 3,917 |
| **Total instances** | **4,431** |

---

## Output Files

| File | Description |
|---|---|
| `dtmf_recvr_core_syn.v` | Gate-level netlist |
| `dtmf_recvr_core_syn.sdc` | Constraints mapped to synthesized gates |
| `dtmf_recvr_core.db` | Genus database snapshot |
