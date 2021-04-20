module test_id_stage ();
    reg [31:0] pc_from_if;
    reg [31:0] ir;

    wire [4:0] rs1;
    wire [4:0] rs2;

    reg [31:0] data1_from_regfile;
    reg [31:0] data2_from_regfile;

    wire [31:0] pc_to_ex;
    wire [6:0] opcode;
    wire [2:0] funct3;
    wire [6:0] funct7;
    wire [31:0] data1, data2, imm;
    wire [4:0] rd;

    id_stage subject(
        .pc_from_if(pc_from_if),
        .ir(ir),
        .rs1(rs1),
        .rs2(rs2),
        .data1_from_regfile(data1_from_regfile),
        .data2_from_regfile(data2_from_regfile),
        .pc_to_ex(pc_to_ex),
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .data1(data1),
        .data2(data2),
        .imm(imm),
        .rd(rd)
    );

    initial begin
        //
        // Setup
        //
        assign data1_from_regfile = 32'd1;
        assign data2_from_regfile = 32'd2;

        //
        // Test
        //

        // ADD r3, r1, r2
        assign pc_from_if = 32'd4;  // any multiple of 4 will do
        assign ir = 32'b0000000_00010_00001_000_00011_0110011;
        // expect
        // rs1: 1
        // rs2: 2
        // pc_to_ex: 4
        // opcode: 0110011
        // funct3: 000
        // funct7: 0000000
        // data1: 1
        // data2: 2
        // imm: X
        // rd: 3
        #5

        // ADDI r3, r1, 12'h801
        assign pc_from_if = 32'd8;
        assign ir = 32'b1000_0000_0001_00001_000_00011_0010011;
        // expect
        // rs1: 1
        // rs2: 2
        // pc_to_ex: 8
        // opcode: 0010011
        // funct3: 000
        // funct7: X
        // data1: 1
        // data2: X
        // imm: 12'hffff_f801
        // rd: 3
        #5

        $finish;
    end
endmodule