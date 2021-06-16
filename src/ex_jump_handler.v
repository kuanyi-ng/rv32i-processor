`include "constants/ir_type.v"

module ex_jump_handler (
    // Inputs
    input [3:0] ir_type,
    input jump_prediction,
    input jump_from_branch_alu,
    input [31:0] addr_prediction,
    input [31:0] addr_from_alu,
    input [31:0] pc4,

    input flush_from_id,

    // Outputs
    output jump,
    output [31:0] jump_addr
);

    wire is_jump_ir = (ir_type == `JAL_IR) || (ir_type == `JALR_IR) || (ir_type == `BRANCH_IR);
    wire is_jump_prediction_wrong = (jump_prediction != jump_from_branch_alu);
    // check if addr_prediction is wrong
    // This is possible when 2 instructions (M, N) with different pc shares the same entry in prediction table.
    // M has target_addr of O, while N has target_addr of P.
    // If M's entry is initialized before N and has a state of 1,
    // when instruction N is fetch, jump_prediction = 1, addr_prediction = O,
    // even though the jump prediction is correct, execution jumped to the wrong addr.
    // So fixes are required. => need to jump
    //
    // Don't really care about correctness of addr_prediction if jump_prediction = 0
    // cause there's no risk of jumping to the wrong addr due to prediction.
    wire is_addr_prediction_wrong = (jump_prediction == 1'b1) && (addr_prediction != addr_from_alu);

    assign jump = jump_ctrl(
        flush_from_id,
        is_jump_ir,
        is_jump_prediction_wrong,
        is_addr_prediction_wrong
    );
    assign jump_addr = (jump_from_branch_alu) ? addr_from_alu : pc4;

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
                    jump_ctrl = (is_jump_prediction_wrong || is_addr_prediction_wrong);
                end else begin
                    // Else just follow the Branch ALU result
                    jump_ctrl = jump_from_branch_alu;
                end
            end
        end
    endfunction
endmodule
