module mepc_reg (
    input clk,
    input rst_n,
    input [31:0] in,
    output [31:0] out
);
    
    localparam [31:0] default_in = 32'b0;
    
    reg [31:0] mepc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) mepc <= default_in;
        else mepc <= in;
    end

    assign out = { mepc[31:2], 2'b00 };

endmodule