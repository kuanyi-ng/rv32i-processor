// this module is used for drafing

module sand ();
    reg [31:0] in;
    reg [31:0] offset;    
    wire [31:0] out;

    box subject(.in(in), .offset(offset), .out(out));

    initial begin
        assign in = 32'd1;
        assign offset = 32'd8;
        #10

        $finish;
    end
    
endmodule

module box (
    input [31:0] in,
    input [31:0] offset,
    output [31:0] out
);
    
    assign out = in << offset;
endmodule