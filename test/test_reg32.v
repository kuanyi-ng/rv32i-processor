module test_reg32 ();
    reg clk;
    reg rst_n;
    reg [31:0] in;
    reg [31:0] default_in;

    wire [31:0] out;

    reg32 subject(
        .clk(clk),
        .rst_n(rst_n),
        .in(in),
        .default_in(default_in),
        .out(out)
    );

    // clock generation
    always begin
        clk = 1'b1;
        #5 clk = 1'b0;
        #5;
    end

    initial begin
        assign rst_n = 1'b0;
        assign default_in = 32'h0001_0000;

        #10

        // expect: 0
        assign in = 32'd0;
        #5
        
        // expect: 0
        assign in = 32'd4;
        #5

        // expect: 4
        #5

        // expect: 4
        assign in = 32'd12;
        #5

        $finish;
    end
endmodule