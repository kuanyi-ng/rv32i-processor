module test_ld_converter ();
    reg [31:0] mem_data;
    reg [1:0] offset;
    reg [2:0] funct3;

    wire [31:0] loaded_data;

    ld_converter subject(.in(mem_data), .offset(offset), .format(funct3), .out(loaded_data));

    initial begin
        // data from memory
        assign mem_data = 32'h8192_a3b4;
        #1

        // LB
        assign funct3 = 3'b000;
        // offset 0
        // expect: ffff_ffb4
        assign offset = 2'b00;
        #10
        // offset 1
        // expect: ffff_ffa3
        assign offset = 2'b01;
        #10
        // offset 2
        // expect: ffff_ff92
        assign offset = 2'b10;
        #10
        // offset 3
        // expect: ffff_ff81
        assign offset = 2'b11;
        #10


        // LBU
        assign funct3 = 3'b100;
        // offset 0
        // expect: 0000_00b4
        assign offset = 2'b00;
        #10
        // offset 1
        // expect: 0000_00a3
        assign offset = 2'b01;
        #10
        // offset 2
        // expect: 0000_0092
        assign offset = 2'b10;
        #10
        // offset 3
        // expect: 0000_0081
        assign offset = 2'b11;
        #10

        // LH
        assign funct3 = 3'b001;
        // offset 0
        // expect: ffff_a3b4
        assign offset = 2'b00;
        #10
        // offset 1
        // expect: ffff_a3b4 (TODO)
        assign offset = 2'b01;
        #10
        // offset 2
        // expect: ffff_8192
        assign offset = 2'b10;
        #10
        // offset 3
        // expect: ffff_a3b4 (TODO)
        assign offset = 2'b11;
        #10

        // LHU
        assign funct3 = 3'b101;
        // offset 0
        // expect: 0000_a3b4
        assign offset = 2'b00;
        #10
        // offset 1
        // expect: 0000_a3b4 (TODO)
        assign offset = 2'b01;
        #10
        // offset 2
        // expect: 0000_8192
        assign offset = 2'b10;
        #10
        // offset 3
        // expect: 0000_a3b4 (TODO)
        assign offset = 2'b11;
        #10

        // LW
        assign funct3 = 3'b010;
        // expect: 8192_a3b4
        assign offset = 2'b00;
        #10
        assign offset = 2'b01;
        #10
        assign offset = 2'b10;
        #10
        assign offset = 2'b11;
        #10

        $finish;
    end
endmodule