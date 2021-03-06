`include "constants/mem_access_size.v"

`include "mem_ctrl.v"
`include "st_converter.v"
`include "ld_converter.v"

module mem_stage (
    // inputs from Memory Module
    input [31:0] data_from_mem,

    // inputs from EX stage
    input [3:0] ir_type,
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

    // NOTE: need to request for memory access first,
    // then only we will receive data_mem_ready_n from the memory.

    mem_ctrl mem_ctrl_inst(
        .ir_type(ir_type),
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