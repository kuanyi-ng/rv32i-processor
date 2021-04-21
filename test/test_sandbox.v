module test_sandbox ();
    reg clk;
    reg rst_n;

    wire [31:0] IAD;
    reg [31:0] IDT;
    reg ACKI_n;

    top subject(
        .clk(clk),
        .rst_n(rst_n),
        .IAD(IAD),
        .IDT(IDT),
        .ACKI_n(ACKI_n)
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
        assign ACKI_n = 1'b1;

        #5

        #5

        assign rst_n = 1'b1;
        assign ACKI_n = 1'b0;

        assign IDT = 32'd2;

        #5

        #5

        assign IDT = 32'd4;

        #5

        #5

        $finish;
    end
    
endmodule