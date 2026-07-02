# ASIC Low-Power Synthesis Flow using Cadence Genus

This repository contains an industry-standard, physical-aware RTL-to-Gate logic synthesis flow using **Cadence Genus Synthesis Solution**. The primary objective of this project is to optimize a digital design for strict power constraints using advanced low-power methodologies, including integrated clock gating and multi-Vt (Threshold Voltage) optimization, evaluated via the Joules power engine.

## 🚀 Key Methodologies Implemented

*   **Integrated Clock Gating (ICG):** Automated insertion of clock gating logic to freeze the clock tree for idle registers and memory blocks, drastically reducing dynamic switching power.
*   **Multi-Vt Swapping (Leakage Optimization):** Aggressive optimization of static leakage power by forcing the tool to utilize High-Vt (low leakage, slower) standard cells on non-critical timing paths, reserving Standard-Vt/Low-Vt cells only for timing-critical paths.
*   **Physical-Aware Synthesis (iSpatial):** Utilization of LEF physical libraries and capacitance tables during synthesis to accurately estimate wire-load models and prevent post-layout timing degradation.
*   **Joules Power Engine:** High-accuracy power estimation utilizing `.tcf` switching activity profiling to compute realistic average and peak power metrics.

## 📊 Quality of Results (QoR) Summary

The following metrics were achieved on the `dtmf_recvr_core` DSP block, synthesized at 1.08V (125°C) using a TSMC 130nm technology node.

### Power Optimization
Through clock gating and standard cell swapping, total design power was reduced by **25%** from the initial generic mapping to the final optimized netlist.

| Metric | Pre-Optimization | Post-Optimization | Improvement |
| :--- | :--- | :--- | :--- |
| **Total Power** | 18.27 mW | 13.70 mW | **25.0% Reduction** |
| **Memory Power** | 5.74 mW | 0.10 mW | **98.2% Reduction** |
| **Leakage Power** | 0.04 mW | 0.04 mW | Maintained |
| **HVT Cell Utilization** | N/A | 50.7% | High-Vt Dominant |

### Clock Gating Efficiency
| Metric | Result |
| :--- | :--- |
| **Total Flops/Sinks** | 514 |
| **Sinks Successfully Gated** | 448 |
| **Clock Gating Efficiency** | **87.16%** |

### Timing Closure (Worst Negative Slack)
| Clock Domain | Initial WNS | Final WNS |
| :--- | :--- | :--- |
| `m_clk` | -99.6 ps | **-23.3 ps** |

*(Note: A final WNS of -23.3 ps is considered effectively closed for pre-layout synthesis and will be easily resolved during the Place & Route physical design stage).*

