module reg1 (
    input clk,
    input rst_n,
    input in,
    input default_in,
    output reg out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) out <= default_in;
        else out <= in;
    end
endmodule