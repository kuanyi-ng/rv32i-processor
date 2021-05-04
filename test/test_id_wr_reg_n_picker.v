module test_id_wr_reg_n_picker ();
    reg wr_reg_n_in;
    reg flush;

    wire wr_reg_n_out;

    id_wr_reg_n_picker subject(
        .wr_reg_n_in(wr_reg_n_in),
        .flush(flush),
        .wr_reg_n_out(wr_reg_n_out)
    );

    initial begin
        assign wr_reg_n_in = 1'b0;
        assign flush = 1'b0;
        // wr_reg_n_out: 0
        #5

        assign wr_reg_n_in = 1'b0;
        assign flush = 1'b1;
        // wr_reg_n_out: 1
        #5

        assign wr_reg_n_in = 1'b1;
        assign flush = 1'b0;
        // wr_reg_n_out: 1
        #5

        assign wr_reg_n_in = 1'b1;
        assign flush = 1'b1;
        // wr_reg_n_out: 1
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, wr_reg_n_out: %b", $time, wr_reg_n_out);
    end
    
endmodule