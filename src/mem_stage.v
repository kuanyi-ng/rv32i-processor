module mem_stage (
    // inputs from Memory Module
    input data_mem_ready_n,  // 0: ready to access memory, 1: not ready
    input [31:0] data_from_mem,

    // inputs from EX stage
    input [6:0] opcode,
    input [2:0] funct3,
    input [31:0] b,                 // data to store (Store Instructions)
    input [31:0] c,                 // memory address to access

    // outputs to MEM stage
    output [31:0] d,                // data loaded (Load Instructions)

    // outputs to Memory Module
    output require_mem_access,
    output write,                   // 0: read, 1: write
    output [1:0] size,              // 00: word, 01: half, 10: byte
    output [31:0] data_to_mem
);

    // NOTE: need to request for memory access first,
    //  then only we will receive data_mem_ready_n from the memory.

    // NOTE: need to think about how to handle data_mem_ready_n
    mem_ctrl mem_ctrl_inst(
        .opcode(opcode),
        .funct3(funct3),
        .access_size(size),
        .write_to_data_mem(write),
        .require_mem_access(require_mem_access)
    );

    st_converter st_converter_inst(
        .in(b),
        .format(funct3),
        .out(data_to_mem)
    );

    ld_converter ld_converter_inst(
        .in(data_from_mem),
        .offset(c[1:0]),
        .format(funct3),
        .out(d)
    );

endmodule