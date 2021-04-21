module reg7 (
    input clk,
    input rst_n,
    input [6:0] in,
    input [6:0] default_in,
    output reg [6:0] out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= default_in;
        else out <= in;
    end
endmodule