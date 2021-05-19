module ex_mem_regs (
    input clk,
    input rst_n,
    input interlock,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] b_in,
    output [31:0] b_out,

    input [31:0] c_in,
    output [31:0] c_out,

    input [2:0] funct3_in,
    output [2:0] funct3_out,

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [6:0] opcode_in,
    output [6:0] opcode_out,

    input wr_reg_n_in,
    output wr_reg_n_out,

    input flush_in,
    output flush_out
);

    reg [31:0] pc4;
    reg [31:0] b;
    reg [31:0] c;
    reg [2:0] funct3;
    reg [4:0] rd;
    reg [6:0] opcode;
    reg wr_reg_n;
    reg flush;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc4 <= 32'bx;
            b <= 32'bx;
            c <= 32'bx;
            funct3 <= 3'bx;
            rd <= 5'bx;
            opcode <= 7'bx;
            wr_reg_n <= 1'b1;   // default not to write
            flush <= 1'b0;      // default not to flush
        end else if (interlock) begin
            pc4 <= pc4;
            b <= b;
            c <= c;
            funct3 <= funct3;
            rd <= rd;
            opcode <= opcode;
            wr_reg_n <= wr_reg_n;
            flush <= flush;
        end else begin
            pc4 <= pc4_in;
            b <= b_in;
            c <= c_in;
            funct3 <= funct3_in;
            rd <= rd_in;
            opcode <= opcode_in;
            wr_reg_n <= wr_reg_n_in;
            flush <= flush_in;
        end
    end

    assign pc4_out = pc4;
    assign b_out = b;
    assign c_out = c;
    assign funct3_out = funct3;
    assign rd_out = rd;
    assign opcode_out = opcode;
    assign wr_reg_n_out = wr_reg_n;
    assign flush_out = flush;

endmodule