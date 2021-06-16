`include "csrs.v"
`include "csr_forward_u.v"
`include "data_forward_helper.v"
`include "data_forward_u.v"
`include "ex_data_picker.v"
`include "ex_jump_picker.v"
`include "ex_mem_regs.v"
`include "ex_stage.v"
`include "exception_ctrl_u.v"
`include "flush_u.v"
`include "id_data_picker.v"
`include "id_ex_regs.v"
`include "id_flush_picker.v"
`include "id_stage.v"
`include "id_wr_n_picker.v"
`include "id_z_picker.v"
`include "if_flush_picker.v"
`include "if_id_regs.v"
`include "if_stage.v"
`include "interlock_u.v"
`include "ir_type_converter.v"
`include "mem_stage.v"
`include "mem_wb_regs.v"
`include "pc_reg.v"
`include "rf32x32.v"
`include "stall_detector.v"
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
    // Wire Definition
    //

    // IF
    wire [31:0] current_pc;
    wire [31:0] next_pc;
    wire [31:0] pc4_if;
    wire [3:0] ir_type_if;

    // IF-ID
    wire [31:0] pc_from_if;
    wire [31:0] pc4_from_if;
    wire [31:0] ir_from_if;
    wire [3:0] ir_type_from_if;
    wire flush_from_if;

    // ID
    wire [2:0] funct3_id;
    wire [4:0] rd1_addr, rd2_addr, rd_id;
    wire [6:0] funct7_id;
    wire [11:0] csr_addr_id;
    wire [31:0] data1_regfile, data2_regfile;
    wire [31:0] data1_id, data2_id;
    wire [31:0] imm_id;
    wire [31:0] z_csrs;
    wire [31:0] z_id;
    wire wr_reg_n_id_stage;
    wire wr_csr_n_id_stage;
    wire wr_reg_n_id;
    wire wr_csr_n_id;
    wire is_mret_id;
    wire is_ecall_id;

    // ID-EX
    wire [31:0] pc_from_id;
    wire [31:0] pc4_from_id;
    wire [31:0] data1_from_id, data2_from_id;
    wire [3:0] ir_type_from_id;
    wire [6:0] funct7_from_id;
    wire [2:0] funct3_from_id;
    wire [4:0] rs2_from_id, rd_from_id;
    wire [11:0] csr_addr_from_id;
    wire [31:0] imm_from_id;
    wire [31:0] z_from_id;
    wire wr_reg_n_from_id;
    wire wr_csr_n_from_id;
    wire flush_from_id;

    // EX
    wire [31:0] b_ex;
    wire [31:0] c_ex;
    wire jump_from_branch_alu;
    wire jump_ex;

    // EX-MEM
    wire [2:0] funct3_from_ex;
    wire [4:0] rd_from_ex;
    wire [3:0] ir_type_from_ex;
    wire [11:0] csr_addr_from_ex;
    wire [31:0] pc4_from_ex;
    wire [31:0] b_from_ex;
    wire [31:0] z_from_ex;
    wire [31:0] c_from_ex;
    wire wr_reg_n_from_ex;
    wire wr_csr_n_from_ex;
    wire flush_from_ex;

    // MEM
    wire [31:0] data_from_mem, data_to_mem;
    wire [31:0] d_mem;

    // MEM-WB
    wire [3:0] ir_type_from_mem;
    wire [31:0] pc4_from_mem;
    wire [31:0] c_from_mem;
    wire [31:0] d_from_mem;
    wire [31:0] z_from_mem;

    // WB
    wire wr_csr_n_from_mem;

    // Register File
    wire wr_n;
    wire [4:0] wr_addr;
    wire [31:0] data_in;

    // CSRs
    wire [11:0] csr_wr_addr;
    wire [31:0] csr_data_in;

    // Data Forwarding
    // Data Forwarding (ID)
    wire [1:0] forward_data1, forward_data2;
    wire [31:0] data_forwarded_from_ex, data_forwarded_from_mem;
    // Data Forwarding (CSRs)
    wire [1:0] forward_z;
    // Data Forwarding (EX)
    wire forward_b;

    // Pipeline Stalling
    wire stall;

    // Pipeline Flush
    wire flush;
    // Pipelin Flush (IF)
    wire flush_if;
    // Pipeline Flush (ID)
    wire flush_id;

    // Pipeline Interlock
    wire interlock;

    // Exception Handling
    wire i_addr_misaligned_if;
    wire i_addr_misaligned_from_if;
    wire is_illegal_ir_id;

    wire e_raised;
    wire [1:0] e_cause;
    wire [31:0] e_pc;
    wire [31:0] e_tval;
    wire [31:0] trap_vector_addr;
    wire is_e_cause_eq_ecall;

    //
    // Modules Instantiation
    //

    // IF
    pc_reg pc_reg_inst(
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .interlock(interlock),
        .pc_in(next_pc),
        .pc_out(current_pc)
    );

    if_stage if_stage_inst(
        .current_pc(current_pc),
        .c(c_ex),
        .jump(jump_ex),
        .e_raised(e_raised),
        .e_handling_addr(trap_vector_addr),
        .pc4(pc4_if),
        .next_pc(next_pc),
        .i_addr_misaligned(i_addr_misaligned_if)
    );
    assign IAD = current_pc;

    ir_type_converter ir_type_convert_inst(
        .opcode(IDT[6:0]),
        .funct3(IDT[14:12]),
        .ir_type(ir_type_if)
    );

    if_flush_picker if_flush_picker_inst(
        .e_raised(e_raised),
        .flush_from_flush_u(flush),
        .flush_out(flush_if)
    );

    // IF-ID
    if_id_regs if_id_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .interlock(interlock),
        .pc_in(current_pc),
        .pc_out(pc_from_if),
        .pc4_in(pc4_if),
        .pc4_out(pc4_from_if),
        .ir_in(IDT),
        .ir_out(ir_from_if),
        .ir_type_in(ir_type_if),
        .ir_type_out(ir_type_from_if),
        .flush_in(flush_if),
        .flush_out(flush_from_if),
        .i_addr_misaligned_in(i_addr_misaligned_if),
        .i_addr_misaligned_out(i_addr_misaligned_from_if)
    );

    // ID
    id_stage id_stage_inst(
        .ir(ir_from_if),
        .ir_type(ir_type_from_if),
        .is_e_cause_eq_ecall(is_e_cause_eq_ecall),
        .rs1(rd1_addr),
        .rs2(rd2_addr),
        .rd(rd_id),
        .funct3(funct3_id),
        .funct7(funct7_id),
        .csr_addr(csr_addr_id),
        .imm(imm_id),
        .wr_reg_n(wr_reg_n_id_stage),
        .wr_csr_n(wr_csr_n_id_stage),
        .is_mret(is_mret_id),
        .is_ecall(is_ecall_id),
        .is_illegal_ir(is_illegal_ir_id)
    );

    id_data_picker id_data_picker_inst(
        .data1_from_regfile(data1_regfile),
        .data2_from_regfile(data2_regfile),
        .data_forwarded_from_ex(data_forwarded_from_ex),
        .data_forwarded_from_mem(data_forwarded_from_mem),
        .forward_data1(forward_data1),
        .forward_data2(forward_data2),
        .data1_id(data1_id),
        .data2_id(data2_id)
    );

    id_flush_picker id_flush_picker_inst(
        .flush_from_if(flush_from_if),
        .flush_from_flush_u(flush),
        .flush_out(flush_id)
    );

    id_wr_n_picker id_wr_reg_n_picker_inst(
        .wr_n_in(wr_reg_n_id_stage),
        .flush_id(flush_id),
        .wr_n_out(wr_reg_n_id)
    );

    id_wr_n_picker id_wr_csr_n_picker_inst(
        .wr_n_in(wr_csr_n_id_stage),
        .flush_id(flush_id),
        .wr_n_out(wr_csr_n_id)
    );

    id_z_picker id_z_picker_inst(
        .z_from_csr(z_csrs),
        .z_from_ex(c_ex),
        .z_from_mem(c_from_ex),
        .forward_z(forward_z),
        .z_id(z_id)
    );

    // ID-EX
    id_ex_regs id_ex_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .stall(stall),
        .interlock(interlock),
        .pc_in(pc_from_if),
        .pc_out(pc_from_id),
        .pc4_in(pc4_from_if),
        .pc4_out(pc4_from_id),
        .data1_in(data1_id),
        .data1_out(data1_from_id),
        .data2_in(data2_id),
        .data2_out(data2_from_id),
        .funct7_in(funct7_id),
        .funct7_out(funct7_from_id),
        .funct3_in(funct3_id),
        .funct3_out(funct3_from_id),
        .rs2_in(rd2_addr),
        .rs2_out(rs2_from_id),
        .rd_in(rd_id),
        .rd_out(rd_from_id),
        .csr_addr_in(csr_addr_id),
        .csr_addr_out(csr_addr_from_id),
        .ir_type_in(ir_type_from_if),
        .ir_type_out(ir_type_from_id),
        .imm_in(imm_id),
        .imm_out(imm_from_id),
        .z_in(z_id),
        .z_out(z_from_id),
        .wr_reg_n_in(wr_reg_n_id),
        .wr_reg_n_out(wr_reg_n_from_id),
        .wr_csr_n_in(wr_csr_n_id),
        .wr_csr_n_out(wr_csr_n_from_id),
        .flush_in(flush_id),
        .flush_out(flush_from_id)
    );

    // EX
    ex_stage ex_stage_inst(
        .ir_type(ir_type_from_id),
        .funct3(funct3_from_id),
        .funct7(funct7_from_id),
        .pc(pc_from_id),
        .data1(data1_from_id),
        .data2(data2_from_id),
        .imm(imm_from_id),
        .z_(z_from_id),
        .jump(jump_from_branch_alu),
        .c(c_ex)
    );

    ex_data_picker ex_data_picker_inst(
        .data2_from_id(data2_from_id),
        .d_mem(d_mem),
        .forward_b(forward_b),
        .b_ex(b_ex)
    );

    ex_jump_picker ex_jump_picker_inst(
        .jump_from_branch_alu(jump_from_branch_alu),
        .flush_from_id(flush_from_id),
        .jump(jump_ex)
    );

    // EX-MEM
    ex_mem_regs ex_mem_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .interlock(interlock),
        .pc4_in(pc4_from_id),
        .pc4_out(pc4_from_ex),
        .b_in(b_ex),
        .b_out(b_from_ex),
        .c_in(c_ex),
        .c_out(c_from_ex),
        .z_in(z_from_id),
        .z_out(z_from_ex),
        .funct3_in(funct3_from_id),
        .funct3_out(funct3_from_ex),
        .rd_in(rd_from_id),
        .rd_out(rd_from_ex),
        .csr_addr_in(csr_addr_from_id),
        .csr_addr_out(csr_addr_from_ex),
        .ir_type_in(ir_type_from_id),
        .ir_type_out(ir_type_from_ex),
        .wr_reg_n_in(wr_reg_n_from_id),
        .wr_reg_n_out(wr_reg_n_from_ex),
        .wr_csr_n_in(wr_csr_n_from_id),
        .wr_csr_n_out(wr_csr_n_from_ex),
        .flush_in(flush_from_id),
        .flush_out(flush_from_ex)
    );

    // MEM
    mem_stage mem_stage_inst(
        .data_from_mem(data_from_mem),
        .ir_type(ir_type_from_ex),
        .funct3(funct3_from_ex),
        .b(b_from_ex),
        .flush(flush_from_ex),
        .d(d_mem),
        .require_mem_access(MREQ),
        .write(WRITE),
        .size(SIZE),
        .data_to_mem(data_to_mem)
    );
    assign DAD = c_from_ex;
    assign data_from_mem = DDT;
    assign DDT = (WRITE) ? data_to_mem : 32'bz;

    // MEM-WB
    mem_wb_regs mem_wb_regs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .interlock(interlock),
        .pc4_in(pc4_from_ex),
        .pc4_out(pc4_from_mem),
        .c_in(c_from_ex),
        .c_out(c_from_mem),
        .d_in(d_mem),
        .d_out(d_from_mem),
        .z_in(z_from_ex),
        .z_out(z_from_mem),
        .rd_in(rd_from_ex),
        .rd_out(wr_addr),
        .csr_addr_in(csr_addr_from_ex),
        .csr_addr_out(csr_wr_addr),
        .ir_type_in(ir_type_from_ex),
        .ir_type_out(ir_type_from_mem),
        .wr_reg_n_in(wr_reg_n_from_ex),
        .wr_reg_n_out(wr_n),
        .wr_csr_n_in(wr_csr_n_from_ex),
        .wr_csr_n_out(wr_csr_n_from_mem)
    );

    // WB
    wb_stage wb_stage_inst(
        .ir_type(ir_type_from_mem),
        .c(c_from_mem),
        .d(d_from_mem),
        .pc4(pc4_from_mem),
        .z_(z_from_mem),
        .data_to_reg(data_in),
        .data_to_csr(csr_data_in)
    );

    // Register File
    rf32x32 regfile_inst(
        .clk(clk),
        .reset(rst_n),
        .wr_n(wr_n),
        .rd1_addr(rd1_addr),
        .rd2_addr(rd2_addr),
        .wr_addr(wr_addr),
        .data_in(data_in),
        .data1_out(data1_regfile),
        .data2_out(data2_regfile)
    );

    // CSRs
    csrs csrs_inst(
        .clk(clk),
        .rst_n(rst_n),
        .csr_addr(csr_addr_id),
        .csr_wr_addr(csr_wr_addr),
        .csr_data_in(csr_data_in),
        .wr_csr_n(wr_csr_n_from_mem),
        .is_mret(is_mret_id),
        .e_raised(e_raised),
        .e_cause_in(e_cause),
        .e_pc_in(e_pc),
        .e_tval_in(e_tval),
        .csr_out(z_csrs),
        .trap_vector_addr_out(trap_vector_addr),
        .is_e_cause_eq_ecall(is_e_cause_eq_ecall)
    );

    // Data Forwarding
    data_forward_u data_forward_u_inst(
        .rs1(rd1_addr),
        .rs2(rd2_addr),
        .wr_reg_n_in_ex(wr_reg_n_from_id),
        .rs2_in_ex(rs2_from_id),
        .rd_in_ex(rd_from_id),
        .ir_type_in_ex(ir_type_from_id),
        .wr_reg_n_in_mem(wr_reg_n_from_ex),
        .rd_in_mem(rd_from_ex),
        .ir_type_in_mem(ir_type_from_ex),
        .forward_data1(forward_data1),
        .forward_data2(forward_data2),
        .forward_b(forward_b)
    );

    csr_forward_u csr_forward_u_inst(
        .csr_addr_in_id(csr_addr_id),
        .csr_addr_in_ex(csr_addr_from_id),
        .ir_type_in_ex(ir_type_from_id),
        .wr_csr_n_in_ex(wr_csr_n_from_id),
        .csr_addr_in_mem(csr_addr_from_ex),
        .ir_type_in_mem(ir_type_from_ex),
        .wr_csr_n_in_mem(wr_csr_n_from_ex),
        .forward_z(forward_z)
    );

    data_forward_helper #(.IS_MEM_STAGE(0)) data_forward_helper_ex(
        .main_data(c_ex),
        .sub_data(pc4_from_id),
        .csr_data(z_from_id),
        .ir_type(ir_type_from_id),
        .data_to_forward(data_forwarded_from_ex)
    );

    data_forward_helper #(.IS_MEM_STAGE(1)) data_forward_helper_mem(
        .main_data(c_from_ex),
        .sub_data(d_mem),
        .csr_data(z_from_ex),
        .ir_type(ir_type_from_ex),
        .data_to_forward(data_forwarded_from_mem)
    );

    // Pipeline Stalling
    stall_detector stall_detector_inst(
        .rs1(rd1_addr),
        .rs2(rd2_addr),
        .ir_type_in_id(ir_type_from_if),
        .wr_reg_n_in_ex(wr_reg_n_from_id),
        .rd_in_ex(rd_from_id),
        .ir_type_in_ex(ir_type_from_id),
        .stall(stall)
    );

    // Pipeline Flush
    flush_u flush_u_inst(
        .jump(jump_ex),
        .flush(flush)
    );

    // Pipeline Interlock
    interlock_u interlock_u_inst(
        .imem_ack_n(ACKI_n),
        .dmem_ack_n(ACKD_n),
        .ir_type(ir_type_from_ex),
        .interlock(interlock)
    );

    // Exception Handling
    exception_ctrl_u exception_ctrl_u_inst(
        .pc_in_id(pc_from_if),
        .i_addr_misaligned(i_addr_misaligned_from_if),
        .is_illegal_ir(is_illegal_ir_id),
        .ir_in_id(ir_from_if),
        .is_ecall(is_ecall_id),
        .flush(flush_id),
        .e_raised(e_raised),
        .e_cause(e_cause),
        .e_pc(e_pc),
        .e_tval(e_tval)
    );

endmodule
