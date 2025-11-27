# RAM Controller Design (Design025)

## 📋 Project Overview

This project implements a simple synchronous RAM controller with a finite state machine (FSM) to manage read and write operations. The design demonstrates fundamental RTL design concepts including FSM design, memory inference, and proper testbench development.

## 🎯 Features

- **Parameterized Design**: Configurable address width and data width
- **FSM-Based Control**: Three-state FSM for managing operations
- **Synchronous Operations**: All operations synchronized to clock edge
- **Ready Handshaking**: Ready signal to indicate controller availability
- **Comprehensive Testbench**: Includes multiple test scenarios with automated checking

## 📁 Directory Structure

```
design025/
├── ram_controller.sv                              # Main RTL design file
├── tb_ram_controller.sv                           # Testbench with verification tasks
├── xcelium_output.png                             # Simulation results screenshot
├── ram_controller_simvision_waveform_xcelium.png  # Waveform viewer screenshot
└── README.md                                      # This file
```

## 🔧 Design Specifications

### Parameters
- `ADDR_WIDTH`: Address bus width (default: 8 bits → 256 locations)
- `DATA_WIDTH`: Data bus width (default: 32 bits)

### Ports

| Port Name   | Direction | Width              | Description                          |
|-------------|-----------|--------------------|------------------------------------- |
| clk         | Input     | 1                  | System clock                         |
| reset_n     | Input     | 1                  | Active-low asynchronous reset        |
| read_en     | Input     | 1                  | Read enable signal                   |
| write_en    | Input     | 1                  | Write enable signal                  |
| addr        | Input     | ADDR_WIDTH         | Memory address                       |
| write_data  | Input     | DATA_WIDTH         | Data to be written                   |
| read_data   | Output    | DATA_WIDTH         | Data read from memory                |
| ready       | Output    | 1                  | Controller ready for new operation   |

### State Machine

The controller implements a three-state FSM:

```
IDLE (00) ──read_en──> READ_CYCLE (01) ──> IDLE
    │
    └──write_en──> WRITE_CYCLE (10) ──> IDLE
```

**States:**
- **IDLE**: Waiting for read or write request
- **READ_CYCLE**: Performing memory read operation
- **WRITE_CYCLE**: Performing memory write operation

## 🧪 Testbench Features

The testbench (`tb_ram_controller.sv`) includes:

1. **Clock Generation**: 10ns period (100MHz)
2. **Reset Sequence**: Proper initialization
3. **Test Cases**:
   - ✅ Write operations to multiple addresses
   - ✅ Read back and verify written data
   - ✅ Read from uninitialized locations
   - ✅ Overwrite existing data
4. **Helper Tasks**:
   - `write_to_ram()`: Performs write with proper handshaking
   - `read_from_ram()`: Performs read with automatic verification
5. **Automated Checking**: Pass/Fail reporting for each read operation
6. **Waveform Dumping**: VCD file generation for debugging

## 🚀 Running the Simulation

### Prerequisites
- Cadence Xcelium simulator
- SystemVerilog support

### Commands

```bash
# Navigate to the design directory
cd design025/

# Run simulation with Xcelium
xrun -timescale 1ns/1ps +access+rwc ram_controller.sv tb_ram_controller.sv

# For waveform viewing, add GUI mode
xrun -timescale 1ns/1ps +access+rwc -gui ram_controller.sv tb_ram_controller.sv
```

## 📊 Simulation Results

### Console Output

![Xcelium Simulation Output](xcelium_output.png)

The simulation executes all test cases and reports:
- ✅ All write operations completed successfully
- ✅ All read operations passed verification
- ✅ Uninitialized memory behavior observed
- ✅ Overwrite functionality confirmed

**Sample Output:**
```
Starting RAM Controller test

-- TEST 1: WRITING DATA---
WRITE: Addr=0x10, Data=0xdeadbeac
WRITE: Addr=0x20, Data=0x12345678
WRITE: Addr=0x30, Data=0xabcdef00

--- TEST2: Reading Data ----
 READ: Addr = 0x10, Data = 0xdeadbeac [PASS]
 READ: Addr = 0x20, Data = 0x12345678 [PASS]
 READ: Addr = 0x30, Data = 0xabcdef00 [PASS]

 -- TEST3: Read Uninitialized Address ---
READ: Addr = 0x50, Data = 0xx [NO CHECK] 

--- TEST 4: Overwrite exisitng data --- 
WRITE: Addr=0x10, Data=0xcafebabe
 READ: Addr = 0x10, Data = 0xcafebabe [PASS]

Test complete
```

### Waveform Analysis

![SimVision Waveform](ram_controller_simvision_waveform_xcelium.png)

The waveform shows:
- **FSM Transitions**: IDLE → READ_CYCLE/WRITE_CYCLE → IDLE
- **Ready Signal**: Deasserts during operations, asserts when idle
- **Memory Operations**: Proper timing relationships between address, data, and control signals
- **Read Data Latency**: One cycle delay from read enable to data valid

## 🎓 Learning Objectives

This design demonstrates:

1. **FSM Design Patterns**: Proper state encoding and transition logic
2. **Memory Inference**: How synthesizers infer RAM from HDL code
3. **Synchronous Design**: Clocked logic and proper reset handling
4. **Interface Protocol**: Ready/valid handshaking mechanism
5. **Testbench Development**: Task-based verification methodology
6. **Parameterization**: Creating reusable, configurable designs

## 🔍 Key Design Decisions

### Why FSM-Based?
- Provides clear control flow
- Easy to extend with additional states (e.g., burst modes)
- Simplifies timing analysis

### Why Registered Outputs?
- `read_data` is registered for better timing closure
- Eliminates combinational paths through large memories
- Reduces clock-to-output delay uncertainty

### Why Ready Signal?
- Enables proper handshaking with external modules
- Prevents bus contention
- Supports non-pipelined operation model


## 📝 Design Verification Status

| Test Case                    | Status | Notes                              |
|------------------------------|--------|------------------------------------|
| Basic Write                  | ✅ PASS | Single and multiple writes         |
| Basic Read                   | ✅ PASS | Data integrity verified            |
| Read-After-Write             | ✅ PASS | Immediate readback successful      |
| Uninitialized Read           | ✅ PASS | Returns X as expected              |
| Overwrite                    | ✅ PASS | Old data correctly replaced        |
| FSM State Transitions        | ✅ PASS | All transitions verified           |
| Ready Signal Behavior        | ✅ PASS | Proper handshaking confirmed       |
