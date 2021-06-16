`include "ex_ctrl.v"
`include "alu.v"
`include "branch_alu.v"

module ex_stage (
    // inputs from ID stage
    input [3:0] ir_type,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] alu_in1,
    input [31:0] alu_in2,
    input [31:0] branch_alu_in1,
    input [31:0] branch_alu_in2,

    // outputs to MEM stage
    output jump,
    output [31:0] c
);

    wire [3:0] alu_op;
    wire [2:0] branch_alu_op;

    ex_ctrl ex_ctrl_inst(
        .ir_type(ir_type),
        .funct3(funct3),
        .funct7(funct7),
        .branch_alu_op(branch_alu_op),
        .alu_op(alu_op)
    );

    alu alu_inst(
        .in1(alu_in1),
        .in2(alu_in2),
        .alu_op(alu_op),
        .out(c)
    );

    branch_alu branch_alu_inst(
        .in1(branch_alu_in1),
        .in2(branch_alu_in2),
        .branch_alu_op(branch_alu_op),
        .out(jump)
    );

endmodule
