`include "constants/pipeline_regs_default.v"

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

    input [31:0] z_in,
    output [31:0] z_out,

    input [2:0] funct3_in,
    output [2:0] funct3_out,

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [11:0] csr_addr_in,
    output [11:0] csr_addr_out,

    input [3:0] ir_type_in,
    output [3:0] ir_type_out,

    input wr_reg_n_in,
    output wr_reg_n_out,

    input wr_csr_n_in,
    output wr_csr_n_out,

    input flush_in,
    output flush_out
);

    reg [31:0] pc4;
    reg [31:0] b;
    reg [31:0] c;
    reg [31:0] z_;
    reg [2:0] funct3;
    reg [4:0] rd;
    reg [11:0] csr_addr;
    reg [3:0] ir_type;
    reg wr_reg_n;
    reg wr_csr_n;
    reg flush;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc4 <= `DEFAULT_PC4;
            b <= `DEFAULT_B;
            c <= `DEFAULT_C;
            z_ <= `DEFAULT_Z;
            funct3 <= `DEFAULT_FUNCT3;
            rd <= `DEFAULT_RD;
            csr_addr <= `DEFAULT_CSR_ADDR;
            ir_type <= `DEFAULT_IR_TYPE;
            wr_reg_n <= `DEFAULT_WR_N;
            wr_csr_n <= `DEFAULT_WR_N;
            flush <= `DEFAULT_FLUSH;
        end else if (interlock) begin
            pc4 <= pc4;
            b <= b;
            c <= c;
            z_ <= z_;
            funct3 <= funct3;
            rd <= rd;
            csr_addr <= csr_addr;
            ir_type <= ir_type;
            wr_reg_n <= wr_reg_n;
            wr_csr_n <= wr_csr_n;
            flush <= flush;
        end else begin
            pc4 <= pc4_in;
            b <= b_in;
            c <= c_in;
            z_ <= z_in;
            funct3 <= funct3_in;
            rd <= rd_in;
            csr_addr <= csr_addr_in;
            ir_type <= ir_type_in;
            wr_reg_n <= wr_reg_n_in;
            wr_csr_n <= wr_csr_n_in;
            flush <= flush_in;
        end
    end

    assign pc4_out = pc4;
    assign b_out = b;
    assign c_out = c;
    assign z_out = z_;
    assign funct3_out = funct3;
    assign rd_out = rd;
    assign csr_addr_out = csr_addr;
    assign ir_type_out = ir_type;
    assign wr_reg_n_out = wr_reg_n;
    assign wr_csr_n_out = wr_csr_n;
    assign flush_out = flush;

endmodule
