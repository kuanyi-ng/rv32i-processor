`include "id_ctrl.v"

module id_stage (
    // inputs from IF stage
    input [31:0] ir,
    input [3:0] ir_type,

    // inputs from CSRs
    input is_e_cause_eq_ecall,

    // outputs to Register File
    output [4:0] rs1,
    output [4:0] rs2,

    // outputs to EX stage
    output [4:0] rd,
    output [2:0] funct3,
    output [6:0] funct7,
    output [11:0] csr_addr,
    output [31:0] imm,
    // 0: write, 1: don't write
    output wr_reg_n,
    output wr_csr_n,
    // 0: not mret, 1: mret
    output is_mret,
    // 0: not ecall, 1: ecall
    output is_ecall,
    // 0: legal, 1: illegal
    output is_illegal_ir
);

    //
    // Local Parameters
    //

    localparam [31:0] MRET_IR = 32'b0011000_00010_00000_000_00000_1110011;
    localparam [31:0] ECALL_IR = 32'b000000000000_00000_000_00000_1110011;

    //
    // Main
    //

    assign rs1 = ir[19:15];
    assign rs2 = ir[24:20];
    assign rd = ir[11:7];
    assign funct3 = ir[14:12];
    assign funct7 = ir[31:25];
    assign csr_addr = ir[31:20];

    assign is_mret = (ir == MRET_IR);
    assign is_ecall = (ir == ECALL_IR);

    wire is_return_from_ecall = (is_mret && is_e_cause_eq_ecall);

    id_ctrl id_ctrl_inst(
        .ir(ir),
        .ir_type(ir_type),
        .funct7(funct7),
        .funct3(funct3),
        .rs1(rs1),
        .rd(rd),
        .is_mret(is_mret),
        .is_ecall(is_ecall),
        .is_return_from_ecall(is_return_from_ecall),
        .imm(imm),
        .wr_reg_n(wr_reg_n),
        .wr_csr_n(wr_csr_n),
        .is_illegal_ir(is_illegal_ir)
    );

endmodule
