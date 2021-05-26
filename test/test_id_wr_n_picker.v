module test_id_wr_n_picker ();
    reg wr_n_in;
    reg flush_id;

    wire wr_n_out;

    id_wr_n_picker subject(
        .wr_n_in(wr_n_in),
        .flush_id(flush_id),
        .wr_n_out(wr_n_out)
    );

    initial begin
        assign wr_n_in = 1'b0;
        assign flush_id = 1'b0;
        // wr_n_out: 0
        #5

        assign wr_n_in = 1'b0;
        assign flush_id = 1'b1;
        // wr_n_out: 1
        #5

        assign wr_n_in = 1'b1;
        assign flush_id = 1'b0;
        // wr_n_out: 1
        #5

        assign wr_n_in = 1'b1;
        assign flush_id = 1'b1;
        // wr_n_out: 1
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, wr_n_out: %b", $time, wr_n_out);
    end

endmodule
