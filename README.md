# CPC Lab Startup Training: Processor Design
Design and build a processor able to execute RISC-V (RV32I) instructions as a way to understand the working principles behind modern processors.

- [CPC Lab Startup Training: Processor Design](#cpc-lab-startup-training-processor-design)
  - [RV32I Insructions](#rv32i-insructions)
  - [Steps for Processor Design (Example)](#steps-for-processor-design-example)
    - [1. Make an Instruction Execution Table (8 hours)](#1-make-an-instruction-execution-table-8-hours)
    - [2. Draw a Block Diagram for the Processor (32 hours)](#2-draw-a-block-diagram-for-the-processor-32-hours)
    - [3. Modules Implementation with Verilog-HDL (112 hours)](#3-modules-implementation-with-verilog-hdl-112-hours)
    - [4. Top Module Implementation (24 hours)](#4-top-module-implementation-24-hours)
    - [5. Testing (168 hours)](#5-testing-168-hours)
    - [6. Logic Synthesis (56 hours ++)](#6-logic-synthesis-56-hours-)
    - [7. +$\alpha$](#7-alpha)
    - [8. Documentation & Presentation (112 hours)](#8-documentation--presentation-112-hours)
  - [Source](#source)

## RV32I Insructions
A list of instructions available in RV32I is available [here](https://msyksphinz-self.github.io/riscv-isadoc/html/rvi.html).

Specification of RV32I can be found in _Chapter 2. RV32I Base Integer Instruction Set, Version 2.1_ section of _RISC-V ISA Specification: Volume 1, Unprivileged Spec v. 20191213_ which is available [here](https://github.com/riscv/riscv-isa-manual/releases/download/Ratified-IMAFDQC/riscv-spec-20191213.pdf).

## Steps for Processor Design (Example)
### 1. Make an Instruction Execution Table (8 hours)
An Instruction Execution Table contains information about what process is performed during each execution phase (in a pipelined processor) for each instructions.

### 2. Draw a Block Diagram for the Processor (32 hours)
> A block diagram is a diagram of a system in which the principal parts or functions are represented by blocks connected by lines that show the relationships of the blocks.
> 
> -- Wikipedia: https://en.wikipedia.org/wiki/Block_diagram

Draw a block diagram showing how bits flow through different modules (logic circuits that perform calculation on input bits) at different execution stages.
This diagram will act as a reference when we implement each modules with Verilog-HDL later on, so it's better to draw this diagram with details.

### 3. Modules Implementation with Verilog-HDL (112 hours)

### 4. Top Module Implementation (24 hours)

### 5. Testing (168 hours)

### 6. Logic Synthesis (56 hours ++)
> In computer engineering, logic synthesis is a process by which an abstract specification of desired circuit behavior, typically at register transfer level (RTL), is turned into a design implementation in terms of logic gates, typically by a computer program called a _synthesis tool_.
>
> -- Wikipedia: https://en.wikipedia.org/wiki/Logic_synthesis

### 7. +$\alpha$

### 8. Documentation & Presentation (112 hours)

## Source
- [CPC研究室. Startup-Training: Processor Design Wiki 基本事項](http://web.cpc.ait.kyushu-u.ac.jp/ST/ProcDesign_wiki/index.php?%B4%F0%CB%DC%BB%F6%B9%E0)