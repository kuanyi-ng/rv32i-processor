`include "ex_ctrl.v"
`include "alu.v"
`include "branch_alu.v"

module ex_stage (
    // inputs from ID stage
    input [3:0] ir_type,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] pc,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] imm,
    input [31:0] z_,

    // outputs to MEM stage
    output jump,
    output [31:0] c
);

    wire [31:0] in1;
    wire [31:0] in2;
    wire [3:0] alu_op;
    wire [2:0] branch_alu_op;

    ex_ctrl ex_ctrl_inst(
        .ir_type(ir_type),
        .funct3(funct3),
        .funct7(funct7),
        .data1(data1),
        .data2(data2),
        .pc(pc),
        .imm(imm),
        .z_(z_),
        .in1(in1),
        .in2(in2),
        .branch_alu_op(branch_alu_op),
        .alu_op(alu_op)
    );

    alu alu_inst(
        .in1(in1),
        .in2(in2),
        .alu_op(alu_op),
        .out(c)
    );

    branch_alu branch_alu_inst(
        .in1(data1),
        .in2(data2),
        .branch_alu_op(branch_alu_op),
        .out(jump)
    );

endmodule
