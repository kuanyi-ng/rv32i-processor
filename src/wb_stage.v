module wb_stage (
    // inputs from MEM
    input [4:0] rd,
    input [6:0] opcode,
    input [31:0] c,
    input [31:0] d,
    input [31:0] pc_from_mem,

    // outputs to Register File
    output [4:0] reg_wr_addr,
    output write,
    output [31:0] data_to_reg,

    // outputs to IF
    output [31:0] next_pc
);

    //
    // Main
    //
    wire [1:0] data_to_reg_sel;

    wb_ctrl wb_ctrl_inst(
        .opcode(opcode),
        .write_to_reg(write),
        .data_to_reg_sel(data_to_reg_sel)
    );

    wire [31:0] pc4;

    pc_adder wb_pc_adder(
        .in(pc_from_mem),
        .out(pc4)
    );

    assign data_to_reg = data_to_reg_prep(data_to_reg_sel, c, d, pc4);

    assign reg_wr_addr = rd;
    assign next_pc = c;

    //
    // Functions
    //
    function [31:0] data_to_reg_prep(input [1:0] sel, input [31:0] c, input [31:0] d, input [31:0] pc4);
        begin
            if (sel == 2'b00) data_to_reg_prep = c;
            else if (sel == 2'b01) data_to_reg_prep = d;
            else data_to_reg_prep = pc4;
        end
    endfunction
endmodule
