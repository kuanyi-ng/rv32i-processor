module test_ld_converter ();
    reg [31:0] mem_data;
    reg [2:0] funct3;

    wire [31:0] loaded_data;

    ld_converter subject(.in(mem_data), .funct3(funct3), .out(loaded_data));

    initial begin
        // data from memory
        assign mem_data = 32'h8192_a3b4;
        #1

        // LB
        assign funct3 = 3'b000;
        // offset 0
        // expect: ffff_ffb4
        #10

        // LBU
        assign funct3 = 3'b100;
        // offset 0
        // expect: 0000_00b4
        #10

        // LH
        assign funct3 = 3'b001;
        // offset 0
        // expect: ffff_a3b4
        #10

        // LHU
        assign funct3 = 3'b101;
        // offset 0
        // expect: 0000_a3b4
        #10

        // LW
        assign funct3 = 3'b010;
        // expect: 8192_a3b4
        #10

        $finish;
    end
endmodule