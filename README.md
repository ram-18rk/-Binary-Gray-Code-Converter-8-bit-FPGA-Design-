# -Binary-Gray-Code-Converter-8-bit-FPGA-Design-
# 🔁 Binary ↔ Gray Code Converter (8-bit FPGA Design)

This project implements a fully synchronous **8-bit Binary-to-Gray and Gray-to-Binary converter** using Verilog HDL.  
The design follows a **modular RTL approach** using a **Datapath + Finite State Machine (FSM)** architecture and reuses a **single XOR gate** for all bit operations (resource sharing).

---

## 🧠 Project Overview

Gray code is commonly used in encoders, counters, and digital communication systems because it ensures that only **one bit changes at a time**, reducing the chance of errors.

This hardware design supports:

✔ **Binary → Gray Conversion**  
✔ **Gray → Binary Conversion**  
✔ Fully reversible operation  
✔ Clocked sequential execution  
✔ Resource-optimized datapath implementation  

---

## 🏗 Architecture

The design is partitioned into two major blocks:

| Module | Function |
|--------|----------|
| **FSM Controller** | Controls sequence, bit index, register writes, and mode selection |
| **Datapath** | Performs register operations and XOR-based computation |

---

## 🧩 Datapath Components

| Component    | Description |
|-----------   |------------|
| `pipo.v`     | 8-bit parallel load register (R1 and R2) |
| `reg_r.v`    | 1-bit register (R3 and R4) |
| `xor_gate.v` | Single XOR hardware reused iteratively |
| `datapath.v` | Connects registers, muxes, and XOR logic |

---

## 🔄 Conversion Logic

### Binary → Gray

g[7] = b[7]
g[i] = b[i+1] XOR b[i]
### Gray → Binary
b[7] = g[7]
b[i] = b[i+1] XOR g[i]
## ▶ Simulation Results
Two simulation modes were tested:

| Mode | Input | Output |
|------|--------|---------|
| Binary → Gray | `0xAD` | `0xFD` |
| Gray → Binary | `0xFD` | `0xAD` |


Waveform Examples:
binary (1010 1101) ---> gray (1111 1101)
gray (1111 1101) ---> binary (1010 1101)

<img width="1559" height="936" alt="Screenshot 2025-11-29 193351" src="https://github.com/user-attachments/assets/04303eb8-f102-42fa-a180-d1618c3f94f2" />
<img width="1569" height="949" alt="Screenshot 2025-11-29 193519" src="https://github.com/user-attachments/assets/6ff7beda-c3b0-46fc-b8d2-c2fd7403c792" />
## 🔧 Synthesis & Resource Utilization

<img width="608" height="77" alt="Screenshot 2025-11-29 194049" src="https://github.com/user-attachments/assets/306a4a34-e1d9-4c11-8959-095490c08074" />

<img width="719" height="379" alt="Screenshot 2025-11-29 194104" src="https://github.com/user-attachments/assets/ab467553-0f65-43c8-ba67-1d93a6479ff9" />


---

## 🚀 How to Run

1. Open Vivado  
2. Add all RTL files and the testbench  
3. Run behavioral simulation  
4. Observe waveform results  
5. Run synthesis to generate reports  

---

## 🧪 Testbench Example

```verilog
start = 1; convert = 0; data_in = 8'hAD;   // Binary → Gray
start = 1; convert = 1; data_in = 8'hFD;   // Gray → Binary

