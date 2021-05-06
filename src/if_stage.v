`include "pc_adder.v"
`include "if_ctrl.v"

module if_stage (
    input [31:0] current_pc,
    input [31:0] c,
    input jump,
    output [31:0] pc4,
    output [31:0] next_pc
);

    pc_adder if_pc_adder(
        .in(current_pc),
        .out(pc4)
    );

    if_ctrl if_ctrl_inst(
        .pc4(pc4),
        .c(c),
        .jump(jump),
        .next_pc(next_pc)
    );
    
endmodule