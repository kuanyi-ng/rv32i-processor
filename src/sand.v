// this module is used for drafing

module sand ();
    reg [31:0] in1;
    reg [31:0] in2;    
    wire [31:0] out;

    box subject(.in1(in1), .in2(in2), .out(out));

    initial begin
        assign in1 = 32'd1;
        assign in2 = 32'd8;
        #10

        assign in1 = 32'd2;
        assign in2 = 32'd8;
        #10

        $finish;
    end
    
endmodule

module box (
    input [31:0] in1,
    input [31:0] in2,
    output [31:0] out
);
    
    assign out = (in1 + in2) & ~1;
endmodule