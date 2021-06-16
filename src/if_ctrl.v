module if_ctrl (
    // Inputs from IF Stage
    input [31:0] pc4,
    input jump_prediction,
    input [31:0] addr_prediction,

    // Inputs from ID Stage
    input e_raised,
    input [31:0] e_handling_addr,

    // Inputs from EX Stage
    input [31:0] jump_addr,
    input [31:0] c,
    input jump,

    // Output to IF Stage
    output [31:0] next_pc
);
    
    //
    // Main
    //

    assign next_pc = next_pc_ctrl(
        pc4,
        jump_prediction,
        addr_prediction,
        e_raised,
        e_handling_addr,
        jump_addr,
        c,
        jump
    );

    //
    // Function
    //

    function [31:0] next_pc_ctrl(
        input [31:0] pc4,
        input jump_prediction,
        input [31:0] addr_prediction,

        input e_raised,
        input [31:0] e_handling_addr,

        input [31:0] jump_addr,
        input [31:0] c,
        input jump
    );
        begin
            // When instruction in EX wants to jump,
            // instruction in ID won't get executed,
            // so the exception raised in ID stage can be ignored.
            //
            // When an exception happens,
            // instruction in IF won't get executed,
            // so don't have to fetch addr_prediction next.
            //
            // Priority:
            // jump (EX) > exception (ID) > prediction (IF) > pc4 (IF)
            if (jump) next_pc_ctrl = jump_addr;
            else if (e_raised) next_pc_ctrl = e_handling_addr;
            else if (jump_prediction) next_pc_ctrl = addr_prediction;
            else next_pc_ctrl = pc4;
        end
    endfunction

endmodule
