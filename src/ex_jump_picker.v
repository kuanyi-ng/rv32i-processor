`include "constants/ir_type.v"

module ex_jump_picker (
    // Inputs
    input [3:0] ir_type,
    input jump_prediction,
    input jump_from_branch_alu,
    input [31:0] addr_prediction,
    input [31:0] addr_from_alu,

    input flush_from_id,

    // Outputs
    output jump
);

    wire is_jump_ir = (ir_type == `JAL_IR) || (ir_type == `JALR_IR);
    wire is_jump_prediction_wrong = (jump_prediction != jump_from_branch_alu);
    wire is_addr_prediction_wrong = (addr_prediction != addr_from_alu);

    assign jump = jump_ctrl(flush_from_id, is_jump_ir, is_jump_prediction_wrong, is_addr_prediction_wrong);

    //
    // Function
    //

    function jump_ctrl(
        input flush,
        input is_jump_ir,
        input is_jump_prediction_wrong,
        input is_addr_prediction_wrong
    );
        begin
            if (flush) begin
                // Don't jump if this instruction is being flushed
                jump_ctrl = 1'b0;
            end else begin
                if (is_jump_ir) begin
                    // Only check prediction result if current instruction is an unconditional jump
                    jump_ctrl = (is_jump_prediction_wrong || is_addr_prediction_wrong);
                end else begin
                    // Else just follow the Branch ALU result
                    jump_ctrl = jump_from_branch_alu;
                end
            end
        end
    endfunction
endmodule
