module test_alu ();
    reg [31:0] data1, data2;
    reg [3:0] alu_op;
    wire [31:0] alu_output;

    alu subject(.in1(data1), .in2(data2), .alu_op(alu_op), .out(alu_output));

    initial begin
        // initial setup
        assign data1 = 32'd4;
        assign data2 = 32'd6;

        // ADD
        // expect: 0000_000a
        assign alu_op = 4'b0000;
        #10

        // SUB
        // expect: ffff_fffe
        assign alu_op = 4'b0001;
        #10

        // XOR
        // expect: 0000_0002
        assign alu_op = 4'b0010;
        #10

        // OR
        // expect: 0000_0006
        assign alu_op = 4'b0011;
        #10

        // AND
        // expect: 0000_0004
        assign alu_op = 4'b0100;
        #10

        assign data1 = 32'hf000_0004;
        assign data2 = 32'd4;

        // SLL
        // expect: 0000_0040
        assign alu_op = 4'b0101;
        #10

        // SRL
        // expect: 0f00_0000
        assign alu_op = 4'b0110;
        #10

        // SRA
        // expect: ff00_0000
        assign alu_op = 4'b0111;
        #10

        // JALR
        assign data2 = 32'd8;
        assign alu_op = 4'b1110;
        // context: doesn't switch 0th bit
        // expect: 0000_0008
        assign data1 = 32'd1;
        #10
        // context: switch 0th bit
        // expect: 0000_000a
        assign data1 = 32'd2;
        #10

        $finish;
    end
endmodule
