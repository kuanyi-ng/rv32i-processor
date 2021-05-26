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
    parameter [6:0] CSR_OP = 7'b1110011
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

    //
    // Local Parameters
    //

    localparam [3:0] ADD = 4'b0000;
    localparam [3:0] SLL = 4'b0001;
    localparam [3:0] SLT = 4'b0010;
    localparam [3:0] SLTU = 4'b0011;
    localparam [3:0] XOR = 4'b0100;
    localparam [3:0] SRL = 4'b0101;
    localparam [3:0] OR = 4'b0110;
    localparam [3:0] AND = 4'b0111;
    localparam [3:0] SUB = 4'b1000;
    localparam [3:0] CP_IN2 = 4'b1001;
    localparam [3:0] JALR = 4'b1010;
    localparam [3:0] CSRRC = 4'b1011;
    localparam [3:0] SRA = 4'b1101;

    localparam [2:0] EQ = 3'b000;
    localparam [2:0] NE = 3'b001;
    localparam [2:0] JUMP = 3'b010;
    localparam [2:0] NO_JUMP = 3'b011;
    localparam [2:0] LT = 3'b100;
    localparam [2:0] GE = 3'b101;
    localparam [2:0] LTU = 3'b110;
    localparam [2:0] GEU = 3'b11;

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
        .CSR_OP(CSR_OP),
        .ADD(ADD),
        .OR(OR),
        .CP_IN2(CP_IN2),
        .CSRRC(CSRRC),
        .JUMP(JUMP),
        .NO_JUMP(NO_JUMP)
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

    alu #(
        .ADD(ADD),
        .SLL(SLL),
        .SLT(SLT),
        .SLTU(SLTU),
        .XOR(XOR),
        .SRL(SRL),
        .OR(OR),
        .AND(AND),
        .SUB(SUB),
        .CP_IN2(CP_IN2),
        .JALR(JALR),
        .CSRRC(CSRRC),
        .SRA(SRA)
    ) alu_inst(
        .in1(in1),
        .in2(in2),
        .alu_op(alu_op),
        .out(c)
    );

    branch_alu #(
        .EQ(EQ),
        .NE(NE),
        .JUMP(JUMP),
        .NO_JUMP(NO_JUMP),
        .LT(LT),
        .GE(GE),
        .LTU(LTU),
        .GEU(GEU)
    ) branch_alu_inst(
        .in1(data1),
        .in2(data2),
        .branch_alu_op(branch_alu_op),
        .out(jump)
    );

endmodule
