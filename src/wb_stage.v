module wb_stage
#(
    parameter [6:0] LUI_OP = 7'b0110111,
    parameter [6:0] AUIPC_OP = 7'b0010111,
    parameter [6:0] JAL_OP = 7'b1101111,
    parameter [6:0] JALR_OP = 7'b1100111,
    parameter [6:0] BRANCH_OP = 7'b1100011,
    parameter [6:0] LOAD_OP = 7'b0000011,
    parameter [6:0] STORE_OP = 7'b0100011,
    parameter [6:0] I_TYPE_OP = 7'b0010011,
    parameter [6:0] R_TYPE_OP = 7'b0110011,
    parameter [6:0] SYSTEM_OP = 7'b1110011
) (
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

    assign data_to_reg = data_to_reg_prep(opcode, c, d, pc4, z_);
    assign data_to_csr = c;

    //
    // Functions
    //

    function [31:0] data_to_reg_prep(
        input [6:0] opcode,
        input [31:0] c,
        input [31:0] d,
        input [31:0] pc4,
        input [31:0] z_
    );
        reg is_load, is_jal, is_jalr, is_csr;

        begin
            is_load = (opcode == LOAD_OP);
            is_jal = (opcode == JAL_OP);
            is_jalr = (opcode == JALR_OP);
            is_csr = (opcode == SYSTEM_OP);    // NOTE: need to be careful of ecall, ebreak

            if (is_load) data_to_reg_prep = d;
            else if (is_jal || is_jalr) data_to_reg_prep = pc4;
            else if (is_csr) data_to_reg_prep = z_;
            else data_to_reg_prep = c;
        end
    endfunction
endmodule
