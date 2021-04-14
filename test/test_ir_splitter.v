module test_ir_splitter ();
    reg [31:0] ir;

    wire [6:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [2:0] funct3;
    wire [6:0] funct7;

    ir_splitter subject(
        .ir(ir),
        .opcode(opcode),
        .rs1(rs1), 
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7)
    );

    initial begin
        // ADD instruction
        // add x1, x2, x31
        assign ir = 32'b0000_0000_0010_0000_1000_1111_1011_0011;
        // expect:
        // opcode: 0110011
        // rs1: 00001
        // rs2: 00010
        // rd: 11111
        // funct3: 000
        // funct7: 0000000
        #10

        $finish;
    end
endmodule