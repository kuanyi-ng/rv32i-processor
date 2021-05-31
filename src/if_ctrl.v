module if_ctrl #(
    parameter [1:0] NOT_EXCEPTION = 2'b00
) (
    input [31:0] pc4,
    input [31:0] c,
    input jump,
    input [1:0] exception_cause,
    input [31:0] exception_handling_addr,

    output [31:0] next_pc
);
    
    //
    // Main
    //

    assign next_pc = next_pc_ctrl(pc4, c, jump, exception_cause, exception_handling_addr);

    //
    // Function
    //

    function [31:0] next_pc_ctrl(
        input [31:0] pc4,
        input [31:0] c,
        input jump,
        input [1:0] exception_cause,
        input [31:0] exception_handling_addr
    );
        begin
           if (jump) next_pc_ctrl = c;
           else if (exception_cause != NOT_EXCEPTION) next_pc_ctrl = exception_handling_addr;
           else next_pc_ctrl = pc4;
        end
    endfunction

endmodule
