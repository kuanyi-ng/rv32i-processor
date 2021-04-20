module test_top ();
    reg clk;
    reg rst_n;

    top subject(
        .clk(clk),
        .rst_n(rst_n)
    );

    always begin
        assign clk = 1'b1;
        #5
        assign clk = 1'b0;
        #5;
    end

    initial begin
        // reset for one cycle
        assign rst_n = 1'b0;

        #5

        #5

        assign rst_n = 1'b1;
        
        #5

        #5

        #5

        #5

        $finish;
    end
    
endmodule