module if_id_regs (
    input clk,
    input rst_n,

    input [31:0] pc_in,
    output [31:0] pc_out,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] ir_in,
    output [31:0] ir_out
);

    reg [31:0] pc;
    reg [31:0] pc4;
    reg [31:0] ir;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            pc <= pc_in;
            pc4 <= pc4_in;
            ir <= ir_in;
        end else begin
            pc <= 32'bx;
            pc4 <= 32'bx;
            ir <= 32'bx;
        end
    end

    assign pc_out = pc;
    assign pc4_out = pc4;
    assign ir_out = ir;
    
endmodule