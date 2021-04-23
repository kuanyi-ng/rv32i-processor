module if_id_regs (
    input clk,
    input rst_n,

    input [31:0] pc_in,
    output [31:0] pc_out,

    input [31:0] ir_in,
    output [31:0] ir_out
);

    reg [31:0] pc;
    reg [31:0] ir;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            pc <= pc_in;
            ir <= ir_in;
        end else begin
            pc <= 32'bx;
            ir <= 32'bx;
        end
    end

    assign pc_out = pc;
    assign ir_out = ir;
    
endmodule