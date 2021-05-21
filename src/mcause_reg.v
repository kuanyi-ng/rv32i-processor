module mcause_reg (
    input clk,
    input rst_n,
    input [31:0] in,
    output [31:0] out
);
    
    localparam [31:0] default_in = 32'b0;
    
    reg [31:0] mcause;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) mcause <= default_in;
        else mcause <= in;
    end

    assign out = mcause;

endmodule