module reg3 (
    input clk,
    input rst_n,
    input [2:0] in,
    input [2:0] default_in,
    output reg [2:0] out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= default_in;
        else out <= in;
    end
endmodule