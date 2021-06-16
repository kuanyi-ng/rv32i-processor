`include "constants/ir_type.v"
`include "constants/funct3.v"

`define DEFAULT_PC4         32'h0001_0004
`define DEFAULT_B           32'h0000_0000
`define DEFAULT_C           32'h0000_0000
`define DEFAULT_D           32'h0000_0000
`define DEFAULT_Z           32'h0000_0000
`define DEFAULT_CSR_ADDR    12'hf11 // mvendorid (cannot be overwrite)
`define DEFAULT_RD          5'b0
`define DEFAULT_IR_TYPE     `REG_IMM_IR // from NOP
`define DEFAULT_FUNCT3      `ADD_FUNCT3 // from NOP
`define DEFAULT_WR_N        1'b1    // deactive write (dont update state)
`define DEFAULT_FLUSH       1'b0    // dont flush on default
