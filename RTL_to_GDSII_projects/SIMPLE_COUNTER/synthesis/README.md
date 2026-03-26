# 🔧 RTL to GDSII — Synthesis Stage

## 8-bit Synchronous Counter (Cadence Genus)

---

## 📌 Overview

This stage implements **RTL → Gate-Level Netlist synthesis** of an 8-bit synchronous counter using **Cadence Genus (GPDK045, 45nm)** under worst-case operating conditions.

---

## 🧾 Design Specifications

* **Module:** `counter`
* **Function:** 8-bit synchronous up-counter
* **Reset:** Asynchronous active-low (`negedge rst`)
* **Clock:** 100 MHz (10 ns period)
* **Output:** `count[7:0]`
* **Technology:** GPDK045 (45nm)
* **Corner:** Slow (worst-case)
* **Voltage:** 1.08 V
* **Temperature:** 125°C

---

## ⚙️ Synthesis Flow

```tcl
read_libs {slow.lib leon.lib}
read_hdl counter.v
elaborate
read_sdc constraints_top.sdc

syn_generic
syn_map
syn_opt

write_hdl > counter_netlist.v
write_sdc > counter_sdc.sdc
write_sdf > delays.sdf
```

---

## 📊 Results Summary

| Metric                     | Value    |
| -------------------------- | -------- |
| Clock Period               | 10 ns    |
| Worst Negative Slack (WNS) | +8.56 ns |
| Total Negative Slack (TNS) | 0        |
| Power                      | ~10.4 µW |
| Flip-Flops                 | 8        |
| Combinational Cells        | 17       |

✅ **Timing Status: MET (No violations)**

---

## 🧠 Key Insights

* Synthesized as a **ripple-carry incrementer**
* **Register-dominated power (~83%)**
* **Scan flip-flop (SDFF)** inserted automatically for MSB
* Extremely relaxed timing → capable of GHz operation (pre-layout)
* Area not reported due to missing library attributes

---

## 📁 Project Structure

```
SIMPLE_COUNTER/
├── counter.v
├── constraints/
│   └── constraints_top.sdc
├── synthesis/
│   ├── genus_script.tcl
│   ├── reports/
│   ├── outputs/
```

---

## 📸 Synthesis Output Snapshot

![Synthesis Screenshot](./screenshots/synthesis_screenshot_counter.png)


**Author:** Ram Tripathi
**Flow:** RTL → Synthesis → (Next: Physical Design)
