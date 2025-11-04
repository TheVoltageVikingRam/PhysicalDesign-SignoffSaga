# Sequential Signed Multiplier

**Hardware project:** sequential signed multiplier using a modified Booth algorithm.

---

## Overview

This project implements a hardware-based sequential signed multiplier that multiplies two signed `WIDTH`-bit numbers using a shift-and-add approach (modified Booth-style control). The default `WIDTH` is 8, producing a 16-bit signed product.

## Features

* Parameterized bit-width (default: 8)
* Correct handling of signed (two's complement) inputs
* Area-efficient sequential datapath (single adder reused)
* FSM control with clear state separation
* Handshake signals: `start` (input) and `done` (output)

---

## Repository layout

```
design020/
├── README.md
├── sequential_multiplier.sv
├── tb_mult_controller.sv
└── simvision_xeclium_waveform_mult_controller.png
```


![SimVision waveform](simvision_xeclium_waveform_mult_controller.png)


---

## Module interface

**Parameters**

* `WIDTH` — default `8` (bit width of operands)

**Ports**

* `input logic clk`
* `input logic rst_n` — active-low asynchronous reset
* `input logic start`
* `input signed [WIDTH-1:0] multiplicand`
* `input signed [WIDTH-1:0] multiplier`
* `output signed [2*WIDTH-1:0] product`
* `output logic done`

---

## Architecture and FSM

The controller is an FSM with the following high-level states:

* `IDLE` — wait for `start`
* `LOAD` — latch inputs into internal registers
* `CHECK` — inspect product register LSB to decide operation
* `ADD` / `SUB` — add or subtract multiplicand to/from the upper product half
* `SHIFT` — arithmetic right-shift the product register and decrement counter
* `ADJUST` — final correction if multiplier was negative (Booth correction)
* `COMPLETE` — assert `done` and return to `IDLE`

This FSM makes the datapath simple and modular; the adder/subtractor is time-multiplexed across iterations.

---

## Algorithm summary

1. Load multiplicand and multiplier into internal registers (product register holds multiplier in its low half).
2. For `WIDTH` iterations:

   * If LSB of the product register is `1`, add multiplicand to upper half.
   * Perform arithmetic right shift on the full product register.
3. If multiplier was negative, apply the final subtraction (correction) in `ADJUST` state.
4. Set `done` high in `COMPLETE` state and present the 2*WIDTH result on `product`.

---

## Testbench

`tb_mult_controller.sv` covers:

* Positive and negative operand combinations
* Zeros and ones
* Boundary values (`127`, `-128` for 8-bit)
* Powers of two and random vectors

The testbench is self-checking (compares the DUT output to SystemVerilog `*` operator), generates a VCD/waveform file and contains a simulation timeout guard to avoid hung simulations.

---

## How to simulate (Cadence Xcelium)

```bash
# compile + simulate
xrun sequential_multiplier.sv tb_mult_controller.sv

# GUI with SimVision
xrun -gui sequential_multiplier.sv tb_mult_controller.sv

# waveform logging (rwc access)
xrun -access +rwc sequential_multiplier.sv tb_mult_controller.sv
```

## Synthesis notes & tradeoffs

* Uses ~1 adder/subtractor (WIDTH bits) and ~30–40 flip-flops for 8-bit configuration.
* Critical path goes through the adder — choose a fast adder (carry-lookahead / carry-select) to raise fmax.
* Sequential design prioritizes area and power; pipelined or combinational designs trade area for throughput.

---

## Known limitations

* No overflow flag (the result is presented as 2*WIDTH bits; higher precision required to detect overflow)
* Not pipelined — throughput ≈ one multiplication per (`WIDTH` + control cycles)
* No early termination implemented (can be added as an enhancement)

---

## Debugging tips

* Inspect `state`, `bit_count`, and `product_reg` in the waveform
* Validate `sign_adjust` and `add_enable` control signals
* Confirm use of arithmetic shift (`>>>`) to preserve sign

---

## License & Author

Author: Part of the *100 Verilog Designs* series
Last updated: November 2025

---

If you'd like, I can also create a ready-to-commit README file content or provide a small `Makefile`/`scripts/run_xrun.sh` helper to run simulations with common options.
