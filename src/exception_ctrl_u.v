module exception_ctrl_u #(
    parameter [1:0] NOT_EXCEPTION = 2'b00,
    parameter [1:0] I_ADDR_MISALIGNMENT = 2'b01,
    parameter [1:0] ILLEGAL_IR = 2'b10
) (
    // current pc
    input [31:0] current_pc,

    // Instruction Address Misalignment
    input i_addr_misaligned,
    input [31:0] pc_of_i_addr_misaligned,

    // Illegal Instruction
    input illegal_ir,
    input [31:0] ir_in_question,
    input [31:0] pc_of_illegal_ir,

    // Jump
    input jump,

    // Outputs
    output [1:0] exception_cause,
    output [31:0] exception_epc,
    output [31:0] exception_tval
);

    //
    // Main
    //

    wire is_first_instruction = (current_pc == 32'h0001_0000);

    assign exception_cause = cause_ctrl(i_addr_misaligned, illegal_ir, is_first_instruction, jump);
    assign exception_epc = epc_ctrl(exception_cause, pc_of_i_addr_misaligned, pc_of_illegal_ir);
    assign exception_tval = tval_ctrl(exception_cause, pc_of_i_addr_misaligned, ir_in_question);

    //
    // Function
    //

    function [1:0] cause_ctrl(input i_addr_misaligned, input illegal_ir, input is_first_instruction, input jump);
        begin
            // Don't raise Exception when this is the first instruction in execution
            // Don't raise Exception when jump
            // because this instruction will not be executed due to jump
            if (is_first_instruction || jump) cause_ctrl = NOT_EXCEPTION;
            else if (illegal_ir) cause_ctrl = ILLEGAL_IR;
            else if (i_addr_misaligned) cause_ctrl = I_ADDR_MISALIGNMENT;
            else cause_ctrl = NOT_EXCEPTION;
        end
    endfunction

    function [31:0] epc_ctrl(input [1:0] cause, input [31:0] pc_of_i_addr_misaligned, input [31:0] pc_of_illegal_ir);
        begin
            case (cause)
                ILLEGAL_IR: epc_ctrl = pc_of_illegal_ir;

                I_ADDR_MISALIGNMENT: epc_ctrl = pc_of_i_addr_misaligned;
                
                // set to default pc
                // include NOT_EXCEPTION
                default: epc_ctrl = 32'h0001_0000;
            endcase
        end
    endfunction

    function [31:0] tval_ctrl(input [1:0] cause, input [31:0] pc_of_i_addr_misaligned, input [31:0] ir_in_question);
        begin
            case (cause)
                ILLEGAL_IR: tval_ctrl = ir_in_question;

                I_ADDR_MISALIGNMENT: tval_ctrl = pc_of_i_addr_misaligned;

                // include NOT_EXCEPTION
                default: tval_ctrl = 32'h0;
            endcase
        end
    endfunction

endmodule
