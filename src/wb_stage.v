`include "constants/opcode.v"

module wb_stage (
    // inputs from MEM
    input [2:0] funct3,
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

    assign data_to_reg = data_to_reg_prep(funct3, opcode, c, d, pc4, z_);
    assign data_to_csr = c;

    //
    // Functions
    //

    function [31:0] data_to_reg_prep(
        input [2:0] funct3,
        input [6:0] opcode,
        input [31:0] c,
        input [31:0] d,
        input [31:0] pc4,
        input [31:0] z_
    );
        reg is_load, is_jal, is_jalr, is_csr;

        begin
            is_load = (opcode == `LOAD_OP);
            is_jal = (opcode == `JAL_OP);
            is_jalr = (opcode == `JALR_OP);
            is_csr = (opcode == `SYSTEM_OP) && (funct3 != 3'b000);

            if (is_load) data_to_reg_prep = d;
            else if (is_jal || is_jalr) data_to_reg_prep = pc4;
            else if (is_csr) data_to_reg_prep = z_;
            else data_to_reg_prep = c;
        end
    endfunction
endmodule
