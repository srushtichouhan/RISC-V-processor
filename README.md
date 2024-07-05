# RISC-V Processor

This project involves designing and verifying a RISC-V 32I processor, which includes several key components essential for accurate instruction execution and efficient data processing.

## Components

- **Instruction Fetch Unit (IFU):** Fetches instructions from memory.
- **Instruction Decode Unit (IDU):** Decodes instructions into control signals, determines register sources/destinations, and generates immediate values.
- **Register File:** Manages read/write access to processor registers.
- **Branch Unit:** Handles conditional and unconditional branching operations.
- **Load/Store Unit:** Executes data memory operations, including loading and storing data.
- **Immediate Generator:** Produces immediate values required by instructions.
- **ALU:** Performs arithmetic and logic operations on data operands.

## Implementation

- **Languages and Tools:** Verilog for hardware design, Python with Cocotb for verification.
- **Verification:** Comprehensive testing using Cocotb to ensure functionality and performance of each component.

## Objective

The primary objective of this project is to achieve accurate instruction execution and efficient data processing through the thorough design and validation of the RISC-V 32I processor.
