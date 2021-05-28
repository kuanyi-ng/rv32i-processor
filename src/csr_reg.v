module csr_reg #(
    parameter [31:0] rst_value = 32'b0
) (
    input clk,
    input rst_n,

    input [31:0] in,
    input wr_reg,

    output [31:0] out
);

    reg [31:0] stored_value;

    always @(negedge clk or negedge rst_n) begin
        if (!rst_n) stored_value <= rst_value;
        else if (wr_reg) stored_value <= in;
        else stored_value <= stored_value;
    end

    assign out = stored_value;

endmodule
