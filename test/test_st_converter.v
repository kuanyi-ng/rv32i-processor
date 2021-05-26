module test_st_converter ();
    reg [31:0] data;
    reg [2:0] funct3;

    wire [31:0] data_to_store;

    st_converter subject(.in(data), .funct3(funct3), .out(data_to_store));

    initial begin
        assign data = 32'h1234_5678;
        #1

        // SB
        // expect: 7878_7878
        assign funct3 = 3'b000;
        #10

        // SH
        // expect: 5678_5678
        assign funct3 = 3'b001;
        #10

        // SW
        // expect: 1234_5678
        assign funct3 = 3'b010;
        #10

        // default
        // expect: 1234_5678
        assign funct3 = 3'b011;
        #10
        assign funct3 = 3'b100;
        #10
        assign funct3 = 3'b101;
        #10
        assign funct3 = 3'b110;
        #10
        assign funct3 = 3'b111;
        #10

        $finish;
    end
endmodule