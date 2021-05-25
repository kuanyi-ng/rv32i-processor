`include "wb_ctrl.v"

module wb_stage (
    // inputs from MEM
    input [6:0] opcode,
    input [31:0] c,
    input [31:0] d,
    input [31:0] pc4,
    input [31:0] z_,

    // outputs to Register File
    output [31:0] data_to_reg,

    // outputs to CSRs Registers
    output [31:0] data_to_csr
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

    assign data_to_reg = data_to_reg_prep(data_to_reg_sel, c, d, pc4, z_);

    assign data_to_csr = c;

    //
    // Functions
    //
    function [31:0] data_to_reg_prep(
        input [1:0] sel,
        input [31:0] c,
        input [31:0] d,
        input [31:0] pc4,
        input [31:0] z_
    );
        begin
            case (sel)
                2'b00: data_to_reg_prep = c;
                2'b01: data_to_reg_prep = d;
                2'b10: data_to_reg_prep = pc4;
                2'b11: data_to_reg_prep = z_;
            endcase
        end
    endfunction
endmodule
