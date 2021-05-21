module reg32 (
    input clk,
    input rst_n,
    input [31:0] in,
    output [31:0] out
);

    parameter [31:0] rst_value = 32'b0;

    reg [31:0] stored_value;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) stored_value <= rst_value;
        else stored_value <= in;
    end

    assign out = stored_value;

endmodule