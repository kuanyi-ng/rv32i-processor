// this module is used for drafing

module sand ();
    reg clock;
    reg reset;
    reg write_enable;
    reg [4:0] rd1_addr;
    reg [4:0] rd2_addr;
    reg [4:0] wr_addr;
    reg [31:0] data_in;

    wire [31:0] data1_out;
    wire [31:0] data2_out;

    rf32x32 subject(
        .clk(clock),
        .reset(reset),
        .wr_n(write_enable),
        .rd1_addr(rd1_addr),
        .rd2_addr(rd2_addr),
        .wr_addr(wr_addr),
        .data_in(data_in),
        .data1_out(data1_out),
        .data2_out(data2_out)
    );

    // NOTE:
    // manage to
    // write when
    // clock: 1, reset: 1, write_enable = 0

    // NOTE:
    // when clock: 1, reset: 1, write_enable: 0
    // data_in will be written onto rd1_addr
    // and that value can be read after clock turns 0

    // NOTE:
    // if read and write are performed on the same reg
    // in the same clock cycle, the write value will be read.

    initial begin
        assign reset = 1'b1;
        assign clock = 1'b1;
	assign data_in = 32'd0;
        assign write_enable = 1'b0;
        #10

        // write data to register file
        assign clock = ~clock; // trigger posedge
        assign wr_addr = 5'd1;
        assign rd1_addr = 5'd1;
        // context: clock down
        // expect: data1_out != 0000_0001
        // assign clock = 1'b0;
        #10

        // assign write_enable = 1'b0;
        // assign data_in = 32'd2;
        // context: clock up
        // expect: data1_out: 0000_0001
	    assign write_enable = 1'b1;
        assign data_in = 32'd1;
        assign clock = ~clock;
        #10

        assign data_in = 32'd3;
        assign clock = ~clock;
        #10

        // assign data_in = 32'd4;
        assign clock = ~clock;
        #10

        // assign write_enable = 1'b0;
        // try to read data from register file

        // try to update register at index 0
        // expect: fail (value stays at 0)

        // try to update register at index 1
        // expect: value updated

        $finish;
    end
    
endmodule
