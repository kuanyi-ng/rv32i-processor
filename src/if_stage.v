module if_stage (
    input [31:0] current_pc,
    input [31:0] c,
    input jump_or_branch,
    output [31:0] next_pc
);

    wire [31:0] pc4;

    pc_adder if_pc_adder(
        .in(current_pc),
        .out(pc4)
    );

    if_ctrl if_ctrl_inst(
        .pc4(pc4),
        .c(c),
        .jump_or_branch(jump_or_branch),
        .next_pc(next_pc)
    );
    
endmodule