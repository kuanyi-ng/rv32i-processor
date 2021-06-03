module if_id_regs (
    input clk,
    input rst_n,
    input stall,
    input interlock,

    input [31:0] pc_in,
    output [31:0] pc_out,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] ir_in,
    output [31:0] ir_out,

    input flush_in,
    output flush_out
);

    reg [31:0] pc;
    reg [31:0] pc4;
    reg [31:0] ir;
    reg flush;

    localparam [31:0] NOP_IR = { 12'b0, 5'b0, 3'b0, 5'b0, 7'b0010011 };

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // reset
            pc <= 32'bx;
            pc4 <= 32'bx;
            ir <= NOP_IR;
            flush <= 1'b0;  // default not to flush
        end else if (stall || interlock) begin
            // holds the same value when stall or interlock
            pc <= pc;
            pc4 <= pc4;
            ir <= ir;
            flush <= flush;
        end else begin
            // update value
            pc <= pc_in;
            pc4 <= pc4_in;
            ir <= ir_in;
            flush <= flush_in;
        end
    end

    assign pc_out = pc;
    assign pc4_out = pc4;
    assign ir_out = ir;
    assign flush_out = flush;
    
endmodule