module if_ctrl (
    input [31:0] pc4,
    input [31:0] c,
    input jump,
    output [31:0] next_pc
);
    
    //
    // Main
    //
    assign next_pc = (jump == 1'b1) ? c : pc4;
endmodule