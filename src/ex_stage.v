module ex_stage (
    // inputs from ID stage
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input [31:0] pc_from_id,
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] imm,
    input [4:0] rd,

    // outputs to MEM stage
    output jump_or_branch,
    output [31:0] b,
    output [31:0] c,
    output [4:0] reg_wr_addr    // same value as rd (pass over)
);

    wire in1_sel, in2_sel;
    wire [3:0] alu_op;
    wire [2:0] branch_alu_op;

    ex_ctrl ex_ctrl_inst(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .a_sel(in1_sel),
        .b_sel(in2_sel),
        .alu_op(alu_op),
        .branch_alu_op(branch_alu_op)
    );

    wire [31:0] in1;
    // A Multiplexer
    assign in1 = (in1_sel == 1'b1) ? pc_from_id : data1;

    wire [31:0] in2;
    // B Multiplexer
    assign in2 = (in2_sel == 1'b1) ? imm : data2;

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
        .out(jump_or_branch)
    );

    // pass over
    assign b = data2;   // used by store instructions
    assign reg_wr_addr = rd;

endmodule
