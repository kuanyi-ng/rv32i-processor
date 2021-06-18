`include "pc_adder.v"
`include "if_ctrl.v"

module if_stage (
    // Inputs from IF Stage
    input [31:0] current_pc,
    input jump_prediction,
    input [31:0] addr_prediction,
    // Inputs from ID Stage
    input e_raised,
    input [31:0] e_handling_addr,
    // Inputs from EX Stage
    input [31:0] jump_addr,
    input jump,

    output [31:0] pc4,
    output [31:0] next_pc,
    output i_addr_misaligned
);

    pc_adder if_pc_adder(
        .in(current_pc),
        .out(pc4)
    );

    if_ctrl if_ctrl_inst(
        .pc4(pc4),
        .jump_prediction(jump_prediction),
        .addr_prediction(addr_prediction),
        .e_raised(e_raised),
        .e_handling_addr(e_handling_addr),
        .jump_addr(jump_addr),
        .jump(jump),
        .next_pc(next_pc)
    );
    
    // Detection for Instruction Address Misalignment
    //
    // Instructions are stored in Imem with address of mulitple of 4.
    // Allowed value for lower 2 bits of instruction address are { 0, 4, 8, c }
    // which lower 2 bits are 00 in binary.
    assign i_addr_misaligned = current_pc[1:0] != 2'b00;

endmodule
