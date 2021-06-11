`include "constants/ir_type.v"
// check ir_type to determine the type of instruction
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
    input [3:0] ir_type,
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
        ir_type,
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
        input [3:0] ir_type,
        input [2:0] funct3,
        input is_mem_stage
    );
        // NOTE: don't forward data from EX stage
        // if the instruction executing in EX stage is a load instruction.
        begin
            case (ir_type)
                `LUI_IR: prep_data_to_forward = main;
                `AUIPC_IR: prep_data_to_forward = main;
                `REG_IMM_IR: prep_data_to_forward = main;
                `REG_REG_IR: prep_data_to_forward = main;
                `JAL_IR: prep_data_to_forward = sub;
                `JALR_IR: prep_data_to_forward = sub;
                `CSR_IR: prep_data_to_forward = csr;
                `LOAD_IR: prep_data_to_forward = (is_mem_stage) ? sub : 32'bx;

                // default includes Store, Branch Instruction
                default: prep_data_to_forward = 32'bx;
            endcase
        end
    endfunction
endmodule
