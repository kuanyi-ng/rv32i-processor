`include "mem_ctrl.v"
`include "st_converter.v"
`include "ld_converter.v"

module mem_stage (
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