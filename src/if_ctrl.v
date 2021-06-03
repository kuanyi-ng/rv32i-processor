module if_ctrl (
    input [31:0] pc4,
    input [31:0] c,
    input jump,
    input e_raised,
    input [31:0] e_handling_addr,

    output [31:0] next_pc
);
    
    //
    // Main
    //

    assign next_pc = next_pc_ctrl(pc4, c, jump, e_raised, e_handling_addr);

    //
    // Function
    //

    function [31:0] next_pc_ctrl(
        input [31:0] pc4,
        input [31:0] c,
        input jump,
        input e_raised,
        input [31:0] e_handling_addr
    );
        begin
           if (jump) next_pc_ctrl = c;
           else if (e_raised) next_pc_ctrl = e_handling_addr;
           else next_pc_ctrl = pc4;
        end
    endfunction

endmodule
