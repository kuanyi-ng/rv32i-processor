module pc_reg (
    input clk,
    input rst_n,
    input stall,

    input [31:0] pc_in,
    output [31:0] pc_out
);

    parameter [31:0] default_pc = 32'h0001_0000;

    reg [31:0] pc;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc <= default_pc;
        else if (stall) pc <= pc;
        else pc <= pc_in;
    end

    assign pc_out = pc;

endmodule