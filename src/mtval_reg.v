module mtval_reg (
    input clk,
    input rst_n,
    input [31:0] in,
    output [31:0] out
);
    
    localparam [31:0] default_in = 32'b0;
    
    reg [31:0] mtval;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) mtval <= default_in;
        else mtval <= in;
    end

    assign out = mtval;

endmodule