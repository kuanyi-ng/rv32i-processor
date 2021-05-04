module test_id_flush_picker ();
    reg flush_from_if;
    reg flush_from_flush_u;

    wire flush_out;

    id_flush_picker subject(
        .flush_from_if(flush_from_if),
        .flush_from_flush_u(flush_from_flush_u),
        .flush_out(flush_out)
    );

    initial begin
        assign flush_from_if = 1'b0;
        assign flush_from_flush_u = 1'b0;
        // flush_out: 0
        #5

        assign flush_from_if = 1'b0;
        assign flush_from_flush_u = 1'b1;
        // flush_out: 1
        #5

        assign flush_from_if = 1'b1;
        assign flush_from_flush_u = 1'b0;
        // flush_out: 1
        #5

        assign flush_from_if = 1'b1;
        assign flush_from_flush_u = 1'b1;
        // flush_out: 1
        #5

        $finish;
    end

    initial begin
        $monitor("t: %3d, flush_out: %b", $time, flush_out);
    end
    
endmodule