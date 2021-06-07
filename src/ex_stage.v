`include "ex_ctrl.v"
`include "alu.v"
`include "branch_alu.v"

module ex_stage
#(
    parameter [6:0] LUI_OP = 7'b0110111,
    parameter [6:0] AUIPC_OP = 7'b0010111,
    parameter [6:0] JAL_OP = 7'b1101111,
    parameter [6:0] JALR_OP = 7'b1100111,
    parameter [6:0] BRANCH_OP = 7'b1100011,
    parameter [6:0] LOAD_OP = 7'b0000011,
    parameter [6:0] STORE_OP = 7'b0100011,
    parameter [6:0] I_TYPE_OP = 7'b0010011,
    parameter [6:0] R_TYPE_OP = 7'b0110011,
    parameter [6:0] SYSTEM_OP = 7'b1110011
) (
    // inputs from ID stage
    input [6:0] opcode,
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

    ex_ctrl #(
        .LUI_OP(LUI_OP),
        .AUIPC_OP(AUIPC_OP),
        .JAL_OP(JAL_OP),
        .JALR_OP(JALR_OP),
        .BRANCH_OP(BRANCH_OP),
        .LOAD_OP(LOAD_OP),
        .STORE_OP(STORE_OP),
        .I_TYPE_OP(I_TYPE_OP),
        .R_TYPE_OP(R_TYPE_OP),
        .SYSTEM_OP(SYSTEM_OP)
    ) ex_ctrl_inst(
        .opcode(opcode),
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
