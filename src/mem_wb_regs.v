module mem_wb_regs (
    input clk,
    input rst_n,
    input interlock,

    input [31:0] pc4_in,
    output [31:0] pc4_out,

    input [31:0] c_in,
    output [31:0] c_out,

    input [31:0] d_in,
    output [31:0] d_out,

    input [31:0] z_in,
    output [31:0] z_out,

    input [2:0] funct3_in,
    output [2:0] funct3_out,

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [11:0] csr_addr_in,
    output [11:0] csr_addr_out,

    input [6:0] opcode_in,
    output [6:0] opcode_out,

    input wr_reg_n_in,
    output wr_reg_n_out,

    input wr_csr_n_in,
    output wr_csr_n_out
);

    reg [31:0] pc4;
    reg [31:0] c;
    reg [31:0] d;
    reg [31:0] z_;
    reg [2:0] funct3;
    reg [4:0] rd;
    reg [11:0] csr_addr;
    reg [6:0] opcode;
    reg wr_reg_n;
    reg wr_csr_n;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc4 <= 32'bx;
            c <= 32'bx;
            d <= 32'bx;
            z_ <= 32'bx;
            funct3 <= 3'bx;
            rd <= 5'bx;
            csr_addr <= 12'bx;
            opcode <= 7'bx;
            wr_reg_n <= 1'b1; // default not to write
            wr_csr_n <= 1'b1; // default not to write
        end else if (interlock) begin
            // holds the same value when interlock
            pc4 <= pc4;
            c <= c;
            d <= d;
            z_ <= z_;
            funct3 <= funct3;
            rd <= rd;
            csr_addr <= csr_addr;
            opcode <= opcode;
            wr_reg_n <= wr_reg_n;
            wr_csr_n <= wr_csr_n;
        end else begin
            pc4 <= pc4_in;
            c <= c_in;
            d <= d_in;
            z_ <= z_in;
            funct3 <= funct3_in;
            rd <= rd_in;
            csr_addr <= csr_addr_in;
            opcode <= opcode_in;
            wr_reg_n <= wr_reg_n_in;
            wr_csr_n <= wr_csr_n_in;
        end
    end

    assign pc4_out = pc4;
    assign c_out = c;
    assign d_out = d;
    assign z_out = z_;
    assign funct3_out = funct3;
    assign rd_out = rd;
    assign csr_addr_out = csr_addr;
    assign opcode_out = opcode;
    assign wr_reg_n_out = wr_reg_n;
    assign wr_csr_n_out = wr_csr_n;

endmodule
