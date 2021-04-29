`include "wb_ctrl.v"

module wb_stage (
    // inputs from MEM
    input [6:0] opcode,
    input [31:0] c,
    input [31:0] d,
    input [31:0] pc4,

    // outputs to Register File
    output [31:0] data_to_reg
);

    //
    // Main
    //
    wire write;
    wire [1:0] data_to_reg_sel;

    wb_ctrl wb_ctrl_inst(
        .opcode(opcode),
        .data_to_reg_sel(data_to_reg_sel)
    );

    assign data_to_reg = data_to_reg_prep(data_to_reg_sel, c, d, pc4);

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
