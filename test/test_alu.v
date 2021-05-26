module test_alu ();
    reg [31:0] data1, data2;
    reg [3:0] alu_op;
    wire [31:0] alu_output;

    alu subject(.in1(data1), .in2(data2), .alu_op(alu_op), .out(alu_output));

    initial begin
        // initial setup
        data1 = 32'd4;
        data2 = 32'd6;

        // ADD, ADDI, Load, Store, Branch, JAL, AUIPC
        // expect: 0000_000a
        alu_op = 4'b0000;
        #10

        // SUB
        // expect: ffff_fffe
        alu_op = 4'b1000;
        #10

        // XOR, XORI
        // expect: 0000_0002
        alu_op = 4'b0100;
        #10

        // OR, ORI, CSRRS, CSRRSI
        // expect: 0000_0006
        alu_op = 4'b0110;
        #10

        // AND, ANDI
        // expect: 0000_0004
        alu_op = 4'b0111;
        #10

        data1 = 32'hf000_0004;
        data2 = 32'd4;

        // SLL, SLLI
        // expect: 0000_0040
        alu_op = 4'b0001;
        #10

        // SRL, SRLI
        // expect: 0f00_0000
        alu_op = 4'b0101;
        #10

        // SRA, SRAI
        // expect: ff00_0000
        alu_op = 4'b1101;
        #10

        data1 = 32'h0000_1000;
        data2 = 32'hf000_1000;

        // SLT, SLTI
        // expect: 0000_0000
        alu_op = 4'b0010;
        #10

        // SLTU, SLTIU
        // expect: 0000_0001
        alu_op = 4'b0011;
        #10

        // JALR
        data2 = 32'd8;
        alu_op = 4'b1010;
        // context: doesn't switch 0th bit
        // expect: 0000_0008
        data1 = 32'd1;
        #10
        // context: switch 0th bit
        // expect: 0000_000a
        data1 = 32'd2;
        #10

        // LUI, CSRRW, CSRRWI
        // expect: 0000_0008
        alu_op = 4'b1001;
        #10

        data1 = 32'h0000_1000;
        data2 = 32'hf000_1000;

        // CSRRC, CSRRCI
        // 0000_0000
        alu_op = 4'b1011;
        #10

        $finish;
    end

    initial begin
        $monitor("t: %d, c: %h", $time, alu_output);
    end
endmodule
