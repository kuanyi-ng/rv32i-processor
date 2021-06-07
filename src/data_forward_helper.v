`include "constants/opcode.v"
// check opcode to determine the type of instruction
//
// LUI      : x[rd] <- C => main_data
// AUIPC    : x[rd] <- C => main_data
// I-type   : x[rd] <- C => main_data
// R-type   : x[rd] <- C => main_data
// Load     : x[rd] <- D => sub_data
// Store    : doesn't update => X
// JAL      : x[rd] <- PC + 4 => sub_data
// JALR     : x[rd] <- PC + 4 => sub_data
// Branch   : doesn't update => X
// CSR      : x[rd] <- Z => csr_data
//
module data_forward_helper
#(
    parameter IS_MEM_STAGE = 1  // 0: ex, 1: mem
) (
    input [31:0] main_data,
    input [31:0] sub_data,
    input [31:0] csr_data,
    input [6:0] opcode,
    input [2:0] funct3,

    output [31:0] data_to_forward
);
    //
    // Main
    //
    
    assign data_to_forward = prep_data_to_forward(
        main_data,
        sub_data,
        csr_data,
        opcode,
        funct3,
        IS_MEM_STAGE
    );

    //
    // Functions
    //

    function [31:0] prep_data_to_forward(
        input [31:0] main,
        input [31:0] sub,
        input [31:0] csr,
        input [6:0] opcode,
        input [2:0] funct3,
        input is_mem_stage
    );
        // NOTE: don't forward data from EX stage
        // if the instruction executing in EX stage is a load instruction.
        reg is_lui, is_auipc, is_i_type, is_r_type, is_load, is_jal, is_jalr, is_csr;

        begin
            is_lui = (opcode == `LUI_OP);
            is_auipc = (opcode == `AUIPC_OP);
            is_i_type = (opcode == `I_TYPE_OP);
            is_r_type = (opcode == `R_TYPE_OP);
            is_load = (opcode == `LOAD_OP);
            is_jal = (opcode == `JAL_OP);
            is_jalr = (opcode == `JALR_OP);
            is_csr = (opcode == `SYSTEM_OP) && (funct3 != 3'b000);

            if (is_lui || is_auipc || is_i_type || is_r_type) begin
                prep_data_to_forward = main;
            end else if (is_jal || is_jalr) begin
                prep_data_to_forward = sub;
            end else if (is_csr) begin
                prep_data_to_forward = csr;
            end else if (is_load) begin
                prep_data_to_forward = (is_mem_stage) ? sub : 32'bx;
            end else begin
                // includes Store, Branch instructions
                prep_data_to_forward = 32'bx;
            end
        end
    endfunction
endmodule