module test_ex_data_picker ();
    reg [31:0] data2_from_id, d_mem;
    reg forward_b;

    wire [31:0] b_ex;

    ex_data_picker subject(
        .data2_from_id(data2_from_id),
        .d_mem(d_mem),
        .forward_b(forward_b),
        .b_ex(b_ex)
    );

    initial begin
        assign data2_from_id = 32'd1;
        assign d_mem = 32'd2;

        assign forward_b = 1'b0;
        // b_ex: 1
        #5

        assign forward_b = 1'b1;
        // b_ex: 2
        #5

        $finish;
    end

    initial begin
        $monitor("b_ex: %d", b_ex);
    end
endmodule