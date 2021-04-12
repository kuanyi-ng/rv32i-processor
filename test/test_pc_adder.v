module test_pc_adder ();
    reg [31:0] curr_pc;
    wire [31:0] next_pc;

    pc_adder subject(.in(curr_pc), .out(next_pc));

    initial begin
        // expect: 32'd4
        assign curr_pc = 32'd0;
        #10

        // expect: 32'd8
        assign curr_pc = 32'd4;
        #10

        $finish;
    end
endmodule