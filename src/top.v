`include "reg32.v"
`include "if_stage.v"
`include "if_id_regs.v"
`include "id_stage.v"
`include "id_ex_regs.v"
`include "rf32x32.v"
`include "ex_stage.v"
`include "ex_mem_regs.v"
`include "mem_stage.v"
`include "mem_wb_regs.v"
`include "wb_stage.v"

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
    wire [31:0] ir_from_if;
    if_id_regs if_id_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(current_pc),
        .pc_out(pc_from_if),
        .ir_in(IDT),
        .ir_out(ir_from_if)
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
    wire [31:0] data1_id, data2_id;
    wire [31:0] data1_from_id, data2_from_id;
    wire [6:0] funct7_from_id;
    wire [2:0] funct3_from_id;
    wire [4:0] rd_from_id;
    wire [6:0] opcode_from_id;
    wire [31:0] imm_from_id;
    id_ex_regs id_ex_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_from_if),
        .pc_out(pc_from_id),
        .data1_in(data1_id),
        .data1_out(data1_from_id),
        .data2_in(data2_id),
        .data2_out(data2_from_id),
        .funct7_in(funct7_id),
        .funct7_out(funct7_from_id),
        .funct3_in(funct3_id),
        .funct3_out(funct3_from_id),
        .rd_in(rd_id),
        .rd_out(rd_from_id),
        .opcode_in(opcode_id),
        .opcode_out(opcode_from_id),
        .imm_in(imm_id),
        .imm_out(imm_from_id)
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
    wire jump_from_ex;
    wire [31:0] b_from_ex;
    wire [31:0] c_from_ex;
    wire [2:0] funct3_from_ex;
    wire [6:0] opcode_from_ex;
    wire [4:0] rd_from_ex;
    ex_mem_regs ex_mem_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_from_id),
        .pc_out(pc_from_ex),
        .jump_in(jump_ex),
        .jump_out(jump_from_ex),
        .b_in(b_ex),
        .b_out(b_from_ex),
        .c_in(c_ex),
        .c_out(c_from_ex),
        .funct3_in(funct3_from_id),
        .funct3_out(funct3_from_ex),
        .rd_in(rd_from_id),
        .rd_out(rd_from_ex),
        .opcode_in(opcode_from_id),
        .opcode_out(opcode_from_ex)
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
    wire [31:0] d_from_mem;
    wire [6:0] opcode_from_mem;
    mem_wb_regs mem_wb_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .pc_in(pc_from_ex),
        .pc_out(pc_from_mem),
        .jump_in(jump_from_ex),
        .jump_out(jump_from_mem),
        .c_in(c_from_ex),
        .c_out(c_from_mem),
        .d_in(d_mem),
        .d_out(d_from_mem),
        .rd_in(rd_from_ex),
        .rd_out(wr_addr),
        .opcode_in(opcode_from_ex),
        .opcode_out(opcode_from_mem)
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
