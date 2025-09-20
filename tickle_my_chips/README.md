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
    [COMPLETE]           [COMING SOON]          [PLANNED]
```

---

## Three-Part Learning Series

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

### Part 1: Core Syntax & Operations
**File:** `basic1.tcl` | **Status:** [COMPLETE]

<details>
<summary><strong>▶ Click to view detailed breakdown</strong></summary>

This script covers the essential building blocks of Tcl programming, focusing on syntax fundamentals and basic operations.

#### Key Topics Covered:

```
OUTPUT & COMMENTS          VARIABLES & EXPRESSIONS       OPERATORS
┌─────────────────┐       ┌─────────────────────┐       ┌─────────────────┐
│ puts "Hello"    │       │ set a 5             │       │ + - * / **      │
│ # comment       │       │ expr $a + $b        │       │ | ^ ~ << >>     │
│ Variable: $var  │       │ Command: [expr]     │       │ condition?a:b   │
└─────────────────┘       └─────────────────────┘       └─────────────────┘
```

**Output & Comments**
- `puts` command for printing output
- Single-line comments using `#`
- Variable interpolation in strings

**Variables & Expressions**
- `set` command for variable assignment
- `expr` for mathematical evaluation
- `# Tickle My Chips: Basics

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
    [COMPLETE]           [COMING SOON]          [PLANNED]
```

---

## Three-Part Learning Series

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

### Part 1: Core Syntax & Operations
**File:** `basic1.tcl` | **Status:** [COMPLETE]

<details>
<summary><strong>▶ Click to view detailed breakdown</strong></summary>

This script covers the essential building blocks of Tcl programming, focusing on syntax fundamentals and basic operations.

 syntax for variable access
- Command substitution with `[]`

**Operators**
- **Arithmetic:** `+`, `-`, `*`, `/`, `**` (exponentiation)
- **Bitwise:** `|` (OR), `^` (XOR), `~` (NOT), `<<` (left shift), `>>` (right shift)
- **Ternary:** Conditional operator `condition ? true_value : false_value`

```
LIST OPERATIONS TOOLKIT
┌─────────────────────────────────────────────────────────────────────────┐
│  llength → Count    lindex → Access    lappend → Add to end             │
│  linsert → Insert   lreplace → Replace   lrange → Extract slice         │
│  lsearch → Find (exact/regex)                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

**List Operations**
- `llength` - Get list length
- `lindex` - Access elements by index
- `lappend` - Add elements to list
- `linsert` - Insert elements at specific position
- `lreplace` - Replace range of elements
- `lrange` - Extract sublist
- `lsearch` - Search with exact match and regex patterns

#### Learning Outcomes:
- Master basic I/O operations
- Understand variable manipulation
- Perform mathematical calculations
- Work with Tcl's powerful list data structure
- Use pattern matching for searches

#### Perfect For:
Beginners starting their Tcl journey, especially those interested in VLSI scripting applications.

</details>

---

### Part 2: Control Flow & Logic
**File:** `basic2.tcl` | **Status:** [COMING SOON]

<details>
<summary><strong>▶ Click to view planned content</strong></summary>

```
┌──────────────────────────────────────────────────────────────────────┐
│                              PART 2                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │ Conditionals │  │    Loops     │  │   Advanced   │              │
│  │   if/else    │  │  for/while   │  │   Control    │              │
│  │   switch     │  │   foreach    │  │  Structures  │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
└──────────────────────────────────────────────────────────────────────┘
```

This section will cover decision-making and repetitive operations in Tcl.

#### Planned Topics:

**Conditional Statements**
- `if`, `else`, `elseif` constructs
- Comparison operators
- Logical operators (`&&`, `||`, `!`)
- Nested conditions

**Loops & Iteration**
- `for` loops with counters
- `foreach` for list iteration
- `while` loops for conditions
- Loop control (`break`, `continue`)

**Advanced Control**
- `switch` statements
- Error handling basics
- Flow control best practices

#### Learning Outcomes:
- Implement decision-making logic
- Create efficient loops
- Handle different execution paths
- Build more complex program structures

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

This section will focus on code organization and reusability through custom functions.

#### Planned Topics:

**Procedure Basics**
- `proc` command for function definition
- Parameter passing and default values
- Return values and `return` statement
- Local vs global variable scope

**Code Organization**
- Modular programming concepts
- Function libraries
- Namespace basics
- Best practices for procedure design

**Advanced Functions**
- Variable argument lists
- Recursive procedures
- Callback functions
- Error handling in procedures

#### Learning Outcomes:
- Write reusable code modules
- Understand scope and variable lifetime
- Create maintainable script architecture
- Apply functional programming concepts

</details>

---

## Quick Start

```bash
# Navigate to the basics directory
cd tickle_mychips/basics

# Run the available script
tclsh basic1.tcl

# More scripts coming soon!
```

## Progress Tracker

```
┌─────────┬──────────────┬─────────────────┬─────────────────────────────┐
│  PART   │    SCRIPT    │     STATUS      │         KEY FOCUS           │
├─────────┼──────────────┼─────────────────┼─────────────────────────────┤
│    1    │  basic1.tcl  │   [COMPLETE]    │ Syntax, Variables, Lists    │
│    2    │  basic2.tcl  │ [COMING SOON]   │ Loops, Conditions          │
│    3    │  basic3.tcl  │   [PLANNED]     │ Functions, Procedures      │
└─────────┴──────────────┴─────────────────┴─────────────────────────────┘
```

---

```ascii
 TARGET: Master Tcl fundamentals for VLSI Physical Design applications
```

*Part of the Tickle My Chips learning series*
