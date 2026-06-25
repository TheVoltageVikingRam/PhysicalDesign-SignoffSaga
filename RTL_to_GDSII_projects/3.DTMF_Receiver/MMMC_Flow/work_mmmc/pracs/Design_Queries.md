# Design Visibility & Database Querying in Cadence Genus

> A comprehensive reference for interacting directly with the Cadence Genus synthesis database using TCL and `get_db` commands — covering tool environment navigation, standard cell library profiling, hierarchical connectivity analysis, and gate-level technology mapping.

---

## Table of Contents

**Environment Navigation**
1. [Navigating the Virtual File System (VFS)](#1-navigating-the-virtual-file-system-vfs)

**Port & Interface Analysis**

2. [Extracting Top-Level Design Ports](#2-extracting-top-level-design-ports)
3. [TCL Interpreter vs. Native Database Engine](#3-tcl-interpreter-vs-native-database-engine)
4. [Bidirectional Port Analysis](#4-bidirectional-port-analysis)

**Standard Cell Library Profiling**

5. [Profiling the Physical Timing Library](#5-profiling-the-physical-timing-library)
6. [Profiling the Logical Base Cells](#6-profiling-the-logical-base-cells)

**Instance & Logic Analysis**

7. [Instance Filtering by Base Cell](#7-instance-filtering-by-base-cell)
8. [Combinational Logic Identification](#8-combinational-logic-identification)
9. [Database Exploration via Prefix Matching](#9-database-exploration-via-prefix-matching)

**Hierarchical & Pin-Level Analysis**

10. [Hierarchical Fan-in Analysis](#10-hierarchical-fan-in-analysis)
11. [Pin-Level Verification of Sequential Cells](#11-pin-level-verification-of-sequential-cells)

**Database Object Model**

12. [Object Pointers vs. String Names](#12-object-pointers-vs-string-names)
13. [Technology and Library Mapping](#13-technology-and-library-mapping)

---

## 1. Navigating the Virtual File System (VFS)

**Command**

```tcl
vls
```

**Output**

```text
./              designs/        hdl_libraries/  messages/       tech/
commands/       flows/          libraries/      obj_types/
```

**Purpose**
Browses the Genus internal Virtual File System — a Linux-style directory structure representing all loaded design data, technology files, and tool configurations.

> [!NOTE]
> Cadence Genus structures its internal database as a virtual filesystem. Using `vls` and `vcd` to navigate it allows deep inspection of loaded technology files, design hierarchies, and tool state without needing complex query syntax. This is the foundation of advanced tool debugging.

---

## 2. Extracting Top-Level Design Ports

**Command**

```tcl
get_ports
```

**Output Snippet**

```text
reset int port_pad_data_in[15] port_pad_data_in[14] ... scan_clk test_mode ... Avdd Avss
```

**Purpose**
Dumps the complete top-level I/O boundary of the design, returning both internal object pointers and port name strings.

> [!TIP]
> Use this to rapidly verify that SDC constraints (e.g., `set_input_delay`, `set_output_delay`) are targeting the correct, fully-elaborated port names after synthesis elaboration.

---

## 3. TCL Interpreter vs. Native Database Engine

**Commands**

```tcl
list_ports                  # Custom TCL proc — runs correctly
get_db list_ports           # [TUI-182] Error — wrong scope
get_db ports                # Native DB object — runs correctly
```

**Output**

```text
@genus:design:dtmf_recvr_core.ports 140> list_ports
reset
int
port_pad_data_in[15]
...

@genus:design:dtmf_recvr_core.ports 141> get_db list_ports
Error   : <Start> word is not recognized. [TUI-182] [get_db]
        : 'list_ports' is not a recognized object/attribute.

@genus:design:dtmf_recvr_core.ports 143> get_db ports
port:dtmf_recvr_core/reset port:dtmf_recvr_core/int ...
```

**Purpose**
Demonstrates the architectural boundary between the TCL interpreter layer and the internal Genus CUI (Common User Interface) database engine.

> [!IMPORTANT]
> `list_ports` is a user-sourced TCL procedure (`proc`). It runs correctly when invoked directly because the TCL interpreter executes it. However, passing it to `get_db` triggers `[TUI-182]` because `get_db` talks directly to the internal CUI database schema, which has no awareness of custom user scripts. To query the database natively, the schema object `ports` must be used — which returns physical object pointers rather than raw strings. Understanding this scope boundary is critical for writing robust batch synthesis scripts that won't break on custom proc names.

---

## 4. Bidirectional Port Analysis

**Command**

```tcl
get_db ports -if {.direction == inout}
```

**Output**

```text
port:dtmf_recvr_core/Avdd
port:dtmf_recvr_core/Avss
port:dtmf_recvr_core/VSS
port:dtmf_recvr_core/VDD_TDSPCore_R
port:dtmf_recvr_core/VDD_AO
```

**Purpose**
Filters the port list to isolate all bidirectional (`inout`) and analog/power supply ports at the top-level design boundary.

> [!IMPORTANT]
> Bidirectional ports require **both** `set_input_delay` and `set_output_delay` in SDC constraints. Identifying them early prevents critical setup/hold modeling errors that would otherwise only surface during STA sign-off.

---

## 5. Profiling the Physical Timing Library

**Command**

```tcl
get_db lib_cells
```

**Output Snippet**

```text
lib_cell:wcl_slow/slow/ADDFHX2
lib_cell:wcl_slow/slow/ADDFHX4
...
lib_cell:wcl_slow/slow/DFFHQX1
... <result is 49157 characters long, truncated>
```

**Purpose**
Queries every physical standard cell available in the loaded `.lib` timing library, including the full suite of drive strengths and cell variants.

> [!TIP]
> Verifying `lib_cells` confirms the synthesis engine has access to the correct process corner data (e.g., `wcl_slow/slow/`) and all drive strength variants needed to resolve setup/hold violations via `size_cell`.

---

## 6. Profiling the Logical Base Cells

**Command**

```tcl
get_db base_cells
```

**Output Snippet**

```text
base_cell:CDK_R512x16
base_cell:CDK_S128x16
...
base_cell:DFFHQX1
...
base_cell:NAND2BX1
... <result is 8908 characters long, truncated>
```

**Purpose**
Queries the abstract logical cell functions the tool is permitted to use, before physical drive-strength mapping is applied.

> [!NOTE]
> Distinguishing `lib_cells` (physical, corner-specific) from `base_cells` (logical, abstract) is a critical database concept. This query also confirms that custom macros — such as the `CDK_R512x16` RAM — were successfully integrated into the synthesis database alongside standard logic cells.

---

## 7. Instance Filtering by Base Cell

**Command**

```tcl
get_db insts -if {.base_cell.name == "DFFSQX2M"}
```

**Purpose**
Identifies all placed instances of a specific standard cell type across the entire design.

> [!TIP]
> Use this to audit overuse of high-power or high-leakage cell variants. Also essential when a library cell has a known silicon defect and every instance must be isolated and replaced before tapeout.

---

## 8. Combinational Logic Identification

**Command**

```tcl
get_db insts -if {.is_comb == true}
```

**Output Snippet**

```text
inst:dtmf_recvr_core/PM_INST/g470
inst:dtmf_recvr_core/PM_INST/g506__2398
inst:dtmf_recvr_core/SPI_INST/g507__5115
... <result is 173448 characters long, truncated>
```

**Purpose**
Extracts all purely combinational logic instances (AND, OR, XOR, MUX, etc.) from the synthesized netlist.

> [!TIP]
> The volume and distribution of combinational instances relative to sequential cells helps predict routing congestion and identify heavy logic clouds likely to cause setup timing failures before handoff to Place & Route (PnR).

---

## 9. Database Exploration via Prefix Matching

**Commands**

```tcl
get_db inst:dtmf_recvr_core/D
get_db inst:dtmf_recvr_core/DIGI
```

**Output Snippet**

```text
DIGIT_REG_INST_digit_out_reg[0]/
DIGIT_REG_INST_digit_out_reg[1]/
...
DMA_INST_a_reg[0]/
DMA_INST_a_reg[1]/
...
```

**Purpose**
Leverages `get_db` native prefix matching to interactively explore the design hierarchy without knowing exact instance names.

> [!TIP]
> Rather than dumping the entire design netlist or piping through `grep`, supplying a partial instance path navigates a massive SoC hierarchy from the command line in real time — an efficient way to locate specific blocks like DMA or DIGIT register banks during debug.

---

## 10. Hierarchical Fan-in Analysis

**Command**

```tcl
get_db hpins -if {.direction == in}
```

**Output Snippet**

```text
hpin:dtmf_recvr_core/PM_INST/clk
hpin:dtmf_recvr_core/PM_INST/reset
hpin:dtmf_recvr_core/PM_INST/RC_CG_HIER_INST12/enable
hpin:dtmf_recvr_core/PM_INST/RC_CG_HIER_INST12/ck_in
... <result is 22021 characters long, truncated>
```

**Purpose**
Queries all input pins across the *entire design hierarchy*, including deep sub-modules and synthesized clock-gating cells.

> [!NOTE]
> Using `hpins` (Hierarchical Pins) instead of flat `pins` traverses the full chip topology. The presence of `RC_CG_HIER_INST12` entries confirms that clock-gating cells were successfully synthesized and correctly wired deep within the module hierarchy. The strict dot-operator syntax (`.direction`) within the `-if` filter is a requirement of the Genus CUI schema — spacing errors here cause `[TUI-180]`-class failures in batch scripts.

---

## 11. Pin-Level Verification of Sequential Cells

**Command**

```tcl
get_db inst:dtmf_recvr_core/DIGIT_REG_INST_digit_out_reg[4] .pins
```

**Output**

```text
{pin:dtmf_recvr_core/DIGIT_REG_INST_digit_out_reg[4]/SN}
{pin:dtmf_recvr_core/DIGIT_REG_INST_digit_out_reg[4]/CK}
{pin:dtmf_recvr_core/DIGIT_REG_INST_digit_out_reg[4]/D}
{pin:dtmf_recvr_core/DIGIT_REG_INST_digit_out_reg[4]/Q}
```

**Purpose**
Inspects the individual logical pins of a specific mapped instance.

> [!TIP]
> This bridges the gap between logical RTL and physical gates. When STA flags a setup violation on a register, querying its exact pins reveals the precise timing arc to trace — `CK`→`Q` for propagation, `D`→`CK` for setup — without leaving the Genus shell.

---

## 12. Object Pointers vs. String Names

**Commands Compared**

```tcl
# Returns a human-readable string
get_db inst:dtmf_recvr_core/DIGIT_REG_INST_flag_out_reg .base_cell.name

# Returns the internal database object pointer
get_db inst:dtmf_recvr_core/DIGIT_REG_INST_flag_out_reg .base_cell
get_db inst:dtmf_recvr_core/DIGIT_REG_INST_flag_out_reg .lib_cell
```

**Output**

```text
DFFSHQX1                      ← string (from .base_cell.name)
base_cell:DFFSHQX1            ← object pointer (from .base_cell)
lib_cell:wcl_slow/slow/DFFSHQX1  ← object pointer (from .lib_cell)
```

**Purpose**
Demonstrates the distinction between retrieving a human-readable attribute string (`.base_cell.name`) versus the raw database object pointer (`.base_cell`).

> [!IMPORTANT]
> This distinction is essential for TCL automation. The Genus engine requires **object pointers** — not strings — as inputs to transformation commands like `size_cell` or for chaining further attribute queries. Knowing when to stop at `.name` versus when to keep the pointer object is what separates ad-hoc debugging from production-grade scripting.

---

## 13. Technology and Library Mapping

**Commands**

```tcl
get_db inst:DIGIT_REG_INST_flag_out_reg .base_cell.name
get_db inst:DIGIT_REG_INST_flag_out_reg .lib_cell.name
```

**Output**

```text
DFFSHQX1
wcl_slow/slow/DFFSHQX1
```

**Purpose**
Verifies exactly which physical standard cell from the foundry's technology library was mapped to a logical RTL register.

> [!IMPORTANT]
> This is the ultimate proof of synthesis intent. It confirms not just the cell function (`DFFSHQX1` D-flip-flop), but that it was correctly assigned to the Slow Process Corner library (`wcl_slow/slow/`). If a timing path is too slow, this data enables targeted manual upsizing via `size_cell` without re-running full synthesis.

---

## Quick Reference

| # | Topic | Command / Object | Key Attribute or Filter |
|---|---|---|---|
| 1 | VFS navigation | `vls` | — |
| 2 | All top-level ports | `get_ports` | — |
| 3 | TCL vs. DB engine boundary | `list_ports` / `get_db ports` | `[TUI-182]` error scope |
| 4 | Bidirectional / power ports | `get_db ports` | `.direction == inout` |
| 5 | Physical timing library | `get_db lib_cells` | — |
| 6 | Logical base cells | `get_db base_cells` | — |
| 7 | Instances of one cell type | `get_db insts` | `.base_cell.name == "..."` |
| 8 | All combinational logic | `get_db insts` | `.is_comb == true` |
| 9 | Hierarchy prefix search | `get_db inst:<partial_path>` | — |
| 10 | All hierarchical input pins | `get_db hpins` | `.direction == in` |
| 11 | Pins of a specific instance | `get_db inst:<path>` | `.pins` |
| 12 | Object pointer vs. string | `get_db inst:<path>` | `.base_cell` vs `.base_cell.name` |
| 13 | Library corner verification | `get_db inst:<path>` | `.lib_cell.name` |