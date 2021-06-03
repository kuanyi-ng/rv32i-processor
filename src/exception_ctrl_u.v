module exception_ctrl_u #(
    parameter [1:0] NOT_EXCEPTION = 2'b00,
    parameter [1:0] I_ADDR_MISALIGNMENT = 2'b01
) (
    // Program Counter
    input [31:0] pc_in_id,

    // Instruction Address Misalignment
    input i_addr_misaligned,

    // Jump
    input jump,

    // Outputs
    output exception_raised,
    output [1:0] exception_cause,
    output [31:0] exception_epc,
    output [31:0] exception_tval
);

    //
    // Main
    //

    assign exception_raised = exception_cause != NOT_EXCEPTION;
    assign exception_cause = cause_ctrl(i_addr_misaligned, jump);
    assign exception_epc = epc_ctrl(exception_cause, pc_in_id);
    assign exception_tval = tval_ctrl(exception_cause, pc_in_id);

    //
    // Function
    //

    function [1:0] cause_ctrl(input i_addr_misaligned, input jump);
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
            if (jump) cause_ctrl = NOT_EXCEPTION;
            else if (i_addr_misaligned) cause_ctrl = I_ADDR_MISALIGNMENT;
            else cause_ctrl = NOT_EXCEPTION;
        end
    endfunction

    function [31:0] epc_ctrl(input [1:0] cause, input [31:0] pc);
        begin
            if (cause == NOT_EXCEPTION) epc_ctrl = 32'h0001_0000;
            else epc_ctrl = pc;
        end
    endfunction

    function [31:0] tval_ctrl(input [1:0] cause, input [31:0] pc);
        begin
            case (cause)
                I_ADDR_MISALIGNMENT: tval_ctrl = pc;

                // include NOT_EXCEPTION
                default: tval_ctrl = 32'h0;
            endcase
        end
    endfunction
    
endmodule