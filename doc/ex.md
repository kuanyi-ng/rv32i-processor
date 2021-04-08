# Execution Phase-related Module

## A-Multiplexer (A-Mux)
### Inputs
- `pc`: program counter (when the current instruction is fetch)
- `d1`: value of x[rs1].

### Outputs
- `A`

### Control Bit
- `ASel`: determine which value to pass on to `A`.
  - 0: `pc`
  - 1: `d1`

## B-Multiplexer (B-Mux)
### Inputs
- `d2`: value of x[rs2].
- `shamt`: 5 bits value required on bit shifting operation in `ALU`.
- `imm`: immediate value extracted from ID phase.

### Outputs
- `B`

### Control Bit
- `BSel`: determine which value to pass on to `B`.
  - 00: `d2`
  - 01: `shamt`
  - 10: `imm`

## ALU
### Inputs
- `in1`
- `in2`

### Outputs
- `out`: calculated value from operation performed on `in1` and `in2`.

### Control Bit
- `ALUOp`: determine what kind of operation (calculation) to perform on `A` and `B`.
  - 0000: add `+`
  - 0001: sub `-`
  - 0010: xor `^`
  - 0011: or `|`
  - 0100: and `&`
  - 0101: sll `<<`
  - 0110: srl `>>u`
  - 0111: sra `>>s`
  - 1000: eq `==`
  - 1001: ne `!=`
  - 1010: lt `<`
  - 1011: ltu `<=`
  - 1100: ge `>`
  - 1101: geu `>=`