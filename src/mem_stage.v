module mem_stage (
    // inputs from Memory Module
    input data_mem_access_ready_n,  // 0: ready to access memory, 1: not ready
    input [31:0] data_from_mem,

    // inputs from EX stage
    input [6:0] opcode,
    input [2:0] funct3,
    input [31:0] pc_from_ex,
    input [31:0] b,                 // data to store (Store Instructions)
    input [31:0] c,                 // memory address to access
    // NOTE: might want to pass data from EX to WB in higher level module
    // jump_or_branch is not pass on to WB yet
    input [4:0] rd_from_ex,

    // outputs to MEM stage
    output [31:0] pc_to_wb,
    output [4:0] rd_to_wb,
    output [6:0] opcode_to_wb,
    output [31:0] c_to_wb,
    output [31:0] d,                // data loaded (Load Instructions)

    // outputs to Memory Module
    output [31:0] data_mem_addr,
    output require_mem_access,
    output write,                   // 0: read, 1: write
    output [1:0] size,              // 00: word, 01: half, 10: byte
    output [31:0] data_to_mem
);

    mem_ctrl mem_ctrl_inst(
        .opcode(opcode),
        .funct3(funct3),
        .data_mem_access_ready_n(data_mem_access_ready_n),
        .access_size(size),
        .write_to_data_mem(write),
        .require_mem_access(require_mem_access)
    );

    assign data_mem_addr = c;

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
    
    assign pc_to_wb = pc_from_ex;
    assign rd_to_wb = rd_from_ex;
    assign opcode_to_wb = opcode;
    assign c_to_wb = c;

endmodule