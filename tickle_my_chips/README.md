# Tickle My Chips: Basics

```ascii
╔══════════════════════════════════════════════════════════════════╗
║  ████████╗ ██████╗██╗         ██████╗  █████╗ ███████╗██╗ ██████╗ ║
║  ╚══██╔══╝██╔════╝██║         ██╔══██╗██╔══██╗██╔════╝██║██╔════╝ ║
║     ██║   ██║     ██║         ██████╔╝███████║███████╗██║██║      ║
║     ██║   ██║     ██║         ██╔══██╗██╔══██║╚════██║██║██║      ║
║     ██║   ╚██████╗███████╗    ██████╔╝██║  ██║███████║██║╚██████╗ ║
║     ╚═╝    ╚═════╝╚══════╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝ ╚═════╝ ║
╚══════════════════════════════════════════════════════════════════╝
```

Welcome to the **Basics** section of the Tickle My Chips repository! This directory contains foundational Tcl scripts for VLSI and Physical Design applications.

## Learning Path

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ Part 1: Syntax  │───►│ Part 2: Control │───►│ Part 3: Functions│
│ & Operations    │    │ Flow & Logic    │    │ & Procedures    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
    [COMPLETE]           [COMPLETE]             [PLANNED]
```

---

## Three-Part Learning Series

### Part 1: Core Syntax & Operations
**File:** `basic1.tcl` | **Status:** [COMPLETE]

<details>
<summary><strong>▶ Click to view detailed breakdown</strong></summary>

```
┌──────────────────────────────────────────────────────────────────────┐
│                              PART 1                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │  Variables   │  │  Operators   │  │    Lists     │              │
│  │      &       │  │      &       │  │      &       │              │
│  │    I/O       │  │    Math      │  │   Searching  │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
└──────────────────────────────────────────────────────────────────────┘
```

**Key Topics:**
- **Output & Comments:** `puts`, `#` comments, variable interpolation
- **Variables & Expressions:** `set`, `expr`, `$` syntax, command substitution `[]`
- **Operators:** Arithmetic (`+`, `-`, `*`, `/`, `**`), Bitwise (`|`, `^`, `~`, `<<`, `>>`), Ternary
- **Basic Lists:** `llength`, `lindex`, `lappend`, `linsert`, `lreplace`, `lrange`, `lsearch`

**Perfect For:** Absolute beginners learning Tcl syntax and basic operations.

</details>

---

### Part 2: Control Flow & Logic  
**File:** `basic2.tcl` | **Status:** [COMPLETE]

<details>
<summary><strong>▶ Click to view detailed breakdown</strong></summary>

```
┌──────────────────────────────────────────────────────────────────────┐
│                              PART 2                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │ Conditionals │  │    Loops     │  │    Arrays    │              │
│  │   if/else    │  │  for/while   │  │ & Advanced   │              │
│  │   elseif     │  │   foreach    │  │    Lists     │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
└──────────────────────────────────────────────────────────────────────┘
```

**Key Topics:**
- **Advanced Lists:** `join`, `split`, `lsort`, `concat`, `lreverse`, `lassign`
- **Arrays:** Associative arrays (`array set`), indexed arrays, `array get/size`
- **Conditionals:** `if/elseif/else` constructs, comparison operators
- **Loops:** `while`, `for`, `foreach` with multiple variables, `break/continue`

**Perfect For:** Developers ready to build programs with proper control flow and data structures.

</details>

---

### Part 3: Functions & Procedures
**File:** `basic3.tcl` | **Status:** [PLANNED]

<details>
<summary><strong>▶ Click to view planned content</strong></summary>

```
┌──────────────────────────────────────────────────────────────────────┐
│                              PART 3                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │  Procedures  │  │     Code     │  │   Advanced   │              │
│  │      &       │  │ Organization │  │  Functions   │              │
│  │  Parameters  │  │ & Namespaces │  │ & Recursion  │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
└──────────────────────────────────────────────────────────────────────┘
```

**Planned Topics:**
- **Procedure Basics:** `proc` definition, parameters, return values, scope
- **Code Organization:** Modular programming, function libraries, namespaces
- **Advanced Functions:** Variable arguments, recursion, callbacks, error handling

**Perfect For:** Creating maintainable, reusable code with proper function architecture.

</details>

---

## Quick Start

```bash
# Navigate to the basics directory
cd tickle_mychips/basics

# Run the available scripts
tclsh basic1.tcl
tclsh basic2.tcl

# Part 3 script coming soon!
```

## Progress Tracker

```
┌─────────┬──────────────┬─────────────────┬─────────────────────────────┐
│  PART   │    SCRIPT    │     STATUS      │         KEY FOCUS           │
├─────────┼──────────────┼─────────────────┼─────────────────────────────┤
│    1    │  basic1.tcl  │   [COMPLETE]    │ Syntax, Variables, Lists    │
│    2    │  basic2.tcl  │   [COMPLETE]    │ Arrays, Loops, Conditions   │
│    3    │  basic3.tcl  │   [PLANNED]     │ Functions, Procedures       │
└─────────┴──────────────┴─────────────────┴─────────────────────────────┘
```

---

```ascii
 TARGET: Master Tcl fundamentals for VLSI Physical Design applications
```

*Part of the Tickle My Chips learning series*
