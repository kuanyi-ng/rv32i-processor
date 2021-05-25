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
    output [31:0] data_to_forward
);
    //
    // Main
    //
    
    assign data_to_forward = prep_data_to_forward(main_data, sub_data, csr_data, opcode, IS_MEM_STAGE);

    //
    // Functions
    //

    function [31:0] prep_data_to_forward(
        input [31:0] main,
        input [31:0] sub,
        input [31:0] csr,
        input [6:0] opcode,
        input is_mem_stage
    );
        // NOTE: don't forward data from EX stage
        // if the instruction executing in EX stage is a load instruction.
        reg is_lui, is_auipc, is_i_type, is_r_type, is_load, is_jal, is_jalr, is_csr;

        begin
            is_lui = (opcode == 7'b0110111);
            is_auipc = (opcode == 7'b0010111);
            is_i_type = (opcode == 7'b0010011);
            is_r_type = (opcode == 7'b0110011);
            is_load = (opcode == 7'b0000011);
            is_jal = (opcode == 7'b1101111);
            is_jalr = (opcode == 7'b1100111);
            is_csr = (opcode == 7'b1110011);    // NOTE: need to be careful for ebreak, ecall

            if (is_lui || is_auipc || is_i_type || is_r_type) begin
                prep_data_to_forward = main;
            end else if (is_jal || is_jalr) begin
                prep_data_to_forward = sub;
            end else if (is_csr) begin
                prep_data_to_forward = csr;
            end else if (is_load && is_mem_stage) begin
                prep_data_to_forward = sub;
            end else begin
                // includes Store, Branch instructions
                prep_data_to_forward = 32'bx;
            end
        end
    endfunction
endmodule