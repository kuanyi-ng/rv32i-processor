module test_id_stage ();
    reg [31:0] ir;

    wire [4:0] rs1;
    wire [4:0] rs2;

    wire [4:0] rd;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [11:0] csr_addr;
    wire [31:0] imm;
    wire wr_reg_n;
    wire wr_csr_n;

    id_stage subject(
        .ir(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .csr_addr(csr_addr),
        .imm(imm),
        .wr_reg_n(wr_reg_n),
        .wr_csr_n(wr_csr_n)
    );

    initial begin
        // LUI
        assign ir = 32'b0000_0000_0000_0000_0000_00011_0110111;
        // opcode: 0110111
        // imm: 0
        // rd: 3
        // wr_reg_n: 0
        #5

        // AUIPC
        assign ir = 32'b0000_0000_0000_0000_0000_00011_0010111;
        // opcode: 0010111
        // imm: 0
        // rd: 3
        // wr_reg_n: 0
        #5

        // JAL
        assign ir = 32'b0_0000000001_0_00000000_00011_1101111;
        // opcode: 1101111
        // imm: 2
        // rd: 3
        // wr_reg_n: 0
        #5

        // JAL with rd: 0
        assign ir = 32'b0_0000000001_0_00000000_00000_1101111;
        // opcode: 1101111
        // imm: 2
        // rd: 0
        // wr_reg_n: 1
        #5

        // JALR
        assign ir = 32'b0000_0000_0010_00001_000_00011_1100111;
        // opcode: 1100111
        // imm: 2
        // rs1: 1
        // rd: 3
        // funct3: 000
        // wr_reg_n: 0
        #5

        // Branch: BEQ
        assign ir = 32'b0_000000_00010_00001_000_0001_0_1100011;
        // opcode: 1100011
        // imm: 2
        // rs1: 1
        // rs2: 2
        // funct3: 000
        // wr_reg_n: 1
        #5

        // Load: LB
        assign ir = 32'b0000_0000_0010_00001_000_00011_0000011;
        // opcode: 0000011
        // imm: 2
        // rs1: 1
        // rd: 3
        // funct3: 000
        // wr_reg_n: 0
        #5

        // Store: SB
        assign ir = 32'b0000000_00010_00001_000_00010_0100011;
        // opcode: 0100011
        // imm: 2
        // rs1: 1
        // rs2: 2
        // funct3: 000
        // wr_reg_n: 1
        #5

        // I: ADDI r3, r1, 12'h801
        assign ir = 32'b1000_0000_0001_00001_000_00011_0010011;
        // rs1: 1
        // opcode: 0010011
        // funct3: 000
        // imm: ffff_f801
        // rd: 3
        // wr_reg_n: 0
        #5

        // R: ADD r3, r1, r2
        assign ir = 32'b0000000_00010_00001_000_00011_0110011;
        // rs1: 1
        // rs2: 2
        // opcode: 0110011
        // funct3: 000
        // funct7: 0000000
        // rd: 3
        // wr_reg_n: 0
        #5

        // ecall
        assign ir = 32'b000000000000_00000_000_00000_1110011;
        // wr_csr_n: 1
        #5

        // CSR
        assign ir = 32'b001100000000_00001_001_00010_1110011;
        // csr_addr = h300
        // wr_csr_n: 0
        #5

        $finish;
    end

    initial begin
        $monitor(
            "time: %3d,\nrs1: %d,\nrs2: %d,\nrd: %d,\nopcode: %b,\nfunct3: %b,\nfunct7: %b,\ncsr_addr: %h,\nimm: %h,\nwr_reg_n: %b,\nwr_csr_n: %b\n",
            $time,
            rs1,
            rs2,
            rd,
            opcode,
            funct3,
            funct7,
            csr_addr,
            imm,
            wr_reg_n,
            wr_csr_n
        );
    end
endmodule