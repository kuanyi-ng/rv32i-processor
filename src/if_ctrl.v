module if_ctrl (
    input [31:0] pc4,
    input [31:0] c,
    input jump_or_branch,
    output [31:0] next_pc
);
    
    //
    // Main
    //
    assign next_pc = (jump_or_branch == 1'b1) ? c : pc4;
endmodule