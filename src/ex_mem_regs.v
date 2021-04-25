module ex_mem_regs (
    input clk,
    input rst_n,

    input [31:0] pc_in,
    output [31:0] pc_out,

    input jump_in,
    output jump_out,

    input [31:0] b_in,
    output [31:0] b_out,

    input [31:0] c_in,
    output [31:0] c_out,

    input [2:0] funct3_in,
    output [2:0] funct3_out,

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [6:0] opcode_in,
    output [6:0] opcode_out
);

    reg [31:0] pc;
    reg jump;
    reg [31:0] b;
    reg [31:0] c;
    reg [2:0] funct3;
    reg [4:0] rd;
    reg [6:0] opcode;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n) begin
            pc <= pc_in;
            jump <= jump_in;
            b <= b_in;
            c <= c_in;
            funct3 <= funct3_in;
            rd <= rd_in;
            opcode <= opcode_in;
        end else begin
            pc <= 32'bx;
            jump <= 1'b0;
            b <= 32'bx;
            c <= 32'bx;
            funct3 <= 3'bx;
            rd <= 5'bx;
            opcode <= 7'bx;
        end
    end

    assign pc_out = pc;
    assign jump_out = jump;
    assign b_out = b;
    assign c_out = c;
    assign funct3_out = funct3;
    assign rd_out = rd;
    assign opcode_out = opcode;

endmodule