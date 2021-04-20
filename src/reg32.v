module reg32 (
    input clk,
    input rst_n,
    input [31:0] in,
    output reg [31:0] out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= 32'h0;
        else out <= in;
    end
endmodule