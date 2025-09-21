# Design 002: Boolean Expression Implementation

## Overview
This design implements a complex Boolean expression in Verilog: **Y = (ABC + A'C' + D)**

## Design Description
The `exp` module evaluates a 4-input Boolean function using basic logic operations.

### Module Interface
```verilog
module exp(
    input a, b, c, d,
    output y
);
```

### Boolean Expression
**Y = (ABC + A'C' + D)**
- **Term 1**: ABC (AND of all three inputs a, b, c)
- **Term 2**: A'C' (AND of NOT a and NOT c)  
- **Term 3**: D (Direct input d)
- **Result**: OR of all three terms

## Files
- **`Boolean.v`** - Main design module
- **`Boolean_tb.v`** - Testbench with 5 test cases
- **`xrun.history`** - Simulation command history
- **`xrun.log`** - Detailed simulation log
- **`xrun.key`** - Probe commands for waveform capture

## Truth Table (Selected Test Cases)

| a | b | c | d | ABC | A'C' | Y |
|---|---|---|---|-----|------|---|
| 0 | 1 | 1 | 0 |  0  |  0   | 0 |
| 1 | 0 | 1 | 1 |  0  |  0   | 1 |
| 0 | 0 | 0 | 1 |  0  |  1   | 1 |
| 1 | 1 | 0 | 1 |  0  |  0   | 1 |
| 1 | 0 | 0 | 1 |  0  |  0   | 1 |

## Simulation
```bash
# Run simulation with waveform viewer
xrun -timescale 1ns/1ps -gui +access+r Boolean.v Boolean_tb.v
```

## Waveform Analysis
![Waveform Simulation Results](waveform_boolean.png)

The waveform shows:
- **Input signals**: a, b, c, d transitions over 5 test cases
- **Output Y**: Response based on Boolean expression evaluation
- **Timing**: Each test case runs for 5ns duration

## Key Learning Points
- Complex Boolean expression implementation
- Sum-of-Products (SOP) form realization
- Combinational logic design
- Multi-input logic function verification

## Implementation Details
```verilog
assign y = (a&b&c)|((~a)&(~c))|d;
```
- Uses bitwise operators: `&` (AND), `|` (OR), `~` (NOT)
- Implements the expression as continuous assignment
- Purely combinational logic with zero propagation delay
