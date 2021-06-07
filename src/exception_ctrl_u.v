`include "constants/exception_cause.v"

module exception_ctrl_u (
    // Program Counter
    input [31:0] pc_in_id,

    // Instruction Address Misalignment
    input i_addr_misaligned,

    // ECALL
    input is_ecall,

    // Jump
    input jump,

    // Outputs
    output e_raised,
    output [1:0] e_cause,
    output [31:0] e_pc,
    output [31:0] e_tval
);

    //
    // Main
    //

    assign e_raised = e_cause != `NOT_EXCEPTION;
    assign e_cause = cause_ctrl(i_addr_misaligned, is_ecall, jump);
    assign e_pc = epc_ctrl(e_cause, pc_in_id);
    assign e_tval = tval_ctrl(e_cause, pc_in_id);

    //
    // Function
    //

    function [1:0] cause_ctrl(input i_addr_misaligned, input is_ecall, input jump);
        begin
            // Don't raise Exception when jump
            // because this instruction will not be executed due to jump
            //
            // NOTE:
            // i_addr_misaligned signal is passed on from IF to ID stage.
            // so if there's a situation like below:
            //  F: i_addr_misaligned = 1,
            //  D: branch ir (branch result not clear)
            // passing on i_addr_misaligned signal to ID stage will produce the below situation:
            //  D: i_addr_misaligned = 1,
            //  E: branch ir (branch result known)
            // with the knowledge of branch result, it's easier to decide whether to raise an exception or not
            // even though the i_addr_misaligned is detected in IF stage
            if (jump) cause_ctrl = `NOT_EXCEPTION;
            // Priority of Exception:
            // I_ADDR_MISALIGNMENT > ECALL
            else if (i_addr_misaligned) cause_ctrl = `I_ADDR_MISALIGNMENT;
            else if (is_ecall) cause_ctrl = `ECALL;
            else cause_ctrl = `NOT_EXCEPTION;
        end
    endfunction

    function [31:0] epc_ctrl(input [1:0] cause, input [31:0] pc);
        begin
            if (cause == `NOT_EXCEPTION) epc_ctrl = 32'h0001_0000;
            else epc_ctrl = pc;
        end
    endfunction

    function [31:0] tval_ctrl(input [1:0] cause, input [31:0] pc);
        begin
            case (cause)
                `I_ADDR_MISALIGNMENT: tval_ctrl = pc;

                // include NOT_EXCEPTION, ECALL
                default: tval_ctrl = 32'h0;
            endcase
        end
    endfunction
    
endmodule