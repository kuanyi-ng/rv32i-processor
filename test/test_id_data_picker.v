module test_id_data_picker ();
    reg [31:0] data1_from_regfile, data2_from_regfile;
    reg [31:0] data_forwarded_from_ex, data_forwarded_from_mem;
    reg [1:0] forward_data1, forward_data2;

    wire [31:0] data1_id, data2_id;

    id_data_picker subject(
        .data1_from_regfile(data1_from_regfile),
        .data2_from_regfile(data2_from_regfile),
        .data_forwarded_from_ex(data_forwarded_from_ex),
        .data_forwarded_from_mem(data_forwarded_from_mem),
        .forward_data1(forward_data1),
        .forward_data2(forward_data2),
        .data1_id(data1_id),
        .data2_id(data2_id)
    );

    initial begin
        assign data1_from_regfile = 32'd1;
        assign data2_from_regfile = 32'd2;
        assign data_forwarded_from_ex = 32'd3;
        assign data_forwarded_from_mem = 32'd4;

        assign forward_data1 = 2'b00;
        assign forward_data2 = 2'b01;
        // data1_id: 1
        // data2_id: 3
        #5

        assign forward_data1 = 2'b10;
        assign forward_data2 = 2'b00;
        // data1_id: 4
        // data2_id: 2
        #5

        assign forward_data1 = 2'b01;
        assign forward_data2 = 2'b10;
        // data1_id: 3
        // data2_id: 4
        #5

        $finish;
    end


endmodule