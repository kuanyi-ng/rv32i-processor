`include "constants/exception_cause.v"

module exception_ctrl_u (
    // Program Counter
    input [31:0] pc_in_id,

    // Instruction Address Misalignment
    input i_addr_misaligned,

    // Illegal Instruction
    input is_illegal_ir,
    input [31:0] ir_in_id,

    // ECALL
    input is_ecall,

    // Flush
    input flush,

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
    assign e_cause = cause_ctrl(i_addr_misaligned, is_illegal_ir, is_ecall, flush);
    assign e_pc = epc_ctrl(e_cause, pc_in_id);
    assign e_tval = tval_ctrl(e_cause, pc_in_id, ir_in_id);

    //
    // Function
    //

    function [1:0] cause_ctrl(input i_addr_misaligned, input is_illegal_ir, input is_ecall, input flush);
        begin
            // Don't raise Exception when flush
            // because this instruction will not be executed due to flush
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
            if (flush) cause_ctrl = `NOT_EXCEPTION;
            // Priority of Exception:
            // I_ADDR_MISALIGNMENT > ECALL
            //
            // In general, checking ILLEGAL_IR before I_ADDR_MISALIGNED should be correct (based on the priority level).
            // However, if both is_illegal_ir and i_addr_misaligned are active,
            // it can be deduced that the is_illegal_ir is caused by i_addr_misaligned.
            //
            // is_illegal_ir   |   i_addr_misaligned   |   cause
            // 0            |   0                   |   check ecall
            // 0            |   1                   |   I_ADDR_MISALIGNMENT
            // 1            |   0                   |   ILLEGAL_IR
            // 1            |   1                   |   I_ADDR_MISALIGNMENT
            //
            // So we check for i_addr_misaligned first here.
            else if (i_addr_misaligned) cause_ctrl = `I_ADDR_MISALIGNMENT;
            else if (is_illegal_ir) cause_ctrl = `ILLEGAL_IR;
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

    function [31:0] tval_ctrl(input [1:0] cause, input [31:0] pc, input [31:0] ir);
        begin
            case (cause)
                `I_ADDR_MISALIGNMENT: tval_ctrl = pc;

                `ILLEGAL_IR: tval_ctrl = ir;

                // include NOT_EXCEPTION, ECALL
                default: tval_ctrl = 32'h0;
            endcase
        end
    endfunction
    
endmodule