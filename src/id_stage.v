// stage-level module
module id_stage (
    input clk,              // one clock cycle: 0 -> 1
    input rst_n,            // reset when 0

    // inputs from higher level module
    input wr_n,             // regfile write enable: allow write when 0
    input [4:0] wr_addr,    // write address of regfile
    input [31:0] data_in,   // data to write into wr_addr

    // inputs from IF stage
    input [31:0] pc_from_if,
    input [31:0] ir,

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

    wire [4:0] rs1;
    wire [4:0] rs2;

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

    rf32x32 regfile32_inst(
        .clk(clk),
        .reset(rst_n),
        .wr_n(wr_n),
        .rd1_addr(rs1),
        .rd2_addr(rs2),
        .wr_addr(wr_addr),
        .data_in(data_in),
        .data1_out(data1),
        .data2_out(data2)
    );

    // direct pc_from_if to pc_to_ex
    assign pc_to_ex = pc_from_if;

endmodule
