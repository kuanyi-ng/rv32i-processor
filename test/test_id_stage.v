module test_id_stage ();
    reg [31:0] ir;

    wire [4:0] rs1;
    wire [4:0] rs2;

    wire [4:0] rd;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] imm;

    id_stage subject(
        .ir(ir),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .imm(imm)
    );

    initial begin
        // ADD r3, r1, r2
        assign ir = 32'b0000000_00010_00001_000_00011_0110011;
        // expect
        // rs1: 1
        // rs2: 2
        // opcode: 0110011
        // funct3: 000
        // funct7: 0000000
        // imm: X
        // rd: 3
        #5

        // ADDI r3, r1, 12'h801
        assign ir = 32'b1000_0000_0001_00001_000_00011_0010011;
        // expect
        // rs1: 1
        // opcode: 0010011
        // funct3: 000
        // funct7: X
        // imm: 12'hffff_f801
        // rd: 3
        #5

        $finish;
    end
endmodule