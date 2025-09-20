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
**File:** `basic2.tcl` | **Status:** [COMPLETE]

<details>
<summary><strong>▶ Click to view detailed breakdown</strong></summary>

```
┌──────────────────────────────────────────────────────────────────────┐
│                              PART 2                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐              │
│  │ Conditionals │  │    Loops     │  │    Arrays    │              │
│  │   if/else    │  │  for/while   │  │ & Advanced   │              │
│  │   switch     │  │   foreach    │  │    Lists     │              │
│  └──────────────┘  └──────────────┘  └──────────────┘              │
└──────────────────────────────────────────────────────────────────────┘
```

This section covers decision-making, repetitive operations, and advanced data structures in Tcl.

#### Key Topics Covered:

```
ADVANCED LIST OPERATIONS
┌─────────────────────────────────────────────────────────────────────────┐
│  join → Combine    split → Break apart    lsort → Sort elements         │
│  concat → Merge    lreverse → Flip order   lassign → Destructure        │
└─────────────────────────────────────────────────────────────────────────┘
```

**Advanced List Operations**
- `join` - Convert list to string with delimiter
- `split` - Convert string to list using delimiter
- `lsort` - Sort lists (ascending/descending)
- `concat` - Merge multiple lists
- `lreverse` - Reverse list order
- `lassign` - Destructure lists into variables

```
ARRAY TYPES & USAGE
┌─────────────────────────────────────────────────────────────────────────┐
│  Associative Arrays: array set colors {red FF0000 blue 0000FF}         │
│  Indexed Arrays: set myarray(0) "value0"                               │
│  Access: array get, array size                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**Arrays (Hash Maps)**
- **Associative Arrays:** Key-value pairs using `array set`
- **Indexed Arrays:** Traditional array indexing with `arrayname(index)`
- **Array Operations:** `array get`, `array size` for inspection
- **Note:** Arrays don't preserve insertion order (hash-based storage)

```
CONTROL FLOW STRUCTURES
┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│   Conditionals   │  │      Loops       │  │  Loop Control    │
│                  │  │                  │  │                  │
│ if {condition}   │  │ while {cond}     │  │ break - exit     │
│ elseif {cond}    │  │ for {init;cond}  │  │ continue - skip  │
│ else             │  │ foreach var list │  │                  │
└──────────────────┘  └──────────────────┘  └──────────────────┘
```

**Conditional Statements**
- `if`, `else`, `elseif` constructs with proper syntax
- Comparison operators (`>`, `<`, `==`, `!=`)
- Logical operators (`&&`, `||`)
- Nested ternary operations for complex conditions

**Loops & Iteration**
- `while` loops for condition-based repetition
- `for` loops with initialization, condition, and increment
- `foreach` for list/array iteration with multiple variables
- Index-based iteration using `llength` and `lindex`

**Loop Control**
- `break` - Exit loop immediately
- `continue` - Skip current iteration
- `incr` - Increment variables efficiently

#### Learning Outcomes:
- Master conditional logic and decision trees
- Implement various loop patterns efficiently
- Work with associative and indexed arrays
- Perform advanced list manipulations
- Control program flow with break/continue
- Handle complex data structures

#### Perfect For:
Developers ready to build more sophisticated Tcl programs with proper control flow and data management.

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