`include "ir_splitter.v"
`include "imm_extractor.v"

module id_stage (
    // inputs from IF stage
    input [31:0] ir,

    // outputs to Register File
    output [4:0] rs1,
    output [4:0] rs2,

    // outputs to EX stage
    output [4:0] rd,
    output [6:0] opcode,
    output [2:0] funct3,
    output [6:0] funct7,
    output [11:0] csr_addr,
    output [31:0] imm,
    output wr_reg_n,    // 0: write, 1: don't write
    output wr_csr_n     // 0: write, 1: don't write
);

    //
    // Main
    //
    ir_splitter ir_splitter_inst(
        .ir(ir),
        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .csr_addr(csr_addr)
    );

    wire [2:0] imm_type;
    assign imm_type = imm_type_from(opcode, funct3);

    imm_extractor imm_extractor_inst(
        .in(ir),
        .imm_type(imm_type),
        .out(imm)
    );

    assign wr_reg_n = wr_reg_n_ctrl(opcode, rd);
    assign wr_csr_n = wr_csr_n_ctrl(opcode, funct3);

    //
    // Functions
    //

    localparam [6:0] lui_op = 7'b0110111;
    localparam [6:0] auipc_op = 7'b0010111;
    localparam [6:0] jal_op = 7'b1101111;
    localparam [6:0] jalr_op = 7'b1100111;
    localparam [6:0] branch_op = 7'b1100011;
    localparam [6:0] load_op = 7'b0000011;
    localparam [6:0] store_op = 7'b0100011;
    localparam [6:0] i_type_op = 7'b0010011;
    localparam [6:0] r_type_op = 7'b0110011;
    localparam [6:0] csr_op = 7'b1110011;

    function [2:0] imm_type_from(input [6:0] opcode, input [2:0] funct3);
        localparam [2:0] i_type = 3'b000;
        localparam [2:0] b_type = 3'b001;
        localparam [2:0] s_type = 3'b010;
        localparam [2:0] u_type = 3'b011;
        localparam [2:0] j_type = 3'b100;
        localparam [2:0] shamt_type = 3'b101;
        localparam [2:0] csr_type = 3'b110;
        localparam [2:0] default_type = 3'b111;

        begin
            case (opcode)
                // U-Type
                // LUI
                lui_op: imm_type_from = u_type;

                // AUIPC
                auipc_op: imm_type_from = u_type;

                // JAL
                jal_op: imm_type_from = j_type;

                // JALR
                jalr_op: imm_type_from = i_type;

                // Branch
                branch_op: imm_type_from = b_type;

                // Load
                load_op: imm_type_from = i_type;

                // Store
                store_op: imm_type_from = s_type;

                // I-Type (including shamt)
                i_type_op: begin
                    if (funct3 == 3'b001)
                        // SLLI
                        imm_type_from = shamt_type;
                    else if (funct3 == 3'b101)
                        // SRLI, SRAI
                        imm_type_from = shamt_type;
                    else
                        imm_type_from = i_type;
                end

                csr_op: imm_type_from = csr_type;

                // default: anything not from above
                default: imm_type_from = default_type;
            endcase
        end
   endfunction

   function wr_reg_n_ctrl(input [6:0] opcode, input [4:0] rd);
        // 0: write, 1: don't write

        // whitelist instead of blacklist to be more secure.
        reg is_lui, is_auipc, is_i_type, is_r_type, is_load, is_jal, is_jalr, is_csr;

        begin
            // might to add csr
            is_lui = (opcode == lui_op);
            is_auipc = (opcode == auipc_op);
            is_i_type = (opcode == i_type_op);
            is_r_type = (opcode == r_type_op);
            is_load = (opcode == load_op);
            is_jal = (opcode == jal_op);
            is_jalr = (opcode == jalr_op);
            is_csr = (opcode == csr_op);

            if (rd == 5'b00000) begin
                // don't allow write to x0 (always 0)
                wr_reg_n_ctrl = 1'b1;
            end else if (is_lui || is_auipc || is_i_type || is_r_type || is_load || is_jal || is_jalr || is_csr) begin
                wr_reg_n_ctrl = 1'b0;
            end else begin
                wr_reg_n_ctrl = 1'b1;
            end
        end
    endfunction

    function wr_csr_n_ctrl(input [6:0] opcode, input [2:0] funct3);
        begin
            // CSR instructions share the same opcode with ecall, ebreak instructions
            // ecall and ebreak have funct3 of 000 while CSR instruction doesn't
            if ((opcode == csr_op) && (funct3 != 3'b000)) wr_csr_n_ctrl = 1'b0;
            else wr_csr_n_ctrl = 1'b1;
        end
    endfunction
endmodule
