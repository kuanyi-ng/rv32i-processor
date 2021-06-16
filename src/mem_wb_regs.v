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

    input [4:0] rd_in,
    output [4:0] rd_out,

    input [11:0] csr_addr_in,
    output [11:0] csr_addr_out,

    input [3:0] ir_type_in,
    output [3:0] ir_type_out,

    input wr_reg_n_in,
    output wr_reg_n_out,

    input wr_csr_n_in,
    output wr_csr_n_out
);

    reg [31:0] pc4;
    reg [31:0] c;
    reg [31:0] d;
    reg [31:0] z_;
    reg [4:0] rd;
    reg [11:0] csr_addr;
    reg [3:0] ir_type;
    reg wr_reg_n;
    reg wr_csr_n;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pc4 <= 32'bx;
            c <= 32'bx;
            d <= 32'bx;
            z_ <= 32'bx;
            rd <= 5'bx;
            csr_addr <= 12'bx;
            ir_type <= 4'bx;
            wr_reg_n <= 1'b1; // default not to write
            wr_csr_n <= 1'b1; // default not to write
        end else if (interlock) begin
            // holds the same value when interlock
            pc4 <= pc4;
            c <= c;
            d <= d;
            z_ <= z_;
            rd <= rd;
            csr_addr <= csr_addr;
            ir_type <= ir_type;
            wr_reg_n <= wr_reg_n;
            wr_csr_n <= wr_csr_n;
        end else begin
            pc4 <= pc4_in;
            c <= c_in;
            d <= d_in;
            z_ <= z_in;
            rd <= rd_in;
            csr_addr <= csr_addr_in;
            ir_type <= ir_type_in;
            wr_reg_n <= wr_reg_n_in;
            wr_csr_n <= wr_csr_n_in;
        end
    end

    assign pc4_out = pc4;
    assign c_out = c;
    assign d_out = d;
    assign z_out = z_;
    assign rd_out = rd;
    assign csr_addr_out = csr_addr;
    assign ir_type_out = ir_type;
    assign wr_reg_n_out = wr_reg_n;
    assign wr_csr_n_out = wr_csr_n;

endmodule
