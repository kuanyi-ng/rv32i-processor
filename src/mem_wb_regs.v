module mem_wb_regs (
    input clk,
    input rst_n,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] c_in,
    output [31:0] c_out,

    input [31:0] d_in,
    output [31:0] d_out,

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [6:0] opcode_in,
    output [6:0] opcode_out,

    input wr_reg_n_in,
    output wr_reg_n_out
);

    reg [31:0] pc4;
    reg [31:0] c;
    reg [31:0] d;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg wr_reg_n;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            pc4 <= pc4_in;
            c <= c_in;
            d <= d_in;
            rd <= rd_in;
            opcode <= opcode_in;
            wr_reg_n <= wr_reg_n_in;
        end else begin
            pc4 <= 32'bx;
            c <= 32'bx;
            d <= 32'bx;
            rd <= 5'bx;
            opcode <= 7'bx;
            wr_reg_n <= 1'b1; // default not to write
        end
    end

    assign pc4_out = pc4;
    assign c_out = c;
    assign d_out = d;
    assign rd_out = rd;
    assign opcode_out = opcode;
    assign wr_reg_n_out = wr_reg_n;

endmodule