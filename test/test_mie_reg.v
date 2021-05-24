module test_mie_reg ();
    reg clk, rst_n;
    reg [31:0] mie_in;
    reg wr_mie;
    
    wire [31:0] mie;

    mie_reg subject(
        .clk(clk),
        .rst_n(rst_n),
        .mie_in(mie_in),
        .wr_mie(wr_mie),
        .mie(mie)
    );

    initial begin
        mie_in = { 20'bx, 12'b1_0_111_0_111_0_11 };

        #5 clk = 1'b1;
        rst_n = 1'b0;
        #5 clk = 1'b0;

        #5 clk = 1'b1;
        rst_n = 1'b1;
        #5 clk = 1'b0;

        #5 clk = 1'b1;
        wr_mie = 1'b0;
        #5 clk = 1'b0;

        #5 clk = 1'b1;
        wr_mie = 1'b1;
        #5 clk = 1'b0;

        $finish;
    end

    initial begin
        $monitor("t: %3d, mie: %h", $time, mie);
    end

endmodule
