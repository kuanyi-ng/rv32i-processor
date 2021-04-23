module top (
    input clk,
    input rst_n,

    // Instructions Memory
    output [31:0] IAD,  // Instruction Address Bus
    input [31:0] IDT,   // Instruction Data Bus
    input ACKI_n,       // Acknowledge from Instruction Memory, 0: ready to access, 1: not ready

    // Interuption
    input [2:0] OINT_n,
    output IACK_n,

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

    wire [31:0] c_from_mem;
    wire jump_from_mem;
    if_stage if_stage_inst(
        .current_pc(current_pc),
        .c(c_from_mem),
        .jump_or_branch(jump_from_mem),
        .next_pc(next_pc)
    );
    assign IAD = (ACKI_n == 1'b0) ? current_pc : 32'hx;

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
    // assign wr_n = wr_wb_n;
    // assign data_in = data_in_wb;
    // assign wr_addr = rd_from_mem;

    //
    // EX
    //

    wire jump_ex;
    wire [31:0] b_ex, c_ex;
    ex_stage ex_stage_inst(
        .opcode(opcode_from_id),
        .funct3(funct3_from_id),
        .funct7(funct7_from_id),
        .pc(pc_from_id),
        .data1(data1_from_id),
        .data2(data2_from_id),
        .imm(imm_from_id),
        .jump(jump_ex),
        .b(b_ex),
        .c(c_ex)
    );

    //
    // EX-MEM
    //

    wire [31:0] pc_from_ex;
    reg32 pc_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(pc_from_id),
        .default_in(32'hZ),
        .out(pc_from_ex)
    );

    wire jump_from_ex;
    reg1 jump_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(jump_ex),
        .default_in(1'b0),
        .out(jump_from_ex)
    );

    wire [31:0] b_from_ex;
    reg32 b_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(b_ex),
        .default_in(32'hZ),
        .out(b_from_ex) 
    );

    wire [31:0] c_from_ex;
    reg32 c_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(c_ex),
        .default_in(32'hZ),
        .out(c_from_ex)
    );

    wire [2:0] funct3_from_ex;
    reg3 funct3_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(funct3_from_id),
        .default_in(3'hZ),
        .out(funct3_from_ex)
    );

    wire [6:0] opcode_from_ex;
    reg7 opcode_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(opcode_from_id),
        .default_in(7'hZ),
        .out(opcode_from_ex)
    );

    wire [4:0] rd_from_ex;
    reg5 rd_ex_mem_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(rd_from_id),
        .default_in(5'hZ),
        .out(rd_from_ex)
    );

    //
    // MEM
    //

    wire [31:0] data_from_mem, data_to_mem;
    wire [31:0] d_mem;
    mem_stage mem_stage_inst(
        .data_mem_ready_n(ACKD_n),
        .data_from_mem(data_from_mem),
        .opcode(opcode_from_ex),
        .funct3(funct3_from_ex),
        .b(b_from_ex),
        .c(c_from_ex),
        .d(d_mem),
        .require_mem_access(MREQ),
        .write(WRITE),
        .size(SIZE),
        .data_to_mem(data_to_mem)
    );
    assign DAD = c_from_ex;
    assign data_from_mem = DDT;
    assign DDT = (WRITE) ? data_to_mem : 32'bz;

    //
    // MEM-WB
    //

    wire [31:0] pc_from_mem;
    reg32 pc_mem_wb_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(pc_from_ex),
        .default_in(32'hZ),
        .out(pc_from_mem)
    );

    reg1 jump_mem_wb_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(jump_from_ex),
        .default_in(1'b0),
        .out(jump_from_mem)
    );

    reg32 c_mem_wb_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(c_from_ex),
        .default_in(32'hZ),
        .out(c_from_mem)
    );

    wire [6:0] opcode_from_mem;
    reg7 opcode_mem_wb_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(opcode_from_ex),
        .default_in(7'hZ),
        .out(opcode_from_mem)
    );

    wire [31:0] d_from_mem;
    reg32 d_mem_wb_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(d_mem),
        .default_in(32'hZ),
        .out(d_from_mem)
    );

    reg5 rd_mem_wb_reg(
        .clk(clk),
        .rst_n(rst_n),
        .in(rd_from_ex),
        .default_in(5'hZ),
        .out(wr_addr)
    );

    //
    // WB
    //
    
    wb_stage wb_stage_inst(
        .opcode(opcode_from_mem),
        .c(c_from_mem),
        .d(d_from_mem),
        .pc(pc_from_mem),
        .write_n(wr_n),
        .data_to_reg(data_in)
    );

endmodule
