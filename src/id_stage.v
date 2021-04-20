// stage-level module
module id_stage (
    // inputs from IF stage
    input [31:0] pc_from_if,
    input [31:0] ir,

    // outputs to Register File
    output [4:0] rs1,
    output [4:0] rs2,

    // inputs from Register File (read)
    input [31:0] data1_from_regfile,
    input [31:0] data2_from_regfile,

    // outputs to EX stage
    output [31:0] pc_to_ex,
    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,
    output [31:0] data1,
    output [31:0] data2,
    output [31:0] imm,
    output [4:0] rd
);

    ir_splitter ir_splitter_inst(
        .ir(ir),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7)
    );

    wire [2:0] imm_type;

    opcode_funct3_to_imm_type opcode_funct3_to_imm_type_inst(
        .opcode(opcode),
        .funct3(funct3),
        .imm_type(imm_type)
    );

    imm_extractor imm_extractor_inst(
        .in(ir),
        .imm_type(imm_type),
        .out(imm)
    );

    // direct pc_from_if to pc_to_ex
    // NOTE: might not be a good idea to pass pc directly
    // pc read at IF stage might overwrite
    // (old) pc that are passed over other stages.
    assign pc_to_ex = pc_from_if;

    assign data1 = data1_from_regfile;
    assign data2 = data2_from_regfile;

endmodule
