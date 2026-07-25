# Traffic Light Controller FSM in Verilog

## Overview
This repository contains the RTL design and verification of a 2-way intersection traffic light controller. The system is designed as a **Moore Finite State Machine (FSM)** using SystemVerilog, demonstrating core sequential logic principles, clock-driven state transitions, and integrated timing delays.

## Features
* **Sequential Logic Design:** Implemented utilizing clocked `always @(posedge clk)` blocks for memory and state retention.
* **Automated Timing:** Includes a built-in 4-bit counter to hold states for specific durations (10 cycles for Green, 3 cycles for Yellow).
* **Clock-Driven Testbench:** Features a self-generating system clock and automated reset protocol to verify continuous, cyclic operation over time.

## State Machine Architecture
The intersection manages two orthogonal directions: North/South and East/West. The outputs are mapped as 3-bit arrays representing `{Red, Yellow, Green}`.
* `100` = Red
* `010` = Yellow
* `001` = Green

| State | NS Output | EW Output | Duration | Next State |
| :--- | :--- | :--- | :--- | :--- |
| `S_NS_GREEN` | `001` (Green) | `100` (Red) | 10 Clock Cycles | `S_NS_YELLOW` |
| `S_NS_YELLOW` | `010` (Yellow) | `100` (Red) | 3 Clock Cycles | `S_EW_GREEN` |
| `S_EW_GREEN` | `100` (Red) | `001` (Green) | 10 Clock Cycles | `S_EW_YELLOW` |
| `S_EW_YELLOW` | `100` (Red) | `010` (Yellow) | 3 Clock Cycles | `S_NS_GREEN` |

## Simulation and Verification
The sequential logic was verified by generating a continuous clock signal and monitoring the state transitions across 400+ time units.
