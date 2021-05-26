`include "mem_ctrl.v"
`include "st_converter.v"
`include "ld_converter.v"

module mem_stage #(
    parameter [6:0] LUI_OP = 7'b0110111,
    parameter [6:0] AUIPC_OP = 7'b0010111,
    parameter [6:0] JAL_OP = 7'b1101111,
    parameter [6:0] JALR_OP = 7'b1100111,
    parameter [6:0] BRANCH_OP = 7'b1100011,
    parameter [6:0] LOAD_OP = 7'b0000011,
    parameter [6:0] STORE_OP = 7'b0100011,
    parameter [6:0] I_TYPE_OP = 7'b0010011,
    parameter [6:0] R_TYPE_OP = 7'b0110011,
    parameter [6:0] CSR_OP = 7'b1110011
) (
    // inputs from Memory Module
    input data_mem_ready_n,  // 0: ready to access memory, 1: not ready
    input [31:0] data_from_mem,

    // inputs from EX stage
    input [6:0] opcode,
    input [2:0] funct3,
    input [31:0] b,                 // data to store (Store Instructions)
    input flush,

    // outputs to MEM stage
    output [31:0] d,                // data loaded (Load Instructions)

    // outputs to Memory Module
    output require_mem_access,
    output write,                   // 0: read, 1: write
    output [1:0] size,              // 00: word, 01: half, 10: byte
    output [31:0] data_to_mem
);

    // NOTE: same as the lower 2 bits of funct3
    localparam [1:0] WORD = 2'b00;
    localparam [1:0] HALF = 2'b01;
    localparam [1:0] BYTE = 2'b10;
    localparam [1:0] INPROPER_SIZE = 2'b11;

    // NOTE: need to request for memory access first,
    // then only we will receive data_mem_ready_n from the memory.

    mem_ctrl #(
        .LOAD_OP(LOAD_OP),
        .STORE_OP(STORE_OP),
        .WORD(WORD),
        .HALF(HALF),
        .BYTE(BYTE),
        .INPROPER_SIZE(INPROPER_SIZE)
    ) mem_ctrl_inst(
        .opcode(opcode),
        .funct3(funct3),
        .flush(flush),
        .access_size(size),
        .write_to_data_mem(write),
        .require_mem_access(require_mem_access)
    );

    st_converter st_converter_inst(
        .in(b),
        .funct3(funct3),
        .out(data_to_mem)
    );

    ld_converter ld_converter_inst(
        .in(data_from_mem),
        .funct3(funct3),
        .out(d)
    );

endmodule