`include "constants/ir_type.v"

module wb_stage (
    // inputs from MEM
    input [3:0] ir_type,
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

    assign data_to_reg = data_to_reg_prep(ir_type, c, d, pc4, z_);
    assign data_to_csr = c;

    //
    // Functions
    //

    function [31:0] data_to_reg_prep(
        input [3:0] ir_type,
        input [31:0] c,
        input [31:0] d,
        input [31:0] pc4,
        input [31:0] z_
    );
        begin
            case (ir_type)
                `LOAD_IR: data_to_reg_prep = d;
                `JAL_IR: data_to_reg_prep = pc4;
                `JALR_IR: data_to_reg_prep = pc4;
                `CSR_IR: data_to_reg_prep = z_;
                default: data_to_reg_prep = c;
            endcase
        end
    endfunction
endmodule
