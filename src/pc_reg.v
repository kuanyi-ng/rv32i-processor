`include "constants/pipeline_regs_default.v"

module pc_reg (
    input clk,
    input rst_n,
    input stall,
    input interlock,

    input [31:0] pc_in,
    output [31:0] pc_out
);
    reg [31:0] pc;

    wire stall_or_interlock = (stall || interlock);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) pc <= `DEFAULT_PC;
        else if (stall_or_interlock) pc <= pc;
        else pc <= pc_in;
    end

    assign pc_out = pc;

endmodule