module top (
    input clk,
    input rst_n,

    // Instructions Memory
    output [31:0] IAD,  // Instruction Address Bus
    input [31:0] IDT,   // Instruction Data Bus
    input ACKI_n,       // Acknowledge from Instruction Memory, 0: ready to access, 1: not ready

    // Data Memory
    output [31:0] DAD,  // Data Address Bus
    inout [31:0] DDT,   // Data Data Bus
    output MREQ,        // Memory Request, 0: don't access, 1: access
    output WRITE,       // Write to Data Memory, 0: don't write, 1: write
    output [1:0] SIZE,  // Access Size of Data Memory
    input ACKD_n        // Acknowledge from Data Memory, 0: ready to access, 1: not ready
);
    //
    // IF
    //

    wire [31:0] next_pc; 
    wire [31:0] current_pc;
    reg32 pc_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(next_pc),
        .default_in(32'h0001_0000),
        .out(current_pc)
    );

    if_stage if_stage_inst(
        .current_pc(current_pc),
        .c(32'd0),
        .jump_or_branch(1'd0),
        .next_pc(next_pc)
    );

    assign IAD = (ACKI_n == 1'b0) ? current_pc : 32'hZ;

    //
    // IF-ID
    //

    wire [31:0] pc_from_if;
    reg32 pc_if_id_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(current_pc),
        .default_in(32'h0001_0000),
        .out(pc_from_if)
    );

    wire [31:0] ir_from_if;
    reg32 ir_if_id_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(IDT),
        .default_in(32'hZ),
        .out(ir_from_if)
    );

    //
    // ID
    //

    wire [4:0] rd1_addr, rd2_addr;
    wire [4:0] rd_id;
    wire [6:0] opcode_id;
    wire [2:0] funct3_id;
    wire [6:0] funct7_id;
    wire [31:0] imm_id;
    id_stage id_stage_inst(
        .ir(ir_from_if),
        .rs1(rd1_addr),
        .rs2(rd2_addr),
        .rd(rd_id),
        .opcode(opcode_id),
        .funct3(funct3_id),
        .funct7(funct7_id),
        .imm(imm_id)
    );

    //
    // ID-EX
    //

    wire [31:0] pc_from_id;
    reg32 pc_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(pc_from_if),
        .default_in(32'hZ),
        .out(pc_from_id)
    );

    wire [31:0] data1_id, data2_id;
    wire [31:0] data1_from_id, data2_from_id;
    reg32 data1_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(data1_id),
        .default_in(32'h0),
        .out(data1_from_id)
    );
    reg32 data2_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(data2_id),
        .default_in(32'h0),
        .out(data2_from_id)
    );

    wire [6:0] funct7_from_id;
    reg7 funct7_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(funct7_id),
        .default_in(7'hZ),
        .out(funct7_from_id)
    );

    wire [2:0] funct3_from_id;
    reg3 funct3_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(funct3_id),
        .default_in(3'hZ),
        .out(funct3_from_id)
    );

    wire [4:0] rd_from_id;
    reg5 rd_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(rd_id),
        .default_in(5'hZ),
        .out(rd_from_id)
    );

    wire [6:0] opcode_from_id;
    reg7 opcode_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(opcode_id),
        .default_in(7'hZ),
        .out(opcode_from_id)
    );

    wire [31:0] imm_from_id;
    reg32 imm_id_ex_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(imm_id),
        .default_in(32'h0),
        .out(imm_from_id)
    );

    //
    // Register File
    //

    wire wr_n;
    wire [4:0] wr_addr;
    wire [31:0] data_in;
    rf32x32 regfile_inst(
        .clk(clk),
        .reset(rst_n),
        .wr_n(wr_n),
        .rd1_addr(rd1_addr),
        .rd2_addr(rd2_addr),
        .wr_addr(wr_addr),
        .data_in(data_in),
        .data1_out(data1_id),
        .data2_out(data2_id)
    );

endmodule
